package org.owncoffer.app

import android.content.ContentResolver
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.media.ExifInterface
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.OpenableColumns
import android.view.WindowManager
import com.googlecode.tesseract.android.TessBaseAPI
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayInputStream
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

// A FragmentActivity: the fingerprint prompt (local_auth) needs one.
class MainActivity : FlutterFragmentActivity() {
    private val ocrExecutor: ExecutorService = Executors.newSingleThreadExecutor()
    private val backupFolder = BackupFolder(this)
    private var pendingIncomingFile: Map<String, Any>? = null
    private var incomingFileChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIncomingIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleIncomingIntent(intent)
    }

    @Deprecated("Flutter's activity still delivers picker results here")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (backupFolder.onActivityResult(requestCode, resultCode, data)) return
        super.onActivityResult(requestCode, resultCode, data)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BackupFolder.CHANNEL)
            .setMethodCallHandler(backupFolder)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AppUpdate.CHANNEL)
            .setMethodCallHandler(AppUpdate(this))
        // The automatic lock's option (decision 0025): out of screenshots
        // and blank in the list of recent apps.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WINDOW_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method != "setSecure") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                if (call.argument<Boolean>("secure") == true) {
                    window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                } else {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                }
                result.success(null)
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TEXT_READER_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method != "read") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val image = call.argument<ByteArray>("image")
                val dataPath = call.argument<String>("dataPath")
                val languages = call.argument<String>("languages")
                if (image == null || dataPath == null || languages == null) {
                    result.success(null)
                    return@setMethodCallHandler
                }
                // Tesseract is slow: never block the UI thread.
                ocrExecutor.execute {
                    val lines =
                        try {
                            readLines(image, dataPath, languages)
                        } catch (_: Throwable) {
                            null
                        }
                    runOnUiThread { result.success(lines) }
                }
            }
        val fileChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, INCOMING_FILE_CHANNEL)
        incomingFileChannel = fileChannel
        fileChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialFile" -> {
                    val file = pendingIncomingFile
                    pendingIncomingFile = null
                    result.success(file)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        ocrExecutor.shutdown()
        super.onDestroy()
    }

    /**
     * Local receipt text recognition (decision 0023): Tesseract4Android with
     * the models bundled in the app, nothing leaves the device. Returns the
     * text lines in reading order with their confidence (0 to 1), or null.
     */
    private fun readLines(
        image: ByteArray,
        dataPath: String,
        languages: String,
    ): List<Map<String, Any>>? {
        val bitmap = decodeUpright(image) ?: return null
        val api = TessBaseAPI()
        try {
            if (!api.init(dataPath, languages)) return null
            api.setImage(bitmap)
            api.getUTF8Text() // Runs the recognition.
            val iterator = api.getResultIterator() ?: return null
            val level = TessBaseAPI.PageIteratorLevel.RIL_TEXTLINE
            val lines = mutableListOf<Map<String, Any>>()
            try {
                iterator.begin()
                do {
                    val text = iterator.getUTF8Text(level)?.trim().orEmpty()
                    if (text.isNotEmpty()) {
                        val confidence = (iterator.confidence(level) / 100.0).coerceIn(0.0, 1.0)
                        lines.add(mapOf("text" to text, "confidence" to confidence))
                    }
                } while (iterator.next(level))
            } finally {
                iterator.delete()
            }
            return lines
        } finally {
            api.recycle()
            bitmap.recycle()
        }
    }

    /** Decodes a photo, reduced if very large and turned the right way up. */
    private fun decodeUpright(image: ByteArray): Bitmap? {
        val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        BitmapFactory.decodeByteArray(image, 0, image.size, bounds)
        if (bounds.outWidth <= 0 || bounds.outHeight <= 0) return null
        var sample = 1
        while (maxOf(bounds.outWidth, bounds.outHeight) / sample > MAX_SIDE) sample *= 2
        val options = BitmapFactory.Options().apply { inSampleSize = sample }
        val bitmap = BitmapFactory.decodeByteArray(image, 0, image.size, options) ?: return null
        val degrees =
            try {
                when (
                    ExifInterface(ByteArrayInputStream(image)).getAttributeInt(
                        ExifInterface.TAG_ORIENTATION,
                        ExifInterface.ORIENTATION_NORMAL,
                    )
                ) {
                    ExifInterface.ORIENTATION_ROTATE_90 -> 90f
                    ExifInterface.ORIENTATION_ROTATE_180 -> 180f
                    ExifInterface.ORIENTATION_ROTATE_270 -> 270f
                    else -> 0f
                }
            } catch (_: Exception) {
                0f
            }
        if (degrees == 0f) return bitmap
        val matrix = Matrix().apply { postRotate(degrees) }
        val rotated = Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
        if (rotated != bitmap) bitmap.recycle()
        return rotated
    }

    private fun handleIncomingIntent(intent: Intent?) {
        if (intent == null) return
        val action = intent.action
        if (action != Intent.ACTION_VIEW && action != Intent.ACTION_SEND) return

        val uri: Uri? =
            when (action) {
                Intent.ACTION_VIEW -> intent.data ?: intent.clipData?.getItemAt(0)?.uri
                Intent.ACTION_SEND -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        intent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
                    } else {
                        @Suppress("DEPRECATION")
                        intent.getParcelableExtra(Intent.EXTRA_STREAM)
                    } ?: intent.clipData?.getItemAt(0)?.uri
                }
                else -> null
            }

        if (uri == null) return

        try {
            val name = queryFileName(uri) ?: "statement.ofx"
            val lower = name.lowercase()
            if (!lower.endsWith(".qif") &&
                !lower.endsWith(".ofx") &&
                !lower.endsWith(".csv") &&
                !lower.endsWith(".txt")
            ) {
                return
            }

            val bytes = contentResolver.openInputStream(uri)?.use { it.readBytes() } ?: return
            if (bytes.size > 10 * 1024 * 1024) return

            val fileMap = mapOf<String, Any>(
                "name" to name,
                "bytes" to bytes
            )

            val channel = incomingFileChannel
            if (channel != null) {
                channel.invokeMethod("onFileReceived", fileMap)
            } else {
                pendingIncomingFile = fileMap
            }
        } catch (_: Exception) {
            // Unreadable content or expired URI permission
        }
    }

    private fun queryFileName(uri: Uri): String? {
        if (uri.scheme == ContentResolver.SCHEME_CONTENT) {
            try {
                contentResolver.query(
                    uri,
                    arrayOf(OpenableColumns.DISPLAY_NAME),
                    null,
                    null,
                    null
                )?.use { cursor ->
                    if (cursor.moveToFirst()) {
                        val index = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                        if (index >= 0) {
                            val name = cursor.getString(index)
                            if (!name.isNullOrBlank()) return name
                        }
                    }
                }
            } catch (_: Exception) {}
        }
        return uri.lastPathSegment?.substringAfterLast('/')
    }

    private companion object {
        const val TEXT_READER_CHANNEL = "org.owncoffer.app/text_reader"
        const val WINDOW_CHANNEL = "org.owncoffer.app/window"
        const val INCOMING_FILE_CHANNEL = "org.owncoffer.app/incoming_file"

        /** Longest side kept for recognition, enough for a receipt photo. */
        const val MAX_SIDE = 4000
    }
}

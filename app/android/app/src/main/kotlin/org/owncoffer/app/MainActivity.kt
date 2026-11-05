package org.owncoffer.app

import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.media.ExifInterface
import com.googlecode.tesseract.android.TessBaseAPI
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayInputStream
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private val ocrExecutor: ExecutorService = Executors.newSingleThreadExecutor()
    private val backupFolder = BackupFolder(this)

    @Deprecated("Flutter's activity still delivers picker results here")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (backupFolder.onActivityResult(requestCode, resultCode, data)) return
        super.onActivityResult(requestCode, resultCode, data)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BackupFolder.CHANNEL)
            .setMethodCallHandler(backupFolder)
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

    private companion object {
        const val TEXT_READER_CHANNEL = "org.owncoffer.app/text_reader"

        /** Longest side kept for recognition, enough for a receipt photo. */
        const val MAX_SIDE = 4000
    }
}

package org.owncoffer.app

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.provider.DocumentsContract
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.concurrent.Executors

/**
 * The standalone mode's backup folder on Android (decision 0022): a folder
 * chosen with the system picker (on the phone, a memory card, or a synced
 * app such as Nextcloud), kept across restarts, and the backup files the
 * app writes there or picks to restore. Files are copied a block at a time:
 * a backup never sits in memory.
 */
class BackupFolder(private val activity: Activity) : MethodChannel.MethodCallHandler {
    private val io = Executors.newSingleThreadExecutor()
    private var pending: MethodChannel.Result? = null
    private var pendingDest: String? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "choose" -> {
                if (!startPicker(result, null)) return
                val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).addFlags(
                    Intent.FLAG_GRANT_READ_URI_PERMISSION or
                        Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                        Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION,
                )
                activity.startActivityForResult(intent, CHOOSE)
            }
            "open" -> {
                if (!startPicker(result, call.argument<String>("dest"))) return
                val intent = Intent(Intent.ACTION_OPEN_DOCUMENT)
                    .addCategory(Intent.CATEGORY_OPENABLE)
                    .setType("*/*")
                activity.startActivityForResult(intent, OPEN)
            }
            "write" -> background(result) {
                write(
                    Uri.parse(call.argument<String>("tree")!!),
                    call.argument<String>("name")!!,
                    File(call.argument<String>("source")!!),
                )
                null
            }
            "prune" -> background(result) {
                prune(
                    Uri.parse(call.argument<String>("tree")!!),
                    call.argument<String>("suffix")!!,
                    call.argument<Int>("keep")!!,
                )
                null
            }
            "latest" -> background(result) {
                val tree = Uri.parse(call.argument<String>("tree")!!)
                val newest = children(tree)
                    .filter { it.second.endsWith(call.argument<String>("suffix")!!) }
                    .maxByOrNull { it.second }
                if (newest == null) {
                    null
                } else {
                    copy(newest.first, File(call.argument<String>("dest")!!))
                    newest.second
                }
            }
            else -> result.notImplemented()
        }
    }

    /** Called by the activity; true if the result was one of ours. */
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != CHOOSE && requestCode != OPEN) return false
        val result = pending ?: return true
        val dest = pendingDest
        pending = null
        pendingDest = null
        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null) {
            result.success(null)
            return true
        }
        if (requestCode == CHOOSE) {
            try {
                activity.contentResolver.takePersistableUriPermission(
                    uri,
                    Intent.FLAG_GRANT_READ_URI_PERMISSION or
                        Intent.FLAG_GRANT_WRITE_URI_PERMISSION,
                )
                result.success(uri.toString())
            } catch (e: Exception) {
                result.error("folder", e.message, null)
            }
            return true
        }
        background(result) {
            copy(uri, File(dest!!))
            displayName(uri)
        }
        return true
    }

    private fun startPicker(result: MethodChannel.Result, dest: String?): Boolean {
        if (pending != null) {
            result.error("busy", "A picker is already open", null)
            return false
        }
        pending = result
        pendingDest = dest
        return true
    }

    private fun background(result: MethodChannel.Result, work: () -> Any?) {
        io.execute {
            try {
                val value = work()
                activity.runOnUiThread { result.success(value) }
            } catch (e: Exception) {
                activity.runOnUiThread { result.error("io", e.message ?: "$e", null) }
            }
        }
    }

    private fun treeDocument(tree: Uri): Uri =
        DocumentsContract.buildDocumentUriUsingTree(
            tree,
            DocumentsContract.getTreeDocumentId(tree),
        )

    /** The documents of the folder: their address and name. */
    private fun children(tree: Uri): List<Pair<Uri, String>> {
        val uri = DocumentsContract.buildChildDocumentsUriUsingTree(
            tree,
            DocumentsContract.getTreeDocumentId(tree),
        )
        val found = mutableListOf<Pair<Uri, String>>()
        activity.contentResolver.query(
            uri,
            arrayOf(
                DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                DocumentsContract.Document.COLUMN_DISPLAY_NAME,
            ),
            null,
            null,
            null,
        )?.use { c ->
            while (c.moveToNext()) {
                val id = c.getString(0) ?: continue
                val name = c.getString(1) ?: continue
                found.add(DocumentsContract.buildDocumentUriUsingTree(tree, id) to name)
            }
        }
        return found
    }

    /**
     * [source] as [name] in the folder: written as "name.part" then renamed,
     * so a backup cut short (app closed, storage full) is never taken for a
     * whole one. Providers that cannot rename get a second, direct copy.
     */
    private fun write(tree: Uri, name: String, source: File) {
        val resolver = activity.contentResolver
        val folder = treeDocument(tree)
        val part = DocumentsContract.createDocument(
            resolver,
            folder,
            MIME,
            "$name.part",
        ) ?: throw IllegalStateException("Cannot create $name in the folder")
        try {
            copyTo(source, part)
        } catch (e: Exception) {
            delete(part)
            throw e
        }
        val renamed = try {
            DocumentsContract.renameDocument(resolver, part, name)
        } catch (_: Exception) {
            null
        }
        if (renamed != null) return
        val whole = DocumentsContract.createDocument(resolver, folder, MIME, name)
            ?: throw IllegalStateException("Cannot create $name in the folder")
        try {
            copyTo(source, whole)
        } catch (e: Exception) {
            delete(whole)
            throw e
        } finally {
            delete(part)
        }
    }

    /** Keeps the [keep] newest backups; removes those cut short. */
    private fun prune(tree: Uri, suffix: String, keep: Int) {
        val all = children(tree)
        for ((uri, name) in all) {
            if (name.endsWith("$suffix.part")) delete(uri)
        }
        all.filter { it.second.endsWith(suffix) }
            .sortedByDescending { it.second }
            .drop(keep)
            .forEach { delete(it.first) }
    }

    private fun delete(uri: Uri) {
        try {
            DocumentsContract.deleteDocument(activity.contentResolver, uri)
        } catch (_: Exception) {
            // Left behind: removed at the next prune.
        }
    }

    private fun copyTo(source: File, document: Uri) {
        val out = activity.contentResolver.openOutputStream(document, "w")
            ?: throw IllegalStateException("Cannot write to the folder")
        out.use { o -> source.inputStream().use { it.copyTo(o, BLOCK) } }
    }

    private fun copy(document: Uri, dest: File) {
        dest.parentFile?.mkdirs()
        val input = activity.contentResolver.openInputStream(document)
            ?: throw IllegalStateException("Cannot read the file")
        input.use { i -> dest.outputStream().use { i.copyTo(it, BLOCK) } }
    }

    private fun displayName(uri: Uri): String? =
        activity.contentResolver.query(
            uri,
            arrayOf(DocumentsContract.Document.COLUMN_DISPLAY_NAME),
            null,
            null,
            null,
        )?.use { c -> if (c.moveToFirst()) c.getString(0) else null }

    companion object {
        const val CHANNEL = "org.owncoffer.app/backup_folder"
        private const val CHOOSE = 0x4F43
        private const val OPEN = 0x4F44
        private const val MIME = "application/octet-stream"
        private const val BLOCK = 1 shl 16
    }
}

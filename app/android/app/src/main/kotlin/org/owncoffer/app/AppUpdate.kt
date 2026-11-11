package org.owncoffer.app

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.content.FileProvider
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.security.MessageDigest

/** Shares the downloaded APK with Android's installer, nothing else. */
class UpdateFileProvider : FileProvider()

/**
 * Installs a new version of the app downloaded by the app itself (decision
 * 0032). The APK, already checked against the release's SHA256SUMS, must be
 * OwnCoffer in the expected version and signed by the same key as the app
 * installed; then Android's installer asks the user to confirm.
 * Answers `ok`, or why not: `permission`, `package`, `version`, `signature`,
 * `install`.
 */
class AppUpdate(private val activity: Activity) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method != "install") {
            result.notImplemented()
            return
        }
        result.success(
            try {
                install(call.argument<String>("path"), call.argument<String>("version"))
            } catch (e: Exception) {
                "install"
            },
        )
    }

    private fun install(path: String?, version: String?): String {
        if (path == null || version == null) return "install"
        val updates = File(activity.cacheDir, "updates").canonicalFile
        val apk = File(path).canonicalFile
        if (apk.parentFile != updates || !apk.isFile) return "install"

        val pm = activity.packageManager
        val archive = archiveInfo(pm, apk.path) ?: return "package"
        if (archive.packageName != activity.packageName) return "package"
        if (archive.versionName != version) return "version"
        val installed = installedInfo(pm)
        val ours = signers(installed)
        val theirs = signers(archive)
        // Android refuses another key anyway; said clearly here. When a
        // device cannot read one side, Android's own check stays.
        if (ours.isNotEmpty() && theirs.isNotEmpty() && ours.intersect(theirs).isEmpty()) {
            return "signature"
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && !pm.canRequestPackageInstalls()) {
            activity.startActivity(
                Intent(
                    Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                    Uri.parse("package:${activity.packageName}"),
                ),
            )
            return "permission"
        }

        val uri = FileProvider.getUriForFile(activity, "${activity.packageName}.updates", apk)
        val intent = Intent(Intent.ACTION_VIEW)
            .setDataAndType(uri, "application/vnd.android.package-archive")
            .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        activity.startActivity(intent)
        return "ok"
    }

    @Suppress("DEPRECATION")
    private fun archiveInfo(pm: PackageManager, path: String): PackageInfo? =
        pm.getPackageArchiveInfo(path, signatureFlag())

    @Suppress("DEPRECATION")
    private fun installedInfo(pm: PackageManager): PackageInfo =
        pm.getPackageInfo(activity.packageName, signatureFlag())

    @Suppress("DEPRECATION")
    private fun signatureFlag(): Int =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            PackageManager.GET_SIGNING_CERTIFICATES
        } else {
            PackageManager.GET_SIGNATURES
        }

    /** SHA-256 of each certificate the package is (or was) signed with. */
    @Suppress("DEPRECATION")
    private fun signers(info: PackageInfo): Set<String> {
        val certificates = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            val signing = info.signingInfo ?: return emptySet()
            if (signing.hasMultipleSigners()) {
                signing.apkContentsSigners
            } else {
                signing.signingCertificateHistory
            }
        } else {
            info.signatures
        } ?: return emptySet()
        return certificates.map { sha256(it.toByteArray()) }.toSet()
    }

    private fun sha256(bytes: ByteArray): String =
        MessageDigest.getInstance("SHA-256").digest(bytes).joinToString("") { "%02x".format(it) }

    companion object {
        const val CHANNEL = "org.owncoffer.app/app_update"
    }
}

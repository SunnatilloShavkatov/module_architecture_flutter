package uz.plugin.platform_methods

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import com.google.android.gms.tasks.Task
import com.google.android.play.core.review.ReviewManagerFactory
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

internal class InAppReviewManager(
    private val applicationContext: Context,
    private val activityProvider: () -> Activity?
) {

    companion object {
        private const val PLAY_STORE_PACKAGE = "com.android.vending"
    }

    fun isReviewAvailable(): Boolean {
        val currentActivity = activityProvider()
        if (currentActivity == null || currentActivity.isFinishing) {
            return false
        }
        if (currentActivity.isDestroyed) {
            return false
        }
        return hasPlayStoreInstalled()
    }

    suspend fun requestReview() {
        activeActivity() ?: throw IllegalStateException("Activity is unavailable for in-app review")

        val reviewManager = ReviewManagerFactory.create(applicationContext)
        val reviewInfo = reviewManager.requestReviewFlow().await()
        val freshActivity = activeActivity()
            ?: throw IllegalStateException("Activity became unavailable before launching review flow")
        reviewManager.launchReviewFlow(freshActivity, reviewInfo).await()
    }

    fun openStoreListing() {
        val packageName = applicationContext.packageName
        val marketIntent = Intent(
            Intent.ACTION_VIEW,
            Uri.parse("market://details?id=$packageName")
        ).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            setPackage(PLAY_STORE_PACKAGE)
        }

        val intentToLaunch = if (marketIntent.resolveActivity(applicationContext.packageManager) != null) {
            marketIntent
        } else {
            Intent(
                Intent.ACTION_VIEW,
                Uri.parse("https://play.google.com/store/apps/details?id=$packageName")
            ).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
        }

        applicationContext.startActivity(intentToLaunch)
    }

    private fun activeActivity(): Activity? =
        activityProvider()?.takeUnless { it.isFinishing || it.isDestroyed }

    /** Suspends on a Play Core [Task] without relying on extra ktx artifacts. */
    private suspend fun <T> Task<T>.await(): T = suspendCancellableCoroutine { continuation ->
        addOnCompleteListener { task ->
            if (task.isSuccessful) {
                continuation.resume(task.result)
            } else {
                continuation.resumeWithException(
                    task.exception ?: IllegalStateException("Play Core task failed")
                )
            }
        }
    }

    private fun hasPlayStoreInstalled(): Boolean {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                applicationContext.packageManager.getApplicationInfo(
                    PLAY_STORE_PACKAGE,
                    PackageManager.ApplicationInfoFlags.of(0L)
                )
            } else {
                @Suppress("DEPRECATION")
                applicationContext.packageManager.getApplicationInfo(PLAY_STORE_PACKAGE, 0)
            }
            true
        } catch (_: Exception) {
            false
        }
    }
}

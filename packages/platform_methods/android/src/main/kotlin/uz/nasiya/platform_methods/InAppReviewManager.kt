package uz.nasiya.platform_methods

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.content.pm.PackageManager
import com.google.android.play.core.review.ReviewManagerFactory

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

    fun requestReview(onComplete: () -> Unit, onError: (Throwable) -> Unit) {
        val currentActivity = activityProvider()
        if (currentActivity == null || currentActivity.isFinishing || currentActivity.isDestroyed) {
            openStoreListing(
                onComplete = onComplete,
                onError = { storeError ->
                    onError(IllegalStateException("Activity is unavailable for in-app review", storeError))
                }
            )
            return
        }

        val reviewManager = ReviewManagerFactory.create(applicationContext)
        reviewManager.requestReviewFlow()
            .addOnSuccessListener { reviewInfo ->
                val freshActivity = activityProvider()
                if (freshActivity == null || freshActivity.isFinishing || freshActivity.isDestroyed) {
                    openStoreListing(
                        onComplete = onComplete,
                        onError = { storeError ->
                            onError(IllegalStateException("Activity became unavailable before launching review flow", storeError))
                        }
                    )
                    return@addOnSuccessListener
                }
                reviewManager.launchReviewFlow(freshActivity, reviewInfo)
                    .addOnSuccessListener {
                        onComplete()
                    }
                    .addOnFailureListener { launchError ->
                        openStoreListing(
                            onComplete = onComplete,
                            onError = { storeError ->
                                onError(IllegalStateException("Failed to launch in-app review flow", launchError).apply {
                                    addSuppressed(storeError)
                                })
                            }
                        )
                    }
            }
            .addOnFailureListener { requestError ->
                openStoreListing(
                    onComplete = onComplete,
                    onError = { storeError ->
                        onError(IllegalStateException("Failed to request in-app review flow", requestError).apply {
                            addSuppressed(storeError)
                        })
                    }
                )
            }
    }

    fun openStoreListing(onComplete: () -> Unit, onError: (Throwable) -> Unit) {
        try {
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
            onComplete()
        } catch (error: Throwable) {
            onError(error)
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

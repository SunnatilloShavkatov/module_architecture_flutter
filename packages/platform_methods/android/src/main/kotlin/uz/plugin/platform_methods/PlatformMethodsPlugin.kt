package uz.plugin.platform_methods

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

/**
 * PlatformMethodsPlugin — implements the Pigeon-generated [PlatformMethodsHostApi]
 * over Native Interop (JNI). No MethodChannel is used.
 */
class PlatformMethodsPlugin : FlutterPlugin, ActivityAware, PlatformMethodsHostApi {

    companion object {
        private const val ERROR_GETTING_ID = "ERROR_GETTING_ID"
        private const val ERROR_EMULATOR_CHECK = "ERROR_EMULATOR_CHECK"
        private const val ERROR_REVIEW_CHECK = "ERROR_REVIEW_CHECK"
        private const val ERROR_REVIEW_REQUEST = "ERROR_REVIEW_REQUEST"
        private const val ERROR_STORE_LISTING = "ERROR_STORE_LISTING"
        private const val ERROR_NOT_ATTACHED = "ERROR_NOT_ATTACHED"
    }

    @Volatile
    private var applicationContext: Context? = null

    @Volatile
    private var activity: Activity? = null

    @Volatile
    private var inAppReviewManager: InAppReviewManager? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
        val context = flutterPluginBinding.applicationContext
        applicationContext = context
        inAppReviewManager = InAppReviewManager(context) { activity }
        PlatformMethodsHostApiRegistrar().register(this, flutterPluginBinding)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        PlatformMethodsHostApiRegistrar().unregister(this, binding)
        activity = null
        inAppReviewManager = null
        applicationContext = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override suspend fun isEmulator(): Boolean = guard(ERROR_EMULATOR_CHECK, "Failed to detect emulator status") {
        withContext(Dispatchers.IO) { detectEmulator() }
    }

    override suspend fun getDeviceId(): String? = guard(ERROR_GETTING_ID, "Failed to get Android ID") {
        val context = requireContext()
        withContext(Dispatchers.IO) { readAndroidId(context) }
    }

    override suspend fun isReviewAvailable(): Boolean =
        guard(ERROR_REVIEW_CHECK, "Failed to detect in-app review availability") {
            val manager = inAppReviewManager ?: return@guard false
            withContext(Dispatchers.Main) { manager.isReviewAvailable() }
        }

    override suspend fun requestReview() = guard(ERROR_REVIEW_REQUEST, "Failed to launch in-app review flow") {
        val manager = requireReviewManager()
        withContext(Dispatchers.Main) { manager.requestReview() }
    }

    override suspend fun openStoreListing(appStoreId: String?) =
        guard(ERROR_STORE_LISTING, "Failed to open store listing") {
            // appStoreId is iOS-only; Android uses the application package name.
            val manager = requireReviewManager()
            withContext(Dispatchers.Main) { manager.openStoreListing() }
        }

    private fun requireContext(): Context =
        applicationContext ?: throw PlatformMethodsError(ERROR_NOT_ATTACHED, "Plugin is not attached to an engine")

    private fun requireReviewManager(): InAppReviewManager =
        inAppReviewManager ?: throw PlatformMethodsError(ERROR_NOT_ATTACHED, "Plugin is not attached to an engine")

    /**
     * Maps any failure to [PlatformMethodsError]. Only the throwable's class name is
     * exposed as details — never its message — so no internal data leaks to Dart.
     */
    private suspend fun <T> guard(code: String, message: String, block: suspend () -> T): T {
        try {
            return block()
        } catch (e: CancellationException) {
            throw e
        } catch (e: PlatformMethodsError) {
            throw e
        } catch (t: Throwable) {
            throw PlatformMethodsError(code, message, t.javaClass.simpleName)
        }
    }

    private fun detectEmulator(): Boolean {
        val fingerprint = Build.FINGERPRINT
        val model = Build.MODEL
        val manufacturer = Build.MANUFACTURER
        val brand = Build.BRAND
        val device = Build.DEVICE
        val product = Build.PRODUCT

        return fingerprint.startsWith("generic") ||
            fingerprint.contains("vbox") ||
            fingerprint.contains("test-keys") ||
            model.contains("google_sdk") ||
            model.contains("Emulator") ||
            model.contains("Android SDK built for x86") ||
            manufacturer.contains("Genymotion") ||
            (brand.startsWith("generic") && device.startsWith("generic")) ||
            product == "google_sdk"
    }

    @SuppressLint("HardwareIds")
    private fun readAndroidId(context: Context): String? =
        Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)
}

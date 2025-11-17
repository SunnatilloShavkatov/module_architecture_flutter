package uz.nasiya.platform_methods

import android.annotation.SuppressLint
import android.app.Activity
import android.content.ContentResolver
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** PlatformMethodsPlugin */
class PlatformMethodsPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {

    companion object {
        private const val CHANNEL_NAME = "platform_methods"
    }

    private var activity: Activity? = null
    private lateinit var channel: MethodChannel
    private lateinit var contentResolver: ContentResolver

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
        contentResolver = flutterPluginBinding.applicationContext.contentResolver
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall, result: Result
    ) {
        when (call.method) {
            "getDeviceId" -> {
                try {
                    result.success(getAndroidId())
                } catch (e: Exception) {
                    result.error("ERROR_GETTING_ID", "Failed to get Android ID", e.localizedMessage)
                }
            }

            "isPhysicalDevice" -> {
                result.success(isPhysicalDevice())
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        activity = null
        channel.setMethodCallHandler(null)
    }

    private fun isPhysicalDevice(): Boolean {
        val fingerprint = Build.FINGERPRINT
        val model = Build.MODEL
        val manufacturer = Build.MANUFACTURER
        val brand = Build.BRAND
        val device = Build.DEVICE
        val product = Build.PRODUCT

        return !(fingerprint.startsWith("generic") || fingerprint.contains("vbox") || fingerprint.contains(
            "test-keys"
        ) || model.contains("google_sdk") || model.contains("Emulator") || model.contains("Android SDK built for x86") || manufacturer.contains(
            "Genymotion"
        ) || (brand.startsWith("generic") && device.startsWith("generic")) || product == "google_sdk")
    }

    @SuppressLint("HardwareIds")
    private fun getAndroidId(): String? {
        return Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID)
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
}

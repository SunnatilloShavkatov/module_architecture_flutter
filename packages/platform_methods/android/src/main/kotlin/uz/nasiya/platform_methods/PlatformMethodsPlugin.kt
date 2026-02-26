package uz.nasiya.platform_methods

import android.annotation.SuppressLint
import android.content.ContentResolver
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

/** PlatformMethodsPlugin */
class PlatformMethodsPlugin : FlutterPlugin, MethodCallHandler {

    companion object {
        private const val CHANNEL_NAME = "platform_methods"
        private const val ERROR_GETTING_ID = "ERROR_GETTING_ID"
        private const val ERROR_EMULATOR_CHECK = "ERROR_EMULATOR_CHECK"
    }

    private lateinit var channel: MethodChannel
    private lateinit var contentResolver: ContentResolver
    private val ioScope = CoroutineScope(SupervisorJob() + Dispatchers.IO)
    private val mainHandler = Handler(Looper.getMainLooper())

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
                ioScope.launch {
                    try {
                        val deviceId = getAndroidId()
                        postResult {
                            result.success(deviceId)
                        }
                    } catch (e: Exception) {
                        postResult {
                            mapResultError(result, e, ERROR_GETTING_ID, "Failed to get Android ID")
                        }
                    }
                }
            }

            "isEmulator" -> {
                ioScope.launch {
                    try {
                        val isEmulator = isEmulator()
                        postResult {
                            result.success(isEmulator)
                        }
                    } catch (t: Throwable) {
                        postResult {
                            mapResultError(
                                result,
                                t,
                                ERROR_EMULATOR_CHECK,
                                "Failed to detect emulator status"
                            )
                        }
                    }
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        ioScope.cancel()
        channel.setMethodCallHandler(null)
    }

    private fun isEmulator(): Boolean {
        val fingerprint = Build.FINGERPRINT
        val model = Build.MODEL
        val manufacturer = Build.MANUFACTURER
        val brand = Build.BRAND
        val device = Build.DEVICE
        val product = Build.PRODUCT

        return fingerprint.startsWith("generic") || fingerprint.contains("vbox") || fingerprint.contains(
            "test-keys"
        ) || model.contains("google_sdk") || model.contains("Emulator") || model.contains("Android SDK built for x86") || manufacturer.contains(
            "Genymotion"
        ) || (brand.startsWith("generic") && device.startsWith("generic")) || product == "google_sdk"
    }

    @SuppressLint("HardwareIds")
    private fun getAndroidId(): String? {
        return Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID)
    }

    private fun mapResultError(
        result: Result,
        throwable: Throwable,
        code: String,
        message: String
    ) {
        result.error(code, message, throwable.localizedMessage)
    }

    private fun postResult(action: () -> Unit) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            action()
        } else {
            mainHandler.post(action)
        }
    }
}

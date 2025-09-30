package uz.nasiya.platform_methods

import android.annotation.SuppressLint
import android.app.Activity
import android.content.BroadcastReceiver
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle
import android.os.Vibrator
import android.os.VibratorManager
import android.provider.Settings
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.tasks.Task
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.ref.WeakReference
import java.util.regex.Matcher
import androidx.core.content.ContextCompat
import com.google.android.gms.auth.api.phone.SmsRetrieverClient
import com.google.android.gms.common.api.Status
import com.google.android.gms.tasks.OnSuccessListener
import java.util.regex.Pattern


/** PlatformMethodsPlugin */
class PlatformMethodsPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {

    companion object {
        private const val CHANNEL_NAME = "platform_methods"
    }

    private var activity: Activity? = null
    private lateinit var context: Context
    private var vibration: Vibration? = null
    private lateinit var channel: MethodChannel
    private lateinit var contentResolver: ContentResolver
    private var broadcastReceiver: BroadcastReceiver? = null

    @Suppress("deprecation")
    fun getVibrator(flutterPluginBinding: FlutterPluginBinding): Vibrator? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
            return flutterPluginBinding.applicationContext.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator?
        } else {
            val vibratorManager =
                flutterPluginBinding.applicationContext.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
            return vibratorManager.defaultVibrator
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
        contentResolver = flutterPluginBinding.applicationContext.contentResolver
        val vibrator = this.getVibrator(flutterPluginBinding)
        if (vibrator != null) {
            vibration = Vibration(vibrator)
        }
        context = flutterPluginBinding.applicationContext
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

            "vibrate" -> {
                if (vibration == null) {
                    result.error("UNAVAILABLE", "Vibrator service is not available.", null)
                    return
                } else {
                    val duration: Int = call.argument("duration")!!
                    val pattern: List<Int> = call.argument("pattern")!!
                    val repeat: Int = call.argument("repeat")!!
                    val intensities: List<Int> = call.argument("intensities")!!
                    val amplitude: Int = call.argument("amplitude")!!

                    if (!pattern.isEmpty() && !intensities.isEmpty()) {
                        vibration!!.vibrate(pattern, repeat, intensities)
                    } else if (pattern.isNotEmpty()) {
                        vibration!!.vibrate(pattern, repeat)
                    } else {
                        vibration!!.vibrate(duration.toLong(), amplitude)
                    }
                    result.success(null)
                }
            }

            "cancel" -> {
                if (vibration == null) {
                    result.error("UNAVAILABLE", "Vibrator service is not available.", null)
                    return
                } else {
                    vibration!!.getVibrator().cancel()
                    result.success(null)
                }
            }

            "listenForCode" -> {
                val smsCodeRegexPattern = call.argument<String>("smsCodeRegexPattern") ?: ".*"
                val client: SmsRetrieverClient = SmsRetriever.getClient(activity!!)
                val task: Task<Void> = client.startSmsRetriever()
                task.addOnSuccessListener(OnSuccessListener {
                    unregisterReceiver()
                    broadcastReceiver =
                        SmsBroadcastReceiver(WeakReference(this), smsCodeRegexPattern)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        activity?.registerReceiver(
                            broadcastReceiver,
                            IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION),
                            Context.RECEIVER_EXPORTED
                        )
                    } else if (activity != null) {
                        ContextCompat.registerReceiver(
                            activity!!,
                            broadcastReceiver,
                            IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION),
                            ContextCompat.RECEIVER_NOT_EXPORTED
                        )
                    }
                    result.success(null)
                })
                task.addOnFailureListener { e ->
                    result.error("ERROR_START_SMS_RETRIEVER", "Can't start sms retriever", e)
                }
            }

            "unregisterListener" -> {
                unregisterReceiver()
                result.success("successfully unregister receiver")
            }

            "getAppSignature" -> {
                try {
                    val signatureHelper = AppSignatureHelper(activity!!.applicationContext)
                    val appSignature = signatureHelper.appSignature
                    result.success(appSignature)
                } catch (e: Exception) {
                    result.error("ERROR_GET_SIGNATURE", e.message, e)
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        unregisterReceiver()
        channel.setMethodCallHandler(null)
    }

    fun setCode(code: String?) {
        channel.invokeMethod("smscode", code)
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

    private fun unregisterReceiver() {
        if (broadcastReceiver != null && activity != null) {
            try {
                activity?.unregisterReceiver(broadcastReceiver)
            } catch (_: Exception) {
                // silent catch to avoid crash if not registered
            }
        }
        broadcastReceiver = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        unregisterReceiver()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        unregisterReceiver()
        activity = null
    }

    private class SmsBroadcastReceiver(
        private val pluginRef: WeakReference<PlatformMethodsPlugin>,
        private val smsCodeRegexPattern: String
    ) : BroadcastReceiver() {

        @Suppress("DEPRECATION")
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == SmsRetriever.SMS_RETRIEVED_ACTION) {
                val plugin = pluginRef.get() ?: return
                try {
                    plugin.activity?.unregisterReceiver(this)
                } catch (_: Exception) {
                    // ignore
                }

                val extras: Bundle? = intent.extras
                if (extras != null) {
                    val status: Status? =
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                            extras.getParcelable(SmsRetriever.EXTRA_STATUS, Status::class.java)
                        } else {
                            extras.getParcelable(SmsRetriever.EXTRA_STATUS) as? Status
                        }

                    if (status != null && status.statusCode == CommonStatusCodes.SUCCESS) {
                        val message: String? = extras.getString(SmsRetriever.EXTRA_SMS_MESSAGE)
                        if (message != null) {
                            try {
                                val pattern = Pattern.compile(smsCodeRegexPattern)
                                val matcher: Matcher = pattern.matcher(message)
                                if (matcher.find()) {
                                    plugin.setCode(matcher.group(0))
                                } else {
                                    plugin.setCode(message)
                                }
                            } catch (_: Exception) {
                                plugin.setCode(message)
                            }
                        }
                    }
                }
            }
        }
    }
}

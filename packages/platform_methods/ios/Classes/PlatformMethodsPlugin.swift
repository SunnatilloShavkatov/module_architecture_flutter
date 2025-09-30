import Flutter
import UIKit

public class PlatformMethodsPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "platform_methods", binaryMessenger: registrar.messenger())
        let instance = PlatformMethodsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    private func isPhysicalDevice() -> Bool {
#if targetEnvironment(simulator)
        return false
#else
        return true
#endif
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getDeviceId":
            let deviceIDManager = DeviceIDManager()
            do {
                let deviceID = try deviceIDManager.getAppSetID()
                result(deviceID)
            } catch {
                result(FlutterError(code: "UNAVAILABLE",
                                    message: "Device ID not available",
                                    details: nil))
            }
        case "isPhysicalDevice":
            result(isPhysicalDevice())
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

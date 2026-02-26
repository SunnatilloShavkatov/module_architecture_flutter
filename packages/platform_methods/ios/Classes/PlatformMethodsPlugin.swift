import Flutter
import UIKit

public class PlatformMethodsPlugin: NSObject, FlutterPlugin {
    private let workQueue = DispatchQueue(
        label: "uz.nasiya.platform_methods.work_queue",
        qos: .utility
    )
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "platform_methods", binaryMessenger: registrar.messenger())
        let instance = PlatformMethodsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    private func isEmulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getDeviceId":
            workQueue.async {
                let deviceIDManager = DeviceIDManager()
                do {
                    let deviceID = try deviceIDManager.getAppSetID()
                    DispatchQueue.main.async {
                        result(deviceID)
                    }
                } catch {
                    DispatchQueue.main.async {
                        result(
                            FlutterError(
                                code: "UNAVAILABLE",
                                message: "Device ID not available",
                                details: nil
                            )
                        )
                    }
                }
            }
        case "isEmulator":
            let value = isEmulator()
            result(value)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

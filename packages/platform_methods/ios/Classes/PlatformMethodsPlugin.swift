import Flutter
import UIKit

public class PlatformMethodsPlugin: NSObject, FlutterPlugin {
    private let workQueue = DispatchQueue(
        label: "uz.nasiya.platform_methods.work_queue",
        qos: .utility
    )
    private let inAppReviewManager = InAppReviewManager()
    
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
        case "isReviewAvailable":
            DispatchQueue.main.async {
                result(self.inAppReviewManager.isReviewAvailable())
            }
        case "requestReview":
            inAppReviewManager.requestReview { reviewResult in
                switch reviewResult {
                case .success:
                    result(nil)
                case .failure(let error):
                    result(
                        FlutterError(
                            code: error.code,
                            message: error.message,
                            details: error.details
                        )
                    )
                }
            }
        case "openStoreListing":
            let appStoreId = (call.arguments as? [String: Any])?["appStoreId"] as? String
            inAppReviewManager.openStoreListing(appStoreId: appStoreId) { reviewResult in
                switch reviewResult {
                case .success:
                    result(nil)
                case .failure(let error):
                    result(
                        FlutterError(
                            code: error.code,
                            message: error.message,
                            details: error.details
                        )
                    )
                }
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

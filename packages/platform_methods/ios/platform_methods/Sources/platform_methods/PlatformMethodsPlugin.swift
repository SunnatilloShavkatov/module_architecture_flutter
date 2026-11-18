import Flutter
import UIKit

/// Implements the Pigeon-generated `PlatformMethodsHostApi` over Native Interop (FFI).
/// No FlutterMethodChannel is used.
public final class PlatformMethodsPlugin: NSObject, FlutterPlugin, PlatformMethodsHostApi {
    private let inAppReviewManager = InAppReviewManager()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = PlatformMethodsPlugin()
        registrar.publish(instance)
        PlatformMethodsHostApiSetup.register(api: instance, registrar: registrar)
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        PlatformMethodsHostApiSetup.unregister(api: self, registrar: registrar)
    }

    func isEmulator() async throws -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    func getDeviceId() async throws -> String? {
        let task = Task.detached(priority: .utility) { () throws -> String? in
            try DeviceIDManager().getAppSetID()
        }
        do {
            return try await task.value
        } catch {
            throw PlatformMethodsError(
                code: "UNAVAILABLE",
                message: "Device ID not available",
                details: nil
            )
        }
    }

    func isReviewAvailable() async throws -> Bool {
        await inAppReviewManager.isReviewAvailable()
    }

    func requestReview() async throws {
        try await inAppReviewManager.requestReview()
    }

    func openStoreListing(appStoreId: String?) async throws {
        try await inAppReviewManager.openStoreListing(appStoreId: appStoreId)
    }
}

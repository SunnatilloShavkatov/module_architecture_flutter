import Foundation
import KeychainAccess
import UIKit

class DeviceIDManager {

    // MARK: - Constants
    private struct Constants {
        static let deviceIdKey = "app_set_id"
        static let defaultBundleId = "uz.englify.englify"
    }

    // MARK: - Error Types
    enum DeviceIDError: Error {
        case vendorIdUnavailable
        case keychainSaveFailed
        case keychainReadFailed
    }

    // MARK: - Public Methods
    /// Gets or generates a device ID, stored in Keychain
    func getAppSetID() throws -> String {
        let service = Bundle.main.bundleIdentifier ?? Constants.defaultBundleId
        let keychain = Keychain(service: service).synchronizable(false)

        // Step 1: Try to read existing ID from Keychain
        do {
            if let storedID = try keychain.get(Constants.deviceIdKey), !storedID.isEmpty {
                return storedID
            }
        } catch {
            // Continue with a fresh ID if Keychain read fails.
        }

        // Step 2: Generate new device ID using identifierForVendor
        guard let vendorId = UIDevice.current.identifierForVendor?.uuidString else {
            throw DeviceIDError.vendorIdUnavailable
        }

        // Step 3: Save new vendor ID to Keychain
        do {
            try keychain.set(vendorId, key: Constants.deviceIdKey)
            return vendorId
        } catch {
            throw DeviceIDError.keychainSaveFailed
        }
    }
}
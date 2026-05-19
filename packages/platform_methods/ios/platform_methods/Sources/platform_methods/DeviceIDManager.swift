import Foundation
import Security
import UIKit

class DeviceIDManager {

    private struct Constants {
        static let deviceIdKey = "app_set_id"
        static let defaultBundleId = "uz.englify.englify"
    }

    enum DeviceIDError: Error {
        case vendorIdUnavailable
        case keychainSaveFailed
        case keychainReadFailed
    }

    func getAppSetID() throws -> String {
        let service = Bundle.main.bundleIdentifier ?? Constants.defaultBundleId

        if let storedID = try? keychainRead(service: service, key: Constants.deviceIdKey), !storedID.isEmpty {
            return storedID
        }

        guard let vendorId = UIDevice.current.identifierForVendor?.uuidString else {
            throw DeviceIDError.vendorIdUnavailable
        }

        if keychainWrite(service: service, key: Constants.deviceIdKey, value: vendorId) {
            return vendorId
        } else {
            throw DeviceIDError.keychainSaveFailed
        }
    }

    private func keychainRead(service: String, key: String) throws -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne,
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        return value
    }

    private func keychainWrite(service: String, key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecValueData: data,
        ]
        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
}

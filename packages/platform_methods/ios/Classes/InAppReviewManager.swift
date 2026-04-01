import Foundation
import StoreKit
import UIKit

struct InAppReviewError: Error {
    let code: String
    let message: String
    let details: String?
}

final class InAppReviewManager {
    private enum Constants {
        static let appStoreIdKey = "PlatformMethodsAppStoreId"
    }

    func isReviewAvailable() -> Bool {
        return activeWindowScene() != nil
    }

    func requestReview(completion: @escaping (Result<Void, InAppReviewError>) -> Void) {
        DispatchQueue.main.async {
            if let scene = self.activeWindowScene() {
                SKStoreReviewController.requestReview(in: scene)
                completion(.success(()))
                return
            }

            self.openStoreListing(
                writeReview: true,
                completion: completion
            )
        }
    }

    func openStoreListing(completion: @escaping (Result<Void, InAppReviewError>) -> Void) {
        DispatchQueue.main.async {
            self.openStoreListing(
                writeReview: false,
                completion: completion
            )
        }
    }

    private func openStoreListing(
        writeReview: Bool,
        completion: @escaping (Result<Void, InAppReviewError>) -> Void
    ) {
        guard let appStoreId = appStoreId() else {
            completion(
                .failure(
                    InAppReviewError(
                        code: "APP_STORE_ID_MISSING",
                        message: "PlatformMethodsAppStoreId is missing from Info.plist",
                        details: nil
                    )
                )
            )
            return
        }

        let suffix = writeReview ? "?action=write-review" : ""
        let candidateUrls = [
            URL(string: "itms-apps://itunes.apple.com/app/id\(appStoreId)\(suffix)"),
            URL(string: "https://apps.apple.com/app/id\(appStoreId)\(suffix)")
        ].compactMap { $0 }

        guard !candidateUrls.isEmpty else {
            completion(
                .failure(
                    InAppReviewError(
                        code: "STORE_URL_INVALID",
                        message: "Failed to build App Store URL",
                        details: appStoreId
                    )
                )
            )
            return
        }

        guard let url = candidateUrls.first(where: { UIApplication.shared.canOpenURL($0) }) else {
            completion(
                .failure(
                    InAppReviewError(
                        code: "STORE_LISTING_UNAVAILABLE",
                        message: "App Store listing is unavailable",
                        details: candidateUrls.map(\.absoluteString).joined(separator: ", ")
                    )
                )
            )
            return
        }

        UIApplication.shared.open(url, options: [:]) { didOpen in
            if didOpen {
                completion(.success(()))
            } else {
                completion(
                    .failure(
                        InAppReviewError(
                            code: "STORE_LISTING_OPEN_FAILED",
                            message: "Failed to open App Store listing",
                            details: url.absoluteString
                        )
                    )
                )
            }
        }
    }

    private func activeWindowScene() -> UIWindowScene? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
    }

    private func appStoreId() -> String? {
        let rawValue = Bundle.main.object(forInfoDictionaryKey: Constants.appStoreIdKey)
        if let appStoreId = rawValue as? String, !appStoreId.isEmpty {
            return appStoreId
        }
        if let appStoreId = rawValue as? NSNumber {
            return appStoreId.stringValue
        }
        return nil
    }
}

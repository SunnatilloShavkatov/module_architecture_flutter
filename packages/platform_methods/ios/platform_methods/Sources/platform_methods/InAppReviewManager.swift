import Foundation
import StoreKit
import UIKit

/// All UIKit/StoreKit access runs on the main actor.
@MainActor
final class InAppReviewManager {
    nonisolated init() {}

    func isReviewAvailable() -> Bool {
        activeWindowScene() != nil
    }

    func requestReview() throws {
        guard let scene = activeWindowScene() else {
            throw PlatformMethodsError(
                code: "REVIEW_UNAVAILABLE",
                message: "No active UIWindowScene available to request review",
                details: nil
            )
        }
        SKStoreReviewController.requestReview(in: scene)
    }

    func openStoreListing(appStoreId: String?) async throws {
        guard let appStoreId, !appStoreId.isEmpty else {
            throw PlatformMethodsError(
                code: "APP_STORE_ID_MISSING",
                message: "The appStoreId argument is required on iOS",
                details: nil
            )
        }

        let candidateUrls = [
            URL(string: "itms-apps://itunes.apple.com/app/id\(appStoreId)?action=write-review"),
            URL(string: "https://apps.apple.com/app/id\(appStoreId)?action=write-review"),
        ].compactMap { $0 }

        guard !candidateUrls.isEmpty else {
            throw PlatformMethodsError(
                code: "STORE_URL_INVALID",
                message: "Failed to build App Store URL",
                details: appStoreId
            )
        }

        guard let url = candidateUrls.first(where: { UIApplication.shared.canOpenURL($0) }) else {
            throw PlatformMethodsError(
                code: "STORE_LISTING_UNAVAILABLE",
                message: "App Store listing is unavailable",
                details: candidateUrls.map(\.absoluteString).joined(separator: ", ")
            )
        }

        let didOpen = await UIApplication.shared.open(url, options: [:])
        guard didOpen else {
            throw PlatformMethodsError(
                code: "STORE_LISTING_OPEN_FAILED",
                message: "Failed to open App Store listing",
                details: url.absoluteString
            )
        }
    }

    private func activeWindowScene() -> UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
    }
}

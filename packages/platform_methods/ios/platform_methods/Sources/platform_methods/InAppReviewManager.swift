import Foundation
import StoreKit
import UIKit

struct InAppReviewError: Error {
    let code: String
    let message: String
    let details: String?
}

final class InAppReviewManager {
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

            completion(
                .failure(
                    InAppReviewError(
                        code: "REVIEW_UNAVAILABLE",
                        message: "No active UIWindowScene available to request review",
                        details: nil
                    )
                )
            )
        }
    }

    func openStoreListing(
        appStoreId: String?,
        completion: @escaping (Result<Void, InAppReviewError>) -> Void
    ) {
        DispatchQueue.main.async {
            self.openStoreListingInternal(appStoreId: appStoreId, completion: completion)
        }
    }

    private func openStoreListingInternal(
        appStoreId: String?,
        completion: @escaping (Result<Void, InAppReviewError>) -> Void
    ) {
        guard let appStoreId, !appStoreId.isEmpty else {
            completion(
                .failure(
                    InAppReviewError(
                        code: "APP_STORE_ID_MISSING",
                        message: "The appStoreId argument is required on iOS",
                        details: nil
                    )
                )
            )
            return
        }

        let candidateUrls = [
            URL(string: "itms-apps://itunes.apple.com/app/id\(appStoreId)?action=write-review"),
            URL(string: "https://apps.apple.com/app/id\(appStoreId)?action=write-review")
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
}

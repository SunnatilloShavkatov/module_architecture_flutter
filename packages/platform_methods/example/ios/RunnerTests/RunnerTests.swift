import Flutter
import UIKit
import XCTest

@testable import platform_methods

// Unit tests of the Swift host API implementation (Native Interop, no channels).
// See https://developer.apple.com/documentation/xctest for more information about XCTest.

class RunnerTests: XCTestCase {

  func testIsEmulatorMatchesBuildEnvironment() async throws {
    let plugin = PlatformMethodsPlugin()

    let isEmulator = try await plugin.isEmulator()

    #if targetEnvironment(simulator)
    XCTAssertTrue(isEmulator)
    #else
    XCTAssertFalse(isEmulator)
    #endif
  }

  func testOpenStoreListingWithoutAppStoreIdThrows() async {
    let plugin = PlatformMethodsPlugin()

    do {
      try await plugin.openStoreListing(appStoreId: nil)
      XCTFail("Expected PlatformMethodsError")
    } catch {
      XCTAssertTrue(error is PlatformMethodsError)
    }
  }
}

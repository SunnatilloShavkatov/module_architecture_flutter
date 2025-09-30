import Flutter
import UIKit
import XCTest


@testable import platform_methods

// This demonstrates a simple unit test of the Swift portion of this plugin's implementation.
//
// See https://developer.apple.com/documentation/xctest for more information about using XCTest.

class RunnerTests: XCTestCase {

  func testIsPhysicalDevice() {
    let plugin = PlatformMethodsPlugin()

    let call = FlutterMethodCall(methodName: "isPhysicalDevice", arguments: [])

    let resultExpectation = expectation(description: "result block must be called.")
    plugin.handle(call) { result in
      XCTAssertTrue(result as! Bool)
      resultExpectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

}

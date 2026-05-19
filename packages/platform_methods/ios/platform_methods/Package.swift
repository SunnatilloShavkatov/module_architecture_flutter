// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "platform_methods",
    platforms: [
        .iOS("15.0"),
    ],
    products: [
        .library(name: "platform-methods", targets: ["platform_methods"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.2"),
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
    ],
    targets: [
        .target(
            name: "platform_methods",
            dependencies: [
                .product(name: "KeychainAccess", package: "KeychainAccess"),
                .product(name: "FlutterFramework", package: "FlutterFramework"),
            ],
            path: "Sources/platform_methods",
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        ),
    ]
)

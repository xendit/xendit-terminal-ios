// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "TerminalSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // We export the library under the name "TerminalC2C".
        // It points to the "TerminalC2CWrapper" target which includes the binary and Sentry.
        .library(
            name: "TerminalC2C",
            targets: ["TerminalC2CWrapper"]
        ),
        .library(
            name: "TerminalH2H",
            targets: ["TerminalH2HWrapper"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/getsentry/sentry-cocoa", from: "8.57.3")
    ],
    targets: [
        // 1. The actual binary frameworks.
        // We give them unique names to avoid namespace collisions with the wrapper targets.
        .binaryTarget(
            name: "TerminalC2CBinary",
            url: "https://github.com/shiburagi/cocoapod-test-2/releases/download/1.1.0/TerminalC2C.xcframework.zip",
            checksum: "28d55e737f0b5b7c86e330efb99305b4b3886814839b0d17c88bcb5551b7f9e0"
        ),
        .binaryTarget(
            name: "TerminalH2HBinary",
            url: "https://github.com/shiburagi/cocoapod-test-2/releases/download/1.1.0/TerminalH2H.xcframework.zip",
            checksum: "13091daebad6701dee6d4384d08b69c91b172dc5e2fcc9d5cc636754cb9da018"
        ),

        // 2. The wrapper targets.
        // These are the targets that the consuming app actually "sees" and builds.
        // They must have unique paths.
        .target(
            name: "TerminalC2CWrapper",
            dependencies: [
                .target(name: "TerminalC2CBinary"),
                .product(name: "Sentry", package: "sentry-cocoa")
            ],
            path: "Sources/TerminalC2CWrapper"
        ),
        .target(
            name: "TerminalH2HWrapper",
            dependencies: [
                .target(name: "TerminalH2HBinary"),
                .product(name: "Sentry", package: "sentry-cocoa")
            ],
            path: "Sources/TerminalH2HWrapper"
        )
    ]
)
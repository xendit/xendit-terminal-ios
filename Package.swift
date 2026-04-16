// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "TerminalC2C",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        // We export the library under the name "TerminalC2C".
        // It points to the "TerminalC2CWrapper" target which includes the binary and Sentry.
        .library(
            name: "TerminalC2C",
            targets: ["TerminalC2CWrapper"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/getsentry/sentry-cocoa", from: "8.57.3")
    ],
    targets: [
        // 1. The actual binary framework.
        // We give it a unique name (TerminalC2CBinary) to avoid
        // namespace collisions with the wrapper target or the product name.
        .binaryTarget(
            name: "TerminalC2CBinary",
            url: "https://github.com/xendit/xendit-terminal-ios/releases/download/1.0.1-dev.3/TerminalC2C.xcframework.zip",
            checksum: "7c2299f48e0bd10f2fc172071378387417ddb05c5f22f2219f7ef6c91a29acf9"
        ),

        // 2. The wrapper target.
        // This is the target that the consuming app actually "sees" and builds.
        .target(
            name: "TerminalC2CWrapper",
            dependencies: [
                .target(name: "TerminalC2CBinary"),
                .product(name: "Sentry", package: "sentry-cocoa")
            ],
            path: "Sources/TerminalWrapper"
        )
    ]
)
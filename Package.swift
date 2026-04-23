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
            url: "https://github.com/xendit/xendit-terminal-ios/releases/download/1.1.1/TerminalC2C.xcframework.zip",
            checksum: "529aa507655aded40e68a13b0105c02291421fbff1568fdea8b4bc8bfe2a254b"
        ),
        .binaryTarget(
            name: "TerminalH2HBinary",
            url: "https://github.com/xendit/xendit-terminal-ios/releases/download/1.1.1/TerminalH2H.xcframework.zip",
            checksum: "9a13d06ea6e933877f2fcabb399ba568663e8e8d2703bd665c14119273c2a07a"
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
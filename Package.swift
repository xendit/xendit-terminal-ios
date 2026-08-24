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
            url: "https://github.com/xendit/xendit-terminal-ios/releases/download/1.2.2/TerminalC2C.xcframework.zip",
            checksum: "6177a9978d98947044497d50bf6fe3b20269c7ee4366fdf8f50e14be10fc8b68"
        ),
        .binaryTarget(
            name: "TerminalH2HBinary",
            url: "https://github.com/xendit/xendit-terminal-ios/releases/download/1.2.2/TerminalH2H.xcframework.zip",
            checksum: "8870d0ef0d082a11a6cf5bbb3e63e8b1e6b9715f0b7e3574707a55576335bc73"
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
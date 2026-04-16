// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "TerminalSDK",
    platforms: [
        .iOS("15.0")
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
        // 1. The actual binary framework.
        // We give it a unique name (TerminalC2CBinary) to avoid
        // namespace collisions with the wrapper target or the product name.
        .binaryTarget(
            name: "TerminalC2CBinary",
            url: "https://github.com/shiburagi/cocoapod-test-2/releases/download/1.0.0/TerminalC2C.xcframework.zip",
            checksum: "a7836930dce347e1641c4daadbcf927d00919b3e219f695b0fcba7fe72120b98"
        ),
        .binaryTarget(
            name: "TerminalH2HBinary",
            url: "https://github.com/shiburagi/cocoapod-test-2/releases/download/1.0.0/TerminalH2H.xcframework.zip",
            checksum: "f6f90bee90db6ad1b0c691027e9211a568de71ac0f39b22ab8ba63b324136dfc"
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
        ),
        .target(
            name: "TerminalH2HWrapper",
            dependencies: [
                .target(name: "TerminalH2HBinary"),
                .product(name: "Sentry", package: "sentry-cocoa")
            ],
            path: "Sources/TerminalWrapper"
        )
    ]
)
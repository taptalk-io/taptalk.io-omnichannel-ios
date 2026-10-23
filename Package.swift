// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TapTalkLive",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16) // Needs to be iOS 16+ for newer Google Maps SDKs
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OneTalkLiveChat",
            targets: ["OneTalkLiveChat"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/taptalk-io/taptalk.io-ios",
            from: "3.0.0"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OneTalkLiveChat",
            dependencies: [
                .product(name: "PowerTalk", package: "taptalk.io-ios"),
            ],
            path: "TapTalkLive",
            sources: ["Components", "Managers", "Models", "View Controllers", "Views"],
            resources: [
                .process("Supporting Files/Fonts"),
                .process("XIB")
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("Components"),
                .headerSearchPath("Managers"),
                .headerSearchPath("Models"),
                .headerSearchPath("View Controllers"),
                .headerSearchPath("Views")
            ],
        ),
        .testTarget(
            name: "TapTalkLiveTests",
            dependencies: ["OneTalkLiveChat"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KaraokeSDK",
    defaultLocalization: "ja",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "KaraokeSDK",
            targets: ["KaraokeSDK"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.10.0")),
        .package(url: "https://github.com/marksands/BetterCodable.git", .upToNextMajor(from: "0.4.0")),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins.git", from: "0.59.1"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
        .package(url: "https://github.com/CoreOffice/XMLCoder.git", from: "0.17.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "KaraokeSDK",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "BetterCodable", package: "BetterCodable"),
                .product(name: "SwiftyBeaver", package: "SwiftyBeaver"),
                .product(name: "KeychainAccess", package: "KeychainAccess"),
                .product(name: "XMLCoder", package: "XMLCoder"),
            ],
            resources: [.process("Localizable.xcstrings")],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),
        .testTarget(
            name: "KaraokeSDKTests",
            dependencies: ["KaraokeSDK"],
            path: "Tests",
            resources: [.copy("Resources")]
        ),
    ]
)

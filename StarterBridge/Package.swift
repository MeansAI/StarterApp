// swift-tools-version:6.2

import PackageDescription

let package = Package(
    name: "StarterBridge",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .visionOS(.v26),
        .watchOS(.v26)
    ],
    products: [
        .library(
            name: "StarterBridge",
            targets: ["StarterBridge"]),
    ],
    dependencies: [
        .package(path: "../../JWS/JBS"),
    ],
    targets: [
        .target(
            name: "StarterBridge",
            dependencies: [
                .product(name: "JBS", package: "JBS"),
            ]),
        .testTarget(
            name: "StarterBridgeTests",
            dependencies: ["StarterBridge"]),
    ]
)

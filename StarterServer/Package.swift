// swift-tools-version:6.2
import PackageDescription

let package = Package(
    name: "StarterServer",
    platforms: [
        .macOS(.v26),
    ],
    dependencies: [
        .package(path: "../../JWS/JWS"),
        .package(path: "../StarterBridge"),
    ],
    targets: [
        .target(
            name: "StarterServerApp",
            dependencies: [
                .product(name: "JWS", package: "JWS"),
                .product(name: "StarterBridge", package: "StarterBridge"),
            ],
            swiftSettings: [
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release)),
                .swiftLanguageMode(.v5),
            ]
        ),
        .executableTarget(
            name: "StarterServerRun",
            dependencies: [.target(name: "StarterServerApp")]
        ),
    ]
)

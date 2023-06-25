// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "LaunchDetailFeature", targets: ["LaunchDetailFeature"]),
        .library(name: "PastLaunchesFeature", targets: ["PastLaunchesFeature"]),
        .library(name: "PastLaunchesFeatureTests", targets: ["PastLaunchesFeatureTests"]),
        .library(name: "SharedModels", targets: ["SharedModels"])
    ],
    dependencies: [
        .package(path: "../Kits")
    ],
    targets: [
        .target(
            name: "LaunchDetailFeature",
            dependencies: [
                "SharedModels"
            ],
            path: "LaunchDetailFeature/Sources"
        ),
        .target(
            name: "PastLaunchesFeature",
            dependencies: [
                "LaunchDetailFeature",
                "SharedModels",
                .product(name: "APIClient", package: "Kits"),
                .product(name: "UserDefaultsClient", package: "Kits")
            ],
            path: "PastLaunchesFeature/Sources"
        ),
        .testTarget(
            name: "PastLaunchesFeatureTests",
            dependencies: [
                "PastLaunchesFeature",
                "SharedModels",
                .product(name: "APIClient", package: "Kits")
            ],
            path: "PastLaunchesFeature/Tests"
        ),
        .target(
            name: "SharedModels",
            path: "SharedModels/Sources"
        )
    ]
)

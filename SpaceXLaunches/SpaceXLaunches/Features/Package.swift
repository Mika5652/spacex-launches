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
                "SharedModels",
                .product(name: "APIClient", package: "Kits")
            ],
            path: "PastLaunchesFeature/Sources"
        ),
        .target(
            name: "SharedModels",
            path: "SharedModels/Sources"
        )
    ]
)

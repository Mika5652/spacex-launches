// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "PastLaunchesFeature", targets: ["PastLaunchesFeature"]),
    ],
    dependencies: [
        .package(path: "../Kits")
    ],
    targets: [
        .target(
            name: "PastLaunchesFeature",
            dependencies: [
                .product(name: "APIClient", package: "Kits")
            ],
            path: "PastLaunchesFeature/Sources"
        )
    ]
)

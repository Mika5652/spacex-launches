// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Features",
    products: [
        .library(name: "PastLaunchesFeature", targets: ["PastLaunchesFeature"]),
    ],
    targets: [
        .target(
            name: "PastLaunchesFeature",
            path: "PastLaunchesFeature/Sources"
        )
    ]
)

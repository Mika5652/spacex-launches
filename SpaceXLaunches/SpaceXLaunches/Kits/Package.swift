// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Kits",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "APIClient", targets: ["APIClient"])
    ],
    targets: [
        .target(
            name: "APIClient",
            path: "APIClient/Sources"
        )
    ]
)

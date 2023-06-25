// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Kits",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "APIClient", targets: ["APIClient"]),
        .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"])
    ],
    targets: [
        .target(
            name: "APIClient",
            path: "APIClient/Sources"
        ),
        .target(
            name: "UserDefaultsClient",
            path: "UserDefaultsClient/Sources"
        )
    ]
)

// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Kits",
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

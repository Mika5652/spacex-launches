// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpaceXLaunches",
    products: [
        .library(name: "PastLaunches", targets: ["PastLaunches"]),
    ],
    targets: [
        .target(name: "PastLaunches")
    ]
)

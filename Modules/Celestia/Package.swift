// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Celestia",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "Celestia",
            targets: ["Celestia"]
        )
    ],
    dependencies: [
        .package(name: "CranberrySprite", path: "../CranberrySprite")
    ],
    targets: [
        .target(
            name: "Celestia",
            dependencies: [
                .product(name: "CranberrySprite", package: "CranberrySprite")
            ]
        ),
        .testTarget(
            name: "CelestiaTests",
            dependencies: ["Celestia"]
        )
    ]
)

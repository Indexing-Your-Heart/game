// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Caslon",
    platforms: [.macOS(.v13), .iOS(.v16), .tvOS(.v16)],
    products: [
        .library(
            name: "Caslon",
            targets: ["Caslon"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/Indexing-Your-Heart/JensonKit",
            from: .init(0, 1, 0, prereleaseIdentifiers: ["alpha"])
        ),
        .package(
            url: "https://github.com/apple/swift-log",
            from: .init(1, 0, 0)
        ),
        .package(url: "https://github.com/alicerunsonedora/CranberrySprite", branch: "root")
    ],
    targets: [
        .target(
            name: "Caslon",
            dependencies: [
                .product(name: "JensonKit", package: "JensonKit")
            ],
            path: "./Sources/"
        )
    ]
)

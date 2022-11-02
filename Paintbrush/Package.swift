// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Paintbrush",
    platforms: [.macOS(.v13), .iOS(.v16), .tvOS(.v16)],
    products: [
        .library(
            name: "Paintbrush",
            targets: ["Paintbrush"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/alicerunsonfedora/CranberrySprite", branch: "root")
    ],
    targets: [
        .target(
            name: "Paintbrush",
            dependencies: [
                "CranberrySprite"
            ],
            path: "./Sources/"
        ),
        .testTarget(
            name: "PaintbrushProtractorTests",
            dependencies: [
                "Paintbrush"
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)

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
    ],
    targets: [
        .target(
            name: "Paintbrush",
            dependencies: [],
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

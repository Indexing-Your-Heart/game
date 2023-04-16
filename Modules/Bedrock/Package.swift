// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Bedrock",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "Bedrock",
            targets: ["Bedrock"]),
    ],
    dependencies: [
        .package(name: "Paintbrush", path: "../Paintbrush")
    ],
    targets: [
        .target(
            name: "Bedrock",
            dependencies: [
                .product(name: "Paintbrush", package: "Paintbrush")
            ],
            path: "./Sources/"
        ),
        .testTarget(
            name: "BedrockTests",
            dependencies: ["Bedrock"]),
    ]
)

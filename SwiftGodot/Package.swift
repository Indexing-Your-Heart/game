// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftGodot",
    products: [
        .library(
            name: "SwiftGodot",
            targets: ["SwiftGodot"]),
    ],
    targets: [
        .binaryTarget(name: "SwiftGodot", path: "./SwiftGodot.xcframework")
    ]
)
// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Rollinsport",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        .library(
            name: "Rollinsport",
            type: .dynamic,
            targets: ["Rollinsport"]),
    ],
    dependencies: [
        .package(name: "SwiftGodot", path: "../SwiftGodot"),
        .package(name: "Ashashat", path: "../Ashashat"),
        .package(name: "AnthroBase", path: "../AnthroBase"),
        .package(name: "JensonGodotKit", path: "../JensonGodotKit"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Rollinsport",
            dependencies: [
                "SwiftGodot",
                "Ashashat",
                "AnthroBase",
                "JensonGodotKit",
                .product(name: "Logging", package: "swift-log")
            ],
            linkerSettings: [
                .unsafeFlags(["-Xlinker", "-undefined", "-Xlinker", "dynamic_lookup"])
            ]),
    ]
)

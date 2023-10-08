// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Demoscene",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        .library(
            name: "Demoscene",
            type: .dynamic,
            targets: ["Demoscene"]),
    ],
    dependencies: [
        .package(name: "SwiftGodot", path: "../SwiftGodot"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(name: "Ashashat", path: "../Ashashat"),
        .package(name: "JensonGodotKit", path: "../JensonGodotKit"),
    ],
    targets: [
        .target(
            name: "Demoscene",
            dependencies: [
                "SwiftGodot",
                "Ashashat",
                "JensonGodotKit",
                .product(name: "Logging", package: "swift-log")
            ],
            linkerSettings: [
                .unsafeFlags(["-Xlinker", "-undefined","-Xlinker", "dynamic_lookup"])
            ])
    ]
)


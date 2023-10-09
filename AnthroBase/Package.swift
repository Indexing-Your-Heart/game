// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "AnthroBase",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        .library(
            name: "AnthroBase",
            type: .dynamic,
            targets: ["AnthroBase"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(name: "SwiftGodot", path: "../SwiftGodot"),
    ],
    targets: [
        .target(
            name: "AnthroBase",
            dependencies: [
                "SwiftGodot",
                .product(name: "Logging", package: "swift-log")
            ],
            linkerSettings: [.unsafeFlags(["-Xlinker", "-undefined","-Xlinker", "dynamic_lookup"])]),
    ]
)

// swift-tools-version: 5.7

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
    targets: [
        .binaryTarget(name: "SwiftGodot", path: "../SwiftGodot.xcframework"),
        .target(
            name: "AnthroBase",
            dependencies: ["SwiftGodot"],
            swiftSettings: [.unsafeFlags(["-suppress-warnings"])],
            linkerSettings: [.unsafeFlags(["-Xlinker", "-undefined","-Xlinker", "dynamic_lookup"])])
    ]
)

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
    dependencies: [
        .package(name: "SwiftGodot", path: "../SwiftGodot")
    ],
    targets: [
        .target(
            name: "AnthroBase",
            dependencies: ["SwiftGodot"],
            swiftSettings: [.unsafeFlags(["-suppress-warnings"])],
            linkerSettings: [.unsafeFlags(["-Xlinker", "-undefined","-Xlinker", "dynamic_lookup"])])
    ]
)

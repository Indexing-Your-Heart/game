// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Ashashat",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        .library(
            name: "Ashashat",
            type: .dynamic,
            targets: ["Ashashat"]),
    ],
    dependencies: [
        .package(name: "SwiftGodot", path: "../SwiftGodot"),
    ],
    targets: [
        .target(
            name: "Ashashat",
            dependencies: ["SwiftGodot", .product(name: "SwiftGodotMacros", package: "SwiftGodot")],
            swiftSettings: [.unsafeFlags(["-suppress-warnings"])],
            linkerSettings: [.unsafeFlags(["-Xlinker", "-undefined", "-Xlinker", "dynamic_lookup"])]),
        .testTarget(
            name: "AshashatTests",
            dependencies: ["Ashashat"]),
    ]
)

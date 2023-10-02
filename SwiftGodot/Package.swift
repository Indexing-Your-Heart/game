// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SwiftGodot",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        .library(
            name: "SwiftGodot",
            targets: ["SwiftGodot"]),
        .library(
            name: "SwiftGodotMacros",
            targets: ["SwiftGodotMacros"]
        ),
        .executable(
            name: "SwiftGodotMacrosClient",
            targets: ["SwiftGodotMacrosClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git",
                 from: "509.0.0"),
    ],
    targets: [
        .binaryTarget(
            name: "SwiftGodot",
            url: "https://gitlab.com/indexing-your-heart/SwiftGodotCore/-/releases/v1.0.0-alpha21/downloads/SwiftGodot.xcframework.zip",
            checksum: "54e9723beb8aad113651d5f27156c1d8aee4a1c3ceb1add1c02f835be1ba99be"),
        .macro(
            name: "SwiftGodotMacroLibrary",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "SwiftGodotMacros",
                dependencies: ["SwiftGodotMacroLibrary", .target(name: "SwiftGodot")]),
        .executableTarget(name: "SwiftGodotMacrosClient", dependencies: ["SwiftGodotMacros"]),
        .testTarget(
            name: "SwiftGodotMacrosTests",
            dependencies: [
                "SwiftGodotMacroLibrary",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)

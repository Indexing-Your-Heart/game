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
                 from: "509.0.0-swift-5.9-DEVELOPMENT-SNAPSHOT-2023-04-25-b"),
    ],
    targets: [
        .macro(
            name: "SwiftGodotMacrosMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "SwiftGodotMacros", dependencies: ["SwiftGodotMacrosMacros"]),
        .executableTarget(name: "SwiftGodotMacrosClient", dependencies: ["SwiftGodotMacros"]),
        .testTarget(
            name: "SwiftGodotMacrosTests",
            dependencies: [
                "SwiftGodotMacrosMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
        .binaryTarget(name: "SwiftGodot", path: "./SwiftGodot.xcframework"),
    ]
)

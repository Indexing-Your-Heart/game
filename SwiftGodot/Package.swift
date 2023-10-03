// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let swiftGodotCoreTag = "v1.0.0-alpha21-DEVELOPMENT-SNAPSHOT-2023-10-02-a"

let package = Package(
    name: "SwiftGodot",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        .library(name: "SwiftGodot",
                 targets: ["SwiftGodot"]),
        .library(
            name: "SwiftGodotCore",
            targets: ["SwiftGodotCore"]),
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
        .target(name: "SwiftGodot", dependencies: ["SwiftGodotCore", "SwiftGodotMacros"]),
        .binaryTarget(
            name: "SwiftGodotCore",
            url: "https://gitlab.com/indexing-your-heart/SwiftGodotCore/-/releases/\(swiftGodotCoreTag)/downloads/SwiftGodotCore.xcframework.zip",
            checksum: "3fc0178aa7d041b9b6e599453257f8e85217f68472c728b842a2325d7c5156eb"),
        .macro(
            name: "SwiftGodotMacroLibrary",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "SwiftGodotMacros",
                dependencies: ["SwiftGodotMacroLibrary", .target(name: "SwiftGodotCore")]),
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

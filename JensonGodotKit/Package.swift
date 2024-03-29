// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "JensonGodotKit",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        .library(
            name: "JensonGodotKit",
            type: .dynamic,
            targets: ["JensonGodotKit"]),
    ],
    dependencies: [
        .package(url: "https://gitlab.com/Indexing-Your-Heart/core-dependencies/JensonKit",
                 branch: "root"),
        .package(name: "SwiftGodot", path: "../SwiftGodot")
    ],
    targets: [
        .target(
            name: "JensonGodotKit",
            dependencies: ["SwiftGodot", "JensonKit", .product(name: "SwiftGodotMacros", package: "SwiftGodot")],
            linkerSettings: [.unsafeFlags(["-Xlinker", "-undefined","-Xlinker", "dynamic_lookup"])])
    ]
)

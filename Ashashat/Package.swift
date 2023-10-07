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
        .package(url: "https://gitlab.com/Indexing-Your-Heart/core-dependencies/AshashatKit",
                 from: "1.0.0-DEVELOPMENT-SNAPSHOT-2023-10-03-b")
    ],
    targets: [
        .target(
            name: "Ashashat",
            dependencies: ["AshashatKit", "SwiftGodot"],
            linkerSettings: [
                .unsafeFlags(["-Xlinker", "-undefined", "-Xlinker", "dynamic_lookup"])
            ])
    ]
)

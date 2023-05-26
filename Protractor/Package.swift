// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Protractor",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "Protractor",
            targets: ["Protractor"]),
        .library(
            name: "ProtractorGodotInterop",
            type: .dynamic,
            targets: ["ProtractorGodotInterop"])
    ],
    dependencies: [
        .package(name: "SwiftGodot", path: "../SwiftGodot")
    ],
    targets: [
        .target(name: "Protractor"),
        .target(
            name: "ProtractorGodotInterop",
            dependencies: ["SwiftGodot", "Protractor"],
            swiftSettings: [.unsafeFlags(["-suppress-warnings"])],
            linkerSettings: [.unsafeFlags(["-Xlinker", "-undefined","-Xlinker", "dynamic_lookup"])]),
        .testTarget(
            name: "ProtractorTests",
            dependencies: ["Protractor"],
            resources: [
                .process("Resources")
            ]),
    ]
)

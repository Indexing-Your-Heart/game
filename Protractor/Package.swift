// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Protractor",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "Protractor",
            type: .dynamic,
            targets: ["Protractor"]),
    ],
    dependencies: [
        .package(name: "SwiftGodot", path: "../SwiftGodot")
    ],
    targets: [
        .target(
            name: "Protractor",
            dependencies: ["SwiftGodot"],
            swiftSettings: [.unsafeFlags(["-suppress-warnings"])],
            linkerSettings: [.unsafeFlags(["-Xlinker", "-undefined","-Xlinker", "dynamic_lookup"])]),
        .testTarget(
            name: "ProtractorTests",
            dependencies: ["Protractor"]),
    ]
)

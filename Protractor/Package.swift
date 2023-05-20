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
        .package(url: "https://github.com/alicerunsonfedora/SwiftGodot",
                 branch: "main")
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

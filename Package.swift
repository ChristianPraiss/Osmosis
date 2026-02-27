// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Osmosis",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "Osmosis",
            targets: ["Osmosis"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "5.2.2"),
    ],
    targets: [
        .target(
            name: "Osmosis",
            dependencies: ["Kanna"],
            path: "Pod/Classes"
        ),
        .testTarget(
            name: "OsmosisTests",
            dependencies: ["Osmosis"],
            path: "Tests/OsmosisTests"
        ),
    ]
)

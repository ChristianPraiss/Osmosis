// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Osmosis",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "Osmosis",
            targets: ["Osmosis"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "5.2.7")
    ],
    targets: [
        .target(
            name: "Osmosis",
            dependencies: ["Kanna"],
            path: "Pod/Classes"),
        .testTarget(
            name: "OsmosisTests",
            dependencies: ["Osmosis"],
            path: "Tests"
        ),
    ]
)

// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DemoDateUtility",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "DemoDateUtility",
            type: .dynamic,
            targets: ["DemoDateUtility"]),
    ],
    targets: [
        .target(
            name: "DemoDateUtility",
            path: "Sources"),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)

// swift-tools-version: 5.8.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Inspect",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v14),
        .macCatalyst(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Inspect",
            targets: ["Inspect"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Inspect"),
        .testTarget(
            name: "InspectTests",
            dependencies: ["Inspect"])
    ]
)

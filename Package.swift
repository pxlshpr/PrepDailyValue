// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PrepDailyValue",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PrepDailyValue",
            targets: ["PrepDailyValue"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pxlshpr/PrepShared", from: "0.0.141"),
        .package(url: "https://github.com/pxlshpr/PrepSettings", from: "0.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PrepDailyValue",
            dependencies: [
                .product(name: "PrepShared", package: "PrepShared"),
                .product(name: "PrepSettings", package: "PrepSettings"),
            ]
        ),
        .testTarget(
            name: "PrepDailyValueTests",
            dependencies: ["PrepDailyValue"]),
    ]
)

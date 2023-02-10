// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RoutingReducer",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "RoutingReducer",
            targets: ["RoutingReducer"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            .upToNextMajor(from: "0.50.1")
        )
    ],
    targets: [
        .target(
            name: "RoutingReducer",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                )
            ]
        )
    ]
)


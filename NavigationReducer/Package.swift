// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NavigationReducer",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "NavigationReducer",
            targets: ["NavigationReducer"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            .upToNextMajor(from: "0.50.1")
        )
    ],
    targets: [
        .target(
            name: "NavigationReducer",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                )
            ]
        )
    ]
)


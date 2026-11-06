// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "XiaoYuanDad",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        // An xtool project should contain exactly one library product,
        // representing the main app.
        .library(
            name: "XiaoYuanDad",
            targets: ["XiaoYuanDad"]
        ),
    ],
    targets: [
        .target(
            name: "XiaoYuanDad",
            resources: [.copy("Resources")]
        ),
    ]
)

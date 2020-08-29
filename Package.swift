// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SwiftIB",
    platforms: [
        .macOS(.v10_14),
    ],
    products: [
        .library(
            name: "SwiftIB",
            type: .dynamic, 
            targets: ["SwiftIB"]),
        .executable(
            name: "HistoryDataDump", 
            targets: ["HistoryDataDump"]),
        .executable(
            name: "MktDataDumper",
            targets: ["MktDataDumper"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftIB",
            dependencies: []),
        .target(
            name: "MktDataDumper",
            dependencies: ["SwiftIB"]),
        .target(
            name: "HistoryDataDump",
            dependencies: ["SwiftIB"]),
        .testTarget(
            name: "SwiftIBTests",
            dependencies: ["SwiftIB"]),
    ]
)

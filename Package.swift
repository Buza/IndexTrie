// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "IndexTrie",
    products: [
        .library(name: "IndexTrie", targets: ["IndexTrie"]),
    ],
    targets: [
        .target(name: "IndexTrie"),
        .testTarget(name: "IndexTrieTests", dependencies: ["IndexTrie"]),
    ]
)

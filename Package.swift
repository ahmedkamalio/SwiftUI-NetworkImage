// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkImage",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [.library(name: "NetworkImage", targets: ["NetworkImage"])],
    dependencies: [.package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.4.3")],
    targets: [
        .target(name: "NetworkImage", dependencies: ["Alamofire"]),
        .testTarget(name: "NetworkImageTests", dependencies: ["NetworkImage"]),
    ],
    swiftLanguageVersions: [.v5]
)

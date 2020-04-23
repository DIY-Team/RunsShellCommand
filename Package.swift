// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RunsShellCommand",
    products: [
        .library(
            name: "RunsShellCommand",
            targets: ["RunsShellCommand"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "RunsShellCommand",
            dependencies: ["ShellOut"])
    ]
)

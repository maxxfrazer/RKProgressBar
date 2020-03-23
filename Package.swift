// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RKProgressBar",
  platforms: [.iOS(.v13), .macOS(.v10_15)],
  products: [
    .library(
      name: "RKProgressBar",
      targets: ["RKProgressBar"]),
  ],
  targets: [
    .target(
      name: "RKProgressBar",
      dependencies: []),
    .testTarget(
      name: "RKProgressBarTests",
      dependencies: ["RKProgressBar"]),
  ]
)

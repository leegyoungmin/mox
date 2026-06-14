// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Mox",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Mox",
            path: "Sources/Mox"
        )
    ]
)

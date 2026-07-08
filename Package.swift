// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "ReviewAppSwift",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .executable(name: "ReviewAppSwift", targets: ["ReviewAppSwift"])
    ],
    dependencies: [
        .package(url: "https://github.com/supabase/supabase-swift.git", from: "2.0.0")
    ],
    targets: [
        .executableTarget(
            name: "ReviewAppSwift",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift")
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)

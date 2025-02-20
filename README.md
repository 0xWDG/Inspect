# Inspect

This package provides introspected views that can be used to inspect the underlying \*Kit element of a SwiftUI view.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FInspect%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/0xWDG/Inspect)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FInspect%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/0xWDG/Inspect)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
![License](https://img.shields.io/github/license/0xWDG/Inspect)

## Requirements

- Swift 5.9+ (Xcode 15+)
- iOS 13+, macOS 10.15+

## Installation (Pakage.swift)

```swift
dependencies: [
    .package(url: "https://github.com/0xWDG/Inspect.git", branch: "main"),
],
targets: [
    .target(name: "MyTarget", dependencies: [
        .product(name: "Inspect", package: "Inspect"),
    ]),
]
```

## Installation (Xcode)

1. In Xcode, open your project and navigate to **File** → **Swift Packages** → **Add Package Dependency...**
2. Paste the repository URL (`https://github.com/0xWDG/Inspect`) and click **Next**.
3. Click **Finish**.

## Usage

Example to read a ImageView (Multi platform):

```swift
import SwiftUI
import Inspect

struct ContentView: View {
#if os(macOS)
    let PlatformImageView = NSImageView.self
#else
    let PlatformImageView = UIImageView.self
#endif

    var body: some View {
        VStack {
            Image(systemName: "star")
                .inspect(PlatformImageView) { view in
                    print(view)
                }
        }
        .padding()
    }
}
```

Example to read a View Controller (iOS):

```swift
    var body: some View {
        List {
            Text("Item 1")
            Text("Item 2")
            Text("Item 3")
            Text("Item 4")
            Text("Item 5")
        }
        .inspectVC({ $0.tabBarController }) { view
            print(view)
        }
        .padding()
    }
}
```

## Contact

🦋 [@0xWDG](https://bsky.app/profile/0xWDG.bsky.social)
🐘 [mastodon.social/@0xWDG](https://mastodon.social/@0xWDG)
🐦 [@0xWDG](https://x.com/0xWDG)
🧵 [@0xWDG](https://www.threads.net/@0xWDG)
🌐 [wesleydegroot.nl](https://wesleydegroot.nl)
🤖 [Discord](https://discordapp.com/users/918438083861573692)

Interested learning more about Swift? [Check out my blog](https://wesleydegroot.nl/blog/).


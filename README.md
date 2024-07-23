# Inspect

SwiftUI Inspect allows you to get the underlying \*Kit element of a SwiftUI view.

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
    .package(url: "https://github.com/0xWDG/Inspect.git", .branch("main")),
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
    let PlatfornImageView = NSImageView.self
#else
    let PlatfornImageView = UIImageView.self
#endif

    var body: some View {
        VStack {
            Image(systemName: "star")
                .inspect(PlatfornImageView) { view in
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

We can get in touch via [Twitter/X](https://twitter.com/0xWDG), [Discord](https://discordapp.com/users/918438083861573692), [Mastodon](https://iosdev.space/@0xWDG), [Email](mailto:email+oss@wesleydegroot.nl), [Website](https://wesleydegroot.nl).

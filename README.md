# SwiftUI-NetworkImage

A SwiftUI view that loads images from the internet.

## Features

Load an image from the internet

```swift
let imageUrl = URL(string: "https://via.placeholder.com/300.png")

var body: some View {
    NetworkImage(url: imageUrl) {
        ProgressView() // or any palceholder view of your choice...
    }
}
```

Optionally capture the underlying image data when loaded

```swift
let imageUrl = URL(string: "https://via.placeholder.com/300.png")
@State var imageData: Data? = nil

var body: some View {
    NetworkImage(url: imageUrl, onLoad: { data, _ in imageData = data }) {
        ProgressView() // or any palceholder view of your choice...
    }
}
```

Load an image directly from the cached data (this will not fire a network request)

```swift
let imageUrl = URL(string: "https://via.placeholder.com/300.png")
let cachedData: Data // this can be stored in CoreData for example. 

var body: some View {
    // this image will be rendered directly from the `cachedData`.
    NetworkImage(url: imageUrl, cache: cachedData) {
        ProgressView() // or any palceholder view of your choice...
    }
}
```

Optionally capture error when the image is failed to load

```swift
let imageUrl = URL(string: "https://via.placeholder.com/300.png")
@State var imageData: Data? = nil
@State var error: Error? = nil

var body: some View {
    NetworkImage(
        url: imageUrl,
        onLoad: { data, error in
            if let error = error {
                self.error = error // maybe show some error message to the user!
            }
            imageData = data
        }
    ) {
        ProgressView() // or any palceholder view of your choice...
    }
}
```

A more advanced example where you can load an image from the internet and store it locally for offline usage

```swift
let repository: SomeDataRepository
let imageUrl = URL(string: "https://via.placeholder.com/300.png")
@State var error: Error? = nil

var body: some View {
    if error != nil {
        ErrorImagePlaceholder()
    } else {
        NetworkImage(
            url: imageUrl,
            cache: repository.getStoredImage(),
            onLoad: { data, error in
                if let error = error {
                    self.error = error
                }
                repository.storeImage(data)
            }
        ) {
            ProgressView()
        }
    }
}
```

## Requirements

Supported Platforms
- macOS 10.15+
- iOS 13+
- tvOS 13+
- watchOS 6+

Supported Swift Versions
- v5+

Supported Xcode Versions
- v11+

## Installation

Xcode

1. File > Swift Packages > Add Package Dependency...
2. Paste repository URL `https://github.com/akaahmedkamal/SwiftUI-NetworkImage.git`
3. Rules > Version > Up To Next Major > `0.1.0`
4. Choose the target you want to add SwiftUI-NetworkImage to.

Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/akaahmedkamal/SwiftUI-NetworkImage.git", .upToNextMajor(from: "0.1.0"))
]
```


## TODO

- [ ] Add Unit & UI Tests.


## Communication

- Feel free to reach me out on Twitter [@akaahmedkamal][TWITTER_LINK]
- If you found a bug, open an issue here on GitHub and follow the guide. The more detail the better!
- If you want to contribute, submit a pull request!


## License

SwiftUI-NetworkImage is released under the Apache-2.0 License. [See LICENSE][LICENSE_LINK] for details.



[LICENSE_LINK]: ./LICENSE.md
[TWITTER_LINK]: https://twitter.com/akaahmedkamal

//
//  NetworkImage.swift
//  NetworkImage
//
//  Created by Ahmed Kamal on 06/09/2021.
//

import Alamofire
import Combine
import Foundation
import SwiftUI

public typealias OnNetworkImageLoadedCallback = (Data?, Error?) -> Void

#if os(macOS)
fileprivate typealias UIImage = NSImage

fileprivate extension Image {
    init(uiImage: UIImage) {
        self.init(nsImage: uiImage)
    }
}
#endif

public struct NetworkImage<Content>: View where Content: View {
    @ObservedObject private var loader: NetworkImageLoader
    private let cache: Data?
    private let placeholder: () -> Content

    public var body: some View {
        if let data = cache, let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
        } else {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                placeholder()
                    .onAppear(perform: loader.load)
            }
        }
    }
}

public extension NetworkImage {
    init(url: URL?, @ViewBuilder placeholder: @escaping () -> Content) {
        loader = NetworkImageLoader(url: url)
        self.placeholder = placeholder
        cache = nil
    }
}

public extension NetworkImage {
    init(
        url: URL?,
        cache: Data?,
        @ViewBuilder placeholder: @escaping () -> Content)
    {
        loader = NetworkImageLoader(url: url)
        self.cache = cache
        self.placeholder = placeholder
    }
}

public extension NetworkImage {
    init(
        url: URL?,
        onLoad: @escaping OnNetworkImageLoadedCallback,
        @ViewBuilder placeholder: @escaping () -> Content)
    {
        loader = NetworkImageLoader(url: url, onLoad: onLoad)
        self.placeholder = placeholder
        cache = nil
    }
}

public extension NetworkImage {
    init(
        url: URL?,
        cache: Data?,
        onLoad: @escaping OnNetworkImageLoadedCallback,
        @ViewBuilder placeholder: @escaping () -> Content)
    {
        loader = NetworkImageLoader(url: url, onLoad: onLoad)
        self.placeholder = placeholder
        self.cache = cache
    }
}

public class NetworkImageLoader: ObservableObject {
    @Published fileprivate var image: UIImage? = nil

    private let url: URL?
    private let onLoadCallback: OnNetworkImageLoadedCallback?
    private var isLoading: Bool = false

    init(url: URL?) {
        self.url = url
        onLoadCallback = nil
    }

    init(url: URL?, onLoad: @escaping OnNetworkImageLoadedCallback) {
        self.url = url
        onLoadCallback = onLoad
    }

    func load() {
        guard !isLoading else { return }

        guard let url = url else {
            onLoadCallback?(nil, NetworkImageLoaderError.badUrl)
            return
        }

        isLoading = true

        AF.request(url, method: .get).response { res in
            if let error = res.error {
                self.onLoadCallback?(nil, error)
                return
            }
            if let data = res.data {
                self.image = UIImage(data: data)
            }
            self.onLoadCallback?(res.data, nil)
            self.isLoading = false
        }
    }
}

public enum NetworkImageLoaderError: Error {
    case badUrl
}

//
//  ImageCache.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 4/5/25.
//

import Foundation
import UIKit
import SwiftUICore
import SwiftUI


class ImageCache {
    private var cache = NSCache<NSString, UIImage>()
    
    // Retrieve image from cache
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    // Store image in cache
    func storeImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {}

    private let cache = NSCache<NSString, UIImage>()

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

struct CachedAsyncImage: View {
    @StateObject private var loader = CachedImageLoader()
    let url: String

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loader.load(from: url)
        }
    }
}

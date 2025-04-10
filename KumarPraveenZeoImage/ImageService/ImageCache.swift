//
//  ImageCache.swift
//  KumarPraveenZeoImage
//
//  Created by Praveen on 10/04/25.
//

import Foundation
import UIKit

/// A singleton image cache using `NSCache` to store downloaded images.
class ImageCache{
    static let shared = ImageCache()
    private init() {}
    
    private var cache = NSCache<NSURL, UIImage>()
    
    /// Returns a cached image for the given URL, if available.
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    /// Inserts an image into the cache for the given URL.
    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return }
        cache.setObject(image, forKey: url as NSURL)
    }
}

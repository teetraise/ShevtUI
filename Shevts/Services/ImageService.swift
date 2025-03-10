//
//  ImageService.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import Foundation
import Combine
import UIKit

class ImageService {
    static let shared = ImageService()
    
    private let apiClient = APIClient.shared
    private let baseURL = "http://localhost:8080/api" // Update this with your actual server URL
    private var imageCache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func uploadImage(image: UIImage) -> AnyPublisher<ImageResponse, APIError> {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }
        
        return apiClient.uploadImage(imageData: imageData)
    }
    
    func getImageURL(path: String?) -> URL? {
        guard let path = path, !path.isEmpty else { return nil }
        
        // If path already starts with http, it's a full URL
        if path.starts(with: "http") {
            return URL(string: path)
        }
        
        // If it's a relative path from the API
        if path.starts(with: "/") {
            return URL(string: "\(baseURL)\(path)")
        } else {
            return URL(string: "\(baseURL)/\(path)")
        }
    }
    
    func loadImage(from urlString: String?) -> AnyPublisher<UIImage?, Never> {
        guard let urlString = urlString, !urlString.isEmpty,
              let url = getImageURL(path: urlString) else {
            return Just(nil).eraseToAnyPublisher()
        }
        
        // Check cache first
        let cacheKey = NSString(string: urlString)
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            return Just(cachedImage).eraseToAnyPublisher()
        }
        
        // If not in cache, load from network
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response -> UIImage? in
                if let image = UIImage(data: data) {
                    // Store in cache
                    self.imageCache.setObject(image, forKey: cacheKey)
                    return image
                }
                return nil
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    func clearCache() {
        imageCache.removeAllObjects()
    }
    
    // Helper method to check if an image came from a particular URL
    // Useful to determine if a profile image has been changed
    func isImageFromURL(_ image: UIImage, urlString: String?) -> Bool {
        guard let urlString = urlString, !urlString.isEmpty else { return false }
        
        let cacheKey = NSString(string: urlString)
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            // Simple comparison based on size and pixel data
            return cachedImage.size == image.size &&
                   cachedImage.pngData()?.count == image.pngData()?.count
        }
        
        return false
    }
}

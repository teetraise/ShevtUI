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
    private let baseURL = "https://api.shevts.app/api"
    
    private init() {}
    
    func uploadImage(image: UIImage) -> AnyPublisher<ImageResponse, APIError> {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }
        
        return apiClient.uploadImage(imageData: imageData)
    }
    
    func getImageURL(path: String) -> URL? {
        // Если путь уже полный URL
        if path.starts(with: "http") {
            return URL(string: path)
        }
        
        // Если это относительный путь API
        return URL(string: "\(baseURL)\(path)")
    }
}

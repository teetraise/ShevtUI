//
//  UserService.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import Foundation
import Combine
import UIKit

class UserService {
    static let shared = UserService()
    
    private let apiClient = APIClient.shared
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    func createUser(username: String, email: String, password: String, avatarURL: String) -> AnyPublisher<User, APIError> {
        struct CreateUserRequest: Codable {
            let username: String
            let email: String
            let passwordHash: String
            let avatarURL: String
        }
        
        let userRequest = CreateUserRequest(
            username: username,
            email: email,
            passwordHash: password,
            avatarURL: avatarURL
        )
        
        guard let bodyData = try? JSONEncoder().encode(userRequest) else {
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }
        
        return apiClient.request(endpoint: "/users", method: "POST", body: bodyData)
    }
    
    func getAllUsers() -> AnyPublisher<[User], APIError> {
        return apiClient.request(endpoint: "/users/all")
    }
    
    func getUser(id: UUID) -> AnyPublisher<User, APIError> {
        return apiClient.request(endpoint: "/users/one/\(id.uuidString)")
    }
    
    // After successful login, fetch current user data
    func fetchCurrentUserData(userId: UUID) -> AnyPublisher<User, APIError> {
        return getUser(id: userId)
    }
    
    // Upload a new avatar image
    func uploadAvatar(image: UIImage) -> AnyPublisher<String, APIError> {
        return ImageService.shared.uploadImage(image: image)
            .map { $0.imageURL }
            .eraseToAnyPublisher()
    }
    
    // Update user profile with new avatar URL
    func updateProfile(username: String, avatarURL: String? = nil) -> AnyPublisher<User, APIError> {
        struct UpdateProfileRequest: Codable {
            let username: String
            let avatarURL: String?
        }
        
        let updateRequest = UpdateProfileRequest(
            username: username,
            avatarURL: avatarURL
        )
        
        guard let bodyData = try? JSONEncoder().encode(updateRequest) else {
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }
        
        return apiClient.request(endpoint: "/users/profile", method: "PUT", body: bodyData)
    }
    
    // Get user avatar image
    func getUserAvatar(user: User) -> AnyPublisher<UIImage?, Never> {
        return ImageService.shared.loadImage(from: user.avatarURL)
    }
}

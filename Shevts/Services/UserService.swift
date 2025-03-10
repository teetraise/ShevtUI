//
//  UserService.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import Foundation
import Combine

class UserService {
    static let shared = UserService()
    
    private let apiClient = APIClient.shared
    
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
        return apiClient.request(endpoint: "/users/one/\(id)")
    }
}

//
//  UserModels.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct TokenResponse: Codable {
    let value: String
    let user: UserInfo
    let id: String
    
    struct UserInfo: Codable {
        let id: String
    }
}

struct User: Codable, Identifiable {
    let id: UUID?
    let username: String
    let email: String
    let avatarURL: String
}

struct ImageResponse: Codable {
    let imageURL: String
}

//
//  RouteModels.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import Foundation

struct Route: Codable, Identifiable {
    let id: UUID?
    let name: String
    let description: String
    let imageURL: String?
    let creator: Creator
    
    // Внутренняя структура для поля creator
    struct Creator: Codable {
        let id: UUID
    }
    
    // Для обратной совместимости с вашим кодом
    var creatorID: UUID {
        return creator.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageURL = "imageURL" // Если сервер возвращает это поле в другом формате, укажите его здесь
        case creator
    }
}

struct CreateRouteRequest: Codable {
    let name: String
    let description: String
    let imageURL: String?
}

struct UpdateRouteRequest: Codable {
    let name: String
    let description: String
    let imageURL: String?
}

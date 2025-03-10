//
//  PlaceModels.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import Foundation

struct Place: Codable, Identifiable {
    let id: UUID?
    let name: String
    let description: String
    let imageURL: String?
    let latitude: Double
    let longitude: Double
    let order: Int
    let routeID: UUID
}

struct CreatePlaceRequest: Codable {
    let name: String
    let description: String
    let imageURL: String?
    let latitude: Double
    let longitude: Double
    let order: Int
    let routeID: UUID
}

struct UpdatePlaceRequest: Codable {
    let name: String
    let description: String
    let imageURL: String?
    let latitude: Double
    let longitude: Double
    let order: Int
    let routeID: UUID
}

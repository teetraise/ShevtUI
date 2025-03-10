//
//  PlaceService.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import Foundation
import Combine

class PlaceService {
    static let shared = PlaceService()
    
    private let apiClient = APIClient.shared
    
    private init() {}
    
    func getPlacesForRoute(routeId: UUID) -> AnyPublisher<[Place], APIError> {
        return apiClient.request(endpoint: "/places/route/\(routeId)")
    }
    
    func createPlace(name: String, description: String, imageURL: String?, latitude: Double, longitude: Double, order: Int, routeID: UUID) -> AnyPublisher<Place, APIError> {
        let placeRequest = CreatePlaceRequest(
            name: name,
            description: description,
            imageURL: imageURL,
            latitude: latitude,
            longitude: longitude,
            order: order,
            routeID: routeID
        )
        
        guard let bodyData = try? JSONEncoder().encode(placeRequest) else {
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }
        
        return apiClient.request(endpoint: "/places", method: "POST", body: bodyData)
    }
    
    func updatePlace(id: UUID, name: String, description: String, imageURL: String?, latitude: Double, longitude: Double, order: Int, routeID: UUID) -> AnyPublisher<Place, APIError> {
        let placeRequest = UpdatePlaceRequest(
            name: name,
            description: description,
            imageURL: imageURL,
            latitude: latitude,
            longitude: longitude,
            order: order,
            routeID: routeID
        )
        
        guard let bodyData = try? JSONEncoder().encode(placeRequest) else {
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }
        
        return apiClient.request(endpoint: "/places/\(id)", method: "PUT", body: bodyData)
    }
    
    func deletePlace(id: UUID) -> AnyPublisher<Void, APIError> {
        return apiClient.request(endpoint: "/places/\(id)", method: "DELETE")
            .map { (_: EmptyResponse) in () }
            .eraseToAnyPublisher()
    }
    
    private struct EmptyResponse: Decodable {}
}

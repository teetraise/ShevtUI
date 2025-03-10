//
//  RouteService.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import Foundation
import Combine

class RouteService {
    static let shared = RouteService()
    
    private let apiClient = APIClient.shared
    
    private init() {}
    
    func getAllRoutes() -> AnyPublisher<[Route], APIError> {
        return apiClient.request(endpoint: "/routes/all")
    }
    
    func getRoute(id: UUID) -> AnyPublisher<Route, APIError> {
        return apiClient.request(endpoint: "/routes/\(id)")
    }
    
    func getRoutesByUser(userId: UUID) -> AnyPublisher<[Route], APIError> {
        return apiClient.request(endpoint: "/routes/user/\(userId)")
    }
    
    func getMyRoutes() -> AnyPublisher<[Route], APIError> {
        return apiClient.request(endpoint: "/routes/my")
    }
    
    func createRoute(name: String, description: String, imageURL: String? = nil) -> AnyPublisher<Route, APIError> {
        let routeRequest = CreateRouteRequest(
            name: name,
            description: description,
            imageURL: imageURL
        )
        
        guard let bodyData = try? JSONEncoder().encode(routeRequest) else {
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }
        
        return apiClient.request(endpoint: "/routes", method: "POST", body: bodyData)
    }
    
    func updateRoute(id: UUID, name: String, description: String, imageURL: String? = nil) -> AnyPublisher<Route, APIError> {
        let routeRequest = UpdateRouteRequest(
            name: name,
            description: description,
            imageURL: imageURL
        )
        
        guard let bodyData = try? JSONEncoder().encode(routeRequest) else {
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }
        
        return apiClient.request(endpoint: "/routes/\(id)", method: "PUT", body: bodyData)
    }
    
    func deleteRoute(id: UUID) -> AnyPublisher<Void, APIError> {
        return apiClient.request(endpoint: "/routes/\(id)", method: "DELETE")
            .map { (_: EmptyResponse) in () }
            .eraseToAnyPublisher()
    }
    
    private struct EmptyResponse: Decodable {}
}

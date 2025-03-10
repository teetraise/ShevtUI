//
//  RoutesViewModel.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import Foundation
import Combine

class RoutesViewModel: ObservableObject {
    @Published var recommendedRoutes: [Route] = []
    @Published var myRoutes: [Route] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchRecommendedRoutes() {
        isLoading = true
        errorMessage = nil
        
        RouteService.shared.getAllRoutes()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = "Не удалось загрузить маршруты: \(error.localizedDescription)"
                    }
                },
                receiveValue: { [weak self] routes in
                    self?.recommendedRoutes = routes
                }
            )
            .store(in: &cancellables)
    }
    
    func fetchMyRoutes() {
        isLoading = true
        errorMessage = nil
        
        RouteService.shared.getMyRoutes()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = "Не удалось загрузить ваши маршруты: \(error.localizedDescription)"
                    }
                },
                receiveValue: { [weak self] routes in
                    self?.myRoutes = routes
                }
            )
            .store(in: &cancellables)
    }
    
    func createRoute(name: String, description: String, imageURL: String? = nil, completion: @escaping (Result<Route, Error>) -> Void) {
        isLoading = true
        errorMessage = nil
        
        RouteService.shared.createRoute(name: name, description: description, imageURL: imageURL)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completionResult in
                    self?.isLoading = false
                    if case .failure(let error) = completionResult {
                        self?.errorMessage = "Не удалось создать маршрут: \(error.localizedDescription)"
                        completion(.failure(error))
                    }
                },
                receiveValue: { route in
                    completion(.success(route))
                }
            )
            .store(in: &cancellables)
    }
    
    func deleteRoute(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        isLoading = true
        errorMessage = nil
        
        RouteService.shared.deleteRoute(id: id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completionResult in
                    self?.isLoading = false
                    if case .failure(let error) = completionResult {
                        self?.errorMessage = "Не удалось удалить маршрут: \(error.localizedDescription)"
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
    }
}

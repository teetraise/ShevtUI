//
//  PlacesViewModel.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import Foundation
import Combine

class PlacesViewModel: ObservableObject {
    @Published var places: [Place] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchPlacesForRoute(routeId: UUID) {
        isLoading = true
        errorMessage = nil
        
        PlaceService.shared.getPlacesForRoute(routeId: routeId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = "Не удалось загрузить места: \(error.localizedDescription)"
                    }
                },
                receiveValue: { [weak self] places in
                    self?.places = places
                }
            )
            .store(in: &cancellables)
    }
    
    func createPlace(name: String, description: String, imageURL: String?, latitude: Double, longitude: Double, order: Int, routeID: UUID, completion: @escaping (Result<Place, Error>) -> Void) {
        isLoading = true
        errorMessage = nil
        
        PlaceService.shared.createPlace(
            name: name,
            description: description,
            imageURL: imageURL,
            latitude: latitude,
            longitude: longitude,
            order: order,
            routeID: routeID
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] completionResult in
                self?.isLoading = false
                if case .failure(let error) = completionResult {
                    self?.errorMessage = "Не удалось создать место: \(error.localizedDescription)"
                    completion(.failure(error))
                }
            },
            receiveValue: { place in
                completion(.success(place))
            }
        )
        .store(in: &cancellables)
    }
}

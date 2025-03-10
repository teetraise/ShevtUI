//
//  UserDataStore.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//
import SwiftUI
import Combine

class UserDataStore: ObservableObject {
    static let shared = UserDataStore()
    
    @Published var currentUser: User?
    @Published var usersCache: [UUID: User] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    func saveCurrentUser(_ user: User) {
        DispatchQueue.main.async {
            self.currentUser = user
            if let id = user.id {
                self.usersCache[id] = user
            }
        }
    }
    
    func getUser(id: UUID, completion: @escaping (User?) -> Void) {
        if let cachedUser = usersCache[id] {
            completion(cachedUser)
            return
        }
        
        UserService.shared.getUser(id: id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] user in
                    self?.usersCache[id] = user
                    completion(user)
                }
            )
            .store(in: &cancellables)
    }
}

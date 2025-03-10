//
//  UserViewModel.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func logout() {
        AuthService.shared.logout()
        // Перезагрузка приложения или возврат к экрану логина
    }
}

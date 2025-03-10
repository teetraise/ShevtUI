//
//  AuthService.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import Foundation
import Combine

class AuthService {
    static let shared = AuthService()
    
    private let apiClient = APIClient.shared
    private let userDefaultsTokenKey = "auth_token"
    private var cancellables = Set<AnyCancellable>() // Добавьте эту строку
    
    private init() {
        // Восстанавливаем токен при запуске, если он есть
        if let savedToken = UserDefaults.standard.string(forKey: userDefaultsTokenKey) {
            apiClient.setToken(savedToken)
        }
    }
    
    func login(email: String, password: String) -> AnyPublisher<TokenResponse, APIError> {
        let loginRequest = LoginRequest(email: email, password: password)
        
        guard let bodyData = try? JSONEncoder().encode(loginRequest) else {
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }
        
        return apiClient.request(endpoint: "/auth/login", method: "POST", body: bodyData)
            .handleEvents(receiveOutput: { [weak self] token in
                // Сохраняем токен
                self?.apiClient.setToken(token.value)
                UserDefaults.standard.set(token.value, forKey: self?.userDefaultsTokenKey ?? "")
                
                // Загружаем данные пользователя, используя ID из ответа
                // Загружаем данные пользователя, используя ID из ответа
                if let userId = UUID(uuidString: token.user.id) {
                    // Захватываем self, чтобы иметь прямой доступ к cancellables
                    guard let self = self else { return }
                    
                    UserService.shared.fetchCurrentUserData(userId: userId)
                        .sink(
                            receiveCompletion: { _ in },
                            receiveValue: { user in
                                UserDataStore.shared.saveCurrentUser(user)
                            }
                        )
                        .store(in: &self.cancellables)
                }
            })
            .eraseToAnyPublisher()
    }
    
    func logout() {
        apiClient.clearToken()
        UserDefaults.standard.removeObject(forKey: userDefaultsTokenKey)
    }
    
    func isAuthenticated() -> Bool {
        return apiClient.isAuthenticated()
    }
}

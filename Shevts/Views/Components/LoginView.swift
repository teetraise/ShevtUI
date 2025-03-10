//
//  LoginView.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import SwiftUI
import Combine

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        ZStack {
            Color(hex: Constants.Colors.background)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Вход в Shevts")
                    .font(.custom(Constants.Fonts.medium, size: 28))
                    .padding(.top, 100)
                
                VStack(spacing: 16) {
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    SecureField("Пароль", text: $viewModel.password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 26)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.custom(Constants.Fonts.regular, size: 14))
                }
                
                Button(action: {
                    viewModel.login { success in
                        if success {
                            isAuthenticated = true
                        }
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Войти")
                            .font(.custom(Constants.Fonts.medium, size: 16))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: Constants.Colors.accent))
                .cornerRadius(10)
                .padding(.horizontal, 26)
                .disabled(viewModel.isLoading)
                
                Button(action: {
                    // Переход к регистрации
                }) {
                    Text("Создать аккаунт")
                        .font(.custom(Constants.Fonts.regular, size: 16))
                        .foregroundColor(Color(hex: Constants.Colors.accent))
                }
                .padding(.top, 16)
                
                Spacer()
            }
        }
    }
}

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func login(completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Введите email и пароль"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        AuthService.shared.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completionResult in
                    self?.isLoading = false
                    if case .failure(let error) = completionResult {
                        switch error {
                        case .serverError(let code):
                            self?.errorMessage = "Ошибка сервера: \(code)"
                        case .unauthorized:
                            self?.errorMessage = "Неверный email или пароль"
                        default:
                            self?.errorMessage = "Произошла ошибка. Попробуйте еще раз."
                        }
                        completion(false)
                    }
                },
                receiveValue: { _ in
                    completion(true)
                }
            )
            .store(in: &cancellables)
    }
}

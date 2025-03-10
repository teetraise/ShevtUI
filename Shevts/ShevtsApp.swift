//
//  ShevtsApp.swift
//  Shevts
//
//  Created by User on 03.03.2025.
//

import SwiftUI

@main
struct ShevtsApp: App {
    @State private var isAuthenticated = false
    
    init() {
        // Проверяем, есть ли сохраненный токен
        isAuthenticated = AuthService.shared.isAuthenticated()
    }
    
    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                ContentView()
                    .environmentObject(UserViewModel())
                    .environmentObject(RoutesViewModel())
            } else {
                LoginView(isAuthenticated: $isAuthenticated)
            }
        }
    }
}

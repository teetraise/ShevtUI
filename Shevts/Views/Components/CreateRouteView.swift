//
//  CreateRouteView.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import SwiftUI
import Combine

struct CreateRouteView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var routesViewModel: RoutesViewModel
    
    @State private var routeName: String = ""
    @State private var routeDescription: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var imageURL: String? = nil
    @State private var isCreating = false
    @State private var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Route image picker
                    RouteImagePicker(
                        selectedImage: $selectedImage,
                        onImageUploaded: { url in
                            imageURL = url
                        }
                    )
                    .padding(.top, 10)
                    
                    // Route name field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Route Name")
                            .font(.custom(Constants.Fonts.medium, size: 16))
                        
                        TextField("Enter route name", text: $routeName)
                            .font(.custom(Constants.Fonts.regular, size: 16))
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                    
                    // Route description field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.custom(Constants.Fonts.medium, size: 16))
                        
                        TextEditor(text: $routeDescription)
                            .font(.custom(Constants.Fonts.regular, size: 16))
                            .padding(12)
                            .frame(height: 150)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                    
                    // Error message
                    if let error = errorMessage {
                        Text(error)
                            .font(.custom(Constants.Fonts.regular, size: 14))
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    
                    // Create button
                    Button(action: {
                        createRoute()
                    }) {
                        ZStack {
                            Text(isCreating ? "" : "Create Route")
                                .font(.custom(Constants.Fonts.medium, size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(hex: Constants.Colors.accent))
                                .cornerRadius(10)
                            
                            if isCreating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                        }
                    }
                    .disabled(isCreating || routeName.isEmpty)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Create New Route")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                }
            )
            .background(Color(hex: Constants.Colors.background))
        }
    }
    
    private func createRoute() {
        guard !routeName.isEmpty else {
            errorMessage = "Please enter a route name"
            return
        }
        
        isCreating = true
        errorMessage = nil
        
        routesViewModel.createRoute(
            name: routeName,
            description: routeDescription,
            imageURL: imageURL
        ) { result in
            isCreating = false
            
            switch result {
            case .success(_):
                // Dismiss the view after successful creation
                presentationMode.wrappedValue.dismiss()
                
                // Reload the routes list
                routesViewModel.fetchMyRoutes()
                routesViewModel.fetchRecommendedRoutes()
                
            case .failure(let error):
                errorMessage = "Failed to create route: \(error.localizedDescription)"
            }
        }
    }
}

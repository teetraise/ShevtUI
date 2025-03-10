//
//  RouteCard.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import SwiftUI
import Combine

struct RouteCard: View {
    let route: Route
    
    // Используем StateObject для класса, который будет управлять состоянием
    @StateObject private var viewModel = RouteCardViewModel()
    
    init(route: Route) {
        self.route = route
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background for the entire card
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
                .frame(width: 370, height: 224)
            
            // Route image section
            CachedAsyncImage(
                urlString: route.imageURL,
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 370, height: 235 - 81)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                },
                placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 370, height: 235 - 81)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        )
                }
            )
            .overlay(
                // Action buttons
                HStack {
                    Button(action: {
                        // Save/like functionality
                    }) {
                        Image(systemName: "heart")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.05))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        // Share functionality
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.05))
                            .clipShape(Circle())
                    }
                }
                .padding(12),
                alignment: .topTrailing
            )
            
            // Route information (overlaid at the bottom)
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    // Route name
                    Text(route.name)
                        .font(.custom("Outfit-Medium", size: 22))
                    
                    Spacer()
                }
                .padding(.top, 12)
                .padding(.horizontal, 12)
                
                // Author info
                HStack(spacing: 5) {
                    if let authorAvatar = viewModel.authorAvatar {
                        Image(uiImage: authorAvatar)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 15, height: 15)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 15, height: 15)
                    }
                    
                    Text(viewModel.authorName)
                        .font(.custom("Outfit-Regular", size: 13))
                }
                .padding(.horizontal, 12)
                .padding(.top, 5)
                
                // Description
                Text(route.description)
                    .font(.custom("Outfit-Regular", size: 13))
                    .opacity(0.5)
                    .padding(.horizontal, 12)
                    .padding(.top, 5)
                    .padding(.bottom, 12)
                    .lineLimit(2)
            }
            .frame(width: 370, height: 91)
            .background(Color(hex: Constants.Colors.cardDark))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .frame(width: 370, height: 224)
        .onAppear {
            // Вызов метода viewModel вместо локального
            viewModel.loadAuthorInfo(for: route)
        }
    }
}

// ViewModel для RouteCard
class RouteCardViewModel: ObservableObject {
    @Published var authorName: String = "User"
    @Published var authorAvatar: UIImage? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadAuthorInfo(for route: Route) {
        UserDataStore.shared.getUser(id: route.creator.id) { [weak self] user in
            if let user = user {
                DispatchQueue.main.async {
                    self?.authorName = user.username
                }
                
                // Load user avatar image
                ImageService.shared.loadImage(from: user.avatarURL)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] image in
                        self?.authorAvatar = image
                    }
                    .store(in: &self!.cancellables)
            }
        }
    }
}

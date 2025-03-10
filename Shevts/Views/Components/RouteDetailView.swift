//
//  RouteDetailView.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import SwiftUI
import Combine

struct RouteDetailView: View {
    let route: Route
    @StateObject private var placesViewModel = PlacesViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Изображение маршрута
                AsyncImage(url: ImageService.shared.getImageURL(path: route.imageURL ?? "")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                    } else if phase.error != nil {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 250)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            )
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 250)
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            )
                    }
                }
                
                // Информация о маршруте
                VStack(alignment: .leading, spacing: 16) {
                    Text(route.name)
                        .font(.custom(Constants.Fonts.medium, size: 28))
                    
                    Text(route.description)
                        .font(.custom(Constants.Fonts.regular, size: 16))
                        .foregroundColor(.black.opacity(0.7))
                    
                    // Заголовок для мест
                    Text("Места в маршруте")
                        .font(.custom(Constants.Fonts.medium, size: 22))
                        .padding(.top, 8)
                    
                    // Индикатор загрузки мест
                    if placesViewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .padding(.top, 20)
                    }
                    
                    // Сообщение об ошибке
                    if let errorMessage = placesViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.custom(Constants.Fonts.regular, size: 14))
                            .padding(.top, 20)
                    }
                    
                    // Список мест
                    VStack(spacing: 16) {
                        if placesViewModel.places.isEmpty && !placesViewModel.isLoading {
                            Text("В этом маршруте пока нет мест")
                                .font(.custom(Constants.Fonts.regular, size: 16))
                                .foregroundColor(.gray)
                                .padding(.top, 20)
                        } else {
                            ForEach(placesViewModel.places.sorted(by: { $0.order < $1.order })) { place in
                                PlaceListItem(place: place)
                            }
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(20)
                
                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(hex: Constants.Colors.background))
        .onAppear {
            loadPlaces()
        }
    }
    
    private func loadPlaces() {
        guard let routeId = route.id else { return }
        placesViewModel.fetchPlacesForRoute(routeId: routeId)
    }
}

struct PlaceListItem: View {
    let place: Place
    
    var body: some View {
        HStack(spacing: 16) {
            // Place image
            CachedAsyncImage(
                urlString: place.imageURL,
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                },
                placeholder: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        )
                }
            )
            
            // Place information
            VStack(alignment: .leading, spacing: 4) {
                Text(place.name)
                    .font(.custom(Constants.Fonts.medium, size: 16))
                    .foregroundColor(.black)
                
                Text(place.description)
                    .font(.custom(Constants.Fonts.regular, size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
    }
}

//
//  RouteCard.swift
//  Shevts
//
//  Created by Николай Жирнов on 10.03.2025.
//

import SwiftUI

// Карточка маршрута для использования в HomeView
struct RouteCard: View {
    let route: Route
    @State private var authorName: String = "User"
    @State private var isLiked = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Фон для всей карточки - делаем его полностью непрозрачным
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(1)) // Явная непрозрачность 1
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2) // Раскомментировал тень
                .frame(height: 224)
                .zIndex(1) // Добавляем z-индекс для правильного наложения
            
            // Изображение маршрута
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    // Изображение с использованием AsyncImage
                    AsyncImage(url: ImageService.shared.getImageURL(path: route.imageURL ?? "")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 154)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            // Заполнитель с более насыщенным оттенком
                            Rectangle()
                                .fill(Color.gray.opacity(0.3)) // Увеличиваем непрозрачность
                                .frame(height: 154)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    Image(systemName: "photo")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                )
                        }
                    }
                    
                    // Кнопки сохранения и действий
                    HStack(spacing: 10) {
                        Button(action: {
                            isLiked.toggle()
                        }) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.system(size: 14))
                                .foregroundColor(isLiked ? Color(hex: Constants.Colors.accent) : .white)
                                .padding(8)
                                .background(Color.black.opacity(0.3)) // Раскомментировал фон для кнопки
                                .clipShape(Circle())
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.3)) // Раскомментировал фон для кнопки
                                .clipShape(Circle())
                        }
                    }
                    .padding(12)
                }
                
                Spacer()
            }
            .frame(height: 224)
            .zIndex(2) // Изображение над фоном
            
            // Информация о маршруте (наложена снизу)
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    // Название маршрута
                    Text(route.name)
                        .font(.custom(Constants.Fonts.medium, size: 20))
                        .foregroundColor(Color.black.opacity(1)) // Явно указываем непрозрачность
                        .lineLimit(1)
                    
                    Spacer()
                }
                .padding(.top, 12)
                .padding(.horizontal, 12)
                
                // Автор
                HStack(spacing: 5) {
                    Circle()
                        .fill(Color(hex: Constants.Colors.accent).opacity(0.7))
                        .frame(width: 18, height: 18)
                        .overlay(
                            Text(String(authorName.prefix(1)))
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        )
                    
                    Text(authorName)
                        .font(.custom(Constants.Fonts.regular, size: 13))
                        .foregroundColor(Color.black.opacity(0.8)) // Раскомментировал цвет текста
                }
                .padding(.horizontal, 12)
                .padding(.top, 5)
                
                // Описание
                Text(route.description)
                    .font(.custom(Constants.Fonts.regular, size: 13))
                    .foregroundColor(Color.black.opacity(0.7)) // Раскомментировал цвет текста
                    .lineLimit(2)
                    .padding(.horizontal, 12)
                    .padding(.top, 6)
                    .padding(.bottom, 12)
            }
            .frame(height: 91)
            .background(Color(hex: Constants.Colors.cardDark).opacity(1)) // Явная непрозрачность
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .zIndex(3) // Информация над изображением
        }
        .frame(height: 224)
        .compositingGroup() // Добавляем группировку композиции
        .onAppear {
            loadAuthorName()
        }
    }
    
    // Загрузка имени автора
    private func loadAuthorName() {
        UserDataStore.shared.getUser(id: route.creator.id) { user in
            if let user = user {
                self.authorName = user.username
            }
        }
    }
}

// Предварительный просмотр для отладки (для использования в Preview)
struct RouteCard_Previews: PreviewProvider {
    static var previews: some View {
        RouteCard(route: Route(
            id: UUID(),
            name: "Тестовый маршрут",
            description: "Описание тестового маршрута с подробной информацией",
            imageURL: nil,
            creator: Route.Creator(id: UUID())
        ))
        .frame(width: 370)
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(hex: Constants.Colors.background))
    }
}

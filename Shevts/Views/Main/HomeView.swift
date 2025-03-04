import SwiftUI

struct HomeView: View {
    @State private var selectedTab: TopBarTab = .forYou
    @State private var isFollowingAnyone: Bool = false // Изменяемое состояние для проверки наличия подписок
    
    var body: some View {
        ZStack {
            Color(hex: Constants.Colors.background)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                // Верхняя панель с вкладками
                TopBar(selectedTab: $selectedTab)
                
                // TabView для переключения между For You и Following
                TabView(selection: $selectedTab) {
                    // For You контент
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            // Маленькие плитки с рекомендациями
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 8),
                                GridItem(.flexible(), spacing: 8)
                            ], spacing: 8) {
                                // Плитки с категориями
                                ForEach(getMiniRecommendations()) { item in
                                    MiniRecommendationTile(title: item.title, image: item.image)
                                }
                            }
                            .padding(.horizontal, 26)
                            .padding(.top, 8)
                            
                            // Заголовок "Recommended for you"
                            Text("Recommended for you")
                                .font(.custom("Outfit-Medium", size: 24))
                                .padding(.leading, 26)
                                .padding(.top, 13)
                            
                            // Большие карточки с рекомендациями
                            VStack(spacing: 23) {
                                ForEach(getSampleRecommendations()) { recommendation in
                                    RecommendationCard(recommendation: recommendation)
                                }
                            }
                            .padding(.top, 16)
                            .padding(.horizontal, 26)
                            
                            // Дополнительное пространство внизу для прокрутки
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    .tag(TopBarTab.forYou)
                    
                    // Following контент
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            // Заголовок "Latest picks"
                            Text("Latest picks")
                                .font(.custom("Outfit-Medium", size: 24))
                                .padding(.leading, 26)
                                .padding(.top, 20)
                                .padding(.bottom, 16)
                            
                            if isFollowingAnyone {
                                // Контент если есть подписки
                                VStack(spacing: 23) {
                                    ForEach(getFollowingRecommendations()) { recommendation in
                                        RecommendationCard(recommendation: recommendation)
                                    }
                                }
                                .padding(.horizontal, 26)
                            } else {
                                // Контент если нет подписок
                                VStack(spacing: 10) {
                                    // Изображение лисенка
                                    Image("fox") // Используйте ваше изображение лисенка
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 250, height: 250)
                                        .padding(.top, 10)
                                    
                                    // Текст сообщения
                                    Text("You're not following anyone yet.")
                                        .font(.custom("Outfit-Medium", size: 18))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                        .padding(.top, -28)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            
                            // Кнопка для переключения представления (только для демонстрации)
                            // В реальном приложении эта кнопка будет удалена
                            Button("Toggle Following State (Demo)") {
                                isFollowingAnyone.toggle()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .padding(.horizontal, 26)
                            .padding(.top, 30)
                            
                            // Дополнительное пространство внизу для прокрутки
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    .tag(TopBarTab.following)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onChange(of: selectedTab) { newValue in
                    // Если нужна дополнительная логика при смене вкладки
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }
    
    // Пример данных для мини-рекомендаций
    private func getMiniRecommendations() -> [MiniRecommendation] {
        return [
            MiniRecommendation(id: 1, title: "Bangkok", image: "bangkok_image"),
            MiniRecommendation(id: 2, title: "Top of Cunk", image: "top_of_cunk_image"),
            MiniRecommendation(id: 3, title: "Street art", image: "street_art_image"),
            MiniRecommendation(id: 4, title: "Moscow", image: "moscow_image")
        ]
    }
    
    // Пример данных для рекомендаций "For You"
    private func getSampleRecommendations() -> [Recommendation] {
        return [
            Recommendation(
                id: 1,
                city: "Tbilisi",
                author: "McLovin",
                description: "Paradise for Russian relocants? Bars, stand-up clubs, and gardens.",
                places: 15,
                image: "tbilisi_image"
            ),
            Recommendation(
                id: 2,
                city: "Phuket",
                author: "PETROVA",
                description: "You'll never get bored — beautiful nature and girls.",
                places: 9,
                image: "phuket_image"
            ),
            Recommendation(
                id: 3,
                city: "Los Angeles",
                author: "SEIN",
                description: "The city of angels, Hollywood and palm trees.",
                places: 12,
                image: "la_image"
            )
        ]
    }
    
    // Пример данных для рекомендаций "Following"
    private func getFollowingRecommendations() -> [Recommendation] {
        return [
            Recommendation(
                id: 4,
                city: "Tbilisi",
                author: "McLovin",
                description: "Paradise for Russian relocants? Bars, stand-up clubs, and gardens.",
                places: 15,
                image: "tbilisi_image"
            ),
            Recommendation(
                id: 5,
                city: "Phuket",
                author: "PETROVA",
                description: "You'll never get bored — beautiful nature and girls.",
                places: 99,
                image: "phuket_image"
            ),
            Recommendation(
                id: 6,
                city: "Los Angeles",
                author: "SEIN",
                description: "Explore Hollywood, Venice Beach, and amazing food spots.",
                places: 18,
                image: "la_image"
            )
        ]
    }
}

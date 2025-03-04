import SwiftUI

struct HomeView: View {
    @State private var selectedTab: TopBarTab = .forYou
    
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
                            Text("Following")
                                .font(.custom("Outfit-Medium", size: 24))
                                .padding(.leading, 26)
                                .padding(.top, 20)
                            
                            Text("People you follow will appear here")
                                .font(.custom("Outfit-Regular", size: 16))
                                .foregroundColor(.gray)
                                .padding(.leading, 26)
                                .padding(.top, 10)
                            
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
    
    // Пример данных для больших рекомендаций
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
            )
        ]
    }
}

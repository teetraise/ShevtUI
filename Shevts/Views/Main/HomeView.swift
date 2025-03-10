import SwiftUI
import Combine

struct HomeView: View {
    @State private var selectedTab: TopBarTab = .forYou
    @EnvironmentObject var routesViewModel: RoutesViewModel
    @State private var cancellables = Set<AnyCancellable>()
    
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
                            
                            // Индикатор загрузки
                            if routesViewModel.isLoading {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                                .padding(.top, 20)
                            }
                            
                            // Сообщение об ошибке
                            if let errorMessage = routesViewModel.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.custom(Constants.Fonts.regular, size: 14))
                                    .padding(.horizontal, 26)
                                    .padding(.top, 20)
                            }
                            
                            // Большие карточки с рекомендациями
                            LazyVStack(spacing: 23) {
                                if routesViewModel.recommendedRoutes.isEmpty && !routesViewModel.isLoading {
                                    Text("Нет доступных маршрутов")
                                        .font(.custom(Constants.Fonts.regular, size: 16))
                                        .foregroundColor(.gray)
                                        .padding(.top, 20)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                } else {
                                    ForEach(routesViewModel.recommendedRoutes) { route in
                                        NavigationLink(destination: RouteDetailView(route: route)) {
                                            RouteCard(route: route)
                                                .frame(width: UIScreen.main.bounds.width - 52) // 26 pt padding на каждой стороне
                                        }
                                        .buttonStyle(PlainButtonStyle()) // Важно для правильного отображения tapable области
                                    }
                                    .opacity(1)
                                }
                            }
                            .padding(.top, 16)
                            .padding(.horizontal, 26)
                            .opacity(1)
                            
                            // Дополнительное пространство внизу для прокрутки
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    .opacity(1)
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
        .onAppear {
            loadRecommendedRoutes()
        }
    }
    
    private func loadRecommendedRoutes() {
        routesViewModel.fetchRecommendedRoutes()
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
}

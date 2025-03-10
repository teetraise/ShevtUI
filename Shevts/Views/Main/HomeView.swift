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
                            VStack(spacing: 23) {
                                if routesViewModel.recommendedRoutes.isEmpty && !routesViewModel.isLoading {
                                    Text("Нет доступных маршрутов")
                                        .font(.custom(Constants.Fonts.regular, size: 16))
                                        .foregroundColor(.gray)
                                        .padding(.top, 20)
                                } else {
                                    ForEach(routesViewModel.recommendedRoutes) { route in
                                        NavigationLink(destination: RouteDetailView(route: route)) {
                                            RouteCard(route: route)
                                        }
                                    }
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

//// Создаем компонент карточки маршрута на основе данных с сервера
//struct RouteCard: View {
//    let route: Route
//    @State private var authorName: String = "User"
//    @State private var authorAvatar: UIImage? = nil
//    private var cancellables = Set<AnyCancellable>()
//    
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            // Background for the entire card
//            RoundedRectangle(cornerRadius: 10)
//                .fill(Color.white)
//                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
//                .frame(width: 370, height: 224)
//            
//            // Route image section
//            CachedAsyncImage(
//                urlString: route.imageURL,
//                content: { image in
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 370, height: 235 - 81)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                },
//                placeholder: {
//                    Rectangle()
//                        .fill(Color.gray.opacity(0.3))
//                        .frame(width: 370, height: 235 - 81)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .overlay(
//                            Image(systemName: "photo")
//                                .font(.system(size: 40))
//                                .foregroundColor(.white)
//                        )
//                }
//            )
//            .overlay(
//                // Action buttons
//                HStack {
//                    Button(action: {
//                        // Save/like functionality
//                    }) {
//                        Image(systemName: "heart")
//                            .font(.system(size: 14))
//                            .foregroundColor(.white)
//                            .padding(8)
//                            .background(Color.black.opacity(0.05))
//                            .clipShape(Circle())
//                    }
//                    
//                    Button(action: {
//                        // Share functionality
//                    }) {
//                        Image(systemName: "square.and.arrow.up")
//                            .font(.system(size: 14))
//                            .foregroundColor(.white)
//                            .padding(8)
//                            .background(Color.black.opacity(0.05))
//                            .clipShape(Circle())
//                    }
//                }
//                .padding(12),
//                alignment: .topTrailing
//            )
//            
//            // Route information (overlaid at the bottom)
//            VStack(alignment: .leading, spacing: 0) {
//                HStack(alignment: .center) {
//                    // Route name
//                    Text(route.name)
//                        .font(.custom("Outfit-Medium", size: 22))
//                    
//                    Spacer()
//                }
//                .padding(.top, 12)
//                .padding(.horizontal, 12)
//                
//                // Author info
//                HStack(spacing: 5) {
//                    if let authorAvatar = authorAvatar {
//                        Image(uiImage: authorAvatar)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 15, height: 15)
//                            .clipShape(Circle())
//                    } else {
//                        Circle()
//                            .fill(Color.gray.opacity(0.5))
//                            .frame(width: 15, height: 15)
//                    }
//                    
//                    Text(authorName)
//                        .font(.custom("Outfit-Regular", size: 13))
//                }
//                .padding(.horizontal, 12)
//                .padding(.top, 5)
//                
//                // Description
//                Text(route.description)
//                    .font(.custom("Outfit-Regular", size: 13))
//                    .opacity(0.5)
//                    .padding(.horizontal, 12)
//                    .padding(.top, 5)
//                    .padding(.bottom, 12)
//                    .lineLimit(2)
//            }
//            .frame(width: 370, height: 91)
//            .background(Color(hex: Constants.Colors.cardDark))
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//        }
//        .frame(width: 370, height: 224)
//        .onAppear {
//            loadAuthorInfo()
//        }
//    }
//    
//    private func loadAuthorInfo() {
//        UserDataStore.shared.getUser(id: route.creator.id) { [weak self] user in
//            if let user = user {
//                self?.authorName = user.username
//                
//                // Load user avatar image
//                ImageService.shared.loadImage(from: user.avatarURL)
//                    .receive(on: DispatchQueue.main)
//                    .sink { image in
//                        self?.authorAvatar = image
//                    }
//                    .store(in: &self?.cancellables)
//            }
//        }
//    }
//}

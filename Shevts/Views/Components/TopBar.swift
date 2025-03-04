import SwiftUI

enum TopBarTab {
    case forYou, following
}

struct TopBar: View {
    @Binding var selectedTab: TopBarTab
    
    var body: some View {
        ZStack {
            // Фон и тень
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 86)
                
                // Тонкая линия-разделитель под меню
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 0.5)
            }
            .ignoresSafeArea(edges: .top)
            
            VStack {
                Spacer()
                
                // Вкладки с анимированной линией
                HStack(spacing: 0) {
                    // "For you"
                    VStack(spacing: 8) { // Увеличиваем расстояние между текстом и линией
                        Text("For you")
                            .font(.custom("Outfit-Medium", size: 16))
                            .foregroundColor(selectedTab == .forYou ? .black : .gray)
                            .padding(.horizontal, 3)
                            
                        // Создаем пустое пространство для линии
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 3)
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = .forYou
                        }
                    }
                    
                    // "Following"
                    VStack(spacing: 8) { // Увеличиваем расстояние между текстом и линией
                        Text("Following")
                            .font(.custom("Outfit-Regular", size: 16))
                            .foregroundColor(selectedTab == .following ? .black : .gray)
                            .padding(.horizontal, 10)
                            
                        // Создаем пустое пространство для линии
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 3)
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = .following
                        }
                    }
                }
                .overlay(
                    // Анимированный индикатор выбранной вкладки
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color(hex: Constants.Colors.accent))
                            .frame(width: selectedTab == .forYou ? 70 : 90, height: 3)
                            .offset(x: selectedTab == .forYou ? -100 : 100, y: 0) // Смещаем только по горизонтали
                    }
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
                )
                .frame(height: 40)
                .padding(.bottom, 8)
            }
            .frame(height: 100)
        }
        .ignoresSafeArea(edges: .top)
    }
}

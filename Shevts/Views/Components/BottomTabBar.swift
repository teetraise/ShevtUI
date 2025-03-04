import SwiftUI

struct BottomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 0) {
            // Тонкая линия-разделитель над таб-баром
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.gray.opacity(0.2))
            
            // Фон с прозрачностью
            ZStack {
                // Фон таб-бара
                Rectangle()
                    .fill(Color.white.opacity(0.75))
                
                // Элементы таб-бара с правильным центрированием
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        // Home
                        tabBarItem(
                            title: "Home",
                            icon: "house",
                            selectedIcon: "house.fill",
                            isSelected: selectedTab == 0
                        )
                        .frame(width: geometry.size.width / 3)
                        .onTapGesture { selectedTab = 0 }
                        
                        // Search
                        tabBarItem(
                            title: "Search",
                            icon: "magnifyingglass",
                            selectedIcon: "magnifyingglass",
                            isSelected: selectedTab == 1
                        )
                        .frame(width: geometry.size.width / 3)
                        .onTapGesture { selectedTab = 1 }
                        
                       
                        
                        // Profile - новая вкладка
                        tabBarItem(
                            title: "Profile",
                            icon: "person",
                            selectedIcon: "person.fill",
                            isSelected: selectedTab == 2
                        )
                        .frame(width: geometry.size.width / 3)
                        .onTapGesture { selectedTab = 2 }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 8)
                }
            }
            .frame(height: 55)
        }
        .background(Color.white.opacity(0.85))
    }
    
    private func tabBarItem(title: String, icon: String, selectedIcon: String, isSelected: Bool) -> some View {
        HStack {
            Spacer()
            VStack(spacing: 4) {
                Image(systemName: isSelected ? selectedIcon : icon)
                    .font(.system(size: 25))
                    .foregroundColor(isSelected ? Color(hex: Constants.Colors.accent) : .gray)
                
                Text(title)
                    .font(.custom("Outfit-Regular", size: 12))
                    .foregroundColor(isSelected ? Color(hex: Constants.Colors.accent) : .gray)
            }
            Spacer()
        }
    }
}

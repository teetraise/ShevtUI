import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Фоновый цвет всего приложения
            Color(hex: Constants.Colors.background)
                .ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                
                SearchView()
                    .tag(1)
                
                ProfileView()
                    .tag(2)
            }
            
            // Нижний таб-бар поверх содержимого
            VStack {
                Spacer()
                BottomTabBar(selectedTab: $selectedTab)
            }
        }
        .preferredColorScheme(.light)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



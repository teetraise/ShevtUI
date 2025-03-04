import SwiftUI

struct ProfileView: View {
    // Состояние для отслеживания открытия окна редактирования
    @State private var showEditProfile = false
    
    var body: some View {
        ZStack {
            // Фоновый цвет
            Color(hex: Constants.Colors.background)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Верхняя часть профиля
                    profileHeader
                    
                    // Секция статистики
                    statsSection
                        .padding(.top, 24)
                    
                    // Секция Коллекций
                    collectionsSection
                        .padding(.top, 24)
                    
                    // Секция Сохраненных мест
                    savedPlacesSection
                        .padding(.top, 32)
                        .padding(.bottom, 32)
                }
            }
        }
        .preferredColorScheme(.light)
        // Показ экрана редактирования
        .sheet(isPresented: $showEditProfile) {
            EditProfileView(isPresented: $showEditProfile)
        }
    }
    
    // MARK: - UI Components
    
    // Верхняя часть профиля
    var profileHeader: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                
                // Кнопка настроек
                Button(action: {}) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                }
                .padding(.trailing, 26)
                .padding(.top, 16)
            }
            
            // Аватар пользователя
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                )
            
            // Имя пользователя
            Text("Alex Smith")
                .font(.custom(Constants.Fonts.medium, size: 24))
            
            // Ник пользователя
            Text("@alexsmith")
                .font(.custom(Constants.Fonts.regular, size: 16))
                .foregroundColor(.gray)
                .padding(.bottom, 8)
            
            // Кнопка редактирования профиля
            Button(action: {
                showEditProfile = true
            }) {
                Text("Edit Profile")
                    .font(.custom(Constants.Fonts.medium, size: 16))
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(Color(hex: Constants.Colors.accent))
                    .cornerRadius(10)
            }
        }
    }
    
    // Секция статистики
    var statsSection: some View {
        HStack(spacing: 0) {
            Spacer()
            
            makeStatItem(count: "15", title: "Collections")
            
            Spacer()
            
            // Разделитель
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 40)
            
            Spacer()
            
            makeStatItem(count: "142", title: "Followers")
            
            Spacer()
            
            // Разделитель
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 40)
            
            Spacer()
            
            makeStatItem(count: "251", title: "Following")
            
            Spacer()
        }
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
        .padding(.horizontal, 26)
    }
    
    // Секция коллекций
    var collectionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Заголовок секции
            HStack {
                Text("My Collections")
                    .font(.custom(Constants.Fonts.medium, size: 24))
                
                Spacer()
                
                // Кнопка "Смотреть все"
                Button(action: {}) {
                    Text("See all")
                        .font(.custom(Constants.Fonts.regular, size: 16))
                        .foregroundColor(Color(hex: Constants.Colors.accent))
                }
            }
            .padding(.horizontal, 26)
            
            // Горизонтальный список коллекций
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    // Левый отступ
                    Spacer()
                        .frame(width: 0)
                    
                    // Элементы коллекций
                    makeCollectionItem(title: "Favorite Cafes", count: 12)
                    makeCollectionItem(title: "Best Street Food", count: 8)
                    makeCollectionItem(title: "Hidden Gems", count: 5)
                    
                    // Правый отступ
                    Spacer()
                        .frame(width: 10)
                }
                .padding(.leading, 16)
            }
        }
    }
    
    // Секция сохраненных мест
    var savedPlacesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Заголовок секции
            HStack {
                Text("Saved Places")
                    .font(.custom(Constants.Fonts.medium, size: 24))
                
                Spacer()
                
                // Кнопка "Смотреть все"
                Button(action: {}) {
                    Text("See all")
                        .font(.custom(Constants.Fonts.regular, size: 16))
                        .foregroundColor(Color(hex: Constants.Colors.accent))
                }
            }
            .padding(.horizontal, 26)
            
            // Список сохраненных мест
            VStack(spacing: 16) {
                makeSavedPlaceItem(name: "Central Park Café", location: "New York", image: "cafe_image")
                makeSavedPlaceItem(name: "Street Food Market", location: "Bangkok", image: "market_image")
                makeSavedPlaceItem(name: "Sunset Beach", location: "Phuket", image: "beach_image")
            }
            .padding(.horizontal, 26)
        }
    }
    
    // MARK: - Helper Methods
    
    // Метод для создания элемента статистики
    func makeStatItem(count: String, title: String) -> some View {
        VStack(spacing: 4) {
            Text(count)
                .font(.custom(Constants.Fonts.medium, size: 20))
            
            Text(title)
                .font(.custom(Constants.Fonts.regular, size: 14))
                .foregroundColor(.gray)
        }
    }
    
    // Метод для создания элемента коллекции
    func makeCollectionItem(title: String, count: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Изображение коллекции
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 160, height: 120)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                )
            
            // Название коллекции
            Text(title)
                .font(.custom(Constants.Fonts.medium, size: 16))
                .foregroundColor(.black)
            
            // Количество мест
            Text("\(count) places")
                .font(.custom(Constants.Fonts.regular, size: 14))
                .foregroundColor(.gray)
        }
        .frame(width: 160)
    }
    
    // Метод для создания элемента сохраненного места
    func makeSavedPlaceItem(name: String, location: String, image: String) -> some View {
        HStack(spacing: 16) {
            // Изображение места
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                )
            
            // Информация о месте
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.custom(Constants.Fonts.medium, size: 16))
                    .foregroundColor(.black)
                
                Text(location)
                    .font(.custom(Constants.Fonts.regular, size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Кнопка сохранения
            Button(action: {}) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 22))
                    .foregroundColor(Color(hex: Constants.Colors.accent))
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

import SwiftUI

struct GuideView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Модель данных для путеводителя
    let guide: Guide
    
    var body: some View {
        ZStack {
            // Фоновый цвет
            Color(hex: Constants.Colors.background)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Верхняя часть с изображением города
                    cityHeaderView
                    
                    // Информация о гиде
                    guideInfoView
                        .padding(.horizontal, 26)
                        .padding(.top, 20)
                    
                    // Описание путеводителя
                    Text(guide.description)
                        .font(.custom(Constants.Fonts.regular, size: 16))
                        .lineSpacing(4)
                        .padding(.horizontal, 26)
                        .padding(.top, 16)
                    
                    // Разделитель
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 1)
                        .padding(.horizontal, 26)
                        .padding(.top, 24)
                    
                    // Заголовок "Places"
                    Text("Places")
                        .font(.custom(Constants.Fonts.medium, size: 24))
                        .padding(.horizontal, 26)
                        .padding(.top, 24)
                    
                    // Список мест в формате маршрута
                    placesRouteView
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                }
            }
            .ignoresSafeArea(edges: .top)
            
            // Кнопка "Назад" в верхнем левом углу
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding(.leading, 20)
                    .padding(.top, 60)
                    
                    Spacer()
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Компоненты интерфейса
    
    // Верхняя часть с изображением города
    var cityHeaderView: some View {
        ZStack(alignment: .bottom) {
            // Изображение города
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 350)
                .overlay(
                    Text(guide.city)
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                )
            
            // Градиент внизу изображения для плавного перехода
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color(hex: Constants.Colors.background)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)
        }
    }
    
    // Информация об авторе путеводителя
    var guideInfoView: some View {
        HStack(spacing: 12) {
            // Аватар автора
            Circle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 45, height: 45)
                .overlay(
                    Text(String(guide.author.prefix(1)))
                        .font(.custom(Constants.Fonts.medium, size: 20))
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(guide.author)
                    .font(.custom(Constants.Fonts.medium, size: 16))
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 12))
                    
                    Text("\(guide.places.count) places")
                        .font(.custom(Constants.Fonts.regular, size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Кнопка сохранения всего путеводителя
            Button(action: {}) {
                Image(systemName: "bookmark")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: Constants.Colors.accent))
            }
        }
    }
    
    // Маршрут с местами
    var placesRouteView: some View {
        VStack(spacing: 0) {
            ForEach(Array(guide.places.enumerated()), id: \.element.id) { index, place in
                ZStack {
                    // Карточка места
                    placeCard(place, isLast: index == guide.places.count - 1)
                    
                    // Соединительная линия между местами (кроме последнего)
                    if index < guide.places.count - 1 {
                        VStack {
                            Rectangle()
                                .fill(Color(hex: Constants.Colors.accent))
                                .frame(width: 2, height: 30)
                                .offset(x: -160, y: 70)
                        }
                    }
                }
            }
        }
    }
    
    // Карточка для отдельного места
    func placeCard(_ place: Place, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: 15) {
            // Номер места с цветным кружком
            ZStack {
                Circle()
                    .fill(Color(hex: Constants.Colors.accent))
                    .frame(width: 30, height: 30)
                
                Text("\(place.order)")
                    .font(.custom(Constants.Fonts.medium, size: 14))
                    .foregroundColor(.white)
            }
            .padding(.top, 5)
            
            VStack(alignment: .leading, spacing: 12) {
                // Название места
                Text(place.name)
                    .font(.custom(Constants.Fonts.medium, size: 18))
                
                // Изображение места
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 180)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Адрес и описание
                VStack(alignment: .leading, spacing: 8) {
                    // Адрес
                    if let address = place.address {
                        HStack(spacing: 6) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: Constants.Colors.accent))
                            
                            Text(address)
                                .font(.custom(Constants.Fonts.regular, size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Описание
                    Text(place.description)
                        .font(.custom(Constants.Fonts.regular, size: 15))
                        .lineSpacing(4)
                    
                    // Кнопки действий
                    HStack(spacing: 20) {
                        // Кнопка "Подробнее"
                        Button(action: {}) {
                            HStack(spacing: 4) {
                                Text("Details")
                                    .font(.custom(Constants.Fonts.medium, size: 14))
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                            }
                            .foregroundColor(Color(hex: Constants.Colors.accent))
                        }
                        
                        // Кнопка "Сохранить"
                        Button(action: {}) {
                            Image(systemName: "bookmark")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        // Кнопка "Поделиться"
                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
            }
        }
        .padding(.bottom, isLast ? 0 : 40)
        .padding(.horizontal, 26)
    }
}

// MARK: - Модели данных

struct Guide {
    let id: Int
    let city: String
    let author: String
    let description: String
    let places: [Place]
}

struct Place: Identifiable {
    let id: Int
    let order: Int
    let name: String
    let description: String
    let address: String?
    let image: String
}

// MARK: - Превью

struct GuideView_Previews: PreviewProvider {
    static var previews: some View {
        GuideView(guide: Guide(
            id: 1,
            city: "Tbilisi",
            author: "McLovin",
            description: "Tbilisi is a paradise for Russian relocants. The city offers a blend of ancient and modern architecture, vibrant nightlife, delicious food, and a warm, welcoming atmosphere. This guide highlights the best spots to enjoy the local culture, from cafes and bars to hidden gardens and historical sites.",
            places: [
                Place(
                    id: 1,
                    order: 1,
                    name: "Fabrika",
                    description: "A former Soviet sewing factory transformed into a multi-functional urban space with cafes, bars, co-working spaces, and a hostel. It's a hub for creative people and digital nomads.",
                    address: "Egnate Ninoshvili St 8, Tbilisi",
                    image: "fabrika_image"
                ),
                Place(
                    id: 2,
                    order: 2,
                    name: "Shavi Lomi",
                    description: "A cozy restaurant hidden in the old town serving delicious Georgian cuisine with a modern twist. Their garden is perfect for summer evenings.",
                    address: "4 Zurab Kvlividze St, Tbilisi",
                    image: "shavi_lomi_image"
                ),
                Place(
                    id: 3,
                    order: 3,
                    name: "Mtatsminda Park",
                    description: "A large amusement park on top of Mount Mtatsminda offering breathtaking views of the entire city. Accessible by funicular railway.",
                    address: "Mtatsminda Plateau, Tbilisi",
                    image: "mtatsminda_image"
                )
            ]
        ))
    }
}

import SwiftUI

struct EditProfileView: View {
    // Binding для управления показом этого окна
    @Binding var isPresented: Bool
    
    // Состояние для полей формы
    @State private var username = "Alex Smith"
    @State private var handle = "alexsmith"
    @State private var bio = "Travel enthusiast and food lover. Always looking for new experiences and hidden gems around the world."
    @State private var email = "alex.smith@example.com"
    
    var body: some View {
        ZStack {
            // Фон
            Color(hex: Constants.Colors.background)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Заголовок с кнопкой закрытия
                    HStack {
                        // Кнопка закрытия
                        Button(action: {
                            // При нажатии закрываем окно
                            isPresented = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        // Заголовок
                        Text("Edit Profile")
                            .font(.custom(Constants.Fonts.medium, size: 20))
                        
                        Spacer()
                        
                        // Пустое место для баланса
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .foregroundColor(.clear)
                    }
                    .padding(.top, 16)
                    
                    // Секция аватара
                    VStack(spacing: 16) {
                        // Аватар с кнопкой редактирования
                        ZStack(alignment: .bottomTrailing) {
                            // Аватар
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white)
                                )
                            
                            // Кнопка редактирования
                            Button(action: {
                                // Логика для изменения аватара
                            }) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color(hex: Constants.Colors.accent))
                                    .clipShape(Circle())
                            }
                            .offset(x: 5, y: 5)
                        }
                        .padding(.top, 16)
                    }
                    
                    // Поля формы
                    VStack(spacing: 20) {
                        // Поле имени
                        inputField(title: "Name", text: $username)
                        
                        // Поле ника
                        inputField(title: "Username", text: $handle, prefix: "@")
                        
                        // Поле био
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bio")
                                .font(.custom(Constants.Fonts.medium, size: 16))
                                .foregroundColor(.black)
                            
                            TextEditor(text: $bio)
                                .font(.custom(Constants.Fonts.regular, size: 16))
                                .padding(12)
                                .frame(height: 100)
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        // Поле email
                        inputField(title: "Email", text: $email)
                    }
                    
                    // Кнопка сохранения
                    Button(action: {
                        // Сохраняем профиль и закрываем окно
                        saveProfile()
                        isPresented = false
                    }) {
                        Text("Save Changes")
                            .font(.custom(Constants.Fonts.medium, size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(hex: Constants.Colors.accent))
                            .cornerRadius(10)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 26)
            }
        }
        .preferredColorScheme(.light)
    }
    
    // Вспомогательные функции
    
    // Общий стиль поля ввода
    func inputField(title: String, text: Binding<String>, prefix: String = "") -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom(Constants.Fonts.medium, size: 16))
                .foregroundColor(.black)
            
            HStack(spacing: 0) {
                if !prefix.isEmpty {
                    Text(prefix)
                        .font(.custom(Constants.Fonts.regular, size: 16))
                        .foregroundColor(.gray)
                }
                
                TextField("", text: text)
                    .font(.custom(Constants.Fonts.regular, size: 16))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
    
    // Функция сохранения профиля
    func saveProfile() {
        // Здесь должна быть логика сохранения данных
        print("Сохраняем профиль: \(username), @\(handle)")
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(isPresented: .constant(true))
    }
}

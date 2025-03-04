import SwiftUI

struct RecommendationCard: View {
    let recommendation: Recommendation
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Фон для всей карточки
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
                .frame(width: 370, height: 224)
            
            // Изображение города (занимает всю карточку, без скругления снизу)
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 370, height: 235 - 81)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    // Кнопки сохранения и действий
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "suit.heart")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.05))
                                .clipShape(Circle())
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.05))
                                .clipShape(Circle())
                        }
                    }
                    .padding(12)
                }
                
                Spacer()
            }
            .frame(width: 370, height: 224)
            
            // Информация о городе (наложена снизу)
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    // Название города
                    Text(recommendation.city)
                        .font(.custom("Outfit-Medium", size: 22))
                    
                    Spacer()
                    
                    // Счетчик мест (отцентрирован по названию города)
                    HStack(spacing: 3) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 11))
                            .opacity(0.7)
                            .offset(y: -2)
                        
                        Text("\(recommendation.places) places")
                            .font(.custom("Outfit-Medium", size: 11))
                            .opacity(0.7)
                    }
                }
                .padding(.top, 12)
                .padding(.horizontal, 12)
                
                // Автор
                HStack(spacing: 5) {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 15, height: 15)
                    
                    Text(recommendation.author)
                        .font(.custom("Outfit-Regular", size: 13))
                }
                .padding(.horizontal, 12)
                .padding(.top, 5)
                
                // Описание
                Text(recommendation.description)
                    .font(.custom("Outfit-Regular", size: 13))
                    .opacity(0.5)
                    .padding(.horizontal, 12)
                    .padding(.top, 5)
                    .padding(.bottom, 12)
            }
            .frame(width: 370, height: 91)
            .background(Color(hex: Constants.Colors.cardDark))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .frame(width: 370, height: 224)
    }
}

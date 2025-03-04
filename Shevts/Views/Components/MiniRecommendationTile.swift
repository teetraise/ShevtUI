import SwiftUI

struct MiniRecommendationTile: View {
    let title: String
    let image: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: Constants.Colors.cardLight))
                .frame(height: 54)
            
            HStack(spacing: 0) {
                // Здесь должно быть изображение, но пока заменяем прямоугольником
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 54, height: 54)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Text(title)
                    .font(.custom("Outfit-Medium", size: 16))
                    .foregroundColor(.black)
                    .padding(.leading, 10)
                
                Spacer()
            }
        }
        .frame(height: 54)
    }
}

import SwiftUI

struct LibraryView: View {
    var body: some View {
        ZStack {
            Color(hex: Constants.Colors.background)
                .ignoresSafeArea()
            
            VStack {
                Text("Library Screen")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
        }
    }
}

import SwiftUI

struct SearchView: View {
    // State for the search field
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        ZStack {
            // Background color using constants
            Color(hex: Constants.Colors.background)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top search header
                searchHeader
                
                // Search input field
                searchField
                    .padding(.top, 16)
                    .padding(.horizontal, 26)
                
                // Categories grid
                categoriesSection
                    .padding(.top, 16)
                
                // Trending section
                trendingSection
                    .padding(.top, 32)
                
                Spacer()
                
                // Note: Bottom tab bar is already implemented elsewhere in the project
                // and doesn't need to be included here
            }
        }
        .preferredColorScheme(.light)
    }
    
    // MARK: - UI Components
    
    // Top search header
    var searchHeader: some View {
        HStack {
            // Profile avatar
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 30, height: 30)
            
            Text("Search")
                .font(.custom(Constants.Fonts.medium, size: 22))
                .padding(.leading, 8)
            
            Spacer()
        }
        .padding(.horizontal, 26)
        .padding(.top, 16)
        .padding(.bottom, 16)
    }
    
    // Search input field - FIXED
    var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 12)
            
            TextField("What are you looking for?", text: $searchText)
                .font(.custom(Constants.Fonts.regular, size: 16))
                .foregroundColor(.black)
                .focused($isSearchFocused)
                .submitLabel(.search)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 12)
                }
            }
        }
        .frame(height: 52)
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
    
    // Categories section
    var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                categoryItem(title: "Food & Drinks", image: "food_image")
                categoryItem(title: "Entertainment", image: "entertainment_image")
                categoryItem(title: "Shopping", image: "shopping_image")
                categoryItem(title: "Fitness", image: "fitness_image")
            }
        }
        .padding(.horizontal, 26)
    }
    
    // Trending section
    var trendingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Trending now")
                .font(.custom(Constants.Fonts.medium, size: 24))
                .padding(.leading, 26)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                cityItem(city: "Bangkok", author: "by Alexey Shevtsov", image: "bangkok_image")
                cityItem(city: "New York", author: "by Nastya Fedko", image: "newyork_image")
                cityItem(city: "Saint Petersburg", author: "by Oxxxymiron", image: "petersburg_image")
                cityItem(city: "Los Angeles", author: "by Misha Sein", image: "la_image")
            }
            .padding(.horizontal, 26)
        }
    }
    
    // Category item
    func categoryItem(title: String, image: String) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: Constants.Colors.cardLight))
            
            HStack {
                Text(title)
                    .font(.custom(Constants.Fonts.medium, size: 16))
                    .foregroundColor(.black)
                    .padding(.leading, 16)
                
                Spacer()
                
                // Placeholder for image
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .frame(height: 80)
    }
    
    // City item for trending section
    func cityItem(city: String, author: String, image: String) -> some View {
        ZStack(alignment: .bottomLeading) {
            // Main background
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: Constants.Colors.cardLight))
            
            // Image placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            // Text overlay
            VStack(alignment: .leading, spacing: 2) {
                Text(city)
                    .font(.custom(Constants.Fonts.medium, size: 16))
                    .foregroundColor(.black)
                
                Text(author)
                    .font(.custom(Constants.Fonts.regular, size: 12))
                    .foregroundColor(.black.opacity(0.7))
            }
            .padding(12)
            .background(Color(hex: Constants.Colors.cardLight).opacity(0.8))
            .cornerRadius(10)
            .padding(8)
        }
        .frame(height: 120)
    }
}

// Preview provider
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

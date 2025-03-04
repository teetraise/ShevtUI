import Foundation

struct MiniRecommendation: Identifiable {
    let id: Int
    let title: String
    let image: String
}

struct Recommendation: Identifiable {
    let id: Int
    let city: String
    let author: String
    let description: String
    let places: Int
    let image: String
}

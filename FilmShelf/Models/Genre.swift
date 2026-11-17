import Foundation
struct Genre: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
}

struct GenreResponse: Codable {
    let genres: [Genre]
}

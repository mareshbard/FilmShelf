import Foundation
import SwiftData

@Model
class MovieReview {
    var movieId: Int
    var movieTitle: String
    var rating: Int
    var comment: String?
    var dateAdded: Date
    
    init(movieId: Int, movieTitle: String, rating: Int, comment: String? = nil) {
        self.movieId = movieId
        self.movieTitle = movieTitle
        self.rating = rating
        self.comment = comment
        self.dateAdded = Date()
    }
}

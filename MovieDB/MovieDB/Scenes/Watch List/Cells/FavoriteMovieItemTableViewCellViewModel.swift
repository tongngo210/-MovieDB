import Foundation

struct FavoriteMovieItemTableViewCellViewModel {
    let id: Int
    let title: String
    let poster: String
    let releaseDate: String
    let voteRate: Double
    
    init(favoriteMovie: FavoriteMovie) {
        id = Int(favoriteMovie.id)
        title = favoriteMovie.title ?? ""
        poster = favoriteMovie.imageURLString ?? ""
        releaseDate = favoriteMovie.releaseDate ?? ""
        voteRate = favoriteMovie.rate
    }
}

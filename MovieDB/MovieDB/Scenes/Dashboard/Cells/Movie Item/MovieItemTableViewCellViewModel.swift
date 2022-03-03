import Foundation

struct MovieItemTableViewCellViewModel {
    let id: Int
    let title: String
    let poster: String
    let releaseDate: String
    let voteRate: Double
    
    init(movie: Movie) {
        id = movie.id
        title = movie.title ?? ""
        poster = movie.poster ?? ""
        releaseDate = movie.releaseDate ?? ""
        voteRate = movie.voteRate ?? 0
    }
}

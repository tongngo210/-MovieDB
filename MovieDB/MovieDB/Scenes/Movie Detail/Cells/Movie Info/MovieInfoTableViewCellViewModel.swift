import Foundation

struct MovieInfoTableViewCellViewModel {
    let synopsis: String
    let releaseDate: String
    let voteRate: Double
    let voteRateCount: Int
    let popularity: Double
    
    init(movieDetail: MovieDetail) {
        synopsis = movieDetail.synopsis ?? ""
        releaseDate = movieDetail.releaseDate ?? ""
        voteRate = movieDetail.voteRate ?? 0
        voteRateCount = movieDetail.voteRateCount ?? 0
        popularity = movieDetail.popularity ?? 0
    }
}

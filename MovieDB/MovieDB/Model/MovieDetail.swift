import Foundation

struct MovieDetail: Decodable {
    let id: Int
    let title: String?
    let poster: String?
    let backgroundPoster: String?
    let releaseDate: String?
    let synopsis: String?
    let genres: [Genre]
    let voteRate: Double?
    let voteRateCount: Int?
    let popularity: Double?
    
    private enum CodingKeys: String, CodingKey {
        case id, genres, popularity
        case title = "original_title"
        case poster = "poster_path"
        case backgroundPoster = "backdrop_path"
        case releaseDate = "release_date"
        case synopsis = "overview"
        case voteRate = "vote_average"
        case voteRateCount = "vote_count"
    }
    
    static var emptyMovieDetail: MovieDetail {
        return MovieDetail(id: 0, title: nil, poster: nil, backgroundPoster: nil, releaseDate: nil, synopsis: nil, genres: [], voteRate: nil, voteRateCount: nil, popularity: nil)
    }
}

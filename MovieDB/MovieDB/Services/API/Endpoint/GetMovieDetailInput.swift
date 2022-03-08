import Foundation

final class GetMovieDetailInput: Endpoint {
    required init(movieId: Int) {
        let path = String(format: APIURLs.movieDetail, movieId)
        super.init(path: path, queryItems: nil)
    }
}

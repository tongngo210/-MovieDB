import Foundation

final class GetMovieDetailInput: BaseInput {
    required init(movieId: Int) {
        let path = String(format: APIURLs.movieDetail, movieId)
        super.init(path: path, queryItems: nil)
    }
}

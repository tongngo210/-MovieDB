import Foundation

final class GetMovieReviewsInput: BaseInput {
    required init(movieId: Int) {
        let path = String(format: APIURLs.movieReviews, movieId)
        super.init(path: path, queryItems: nil)
    }
}

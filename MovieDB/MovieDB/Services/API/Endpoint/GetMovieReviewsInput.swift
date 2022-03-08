import Foundation

final class GetMovieReviewsInput: Endpoint {
    required init(movieId: Int) {
        let path = String(format: APIURLs.movieReviews, movieId)
        super.init(path: path, queryItems: nil)
    }
}

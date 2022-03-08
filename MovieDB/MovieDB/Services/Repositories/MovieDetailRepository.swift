import RxSwift
import RxCocoa

protocol MovieDetailRepositoryType {
    func getMovieDetail(movieId: Int) -> Observable<MovieDetail>
    func getMovieReviews(movieId: Int) -> Observable<[MovieReview]>
}

final class MovieDetailRepository: MovieDetailRepositoryType {
    private let api: APIService = APIService.shared
    
    func getMovieDetail(movieId: Int) -> Observable<MovieDetail> {
        let input = GetMovieDetailInput(movieId: movieId)
        return api.request(input: input)
            .map { (response: MovieDetail) in
                return response
            }
    }
    
    func getMovieReviews(movieId: Int) -> Observable<[MovieReview]> {
        let input = GetMovieReviewsInput(movieId: movieId)
        return api.request(input: input)
            .map { (response: MovieReviewList) in
                return response.results
            }
    }
}

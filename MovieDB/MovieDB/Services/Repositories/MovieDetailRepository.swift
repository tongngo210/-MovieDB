import RxSwift
import RxCocoa

protocol MovieDetailRepositoryType {
    func getMovieDetail(input: GetMovieDetailInput) -> Observable<MovieDetail>
    func getMovieReviews(input: GetMovieReviewsInput) -> Observable<[MovieReview]>
}

final class MovieDetailRepository: MovieDetailRepositoryType {
    private let api: APIService = APIService.shared
    
    func getMovieDetail(input: GetMovieDetailInput) -> Observable<MovieDetail> {
        return api.request(input: input)
            .map { (response: MovieDetail) in
                return response
            }
    }
    
    func getMovieReviews(input: GetMovieReviewsInput) -> Observable<[MovieReview]> {
        return api.request(input: input)
            .map { (response: MovieReviewList) in
                return response.results
            }
    }
}

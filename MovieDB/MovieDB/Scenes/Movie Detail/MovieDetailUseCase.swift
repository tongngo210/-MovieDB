import RxCocoa
import RxSwift

protocol MovieDetailUseCaseType {
    func getMovieDetail(movieId: Int) -> Observable<MovieDetail>
    func getMovieReviews(movieId: Int) -> Observable<[MovieReview]>
}

struct MovieDetailUseCase: MovieDetailUseCaseType {
    private let repository = MovieDetailRepository()
    
    func getMovieDetail(movieId: Int) -> Observable<MovieDetail> {
        let input = GetMovieDetailInput(movieId: movieId)
        return repository.getMovieDetail(input: input)
    }
    
    func getMovieReviews(movieId: Int) -> Observable<[MovieReview]> {
        let input = GetMovieReviewsInput(movieId: movieId)
        return repository.getMovieReviews(input: input)
    }
}

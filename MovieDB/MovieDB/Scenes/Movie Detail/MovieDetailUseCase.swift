import RxCocoa
import RxSwift

protocol MovieDetailUseCaseType {
    func getMovieDetail(movieId: Int) -> Observable<MovieDetail>
    func getMovieReviews(movieId: Int) -> Observable<[MovieReview]>
}

struct MovieDetailUseCase: MovieDetailUseCaseType {
    private let repository = MovieDetailRepository()
    
    func getMovieDetail(movieId: Int) -> Observable<MovieDetail> {
        return repository.getMovieDetail(movieId: movieId)
    }
    
    func getMovieReviews(movieId: Int) -> Observable<[MovieReview]> {
        return repository.getMovieReviews(movieId: movieId)
    }
}

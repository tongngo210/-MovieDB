import RxCocoa
import RxSwift

protocol MovieDetailUseCaseType {
    func getMovieDetail(movieId: Int) -> Observable<MovieDetail>
    func getMovieReviews(movieId: Int) -> Observable<[MovieReview]>
    func checkMovieIsFavorited(movieId: Int) -> Observable<Bool>
    func favoriteButtonAction(movieDetail: MovieDetail) -> Observable<Void>
}

struct MovieDetailUseCase: MovieDetailUseCaseType {
    private let movieDetailRepository = MovieDetailRepository()
    private let favoriteMovieRepository = FavoriteMovieRepository()
    
    func getMovieDetail(movieId: Int) -> Observable<MovieDetail> {
        return movieDetailRepository.getMovieDetail(movieId: movieId)
    }
    
    func getMovieReviews(movieId: Int) -> Observable<[MovieReview]> {
        return movieDetailRepository.getMovieReviews(movieId: movieId)
    }
    
    func favoriteButtonAction(movieDetail: MovieDetail) -> Observable<Void> {
        let isMovieFavorited = favoriteMovieRepository.checkMovieIsFavorited(movieId: movieDetail.id)
        if isMovieFavorited {
            return favoriteMovieRepository.deleteFavoriteMovie(movieId: movieDetail.id)
                .andThen(.just(()))
        } else {
            return favoriteMovieRepository.addMovieToFavorite(from: movieDetail)
                .andThen(.just(()))
        }
    }
    
    func checkMovieIsFavorited(movieId: Int) -> Observable<Bool> {
        return Observable.just(favoriteMovieRepository.checkMovieIsFavorited(movieId: movieId))
    }
}

import RxCocoa
import RxSwift

protocol WatchListUseCaseType {
    func getFavoriteMovies() -> Observable<[FavoriteMovie]>
    func deleteFavoriteMovie(movieId: Int) -> Observable<Void>
}

struct WatchListUseCase: WatchListUseCaseType {
    private let repository = FavoriteMovieRepository()
    
    func getFavoriteMovies() -> Observable<[FavoriteMovie]> {
        return repository.getFavoriteMovies()
    }
    
    func deleteFavoriteMovie(movieId: Int) -> Observable<Void> {
        return repository.deleteFavoriteMovie(movieId: movieId)
            .andThen(.just(()))
    }
}

import RxSwift
import RxCocoa

protocol FavoriteMovieRepositoryType {
    func getFavoriteMovies() -> Observable<[FavoriteMovie]>
    func deleteFavoriteMovie(movieId: Int) -> Completable
    func addMovieToFavorite(from movie: Movie) -> Completable
    func addMovieToFavorite(from movieDetail: MovieDetail) -> Completable
    func checkMovieIsFavorited(movieId: Int) -> Bool
}

final class FavoriteMovieRepository: FavoriteMovieRepositoryType {
    private let coreData: CoreDataService = CoreDataService.shared
    
    func getFavoriteMovies() -> Observable<[FavoriteMovie]> {
        return coreData.loadFavoriteMovies()
    }
    
    func deleteFavoriteMovie(movieId: Int) -> Completable {
        return coreData.deleteFavoriteMovie(movieId: movieId)
    }
    
    func addMovieToFavorite(from movie: Movie) -> Completable {
        return coreData.addMovieToFavorite(movieId: movie.id,
                                           title: movie.title ?? "",
                                           imageURLString: movie.poster ?? "",
                                           releaseDate: movie.releaseDate ?? "",
                                           rate: movie.voteRate ?? 0)
    }
    
    func addMovieToFavorite(from movieDetail: MovieDetail) -> Completable {
        return coreData.addMovieToFavorite(movieId: movieDetail.id,
                                           title: movieDetail.title ?? "",
                                           imageURLString: movieDetail.poster ?? "",
                                           releaseDate: movieDetail.releaseDate ?? "",
                                           rate: movieDetail.voteRate ?? 0)
    }
    
    func checkMovieIsFavorited(movieId: Int) -> Bool {
        return coreData.checkMovieIsFavorited(movieId: movieId)
    }
}

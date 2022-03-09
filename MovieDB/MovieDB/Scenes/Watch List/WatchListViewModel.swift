import RxCocoa
import RxSwift

struct WatchListViewModel {
    let useCase: WatchListUseCaseType
}

extension WatchListViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let notification: PublishSubject<Void>
        let bookmarkButtonTrigger: PublishSubject<Int>
    }
    
    struct Output {
        let favoriteMovies: Driver<[FavoriteMovie]>
    }
    
    func transform(_ input: Input) -> Output {
        let loadFavoriteMovies = Driver
            .merge(input.loadTrigger,
                   input.notification.asDriver(onErrorJustReturn: ()))
            .flatMapLatest {
                useCase.getFavoriteMovies()
                    .asDriver(onErrorJustReturn: [])
            }
        
        let deleteFavoriteMovie = input.bookmarkButtonTrigger
            .asDriver(onErrorJustReturn: 0)
            .flatMapLatest {
                useCase.deleteFavoriteMovie(movieId: $0)
                    .asDriver(onErrorJustReturn: ())
            }
            .flatMapLatest {
                useCase.getFavoriteMovies()
                    .asDriver(onErrorJustReturn: [])
            }
            
        let favoriteMovies = Driver.merge(loadFavoriteMovies, deleteFavoriteMovie)
        
        return Output(favoriteMovies: favoriteMovies)
    }
}

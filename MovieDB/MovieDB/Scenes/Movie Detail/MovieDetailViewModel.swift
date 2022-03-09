import RxCocoa
import RxSwift

struct MovieDetailViewModel {
    let useCase: MovieDetailUseCaseType
    let movieId: Int
}

extension MovieDetailViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let bookmarkButtonTrigger: Driver<Void>
        let isMovieFavorited: BehaviorRelay<Bool>
        let movieGenres: BehaviorRelay<[Genre]>
    }
    
    struct Output {
        let movieInfo: Driver<MovieDetail>
        let movieReviews: Driver<[MovieReview]>
        let movieGenres: Driver<[Genre]>
        let isMovieFavorited: Driver<Bool>
        let bookmarkButtonTrigger: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let movieInfo = input.loadTrigger
            .flatMapLatest {
                useCase.getMovieDetail(movieId: movieId)
                    .asDriver(onErrorJustReturn: MovieDetail.emptyMovieDetail)
            }
        
        let movieGenres = movieInfo
            .map { $0.genres }
            .do(onNext: {
                input.movieGenres.accept($0)
            })
        
        let movieReviews = input.loadTrigger
            .flatMapLatest {
                useCase.getMovieReviews(movieId: movieId)
                    .asDriver(onErrorJustReturn: [])
            }
        
        let isMovieFavorited = input.loadTrigger
            .flatMapLatest {
                useCase.checkMovieIsFavorited(movieId: movieId)
                    .asDriver(onErrorJustReturn: false)
            }
            .do(onNext: {
                input.isMovieFavorited.accept($0)
            })
        
        let bookmarkButtonTrigger = input.bookmarkButtonTrigger
            .withLatestFrom(movieInfo)
            .flatMapLatest {
                useCase.favoriteButtonAction(movieDetail: $0)
                    .asDriver(onErrorJustReturn: ())
            }
            .flatMapLatest {
                useCase.checkMovieIsFavorited(movieId: movieId)
                    .asDriver(onErrorJustReturn: false)
            }
        
        return Output(movieInfo: movieInfo,
                      movieReviews: movieReviews,
                      movieGenres: movieGenres,
                      isMovieFavorited: isMovieFavorited,
                      bookmarkButtonTrigger: bookmarkButtonTrigger)
    }
}

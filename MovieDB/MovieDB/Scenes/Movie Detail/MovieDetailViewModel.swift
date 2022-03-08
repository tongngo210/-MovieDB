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
    }
    
    struct Output {
        let movieInfo: Driver<MovieDetail>
        let movieReviews: Driver<[MovieReview]>
        let movieGenres: Driver<[Genre]>
        let addMovieToFavorite: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let movieInfo = input.loadTrigger
            .flatMapLatest {
                useCase.getMovieDetail(movieId: movieId)
                    .asDriver(onErrorJustReturn: MovieDetail.emptyMovieDetail)
            }
        
        let movieGenres = movieInfo
            .map { $0.genres }
        
        let movieReviews = input.loadTrigger
            .flatMapLatest {
                useCase.getMovieReviews(movieId: movieId)
                    .asDriver(onErrorJustReturn: [])
            }
        
        let addMovieToFavorite = input.bookmarkButtonTrigger
            //TODO: Add Movie to Favorite
        
        return Output(movieInfo: movieInfo,
                      movieReviews: movieReviews,
                      movieGenres: movieGenres,
                      addMovieToFavorite: addMovieToFavorite)
    }
}

import RxCocoa
import RxSwift

struct DashboardViewModel {
    let useCase: DashboardUseCaseType
}

extension DashboardViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let loadMoreButtonTrigger: Driver<Void>
        let categorySelectedTrigger: Driver<CategoryType>
        let pageNumber: BehaviorRelay<Int>
        let movieItems: BehaviorRelay<[Movie]>
        let bookmarkButtonTrigger: PublishSubject<Void>
        let starButtonTrigger: PublishSubject<Void>
    }
    
    struct Output {
        let movieItems: BehaviorRelay<[Movie]>
        let firstPageMovies: Driver<[Movie]>
        let nextPageMovies: Driver<[Movie]>
        let categoryItems: Driver<[CategoryType]>
        let saveFavoriteMovie: Driver<Void>
        let voteMovie: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let categoryItems = input.loadTrigger
            .map { CategoryType.allCases }
        
        let saveFavoriteMovie = input.bookmarkButtonTrigger
            //TODO: Save Movie To Favorite
            .map { _ in return () }
            .asDriver(onErrorJustReturn: ())
        
        let voteMovie = input.starButtonTrigger
            //TODO: Vote Movie and send to server
            .map { _ in return () }
            .asDriver(onErrorJustReturn: ())
        
        let firstPageMovies = input.categorySelectedTrigger
            .do{ _ in
                input.pageNumber.accept(1)
            }
            .flatMapLatest {
                useCase.getFirstPageMoviesOfCategory($0)
                    .asDriver(onErrorJustReturn: [])
            }
        
        let nextPageMovies = input.loadMoreButtonTrigger
            .do { _ in
                input.pageNumber.accept(input.pageNumber.value + 1)
            }
            .withLatestFrom(input.categorySelectedTrigger)
            .flatMapLatest {
                useCase.getMoreMoviesOfCategory($0, page: input.pageNumber.value)
                    .asDriver { _ in
                        input.pageNumber.accept(input.pageNumber.value - 1)
                        return Driver.just([])
                    }
            }
        
        return Output(movieItems: input.movieItems,
                      firstPageMovies: firstPageMovies,
                      nextPageMovies: nextPageMovies,
                      categoryItems: categoryItems,
                      saveFavoriteMovie: saveFavoriteMovie,
                      voteMovie: voteMovie)
    }
}

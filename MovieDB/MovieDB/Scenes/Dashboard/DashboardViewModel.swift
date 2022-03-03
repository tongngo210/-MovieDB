import RxCocoa
import RxSwift

struct DashboardViewModel {
    let coordinator: DashboardCoordinatorType
    let useCase: DashboardUseCaseType
}

extension DashboardViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let searchButtonTrigger: Driver<Void>
        let watchListButtonTrigger: Driver<Void>
        let loadMoreButtonTrigger: Driver<Void>
        let searchText: Driver<String>
        let categorySelectedTrigger: Driver<CategoryType>
        let movieSelectedTrigger: Driver<Movie>
    }
    
    struct Output {
        let movieItems = BehaviorRelay<[Movie]>(value: [])
        let categoryItems = BehaviorRelay<[CategoryType]>(value: [])
        let pageNumber = BehaviorRelay<Int>(value: 1)
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.loadTrigger
            .map { CategoryType.allCases }
            .drive(output.categoryItems)
            .disposed(by: disposeBag)
        
        input.categorySelectedTrigger
            .do(onNext: { _ in
                output.pageNumber.accept(1)
            })
            .flatMapLatest {
                useCase.getMoviesFromCategory($0, page: output.pageNumber.value)
                    .asDriver(onErrorJustReturn: [])
            }
            .drive(output.movieItems)
            .disposed(by: disposeBag)
        
        input.loadMoreButtonTrigger
            .do(onNext: { _ in
                output.pageNumber.accept(output.pageNumber.value + 1)
            })
            .withLatestFrom(input.categorySelectedTrigger)
            .flatMapLatest {
                useCase.getMoviesFromCategory($0, page: output.pageNumber.value)
                    .asDriver { _ in
                        output.pageNumber.accept(output.pageNumber.value - 1)
                        return Driver.just([])
                    }
            }
            .drive(onNext: { result in
                output.movieItems.accept(output.movieItems.value + result)
            })
            .disposed(by: disposeBag)
        
        input.searchButtonTrigger
            .withLatestFrom(input.searchText)
            .do(onNext: {
                coordinator.goToSearch(query: $0)
            })
            .drive()
            .disposed(by: disposeBag)
        
        input.watchListButtonTrigger
            .do(onNext: {
                coordinator.goToWatchList()
            })
            .drive()
            .disposed(by: disposeBag)
                
        input.movieSelectedTrigger
            .do(onNext: {
                coordinator.goToMovieDetail(movieId: $0.id)
            })
            .drive()
            .disposed(by: disposeBag)
                
        return output
    }
}

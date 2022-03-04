import RxCocoa
import RxSwift

protocol DashboardUseCaseType {
    func getFirstPageMoviesOfCategory(_ category: CategoryType) -> Observable<[Movie]>
    func getMoreMoviesOfCategory(_ category: CategoryType, page: Int) -> Observable<[Movie]>
    func refreshMoviesOfCategory(_ category: CategoryType) -> Observable<[Movie]>
}

struct DashboardUseCase: DashboardUseCaseType {
    private let repository = MovieRepository()
    
    func getFirstPageMoviesOfCategory(_ category: CategoryType) -> Observable<[Movie]> {
        let input = CategoryMoviesInput(category: category, page: 1)
        return repository.getMoviesFromCategory(input: input)
    }
    
    func getMoreMoviesOfCategory(_ category: CategoryType, page: Int) -> Observable<[Movie]> {
        let input = CategoryMoviesInput(category: category, page: page)
        return repository.getMoviesFromCategory(input: input)
    }
    
    func refreshMoviesOfCategory(_ category: CategoryType) -> Observable<[Movie]> {
        let input = CategoryMoviesInput(category: category, page: 1)
        return repository.getMoviesFromCategory(input: input)
    }
}

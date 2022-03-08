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
        return repository.getMoviesFromCategory(category: category, page: 1)
    }
    
    func getMoreMoviesOfCategory(_ category: CategoryType, page: Int) -> Observable<[Movie]> {
        return repository.getMoviesFromCategory(category: category, page: page)
    }
    
    func refreshMoviesOfCategory(_ category: CategoryType) -> Observable<[Movie]> {
        return repository.getMoviesFromCategory(category: category, page: 1)
    }
}

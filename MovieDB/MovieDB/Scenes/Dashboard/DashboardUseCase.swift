import RxCocoa
import RxSwift

protocol DashboardUseCaseType {
    func getMoviesFromCategory(_ category: CategoryType, page: Int) -> Observable<[Movie]>
}

struct DashboardUseCase: DashboardUseCaseType {
    private let repository = MovieRepository()
    
    func getMoviesFromCategory(_ category: CategoryType, page: Int) -> Observable<[Movie]> {
        let input = CategoryMoviesEndpoint(category: category, page: page)
        return repository.getMoviesFromCategory(input: input)
    }
}

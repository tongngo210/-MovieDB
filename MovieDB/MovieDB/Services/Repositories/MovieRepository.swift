import RxSwift
import RxCocoa

protocol MovieRepositoryType {
    func getMoviesFromCategory(category: CategoryType, page: Int) -> Observable<[Movie]>
}

final class MovieRepository: MovieRepositoryType {
    private let api: APIService = APIService.shared
    
    func getMoviesFromCategory(category: CategoryType, page: Int) -> Observable<[Movie]> {
        let input = CategoryMoviesInput(category: category, page: page)
        return api.request(input: input)
            .map { (response: MovieList) in
                return response.results
            }
    }
}

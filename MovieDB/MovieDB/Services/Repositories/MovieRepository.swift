import RxSwift
import RxCocoa

protocol MovieRepositoryType {
    func getMoviesFromCategory(input: CategoryMoviesInput) -> Observable<[Movie]>
}

final class MovieRepository: MovieRepositoryType {
    private let api: APIService = APIService.shared
    
    func getMoviesFromCategory(input: CategoryMoviesInput) -> Observable<[Movie]> {
        return api.request(input: input)
            .map { (response: MovieList) in
                return response.results
            }
    }
}

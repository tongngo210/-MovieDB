import RxSwift
import RxCocoa

protocol MovieRepositoryType {
    func getMoviesFromCategory(input: CategoryMoviesEndpoint) -> Observable<[Movie]>
}

final class MovieRepository: MovieRepositoryType {
    private let api: APIService = APIService.shared
    
    func getMoviesFromCategory(input: CategoryMoviesEndpoint) -> Observable<[Movie]> {
        return api.request(input: input)
            .map { (response: MovieList) in
                return response.results
            }
    }
}

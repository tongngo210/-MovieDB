import Foundation

final class CategoryMoviesEndpoint: Endpoint {
    required init(category: CategoryType, page: Int) {
        let path = category.url
        let queryItems = [ URLQueryItem(name: "page", value: "\(page)"),
                           URLQueryItem(name: "language", value: "en-US")]
        super.init(path: path, queryItems: queryItems)
    }
}

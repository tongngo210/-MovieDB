import Foundation

class Endpoint {
    let path: String
    let queryItems: [URLQueryItem]?
    
    init(path: String, queryItems: [URLQueryItem]?) {
        self.path = path
        self.queryItems = [URLQueryItem(name: "api_key", value: APIKey.apiKey)] + (queryItems ?? [] )
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = APIURLs.scheme
        components.host = APIURLs.host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}

import RxSwift
import RxCocoa

struct APIService {
    static let shared = APIService()
    
    func request<T: Decodable>(input: Endpoint) -> Observable<T> {
        Observable.create { obs in
            if let url = input.url {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let _ = error {
                        obs.onError(APIError.unableToRequest)
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        obs.onError(APIError.invalidResponse)
                        return
                    }
                    
                    guard let safeData = data else {
                        obs.onError(APIError.unsafeData)
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: safeData)
                        obs.onNext(result)
                        obs.onCompleted()
                    } catch {
                        obs.onError(APIError.invalidData)
                    }
                }.resume()
            } else {
                obs.onError(APIError.invalidURL)
            }
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
        .observe(on: MainScheduler.instance)
    }
}

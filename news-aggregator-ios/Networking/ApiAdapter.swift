import Alamofire
import Foundation

/// Адаптер запросов.
protocol URLRequestAdapter: Alamofire.RequestAdapter {}


/// Адаптер запросов API
final class ApiAdapter: URLRequestAdapter {

    // MARK: - Constants
    
    private enum Constants {
        static let apiKey = "apiKey"
    }
    
    private let apiKey = "af0f1f4cb4474900934fc8150a61389b"
    
    
    // MARK: - Private variables
    
    private let baseURLProvider: BaseURLProvider
    
    
    // MARK: - Initialization
    
    init(baseURLProvider: BaseURLProvider) {
        self.baseURLProvider = baseURLProvider
    }
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        guard let url = urlRequest.url else {
            fatalError("No url in \(urlRequest)")
        }

        let path = baseURLProvider.newsApiURL.absoluteString + url.absoluteString

        guard var urlComponents = URLComponents(string: path) else {
            completion(.failure(AFError.parameterEncodingFailed(reason: .missingURL)))
            return
        }

        let queryItem = URLQueryItem(name: apiKey, value: Constants.apiKey)
        urlComponents.queryItems = [queryItem]
        
        do {
            let request = URLRequest(url: try urlComponents.asURL())
            completion(.success(request))
        } catch {
            completion(.failure(error))
        }
    }
}

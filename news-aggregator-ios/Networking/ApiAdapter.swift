import Alamofire
import Foundation

/// Адаптер запросов.
protocol URLRequestAdapter: Alamofire.RequestAdapter {}


/// Адаптер запросов API
final class ApiAdapter: URLRequestAdapter {

    // MARK: - Constants
    
    private enum Constants {
        static let authorization = "Authorization"
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

        var request: URLRequest = urlRequest
        
        guard let url = request.url else {
            fatalError("No url in \(request)")
        }
        
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: Constants.authorization)
        request.url = URL(string: url.absoluteString, relativeTo: baseURLProvider.newsApiURL)
        
        completion(.success(request))
    }
}

import Alamofire
import Foundation

protocol NetworkProviderProtocol {
    typealias Handler = (_ dataResponse: Alamofire.AFDataResponse<Data>) -> Void

    func makeRequest(_ endpoint: Endpoint, completion: @escaping Handler)
}

final class NetworkProvider: NetworkProviderProtocol {
    private let sessionManager: Alamofire.Session
    
    init(configuration: URLSessionConfiguration,
         trustManager: ServerTrustManager,
         rootQueue: DispatchQueue,
         requestInterceptor: ApiRequestInterceptor) {
        sessionManager = Alamofire.Session(
            configuration: configuration,
            delegate: SessionDelegate(),
            rootQueue: rootQueue,
            interceptor: requestInterceptor,
            serverTrustManager: trustManager
        )
    }
    
    /// Сделать запрос к эндпоинту API.
    func makeRequest(_ endpoint: Endpoint, completion: @escaping Handler) {
        sessionManager.request(endpoint)
            .validate()
            .responseData(completionHandler: completion)
    }
}

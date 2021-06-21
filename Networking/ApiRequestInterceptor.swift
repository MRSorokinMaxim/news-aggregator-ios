import Alamofire

final class ApiRequestInterceptor: RequestInterceptor {
        
    private let requestAdapter: URLRequestAdapter?
    private let requestRetrier: URLRequestRetrier?
    
    init(requestAdapter: URLRequestAdapter?,
         requestRetrier: URLRequestRetrier?) {
        self.requestAdapter = requestAdapter
        self.requestRetrier = requestRetrier
    }

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        requestAdapter?.adapt(urlRequest, for: session, completion: completion)
    }

    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        requestRetrier?.retry(request, for: session, dueTo: error, completion: completion)
    }
}

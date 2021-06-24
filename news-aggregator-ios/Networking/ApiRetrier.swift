import Alamofire

/// Ретраер запросов.
protocol URLRequestRetrier: Alamofire.RequestRetrier {}

final class ApiRetrier: URLRequestRetrier {
        
    // MARK: - Constants
    
    private enum Constants {
        static let maxRetryCount = 3
    }
    
    // MARK: - RequestRetrier
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult
        ) -> Void) {
        
        guard request.retryCount < Constants.maxRetryCount else {
            completion(.doNotRetry)
            return
        }
        
        completion(.retryWithDelay(TimeInterval(0.3)))
    }
}

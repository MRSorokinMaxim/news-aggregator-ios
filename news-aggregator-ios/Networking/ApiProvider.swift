import Alamofire
import Foundation
import UIKit

final class ApiProvider {
    private typealias Response = AFDataResponse<Data>
    
    /// Сетеваой провадйер.
    private let networkProvider: NetworkProvider

    /// Парсер ответа.
    private lazy var parser = JSONParser()
    
    init(configuration: URLSessionConfiguration,
         trustManager: ServerTrustManager,
         requestInterceptor: ApiRequestInterceptor) {
        self.networkProvider = NetworkProvider(
            configuration: configuration,
            trustManager: trustManager,
            rootQueue: DispatchQueue(label: "news_aggregator_api.queue"),
            requestInterceptor: requestInterceptor)
    }

    /// Отправить API запрос по эндпроиту.
    func request<T>(
        endpoint: Endpoint,
        type: T.Type,
        completion: @escaping ([T]?, ApiError?) -> Void
    ) where T: Decodable {
        networkProvider.makeRequest(endpoint) { [weak parser] dataResponse in
            guard let parser = parser else { return }
            let response: Swift.Result<[T], ApiError> = dataResponse.dataOrError(parser: parser)
            switch response {
            case let .success(data):
                print(data)
                return completion(data, nil)
            
            case let .failure(error):
                print(error)
                return completion(nil, error)
            }
        }
    }
}

private extension AFDataResponse {
    func dataOrError<T: Decodable>(parser: JSONParser) -> Swift.Result<[T], ApiError> {
        switch decode(parser: parser) as Swift.Result<[T], ApiError> {
        case let .success(items):
            return .success(items)
        case let .failure(error):
            guard let apiError = decodeError(parser: parser) else {
                return .failure(error)
            }
            
            return .failure(apiError)
        }
    }

    func decode<T: Decodable>(parser: JSONParser) -> Swift.Result<[T], ApiError> {
        guard let data = data else {
            return .failure(.defaultError)
        }

        if let metrics = metrics, metrics.taskInterval.duration > AppServiceLayer.timeout {
            return .failure(.timeoutError)
        }

        guard let decodedResponse = try? parser.parse(data, type: T.self) else {
            return .failure(.defaultError)
        }

        return .success(decodedResponse)
    }

    func decodeError(parser: JSONParser) -> ApiError? {
        switch decode(parser: parser) as Swift.Result<[ApiError], ApiError> {
        case let .success(mappedApiError):
            return mappedApiError.first

        case let .failure(generalError):
            return generalError
        }
    }
}

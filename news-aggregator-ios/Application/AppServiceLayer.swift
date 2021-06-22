import Alamofire

final class AppServiceLayer {

    // MARK: Services

    let newsService: NewsService
    
    // MARK: Initialization
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = AppServiceLayer.timeout
        configuration.timeoutIntervalForResource = AppServiceLayer.timeout
        
        let baseURLProvider = BaseURLProviderImpl()
        let requestInterceptor = ApiRequestInterceptor(
            requestAdapter: ApiAdapter(baseURLProvider: baseURLProvider),
            requestRetrier: ApiRetrier()
        )
        
        let apiProvider = ApiProvider(configuration: configuration,
                                  trustManager: ServerTrustManager(evaluators: [:]),
                                  requestInterceptor: requestInterceptor)
        
        newsService = NewsServiceImpl(apiProvider: apiProvider)
    }
}

extension AppServiceLayer {
    static let timeout = 30.0
}

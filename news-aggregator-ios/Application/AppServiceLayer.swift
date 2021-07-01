import Alamofire

final class AppServiceLayer {

    // MARK: Services

    let newsService: NewsService
    let settingService: SettingService
    let newsStorage: NewsStorage
    let sourceStorage: SourceStorage
    let viewedNewsStorage: ViewedNewsStorage
    
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
                                      trustManager: ServerTrustManager(evaluators: ["newsapi.org": DefaultTrustEvaluator()]),
                                      requestInterceptor: requestInterceptor)
        
        newsService = NewsServiceImpl(apiProvider: apiProvider)
        settingService = SettingServiceImpl()
        newsStorage = NewsStorageImpl()
        sourceStorage = SourceStorageImpl()
        viewedNewsStorage = ViewedNewsStorageImpl()
    }
}

extension AppServiceLayer {
    static let timeout = 10.0
}

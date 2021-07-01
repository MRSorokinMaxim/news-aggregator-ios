import Foundation

protocol NewsService {
    typealias EverythingCompletion = (EverythingResponse?, ApiError?) -> Void
    typealias TopHeadlinesCompletion = (TopHeadlinesResponse?, ApiError?) -> Void
    typealias SourcesCompletion = (SourcesResponse?, ApiError?) -> Void
    
    func obtainEverything(completionHandler: @escaping EverythingCompletion)
    func obtainTopHeadlines(completionHandler: @escaping TopHeadlinesCompletion)
    func obtainSources(completionHandler: @escaping SourcesCompletion)
}


final class NewsServiceImpl: NewsService {
    private let apiProvider: ApiProvider
    
    init(apiProvider: ApiProvider) {
        self.apiProvider = apiProvider
    }
    
    func obtainEverything(completionHandler: @escaping EverythingCompletion) {
        let data = EverythingRequest()
        let endpoint = NewsEndpoint.everything(data: data)

        apiProvider.request(endpoint: endpoint, type: EverythingResponse.self) { result, error in
            completionHandler(result?.first, error)
        }
    }
    
    func obtainTopHeadlines(completionHandler: @escaping TopHeadlinesCompletion) {
        let data = TopHeadlinesRequest(country: .ru, pageSize: 100)
        let endpoint = NewsEndpoint.topHeadlines(data: data)

        apiProvider.request(endpoint: endpoint, type: TopHeadlinesResponse.self) { result, error in
            completionHandler(result?.first , error)
        }
    }
    
    func obtainSources(completionHandler: @escaping SourcesCompletion) {
        let data = SourcesRequest(country: .ru)
        let endpoint = NewsEndpoint.sources(data: data)

        apiProvider.request(endpoint: endpoint, type: SourcesResponse.self) { result, error in
            completionHandler(result?.first, error)
        }
    }
}

import Alamofire

enum NewsEndpoint: Endpoint {
    case everything(data: EverythingRequest)
    case topHeadlines(data: TopHeadlinesRequest)
    case sources(data: SourcesRequest)
    
    func asURLRequest() throws -> URLRequest {
        guard let components = urlComponents else {
            throw AFError.parameterEncodingFailed(reason: .missingURL)
        }
        
        var request = URLRequest(url: try components.asURL())
        request.httpMethod = HTTPMethod.get.rawValue
        
        return request
    }
    
    private var urlComponents: URLComponents? {
        switch self {
        case let .everything(data):
            return buildUrlComponents(source: data, path: "everything")
        
        case let .topHeadlines(data):
            return buildUrlComponents(source: data, path: "top-headlines")

        case let .sources(data):
            return buildUrlComponents(source: data, path: "sources")
        }
    }
    
    private func buildUrlComponents(source: Codable?, path: String) -> URLComponents? {
        var urlComponents = URLComponents(string: path)
        var queryItems: [URLQueryItem] = []

        if let source = source,
           let parameters = ApiHelper.mapValuesToQueryItems(source) {
            queryItems.append(contentsOf: parameters)
        }
    
        urlComponents?.queryItems = queryItems
        
        return urlComponents
    }
}

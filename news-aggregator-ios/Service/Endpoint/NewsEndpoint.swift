import Alamofire

enum NewsEndpoint: Endpoint {
    case everything(data: EverythingRequest)
    case topHeadlines(data: TopHeadlinesRequest)
    case sources(data: SourcesRequest)
    
    func asURLRequest() throws -> URLRequest {
        guard var components = urlComponents else {
            throw AFError.parameterEncodingFailed(reason: .missingURL)
        }

        let queryItems = components.queryItems?.map { ($0.name, $0.value ?? "") } ?? []

        let parameters = Dictionary(uniqueKeysWithValues: queryItems)

        components.queryItems = nil // will be added by URLEncoding

        var request = URLRequest(url: try components.asURL())
        request.httpMethod = HTTPMethod.get.rawValue

        return try URLEncoding.default.encode(request, with: parameters)
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

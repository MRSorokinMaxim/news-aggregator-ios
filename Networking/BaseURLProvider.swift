import Foundation

protocol BaseURLProvider {
    var newsApiURL: URL { get }
}

final class BaseURLProviderImpl: BaseURLProvider {
    
    // MARK: - Constants
    
    private enum ServerApiURL: String {
        case news = "https://newsapi.org/"
    }
    
    private let apiNewsSuffix = "v2/"
    
    private var newsApiServerURL: URL {
        guard let url = URL(string: ServerApiURL.news.rawValue) else {
            fatalError("Can't construct newsApiServerURL")
        }

        return url
    }
    
    // MARK: - Public properties
    
    var newsApiURL: URL {
        guard let url = URL(string: apiNewsSuffix, relativeTo: newsApiServerURL) else {
            fatalError("Can't construct newsApiURL")
        }
        
        return url
    }
}

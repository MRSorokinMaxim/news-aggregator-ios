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
    
    // MARK: - Public properties
    
    var newsApiURL: URL {
        guard let url = URL(string: ServerApiURL.news.rawValue + apiNewsSuffix) else {
            fatalError("Can't construct newsApiURL")
        }
        
        return url
    }
}

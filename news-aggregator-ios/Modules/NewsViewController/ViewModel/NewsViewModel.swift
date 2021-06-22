import Foundation

final class NewsViewModel {
    private let newsService: NewsService
    
    init(newsService: NewsService) {
        self.newsService = newsService
    }
}

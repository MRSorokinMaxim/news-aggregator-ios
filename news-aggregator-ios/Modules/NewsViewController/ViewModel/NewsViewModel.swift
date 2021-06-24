import Foundation

final class NewsViewModel: LoadingViewModel {
    
    // MARK: - Properties
    
    private let newsService: NewsService
    private var topHeadlines: TopHeadlinesResponse?
    
    // MARK: - LoadingViewModel
    
    let downloader = DispatchGroup()
    var state: LoadingState = .initial
    var errors: [ApiError] = []
    
    // MARK: - PromoModuleInput

    weak var view: NewsModuleInput?
    
    // MARK: - Initialization
    
    init(newsService: NewsService) {
        self.newsService = newsService
    }
}

// MARK: - LoadingViewModel

extension NewsViewModel {
    var dataSource: [VoidBlock] {
        [loadTopHeadlines]
    }
    
    func handleResults() {
        state = .rich
        view?.configureTableView()
    }
    
    private func loadTopHeadlines() {
        newsService.obtainTopHeadlines { [weak self] topHeadlines, error in
            self?.handleErrorIfNeeded(error)

            if let topHeadlines = topHeadlines {
                self?.topHeadlines = topHeadlines
            }

            self?.downloader.leave()
        }
    }
}

extension NewsViewModel: NewsBuilderDataSource {
    var newsSourceViewModels: [NewsCell.ViewModel] {
        topHeadlines?.articles.map { news in
            NewsCell.ViewModel(
                iconPath: news.urlToImage,
                title: news.title,
                description: news.description,
                iconIsReading: false)
        } ?? []
    }
}

import Foundation

protocol NewsViewModel: NewsBuilderDataSource {
    func loadContent()
}

final class NewsViewModelImpl: NewsViewModel, LoadingViewModel {
    
    // MARK: - Properties
    
    private let newsService: NewsService
    private let newsStorage: NewsStorage
    private let sourceStorage: SourceStorage

    private var topHeadlines: TopHeadlinesResponse?
    private var sources: SourcesResponse?
    
    // MARK: - LoadingViewModel
    
    let downloader = DispatchGroup()
    var state: LoadingState = .initial {
        willSet {
            view?.refresh(isEnabled: newValue == .loading)
        }
    }
    var errors: [ApiError] = []
    
    // MARK: - PromoModuleInput

    weak var view: NewsModuleInput?
    
    // MARK: - Initialization
    
    init(newsService: NewsService,
         newsStorage: NewsStorage,
         sourceStorage: SourceStorage) {
        self.newsService = newsService
        self.newsStorage = newsStorage
        self.sourceStorage = sourceStorage
    }
}

// MARK: - LoadingViewModel

extension NewsViewModelImpl {
    var dataSource: [VoidBlock] {
        [loadTopHeadlines, loadSource]
    }
    
    func handleResults() {
        state = .rich
        view?.configureTableView()
    }
    
    private func loadTopHeadlines() {
        newsService.obtainTopHeadlines { [weak self] topHeadlines, error in
            self?.handleErrorIfNeeded(error)
            self?.topHeadlines = topHeadlines
            if let articles = topHeadlines?.articles {
                self?.newsStorage.save(articles)
            }
            self?.downloader.leave()
        }
    }
    
    private func loadSource() {
        newsService.obtainSources(completionHandler: { [weak self] sources, error in
            self?.handleErrorIfNeeded(error)
            self?.sources = sources
            if let sources = sources?.sources {
                self?.sourceStorage.save(sources)
            }
            self?.downloader.leave()
        })
    }
}

// MARK: - NewsBuilderDataSource

extension NewsViewModelImpl: NewsBuilderDataSource {
    var newsSourceViewModels: [NewsCell.ViewModel] {
        let articles = topHeadlines?.articles ?? newsStorage.read()
        let sources = self.sources?.sources ?? sourceStorage.read()
        
        return articles.map { news in
            NewsCell.ViewModel(
                iconPath: news.urlToImage,
                title: news.title ?? "",
                description: news.description,
                sourceName: news.source?.name ?? "",
                sourceUrl: sources.first { $0.id == news.source?.id }?.url,
                iconIsReading: false
            )
        } 
    }
}

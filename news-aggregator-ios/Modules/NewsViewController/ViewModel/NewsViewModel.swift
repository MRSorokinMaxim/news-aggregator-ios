import Foundation

protocol NewsViewModel: NewsBuilderDataSource {
    func loadContent()
}

final class NewsViewModelImpl: NewsViewModel, LoadingViewModel {
    
    // MARK: - Properties
    
    private let newsService: NewsService
    private let newsStorage: NewsStorage
    private let sourceStorage: SourceStorage
    private let viewedNewsStorage: ViewedNewsStorage
    private let settingService: SettingService

    private var topHeadlines: TopHeadlinesResponse?
    private var sources: SourcesResponse?
    
    private var updateContentTimer: Timer?

    // MARK: - LoadingViewModel
    
    let downloader = DispatchGroup()
    var state: LoadingState = .initial
    var errors: [ApiError] = []
    
    // MARK: - PromoModuleInput

    weak var view: NewsModuleInput?
    
    // MARK: - NewsBuilderDataSource
    
    var newsSourceViewModels: [NewsCellViewModel] {
        let articles = topHeadlines?.articles ?? newsStorage.read()
        let sources = self.sources?.sources ?? sourceStorage.read()
        let viewedNews = viewedNewsStorage.read()
        
        return articles.map { article in
            NewsCellViewModel(
                iconPath: article.urlToImage,
                title: article.title,
                description: article.description,
                sourceName: article.source?.name,
                sourceUrl: sources.first { $0.id == article.source?.id }?.url,
                isOpen: viewedNews.first { $0.title == article.title }?.isOpen ?? false,
                onTap: { [weak self] in
                    self?.handleTapOnNews(with: article)
                }
            )
        }
    }
    
    var collapceNewsViewModels: [CollapseNewsViewModel] {
        let articles = topHeadlines?.articles ?? newsStorage.read()

        return articles.map { article in
            CollapseNewsViewModel(
                title: article.title,
                iconPath: article.urlToImage,
                onTap: { [weak self] in
                    self?.handleTapOnNews(with: article)
                }
            )
        }
    }
    
    // MARK: - Initialization
    
    init(newsService: NewsService,
         newsStorage: NewsStorage,
         sourceStorage: SourceStorage,
         viewedNewsStorage: ViewedNewsStorage,
         settingService: SettingService) {
        self.newsService = newsService
        self.newsStorage = newsStorage
        self.sourceStorage = sourceStorage
        self.viewedNewsStorage = viewedNewsStorage
        self.settingService = settingService
        
        settingService.addDelegate(self)
        
        createUpdateContentTimer(settingService.newsUpdatFrequency)
    }
    
    private func handleTapOnNews(with article: Article) {
        guard let path = article.url, let url = URL(string: path) else { return }
        updateViewedArticle(article: article)
        view?.onTapNews?(url)
    }
}

// MARK: - LoadingViewModel

extension NewsViewModelImpl {
    var dataSource: [VoidBlock] {
        [loadTopHeadlines, loadSource]
    }
    
    func handleResults() {
        state = .rich
        view?.configureTableViewIfPossible()
    }
    
    private func loadTopHeadlines() {
        newsService.obtainTopHeadlines { [weak self] topHeadlines, error in
            self?.handleErrorIfNeeded(error)
            self?.topHeadlines = topHeadlines
            if let articles = topHeadlines?.articles {
                self?.newsStorage.save(articles)
                self?.updateViewedArticles(articles: articles)
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

private extension NewsViewModelImpl {
    func updateViewedArticles(articles: [Article]) {
        let savedViewedArticles = viewedNewsStorage.read()
        
        let viewedArticles = articles.compactMap { article -> ViewedArticle? in
            let savedViewedArticle = savedViewedArticles.first { $0.title == article.title }
            if savedViewedArticle != nil {
                return savedViewedArticle
            }
            
            guard let title = article.title else { return nil }
            
            return ViewedArticle(title: title, isOpen: false)
        }
        
        viewedNewsStorage.save(viewedArticles)
    }
    
    func updateViewedArticle(article: Article) {
        let viewedArticles = viewedNewsStorage.read().filter { $0.title != article.title }
        
        guard let title = article.title else { return }
        
        viewedNewsStorage.save(viewedArticles + [ViewedArticle(title: title, isOpen: true)])
    }
}

// MARK: - SettingServiceDelegate

extension NewsViewModelImpl: SettingServiceDelegate {
    func updateNewsUpdatFrequency(_ value: String) {
        createUpdateContentTimer(value)
    }
    
    private func createUpdateContentTimer(_ value: String) {
        if let timeInterval = Double(value) {
            let timer = Timer(timeInterval: timeInterval,
                              target: self,
                              selector: #selector(updateTimer),
                              userInfo: nil,
                              repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
            
            self.updateContentTimer?.invalidate()
            self.updateContentTimer = timer
        }
    }
    
    @objc private func updateTimer() {
        loadContent()
    }
}

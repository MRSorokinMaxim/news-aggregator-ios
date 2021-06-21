typealias NewsModule = Presentable

extension ModuleFactory {
    func createNewsModule(appServiceLayer: AppServiceLayer) -> NewsModule {
        let viewModel = NewsViewModel(newsService: appServiceLayer.newsService)
        let viewController = NewsViewController(viewModel: viewModel)
        
        return viewController
    }
}

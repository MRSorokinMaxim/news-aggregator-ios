typealias NewsModule = Presentable

extension ModuleFactory {
    func createNewsModule(appServiceLayer: AppServiceLayer) -> NewsModule {
        let viewModel = NewsViewModelImpl(newsService: appServiceLayer.newsService,
                                          newsStorage: appServiceLayer.newsStorage,
                                          sourceStorage: appServiceLayer.sourceStorage)
        let viewController = NewsViewController(viewModel: viewModel)
        viewModel.view = viewController
        return viewController
    }
}

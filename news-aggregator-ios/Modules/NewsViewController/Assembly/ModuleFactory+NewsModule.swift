import Foundation

protocol NewsModule: Presentable {
    var onTapNews: ParameterClosure<URL>? { get set }
}

extension ModuleFactory {
    func createNewsModule(appServiceLayer: AppServiceLayer) -> NewsModule {
        let viewModel = NewsViewModelImpl(newsService: appServiceLayer.newsService,
                                          newsStorage: appServiceLayer.newsStorage,
                                          sourceStorage: appServiceLayer.sourceStorage,
                                          viewedNewsStorage: appServiceLayer.viewedNewsStorage,
                                          settingService: appServiceLayer.settingService)
        let viewController = NewsViewController(viewModel: viewModel)
        viewModel.view = viewController
        return viewController
    }
}

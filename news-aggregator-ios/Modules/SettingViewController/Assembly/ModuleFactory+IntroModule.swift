protocol SettingModule: Presentable {}

extension ModuleFactory {
    func createSettingModule(appServiceLayer: AppServiceLayer) -> SettingModule {
        let viewModel = SettingViewModel(settingService: appServiceLayer.settingService)
        let viewController = SettingViewController(viewModel: viewModel)
        
        return viewController
    }
}

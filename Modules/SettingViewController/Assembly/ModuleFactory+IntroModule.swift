protocol SettingModule: Presentable {
    var onFinish: VoidBlock? { get set }
}

extension ModuleFactory {
    func createSettingModule() -> SettingModule {
        let viewModel = SettingViewModel()
        let viewController = SettingViewController(viewModel: viewModel)
        
        return viewController
    }
}

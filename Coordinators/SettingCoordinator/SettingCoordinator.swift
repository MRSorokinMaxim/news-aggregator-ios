import Foundation

final class SettingCoordinator: BaseCoordinator {

    private let moduleFactory: ModuleFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: StackRoutable
    private let appServiceLayer: AppServiceLayer

    init(router: StackRoutable,
         moduleFactory: ModuleFactory,
         coordinatorFactory: CoordinatorFactory,
         appServiceLayer: AppServiceLayer) {
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
        self.appServiceLayer = appServiceLayer
    }

    override func start() {
        showNewsModule()
    }

    private func showNewsModule() {
        let module = moduleFactory.createSettingModule()
        router.push(module)
    }
}

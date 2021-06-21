import Foundation

final class TabBarCoordinator: BaseCoordinator {

    private let coordinatorFactory: CoordinatorFactory
    private let appServiceLayer: AppServiceLayer
    private weak var tabBarController: TabBarController?

    init(coordinatorFactory: CoordinatorFactory,
         tabBarController: TabBarController,
         appServiceLayer: AppServiceLayer) {

        self.coordinatorFactory = coordinatorFactory
        self.tabBarController = tabBarController
        self.appServiceLayer = appServiceLayer
    }

    override func start() {
        bindToTabBarModule()
    }

    private func bindToTabBarModule() {
        let modernControllers = TabBarItem.allCases
            .compactMap { makeTabBarItemCoordinator(for: $0).toPresent() }

        tabBarController?.setViewControllers(modernControllers, animated: false)
        tabBarController?.configureAppearance()
    }

    private func makeTabBarItemCoordinator(for item: TabBarItem) -> Presentable {
        let coordinator: Coordinatable
        let presentable: Presentable

        switch item {
        case .news:
            (coordinator, presentable) = coordinatorFactory.makeNewsCoordinator(appServiceLayer: appServiceLayer)

        case .setting:
            (coordinator, presentable) = coordinatorFactory.makeSettingCoordinator(appServiceLayer: appServiceLayer)
        }

        coordinator.onFinish = { [weak self] in
            self?.remove(child: $0)
        }

        add(child: coordinator)
        coordinator.start()

        return presentable
    }
}

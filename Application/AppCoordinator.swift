import Foundation

enum AppScenario: Scenario {
    case main
}

final class AppCoordinator: ScenarioCoordinator<AppScenario> {

    private let coordinatorFactory: CoordinatorFactory
    private let moduleFactory: ModuleFactory
    private let router: AppRouter
    private let appServiceLayer: AppServiceLayer

    private lazy var currentScenarios = scenarios()

    // MARK: - Initialization

    init(router: AppRouter,
         moduleFactory: ModuleFactory,
         coordinatorFactory: CoordinatorFactory,
         appServiceLayer: AppServiceLayer) {
        self.router = router
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        self.appServiceLayer = appServiceLayer
        super.init()
    }

    // MARK: - Start

    override func start() {
        start(with: .main)
    }

    override func start(with scenario: AppScenario) {
        switch scenario {
        case .main:
            runMainFlow()
        }
    }

    private func startNextScenarios(afterScenario: AppScenario) {
        let nextScenarios = currentScenarios.filter { $0 != afterScenario }

        guard let nextScenario = nextScenarios.first else {
            fatalError("Scenarios is over, your flow is bad")
        }

        currentScenarios = nextScenarios

        start(with: nextScenario)
    }

    // MARK: - Flows

    private func runMainFlow() {
        let group = coordinatorFactory.makeTabBarCoordinator(appServiceLayer: appServiceLayer)

        group.coordinator.onFinish = { [weak self] in
            self?.remove(child: $0)
        }

        add(child: group.coordinator)
        group.coordinator.start()
        router.setWindowRoot(module: group.presentable)
    }

    // MARK: - Helpers

    private func scenarios() -> [AppScenario] {
        let scenarios: [AppScenario] = [.main]

        return scenarios
    }
}

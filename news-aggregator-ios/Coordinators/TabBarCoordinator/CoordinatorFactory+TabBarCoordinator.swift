import Foundation

extension CoordinatorFactory {
    func makeTabBarCoordinator(
        appServiceLayer: AppServiceLayer
    ) -> CoordinatorGroup {
        let tabBarController = ModuleFactory.createTabBarModule()
        let coordinator = TabBarCoordinator(coordinatorFactory: self,
                                            tabBarController: tabBarController,
                                            appServiceLayer: appServiceLayer)

        return (coordinator, tabBarController)
    }
}

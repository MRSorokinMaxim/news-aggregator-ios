import UIKit

extension CoordinatorFactory {
    func makeSettingCoordinator(appServiceLayer: AppServiceLayer) -> CoordinatorGroup {
        let navigation = UINavigationController()
        let router = StackRouter(navigation)
        let coordinator = SettingCoordinator(router: router,
                                             moduleFactory: moduleFactory,
                                             coordinatorFactory: self,
                                             appServiceLayer: appServiceLayer)
        
        return (coordinator, navigation)
    }
}

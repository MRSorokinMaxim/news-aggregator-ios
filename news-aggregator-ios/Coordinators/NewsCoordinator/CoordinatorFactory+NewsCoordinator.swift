import UIKit

extension CoordinatorFactory {
    func makeNewsCoordinator(appServiceLayer: AppServiceLayer) -> CoordinatorGroup {
        let navigation = UINavigationController()
        let router = StackRouter(navigation)
        let coordinator = NewsCoordinator(router: router,
                                          moduleFactory: moduleFactory,
                                          coordinatorFactory: self,
                                          appServiceLayer: appServiceLayer)
        
        return (coordinator, navigation)
    }
}

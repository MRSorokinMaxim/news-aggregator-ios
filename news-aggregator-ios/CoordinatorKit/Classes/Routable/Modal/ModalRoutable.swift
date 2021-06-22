import UIKit

public protocol ModalRoutable: Presentable {

    typealias NavigationControllerFactory = (UIViewController) -> UINavigationController
    typealias ConfigurationClosure = (UIViewController) -> ()
    
    func present(_ module: Presentable?)
    func present(_ module: Presentable?, animated: Bool)
    func present(_ module: Presentable?, configurationClosure: ConfigurationClosure?)
    func present(_ module: Presentable?, animated: Bool, configurationClosure: ConfigurationClosure?)

    func dismissModule()
    func dismissModule(animated: Bool, completion: (() -> ())?)

    func presentChild(_ module: Presentable?, navigationControllerFactory: NavigationControllerFactory) -> StackRoutable?
    
    func presentChild(_ module: Presentable?,
                      navigationControllerFactory: NavigationControllerFactory,
                      animated: Bool) -> StackRoutable?

    func presentOnTop(_ module: Presentable?)
    func presentOnTop(_ module: Presentable?, animated: Bool)

    func dismissModuleFromTop()
    func dismissModuleFromTop(animated: Bool, completion: (() -> ())?)
}

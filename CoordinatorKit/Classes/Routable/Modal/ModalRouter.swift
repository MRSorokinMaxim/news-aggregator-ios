import UIKit

public final class ModalRouter: ModalRoutable {
    private var childRootControllers: [UIViewController] = []

    public private(set) weak var rootController: UIViewController?
    public private(set) weak var topController: UIViewController?

    public init(_ rootController: UIViewController) {
        self.rootController = rootController
        self.topController = rootController
    }

    // MARK: - ModalRouter

    public func present(_ module: Presentable?) {
        present(module, animated: true)
    }

    public func present(_ module: Presentable?, animated: Bool) {
        present(module, animated: animated, configurationClosure: nil)
    }
    
    public func present(_ module: Presentable?, configurationClosure: ConfigurationClosure?) {
        present(module, animated: true, configurationClosure: configurationClosure)
    }
    
    public func present(_ module: Presentable?, animated: Bool, configurationClosure: ConfigurationClosure?) {
        guard let controller = module?.toPresent() else {
            return
        }

        let presetation: (() -> ()) = { [weak self] in
            self?.presentOn(self?.rootController,
                            target: controller,
                            animated: animated,
                            configurationClosure: configurationClosure)
        }

        if rootController?.presentedViewController != nil {
            dismissModule(animated: animated, completion: presetation)
        } else {
            presetation()
        }
    }

    public func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }

    public func dismissModule(animated: Bool, completion: (() -> ())?) {
        rootController?.dismiss(animated: animated) { [weak self] in
            self?.topController = self?.rootController
            self?.childRootControllers = []
            completion?()
        }
    }

    public func presentChild(_ module: Presentable?,
                             navigationControllerFactory: ModalRoutable.NavigationControllerFactory) -> StackRoutable? {
        return presentChild(module, navigationControllerFactory: navigationControllerFactory, animated: true)
    }

    public func presentChild(_ module: Presentable?,
                             navigationControllerFactory: ModalRoutable.NavigationControllerFactory,
                             animated: Bool) -> StackRoutable? {
        guard let controller = module?.toPresent() else {
            return nil
        }

        let child = navigationControllerFactory(controller)
        child.modalPresentationStyle = controller.modalPresentationStyle
        childRootControllers.append(child)

        let router = StackRouter(child)
        present(router)

        return router
    }

    public func presentOnTop(_ module: Presentable?) {
        presentOnTop(module, animated: true)
    }

    public func presentOnTop(_ module: Presentable?, animated: Bool) {
        guard topController != nil, topController !== rootController else {
            present(module, animated: animated)
            return
        }

        guard let controller = module?.toPresent() else {
            return
        }

        presentOn(topController, target: controller, animated: animated)
    }

    public func dismissModuleFromTop() {
        dismissModule(animated: true, completion: nil)
    }

    public func dismissModuleFromTop(animated: Bool, completion: (() -> ())?) {
        guard topController != nil, topController !== rootController else {
            dismissModule(animated: animated, completion: completion)
            return
        }

        let presentingController = topController?.presentingViewController ?? rootController

        topController?.dismiss(animated: animated) { [weak self] in
            self?.topController = presentingController
            completion?()
        }
    }

    // MARK: - Presentable

    public func toPresent() -> UIViewController? {
        return rootController
    }

    // MARK: - Private methods

    private func presentOn(_ source: UIViewController?,
                           target: UIViewController,
                           animated: Bool,
                           configurationClosure: ConfigurationClosure? = nil) {

        if let configurationClosure = configurationClosure {
            configurationClosure(target)
        } else if target.modalPresentationStyle != .custom {
            target.modalPresentationStyle = .overFullScreen
        }

        target.modalPresentationCapturesStatusBarAppearance = true
        source?.present(target, animated: animated, completion: nil)

        if !(target is UIAlertController) {
            topController = target
        }
    }
}

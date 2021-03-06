import UIKit

open class StackRouter: StackRoutable {
    private var completions: [UIViewController: () -> ()]

    private lazy var modalRouter: ModalRoutable? = { [weak self] in
        guard let rootController = self?.rootController else {
            return nil
        }
        return ModalRouter(rootController)
    }()

    public private(set) weak var rootController: UINavigationController?

    public var headModule: Presentable?

    public var topModule: Presentable? {
        return rootController?.topViewController
    }

    public init(_ rootController: UINavigationController) {
        self.rootController = rootController
        self.headModule = rootController.topViewController
        self.completions = [:]
    }

    // MARK: - StackRoutable

    public func push(_ module: Presentable?) {
        push(module, animated: true)
    }

    public func push(_ module: Presentable?, animated: Bool) {
        push(module, animated: animated, configurationClosure: nil, completion: nil)
    }
    
    public func push(_ module: Presentable?,
                     animated: Bool,
                     configurationClosure: ConfigurationClosure?) {
        
        push(module, animated: animated, configurationClosure: configurationClosure, completion: nil)
    }
    
    

    public func push(_ module: Presentable?,
                     animated: Bool,
                     configurationClosure: ConfigurationClosure?,
                     completion: (() -> ())?) {
        
        guard let controller = extractController(from: module) else {
            return
        }
        
        configurationClosure?(controller)

        if let completion = completion {
            completions[controller] = completion
        }
        rootController?.pushViewController(controller, animated: animated)
    }

    public func popModule() {
        popModule(animated: true)
    }

    public func popModule(animated: Bool) {
        popModule(animated: animated, completion: nil)
    }

    public func popModule(animated: Bool, completion: (() -> ())?) {
        if let controller = rootController?.popViewController(animated: animated) {
            runCompletion(for: controller)
            completion?()
        }
    }

    public func popToHead() {
        popToHead(animated: true)
    }

    public func popToHead(animated: Bool) {
        if let controller = headModule?.toPresent(),
            let controllers = rootController?.popToViewController(controller, animated: animated) {
            runCompletionsChain(of: controllers)
        }
    }

    public func pop(to module: Presentable?) {
        pop(to: module, animated: true)
    }

    public func pop(to module: Presentable?, animated: Bool) {
        guard let controller = extractController(from: module) else {
            return
        }

        if let controllers = rootController?.popToViewController(controller, animated: animated) {
            runCompletionsChain(of: controllers)
        }
    }

    // MARK: - ModalRoutable

    public func present(_ module: Presentable?) {
        modalRouter?.present(module)
    }

    public func present(_ module: Presentable?, animated: Bool) {
        modalRouter?.present(module, animated: animated)
    }
    
    public func present(_ module: Presentable?, configurationClosure: ConfigurationClosure?) {
        modalRouter?.present(module, animated: true, configurationClosure: configurationClosure)
    }
    
    public func present(_ module: Presentable?, animated: Bool, configurationClosure: ConfigurationClosure?) {
        modalRouter?.present(module, animated: animated, configurationClosure: configurationClosure)
    }

    public func dismissModule() {
        modalRouter?.dismissModule()
    }

    public func dismissModule(animated: Bool, completion: (() -> ())?) {
        modalRouter?.dismissModule(animated: animated, completion: completion)
    }
    
    public func presentChild(_ module: Presentable?,
                             navigationControllerFactory: ModalRoutable.NavigationControllerFactory) -> StackRoutable? {
        return modalRouter?.presentChild(module, navigationControllerFactory: navigationControllerFactory)
    }
    
    public func presentChild(_ module: Presentable?,
                             navigationControllerFactory: ModalRoutable.NavigationControllerFactory,
                             animated: Bool) -> StackRoutable? {
        return modalRouter?.presentChild(module,
                                         navigationControllerFactory: navigationControllerFactory,
                                         animated: animated)
    }

    public func presentOnTop(_ module: Presentable?) {
        modalRouter?.presentOnTop(module)
    }

    public func presentOnTop(_ module: Presentable?, animated: Bool) {
        modalRouter?.presentOnTop(module, animated: animated)
    }

    public func dismissModuleFromTop() {
        modalRouter?.dismissModuleFromTop()
    }

    public func dismissModuleFromTop(animated: Bool, completion: (() -> ())?) {
        modalRouter?.dismissModuleFromTop(animated: animated, completion: completion)
    }

    // MARK: - Presentable

    public func toPresent() -> UIViewController? {
        return rootController
    }

    // MARK: - Helpers

    public func extractController(from module: Presentable?) -> UIViewController? {
        guard let controller = module?.toPresent() else {
            return nil
        }
        guard controller is UINavigationController == false else {
            return nil
        }
        return controller
    }

    public func runCompletion(for controller: UIViewController) {
        completions[controller]?()
        completions.removeValue(forKey: controller)
    }

    public func runCompletionsChain(of controllers: [UIViewController]) {
        controllers.forEach { [weak self] controller in
            self?.runCompletion(for: controller)
        }
    }
}

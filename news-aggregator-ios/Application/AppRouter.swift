import UIKit

protocol AppRoutable {

    var window: UIWindow { get }

    func setWindowRoot(module: Presentable, animated: Bool)
}

final class AppRouter: AppRoutable {
    private var modalRouter: ModalRoutable?

    let window: UIWindow

    var rootController: UIViewController? {
        window.rootViewController
    }

    init(window: UIWindow) {
        self.window = window
    }

    func presentModule(_ module: Presentable, animated: Bool) {
        modalRouter?.present(module, animated: animated)
    }

    func dismissModule(animated: Bool, completion: VoidBlock?) {
        modalRouter?.dismissModule(animated: animated, completion: completion)
    }

    func setWindowRoot(module: Presentable, animated: Bool = true) {
        guard let controller = module.toPresent() else {
            return
        }

        setRootModule(controller, animation: animated ? .scaledFade : .none)

        updateModalRouter()
    }

    private func updateModalRouter() {
        guard let rootController = rootController else {
            return
        }

        modalRouter = ModalRouter(rootController)
    }

    private func setRootModule(_ module: Presentable, animation: AppRouterAnimation) {
        guard let toController = module.toPresent() else { return }

        let fromController = rootController
        let fromSnapshot = fromController?.view.snapshotView(afterScreenUpdates: true)
        window.rootViewController = toController

        guard animation.animated, let snapshot = fromSnapshot else { return }

        toController.view.addSubview(snapshot)
        var animationBlock: VoidBlock
        switch animation {
        case .scaledFade:
            animationBlock = {
                snapshot.alpha = 0.0
                snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }
        case .none:
            fatalError("Can't be used in animation block")
        }
        UIView.animate(withDuration: Constants.animationDuration,
                       animations: animationBlock,
                       completion: { _ in snapshot.removeFromSuperview() }
        )
    }

    public var topModule: Presentable? {
        rootController
    }
}

public enum AppRouterAnimation {

    case none
    case scaledFade

    var animated: Bool {
        return self != .none
    }
}

private extension AppRouter {
    enum Constants {
        static var animationDuration: TimeInterval = 0.3
    }
}

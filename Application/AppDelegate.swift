import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private(set) lazy var appWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        return window
    }()

    static var shared: AppDelegate {
        let delegate = UIApplication.shared.delegate

        guard let appDelegate = delegate as? AppDelegate else {
            fatalError("Can't cast \(type(of: delegate)) to AppDelegate")
        }

        return appDelegate
    }

    private lazy var applicationCoordinator: BaseCoordinator = {
        AppCoordinator(router: AppRouter(window: appWindow),
                       moduleFactory: ModuleFactory(),
                       coordinatorFactory: CoordinatorFactory(),
                       appServiceLayer: AppServiceLayer())
    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        applicationCoordinator.start()
        appWindow.makeKeyAndVisible()

        return true
    }
}


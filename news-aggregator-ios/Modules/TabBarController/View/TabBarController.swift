import UIKit

final class TabBarController: UITabBarController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        [.portrait]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureAppearance()
    }

    func configureAppearance() {
        tabBar.barTintColor = .white
        tabBar.unselectedItemTintColor = .black
        tabBar.tintColor = .blue

        if let viewControllers = viewControllers {
            zip(viewControllers, TabBarItem.allCases).forEach { controller, item in
                controller.tabBarItem = item.asTabBarItem()
            }
        }
    }
}

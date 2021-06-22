import UIKit

public protocol Presentable: AnyObject {
    func toPresent() -> UIViewController?
}

// MARK: - Default implementation for UIViewController

extension UIViewController: Presentable {
    open func toPresent() -> UIViewController? {
        return self
    }
}

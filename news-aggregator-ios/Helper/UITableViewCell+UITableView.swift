import UIKit

extension UITableViewCell {
    var tableView: UITableView? {
        parentView(of: UITableView.self)
    }
}

private extension UIView {
    func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view = superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
}


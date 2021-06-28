import UIKit

enum ViewAssociatedKeys {
    static var isScrollingFastKey = "is_scrolling_fast_key"
}


extension UITableView {
    var isScrollingFast: Bool {
        get {
            ao_get(key: &ViewAssociatedKeys.isScrollingFastKey, defaultValue: false)
        }
        set {
            ao_set(value: newValue, key: &ViewAssociatedKeys.isScrollingFastKey)
        }
    }
}

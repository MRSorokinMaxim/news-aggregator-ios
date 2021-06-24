import UIKit

final class NewsView: TableRootView {
    var refreshControl: UIRefreshControl? {
        tableView.refreshControl
    }
}

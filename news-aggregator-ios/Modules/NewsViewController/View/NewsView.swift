import UIKit

final class NewsView: TableRootView {
    var refreshControl: UIRefreshControl? {
        tableView.refreshControl
    }
    
    required init(style: UITableView.Style = .grouped) {
        super.init(style: style)
        
        tableView.refreshControl = RefreshControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

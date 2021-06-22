import UIKit
import SnapKit

class TableRootView: UIView {
    
    // MARK: - Properties
    
    let tableView: UITableView
    
    // MARK: - Initialization
    
    required init(style: UITableView.Style = .grouped) {
        tableView = UITableView(frame: .zero, style: style)
        super.init(frame: .zero)
        
        setupTableView()
        setupInitialLayout()
        tableView.tableHeaderView = UIView(
            frame: .init(x: 0, y: 0, width: frame.width, height: .leastNormalMagnitude)
        )
        tableView.sectionFooterHeight = .leastNormalMagnitude
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View implementation
    
    func setupTableView() {
        backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }
    
    func setupInitialLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

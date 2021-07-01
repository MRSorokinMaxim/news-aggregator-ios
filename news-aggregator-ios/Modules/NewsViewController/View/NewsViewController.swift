import UIKit
import TableKit

protocol NewsModuleInput: NewsModule {
    func configureTableView()
}

final class NewsViewController: UIViewController, NewsModuleInput {
    private enum LeftBarButtonType {
        case collapse
        case expand
    }
    
    var onTapNews: ParameterClosure<URL>?
    
    private let viewModel: NewsViewModel
    private lazy var tableDirector = TableDirector(tableView: rootView.tableView)
    private let newsBuilder: NewsBuilder = NewsBuilderImpl()
    
    private var leftBarButtonType: LeftBarButtonType = .expand
    
    private var lastOffset: CGPoint = .zero
    private var lastOffsetCapture: TimeInterval = .zero
    private var isScrollingFast = false
    private var isImmediatelyUpdatTableView = false
    
    private var rootView: NewsView {
        guard let view = self.view as? NewsView else {
            fatalError("View is not type of NewsView")
        }
        
        return view
    }
    
    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = NewsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "common_global_news".localized
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "collapse_icon"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(barButtonHandle)
        )
        
        refreshData()
    }
    
    func configureTableView() {
        let section: TableSection
        switch leftBarButtonType {
        case .collapse:
            section = newsBuilder.makeCollapceNewsSection(from: viewModel)
        case .expand:
            section = newsBuilder.makeNewsSection(from: viewModel)
        }
        
        tableDirector.clear()
            .append(section: section)
            .reload()
    }
    
    private func refreshData() {
        viewModel.loadContent()
    }
    
    @objc private func barButtonHandle() {
        toogleBarButton()
        configureTableView()
    }
    
    private func toogleBarButton() {
        switch leftBarButtonType {
        case .collapse:
            navigationItem.leftBarButtonItem?.image = UIImage(named: "collapse_icon")
            leftBarButtonType = .expand
        case .expand:
            navigationItem.leftBarButtonItem?.image = UIImage(named: "expand_icon")
            leftBarButtonType = .collapse
        }
    }
}

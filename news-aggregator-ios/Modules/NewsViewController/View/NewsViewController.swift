import UIKit
import TableKit

protocol NewsModuleInput: NewsModule {
    func configureTableViewIfPossible()
}

final class NewsViewController: UIViewController, NewsModuleInput, UIScrollViewDelegate {
    private enum LeftBarButtonType {
        case collapse
        case expand
    }
    
    var onTapNews: ParameterClosure<URL>?
    
    private let viewModel: NewsViewModel
    private lazy var tableDirector = TableDirector(tableView: rootView.tableView, scrollDelegate: self)
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
    
    func configureTableViewIfPossible() {
        if !isScrollingFast {
            configureTableView()
        } else {
            isImmediatelyUpdatTableView = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset
        let currentTime = Date.timeIntervalSinceReferenceDate
        let timeDiff = currentTime - lastOffsetCapture
        let captureInterval = 0.1
        
        if timeDiff > captureInterval {
            
            let distance = currentOffset.y - lastOffset.y     // calc distance
            let scrollSpeedNotAbs = (distance * 10) / 1000     // pixels per ms*10
            let scrollSpeed = fabsf(Float(scrollSpeedNotAbs))  // absolute value
            
            if scrollSpeed > 0.5 {
                isScrollingFast = true
            } else {
                isScrollingFast = false
                
                if isImmediatelyUpdatTableView {
                    configureTableView()
                }
            }
            
            lastOffset = currentOffset
            lastOffsetCapture = currentTime
        }
    }
    
    private func refreshData() {
        viewModel.loadContent()
    }
    
    private func configureTableView() {
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

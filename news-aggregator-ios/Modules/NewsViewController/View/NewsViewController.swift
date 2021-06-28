import UIKit
import TableKit

protocol NewsModuleInput: NewsModule {
    func configureTableView()
    func refresh(isEnabled: Bool)
}

final class NewsViewController: UIViewController, NewsModuleInput, UIScrollViewDelegate {
    
    var onTapNews: ParameterClosure<URL>?
    
    private let viewModel: NewsViewModel
    private lazy var tableDirector = TableDirector(tableView: rootView.tableView, scrollDelegate: self)
    private let newsBuilder = NewsBuilder()
    
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
        
        configureTableView()
        bindView()
        refreshData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        rootView.refreshControl?.endRefreshing()
    }
    
    func configureTableView() {
        if !isScrollingFast {
            tableDirector.clear()
                .append(sections: newsBuilder.buildSections(from: viewModel))
                .reload()
        }
    }
    
    func refresh(isEnabled: Bool) {
        if isEnabled {
            rootView.refreshControl?.beginRefreshing()
        } else {
            rootView.refreshControl?.endRefreshing()
        }
    }
    
    var lastOffset: CGPoint = .zero
    var lastOffsetCapture: TimeInterval = .zero
    var isScrollingFast: Bool = false
    
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
                tableDirector.tableView?.isScrollingFast = true
                isScrollingFast = true
                print("Fast")
            } else {
                tableDirector.tableView?.isScrollingFast = false
                isScrollingFast = false
                print("Slow")
            }
            
            lastOffset = currentOffset
            lastOffsetCapture = currentTime
            
        }
    }
    
    @objc private func refreshData() {
        viewModel.loadContent()
    }
    
    private func bindView() {
        rootView.refreshControl?.addTarget(self,
                                           action: #selector(refreshData),
                                           for: .valueChanged)
    }
}

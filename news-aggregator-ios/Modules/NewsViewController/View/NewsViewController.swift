import UIKit
import TableKit

protocol NewsModuleInput: AnyObject {
    func configureTableView()
}

final class NewsViewController: UIViewController, NewsModuleInput {
    
    private let viewModel: NewsViewModel
    private lazy var tableDirector = TableDirector(tableView: rootView.tableView)
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
        
        viewModel.loadContent()
    }
    
    func configureTableView() {
        tableDirector.clear()
            .append(sections: newsBuilder.buildSections(from: viewModel))
            .reload()
    }
}

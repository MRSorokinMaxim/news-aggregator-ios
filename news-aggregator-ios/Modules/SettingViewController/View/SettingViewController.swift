import TableKit

final class SettingViewController: UIViewController, SettingModule {

    private let viewModel: SettingViewModel
    private lazy var tableDirector = TableDirector(tableView: rootView.tableView)
    private let settingBuilder = SettingBuilder()
    
    private var rootView: SettingView {
        guard let view = self.view as? SettingView else {
            fatalError("View is not type of NewsView")
        }
        
        return view
    }

    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SettingView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "common_global_setting".localized
        
        configureTableView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle))
        tableDirector.tableView?.addGestureRecognizer(tap)
    }
    
    private func configureTableView() {
        tableDirector.clear()
            .append(sections: settingBuilder.buildSections(from: viewModel))
            .reload()
    }
    
    @objc private func tapHandle() {
        view.endEditing(true)
    }
}

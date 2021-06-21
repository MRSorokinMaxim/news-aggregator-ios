import UIKit

final class SettingViewController: UIViewController, SettingModule {
    var onFinish: VoidBlock?
    
    private let viewModel: SettingViewModel

    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "common_global_setting".localized
    }
}

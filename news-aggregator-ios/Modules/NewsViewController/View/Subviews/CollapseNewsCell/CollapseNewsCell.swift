import TableKit

typealias CollapseNewsTableRow = TableRow<CollapseNewsCell>

struct CollapseNewsViewModel {
    let title: String?
    let iconPath: String?
    let onTap: VoidBlock?
}

final class CollapseNewsCell: UITableViewCell {
    private var onTap: VoidBlock?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear
        
        textLabel?.numberOfLines = 0

        imageView?.contentMode = .scaleAspectFill
        imageView?.layer.masksToBounds = true

        bindViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let imageView = imageView,
              let textLabel = textLabel else {
            return
        }
        
        imageView.frame = CGRect(x: 16, y: 0, width: .imageWidth, height: 44)
        imageView.center.y = textLabel.center.y
        
        textLabel.frame.origin = CGPoint(x: imageView.frame.minX + imageView.frame.width + 16,
                                         y: 0)
        textLabel.frame.size = CGSize(width: frame.width - 16 - textLabel.frame.origin.x,
                                      height: textLabel.frame.size.height)
    }
    
    private func bindViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle))
        addGestureRecognizer(tap)
    }
    
    @objc private func tapHandle() {
        onTap?()
    }
}

extension CollapseNewsCell: ConfigurableCell {
    func configure(with viewModel: CollapseNewsViewModel) {
        textLabel?.text = viewModel.title
        onTap = viewModel.onTap
        
        if let iconPath = viewModel.iconPath {
            let imageWidth = imageView?.frame.width ?? .imageWidth
            imageView?.load(
                path: iconPath,
                width: imageWidth,
                placeholderImage: UIImage(named: "stub_icon")
            )
        }
    }
}

private extension CGFloat {
    static let imageWidth: CGFloat = 60
}

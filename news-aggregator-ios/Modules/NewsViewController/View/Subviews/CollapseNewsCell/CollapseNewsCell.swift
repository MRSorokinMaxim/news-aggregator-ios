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

        imageView?.backgroundColor = .systemGray
        imageView?.contentMode = .scaleAspectFill
        imageView?.layer.masksToBounds = true
        imageView?.image = UIImage(named: "expand_icon")

        resizeImageView()
        bindViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func resizeImageView() {
        let itemSize = CGSize(width: .imageWidth, height: 44)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
        let imageRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
        imageView?.image?.draw(in: imageRect)
        imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
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
            imageView?.load(path: iconPath, width: imageWidth)
        }
    }
}

private extension CGFloat {
    static let imageWidth: CGFloat = 60
}

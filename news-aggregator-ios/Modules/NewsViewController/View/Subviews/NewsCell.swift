import TableKit

typealias NewsTableRow = TableRow<NewsCell>

final class NewsCell: UITableViewCell {
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private let sourceTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .blue
        textView.isEditable = false
        return textView
    }()
    
    private let viewedNewsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.text = "common_viewed".localized
        label.isHidden = true
        label.textAlignment = .right
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        return view
    }()

    private var contentInsets: UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    }
    
    private var onTap: VoidBlock?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear

        setupInitialLayout()
        bindViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        let containerView = UIView()
        contentView.addSubview(containerView)
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 8

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(contentInsets)
        }

        containerView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }

        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }

        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
        
        containerView.addSubview(sourceTextView)
        sourceTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.height.equalTo(30)
            make.leading.equalToSuperview()
        }
        
        containerView.addSubview(viewedNewsLabel)
        viewedNewsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sourceTextView)
            make.height.equalTo(30)
            make.trailing.equalToSuperview()
            make.leading.equalTo(sourceTextView.snp.trailing).offset(8)
        }
        
        containerView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(sourceTextView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    private func bindViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle))
        addGestureRecognizer(tap)
    }
    
    @objc private func tapHandle() {
        viewedNewsLabel.isHidden = false
        onTap?()
    }
}

// MARK: - Configurable

extension NewsCell: ConfigurableCell {

    func configure(with viewModel: NewsCellViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        sourceTextView.attributedText = viewModel.sourceText
        onTap = viewModel.onTouchNews
        viewedNewsLabel.isHidden = !viewModel.isOpen
        
        if let iconPath = viewModel.iconPath {
            iconImageView.load(path: iconPath,
                               width: contentView.frame.width - contentInsets.left - contentInsets.right)
        }
    }
}

import TableKit
import AlamofireImage

typealias NewsTableRow = TableRow<NewsCell>

final class NewsCell: UITableViewCell {
    private let iconImageView = UIImageView()
    
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
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    private var contentInsets: UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear

        setupInitialLayout()
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
            make.leading.trailing.equalToSuperview()
        }
        
        containerView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(sourceTextView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Configurable

extension NewsCell: ConfigurableCell {
    struct ViewModel {
        let iconPath: String?
        let title: String
        let description: String?
        let sourceName: String
        let sourceUrl: String?
        let iconIsReading: Bool
        
        var iconUrl: URL? {
            guard let iconPath = iconPath else {
                return nil
            }
            
            return URL(string: iconPath)
        }
        
        var sourceText: NSAttributedString {
            let attributedString = NSMutableAttributedString(string: "common_source".localized + ": " + sourceName)
            if let sourceUrl = sourceUrl {
                attributedString.addAttribute(
                    .link,
                    value: sourceUrl,
                    range: (attributedString.string as NSString).range(of: sourceName)
                )
            }
            
            return attributedString
        }
    }

    func configure(with viewModel: NewsCell.ViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        sourceTextView.attributedText = viewModel.sourceText
        
        iconImageView.image = nil
        if let iconUrl = viewModel.iconUrl {
            iconImageView.af.setImage(withURL: iconUrl,
                                      cacheKey: iconUrl.absoluteString)
        }
    }
}

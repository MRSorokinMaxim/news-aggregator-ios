import TableKit

typealias SettingTableRow = TableRow<SettingCell>

final class SettingCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.text = "common_setting_content_update_frequency".localized
        return label
    }()
    
    private lazy var valueField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 16)
        textField.textColor = .gray
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.borderStyle = .line
        textField.layer.cornerRadius = 4
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        return textField
    }()
    
    private var onEnterValue: ParameterClosure<String>?

    private var contentInsets: UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    }

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
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().offset(8)
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }

        contentView.addSubview(valueField)
        valueField.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(titleLabel.snp.trailing).offset(40)
            make.width.greaterThanOrEqualTo(40)
        }
    }
    
    private func bindViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle))
        addGestureRecognizer(tap)
    }
    
    @objc private func tapHandle() {
        valueField.becomeFirstResponder()
    }
}

extension SettingCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }

        onEnterValue?(text)
    }
}

// MARK: - Configurable

extension SettingCell: ConfigurableCell {

    func configure(with viewModel: SettingCellViewModel) {
        valueField.text = viewModel.initialValue
        onEnterValue = viewModel.onEnterValue
    }
}


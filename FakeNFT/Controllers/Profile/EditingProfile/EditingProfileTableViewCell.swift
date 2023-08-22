import UIKit
import SnapKit

final class EditingProfileTableViewCell: UITableViewCell {
    lazy var editingTextField: UITextField = {
        let element = UITextField()
        element.layer.cornerRadius = 12
        element.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        element.textAlignment = Locale.current.languageCode == "he" ? .right : .left
        element.leftViewMode = .always
        element.returnKeyType = .done
        element.clearButtonMode = .whileEditing
        element.textColor = .blackDay
        element.backgroundColor = .lightGreyDay
        element.font = .bodyRegular
        return element
    }()
    
    lazy var editingTextView: UITextView = {
        let element = UITextView()
        element.layer.cornerRadius = 12
        element.returnKeyType = .done
        element.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        element.textAlignment = Locale.current.languageCode == "he" ? .right : .left
        element.textColor = .blackDay
        element.backgroundColor = .lightGreyDay
        element.font = .bodyRegular
        element.isScrollEnabled = false
        return element
    }()
    
    var didTextChange: ((String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .backgroundDay
        editingTextView.delegate = self
        editingTextField.delegate = self
        setupTargets()
    }
    
    func setupTargets() {
        editingTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange() {
        guard let newText = editingTextField.text else { return }
        didTextChange?(newText)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(text: String, placeholder: String) {
        contentView.addSubview(editingTextField)
        editingTextField.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        editingTextField.placeholder = placeholder
        editingTextField.text = text
    }
    
    func configureMiddleCell(text: String, placeholder: String) {
        contentView.addSubview(editingTextView)
        editingTextView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        editingTextView.text = text
        editingTextView.setPlaceholder(placeholder)
    }
}

extension EditingProfileTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension EditingProfileTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let newText = textView.text else { return }
        didTextChange?(newText)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

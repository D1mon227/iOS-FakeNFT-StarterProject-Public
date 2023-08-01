import UIKit
import SnapKit

final class EditingProfileTableViewCell: UITableViewCell {
    lazy var editingTextField: UITextField = {
        let element = UITextField()
        element.layer.cornerRadius = 12
        element.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
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
        element.textColor = .blackDay
        element.backgroundColor = .lightGreyDay
        element.font = .bodyRegular
        return element
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .backgroundDay
    }
    
    func configureCell(text: String) {
        addSubview(editingTextField)
        editingTextField.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        editingTextField.text = text
    }
    
    func configureMiddleCell(text: String) {
        addSubview(editingTextView)
        editingTextView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        editingTextView.text = text
    }
}

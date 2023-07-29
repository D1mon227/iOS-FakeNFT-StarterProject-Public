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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    func configureCell(text: String) {
        editingTextField.text = text
    }
    
    private func setupViews() {
        addSubview(editingTextField)
        setupConstraints()
    }
    
    private func setupConstraints() {
        editingTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
    }
}

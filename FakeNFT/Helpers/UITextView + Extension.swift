import UIKit

extension UITextView {
    func setPlaceholder(_ placeholder: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = .bodyRegular
        placeholderLabel.textColor = .textViewPlaceholder
        placeholderLabel.sizeToFit()
        placeholderLabel.isHidden = !text.isEmpty
        
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(8)
        }
        
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            placeholderLabel.isHidden = !(self.text.isEmpty)
        }
    }
}

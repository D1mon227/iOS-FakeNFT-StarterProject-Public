import UIKit
import SnapKit

extension UITextView {
    func setPlaceholder(_ placeholder: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = .bodyRegular
        placeholderLabel.textColor = .textViewPlaceholder
        placeholderLabel.sizeToFit()
        placeholderLabel.isHidden = !text.isEmpty
        
        addSubview(placeholderLabel)
        if let keyWindow = UIApplication.shared.windows.first {
            let windowWidth = keyWindow.frame.width
            let offset: CGFloat = Locale.current.languageCode == "he" ? windowWidth - 100 : 5
            placeholderLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(offset)
                make.trailing.equalToSuperview().offset(-offset)
                make.top.equalToSuperview().offset(8)
            }
        }
        
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            placeholderLabel.isHidden = !(self.text.isEmpty)
        }
    }
}

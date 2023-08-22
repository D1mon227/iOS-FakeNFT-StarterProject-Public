import UIKit
import SnapKit

final class EditingProfileTableViewHeader: UITableViewHeaderFooterView {
    
    private lazy var headerLabel: UILabel = {
        let element = UILabel()
        element.font = .headline3
        element.textColor = .blackDay
        return element
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    func configureHeader(text: String) {
        headerLabel.text = text
    }
    
    private func setupViews() {
        addSubview(headerLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}

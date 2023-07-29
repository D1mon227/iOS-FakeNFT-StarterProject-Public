import UIKit
import SnapKit

final class ProfileTableViewCell: UITableViewCell {
    
    private lazy var myNFTLabel: UILabel = {
        let element = UILabel()
        element.font = .bodyBold
        element.textColor = .blackDay
        return element
    }()
    
    private lazy var switchImage: UIImageView = {
        let element = UIImageView()
        element.image = Resourses.Images.Button.forwardButton
        element.tintColor = .blackDay
        return element
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .backgroundDay
        setupViews()
    }
    
    func configureCell(label: String) {
        myNFTLabel.text = label
    }
    
    private func setupViews() {
        addSubview(myNFTLabel)
        addSubview(switchImage)
        setupConstraints()
    }
    
    private func setupConstraints() {
        myNFTLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        switchImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
}

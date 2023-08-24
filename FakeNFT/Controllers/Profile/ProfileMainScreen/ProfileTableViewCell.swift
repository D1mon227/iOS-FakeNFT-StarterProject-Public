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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(label: String) {
        myNFTLabel.text = label
    }
    
    private func setupViews() {
        backgroundColor = .backgroundDay
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

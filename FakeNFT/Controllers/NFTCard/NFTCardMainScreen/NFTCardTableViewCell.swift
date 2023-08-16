import UIKit
import SnapKit

final class NFTCardTableViewCell: UITableViewCell {
    private lazy var nftImage: UIImageView = {
        let element = UIImageView()
        element.backgroundColor = .black
        element.layer.cornerRadius = 6
        return element
    }()
    
    private lazy var currencyDescriptionStack: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 2
        element.alignment = .leading
        element.distribution = .fillEqually
        return element
    }()
    
    private lazy var currencyNameLabel: UILabel = {
        let element = UILabel()
        element.font = .caption2
        element.textColor = .blackDay
        return element
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let element = UILabel()
        element.font = .caption1
        element.textColor = .blackDay
        element.text = "$18.11"
        return element
    }()
    
    private lazy var nftPriceInCrypto: UILabel = {
        let element = UILabel()
        element.font = .caption2
        element.textColor = .greenUniversal
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
        backgroundColor = .lightGreyDay
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(currencyImage: URL?,
                       currencyName: String?,
                       shortCurrencyName: String?,
                       priceInCrypto: String?) {
        guard let currencyName = currencyName,
        let shortCurrencyName = shortCurrencyName,
        let priceInCrypto = priceInCrypto else { return }
        self.nftImage.setImage(with: currencyImage)
        currencyNameLabel.text = "\(currencyName) (\(shortCurrencyName))"
        nftPriceInCrypto.text = "0,1 " + "(\(priceInCrypto))"
    }
    
    private func setupViews() {
        contentView.addSubview(nftImage)
        contentView.addSubview(currencyDescriptionStack)
        currencyDescriptionStack.addArrangedSubview(currencyNameLabel)
        currencyDescriptionStack.addArrangedSubview(nftPriceLabel)
        contentView.addSubview(nftPriceInCrypto)
        contentView.addSubview(switchImage)
        setupConstraints()
    }
    
    private func setupConstraints() {
        nftImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview().inset(20)
            make.width.height.equalTo(32)
        }
        
        currencyDescriptionStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview().inset(16)
            make.leading.equalTo(nftImage.snp.trailing).offset(10)
        }
        
        switchImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        nftPriceInCrypto.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(switchImage.snp.leading).offset(-16)
        }
    }
}

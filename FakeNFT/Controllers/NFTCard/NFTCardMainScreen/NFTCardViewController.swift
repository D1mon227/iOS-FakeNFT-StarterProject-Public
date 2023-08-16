import UIKit
import SnapKit

final class NFTCardViewController: UIViewController, NFTCardViewControllerProtocol {
    var presenter: NFTCardViewPresenterProtocol?
    private let nftCardView = NFTCardView()
    private var starImageViews: [UIImageView] = []
    private var coverPageControlImageViews: [UIImageView] = []
    private var currentPageIndex: Int = 0
    
    init(nftModel: NFT?, isLiked: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = NFTCardViewPresenter()
        self.presenter?.view = self
        self.presenter?.isLiked = isLiked
        self.presenter?.nftModel = nftModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundDay
        setupViews()
        setupPageControl()
        setupTableView()
        setupCollectionView()
        nftCardView.coverNFTScrollView.delegate = self
        presenter?.fetchCurrencies()
        
    }
    
    func updateNFTDetails(nftModel: NFT?) {
        nftCardView.firstNFTCover.setImage(with: nftModel?.images?[0])
        nftCardView.secondNFTCover.setImage(with: nftModel?.images?[1])
        nftCardView.thirdNFTCover.setImage(with: nftModel?.images?[2])
        nftCardView.nftLabel.text = nftModel?.name
        nftCardView.price.text = "\(nftModel?.price ?? 0.0) ETH"
        updateRatingStars(rating: nftModel?.rating)
    }
    
    func updateLikeButton(isLiked: Bool) {
        isLiked ? setupNavigationBar(tintColor: .redUniversal) : setupNavigationBar(tintColor: .white)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.nftCardView.currencyTableView.reloadData()
        }
    }
    
    private func updateRatingStars(rating: Int?) {
        guard let rating = rating else { return }
        
        for i in 0..<5 {
            starImageViews[i].tintColor = i < rating ? .yellowUniversal : .lightGreyDay
        }
    }
    
    private func setupTableView() {
        nftCardView.currencyTableView.dataSource = self
        nftCardView.currencyTableView.delegate = self
        nftCardView.currencyTableView.register(NFTCardTableViewCell.self, forCellReuseIdentifier: "NFTCardTableViewCell")
    }
    
    private func setupCollectionView() {
        nftCardView.nftCollectionView.dataSource = self
        nftCardView.nftCollectionView.delegate = self
        nftCardView.nftCollectionView.register(NFTCardCollectionViewCell.self, forCellWithReuseIdentifier: "NFTCardCollectionViewCell")
    }
    
    private func setupPageControl() {
        for (index, imageView) in coverPageControlImageViews.enumerated() {
            imageView.backgroundColor = index == currentPageIndex ? .blackDay : .lightGreyDay
        }
    }
}

//MARK: UITableViewDataSource
extension NFTCardViewController: UITableViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.currencies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NFTCardTableViewCell", for: indexPath) as? NFTCardTableViewCell,
              let currency = presenter?.currencies?[indexPath.row] else { return UITableViewCell() }
        
        cell.configureCell(currencyImage: currency.image,
                           currencyName: currency.title,
                           shortCurrencyName: currency.name,
                           priceInCrypto: currency.name)
        return cell
    }
}

//MARK: UITableViewDelegate
extension NFTCardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
}

extension NFTCardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NFTCardCollectionViewCell", for: indexPath) as? NFTCardCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(nftImage: Resourses.Images.NFT.nftCard1,
                           nftName: "Luna",
                           nftPrice: "23")
        return cell
    }
}

extension NFTCardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 108, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension NFTCardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / view.frame.width)
        currentPageIndex = Int(page)
        setupPageControl()
    }
}

//MARK: SetupViews
extension NFTCardViewController {
    private func setupNavigationBar(tintColor: UIColor) {
        let rightButton = UIButton(type: .system)
        rightButton.setImage(Resourses.Images.Cell.like, for: .normal)
        rightButton.tintColor = tintColor
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupViews() {
        view.addSubview(nftCardView.generalScrollView)
        nftCardView.generalScrollView.addSubview(nftCardView.coverNFTScrollView)
        nftCardView.coverNFTScrollView.addSubview(nftCardView.firstNFTCover)
        nftCardView.coverNFTScrollView.addSubview(nftCardView.secondNFTCover)
        nftCardView.coverNFTScrollView.addSubview(nftCardView.thirdNFTCover)
        nftCardView.generalScrollView.addSubview(nftCardView.pageControlView)
        nftCardView.pageControlView.addSubview(nftCardView.coverPageControlStack)
        setupCoverPageControlStack()
        nftCardView.generalScrollView.addSubview(nftCardView.nftLabel)
        nftCardView.generalScrollView.addSubview(nftCardView.nftRatingStack)
        setupRatingStack()
        nftCardView.generalScrollView.addSubview(nftCardView.nftCollectionLabel)
        nftCardView.generalScrollView.addSubview(nftCardView.priceLabel)
        nftCardView.generalScrollView.addSubview(nftCardView.price)
        nftCardView.generalScrollView.addSubview(nftCardView.addToCartButton)
        nftCardView.generalScrollView.addSubview(nftCardView.currencyTableView)
        nftCardView.generalScrollView.addSubview(nftCardView.sellerWebsiteButton)
        nftCardView.generalScrollView.addSubview(nftCardView.nftCollectionView)
        nftCardView.coverNFTScrollView.contentSize = CGSize(width: view.frame.width * 3, height: 375)
        setupConstraints()
    }
    
    private func setupCoverPageControlStack() {
        for _ in 0..<3 {
            let imageView = UIImageView()
            imageView.backgroundColor = .lightGreyDay
            imageView.layer.cornerRadius = 2
            imageView.snp.makeConstraints { make in
                make.height.equalTo(4)
                make.width.greaterThanOrEqualTo(109)
            }
            nftCardView.coverPageControlStack.addArrangedSubview(imageView)
            coverPageControlImageViews.append(imageView)
        }
    }
    
    private func setupRatingStack() {
        for _ in 0..<5 {
            let imageView = UIImageView(image: Resourses.Images.Cell.star)
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(12)
            }
            
            imageView.tintColor = .lightGreyDay
            nftCardView.nftRatingStack.addArrangedSubview(imageView)
            starImageViews.append(imageView)
        }
    }
    
    private func setupConstraints() {
        nftCardView.firstNFTCover.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width)
            make.height.equalTo(375)
        }
        
        nftCardView.secondNFTCover.snp.makeConstraints { make in
            make.leading.equalTo(nftCardView.firstNFTCover.snp.trailing)
            make.width.equalTo(view.frame.width)
            make.height.equalTo(375)
        }
        
        nftCardView.thirdNFTCover.snp.makeConstraints { make in
            make.leading.equalTo(nftCardView.secondNFTCover.snp.trailing)
            make.width.equalTo(view.frame.width)
            make.height.equalTo(375)
        }
        
        nftCardView.generalScrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        nftCardView.coverNFTScrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(375)
        }
        
        nftCardView.pageControlView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(28)
            make.top.equalTo(nftCardView.coverNFTScrollView.snp.bottom)
        }
        
        nftCardView.coverPageControlStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        nftCardView.nftLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(nftCardView.coverPageControlStack.snp.bottom).offset(16)
        }
        
        nftCardView.nftRatingStack.snp.makeConstraints { make in
            make.leading.equalTo(nftCardView.nftLabel.snp.trailing).offset(8)
            make.centerY.equalTo(nftCardView.nftLabel)
        }
        
        nftCardView.nftCollectionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(nftCardView.nftLabel)
        }
        
        nftCardView.priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(nftCardView.nftLabel.snp.bottom).offset(24)
        }
        
        nftCardView.price.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(nftCardView.priceLabel.snp.bottom).offset(2)
        }
        
        nftCardView.addToCartButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(nftCardView.nftLabel.snp.bottom).offset(24)
            make.height.equalTo(44)
            make.width.equalTo(240)
        }
        
        nftCardView.currencyTableView.snp.makeConstraints { make in
            make.leading.trailing.width.equalToSuperview().inset(16)
            make.top.equalTo(nftCardView.addToCartButton.snp.bottom).offset(24)
            make.height.equalTo(576)
        }
        
        nftCardView.sellerWebsiteButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(nftCardView.currencyTableView.snp.bottom).offset(24)
            make.height.equalTo(40)
        }
        
        nftCardView.nftCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(nftCardView.sellerWebsiteButton.snp.bottom).offset(36)
            make.height.equalTo(192)
        }
    }
}

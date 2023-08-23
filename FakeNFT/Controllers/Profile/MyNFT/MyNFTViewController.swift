import UIKit
import SnapKit

final class MyNFTViewController: UIViewController, MyNFTViewControllerProtocol {
    var presenter: MyNFTViewPresenterProtocol?
    private var profilePresenter: ProfileViewPresenterProtocol?
    private let myNFTView = MyNFTView()
    private let alertService = AlertService()
    private let analyticsService = AnalyticsService.shared
    
    init(profilePresenter: ProfileViewPresenterProtocol?, likes: [String]?) {
        super.init(nibName: nil, bundle: nil)
        self.profilePresenter = profilePresenter
        self.presenter = MyNFTViewPresenter(profilePresenter: profilePresenter)
        self.presenter?.view = self
        self.presenter?.likes = likes
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundDay
        analyticsService.report(event: .open, screen: .myNFTsVC, item: nil)
        setupNavigationBar()
        setupTableView()
        presenter?.fetchNFTs()
        presenter?.fetchUsers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: .close, screen: .myNFTsVC, item: nil)
    }
    
    private func setupTableView() {
        myNFTView.myNFTTableView.dataSource = self
        myNFTView.myNFTTableView.delegate = self
        myNFTView.myNFTTableView.register(MyNFTTableViewCell.self, forCellReuseIdentifier: MyNFTTableViewCell.identifier)
    }
    
    func reloadViews() {
        setupTitle()
        presenter?.arePurchasedNFTsEmpty() ?? false ? addEmptyLabel() : addCollectionView()
    }
    
    private func addEmptyLabel() {
        myNFTView.myNFTTableView.removeFromSuperview()
        view.addSubview(myNFTView.emptyLabel)
        myNFTView.emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func addCollectionView() {
        myNFTView.emptyLabel.removeFromSuperview()
        view.addSubview(myNFTView.myNFTTableView)
        myNFTView.myNFTTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        myNFTView.myNFTTableView.reloadData()
    }
    
    private func setupTitle() {
        if presenter?.arePurchasedNFTsEmpty() ?? false {
            self.title = nil
        } else {
            self.title = LocalizableConstants.Profile.myNFT
        }
    }
    
    @objc private func sort() {
        guard let model = presenter?.getSortModel() else { return }
        analyticsService.report(event: .click, screen: .myNFTsVC, item: .sort)
        alertService.showSortAlert(model: model, controller: self)
    }
    
    private func switchToNFTCardVC(nftModel: NFT?, isLiked: Bool) {
        guard let customNC = navigationController as? CustomNavigationController else { return }
        let nftCardVC = NFTCardViewController(nftModel: nftModel, isLiked: isLiked)
        customNC.pushViewController(nftCardVC, animated: true)
    }
}

//MARK: UITableViewDataSource
extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.purchasedNFTs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyNFTTableViewCell.identifier, for: indexPath) as? MyNFTTableViewCell,
              let nfts = presenter?.purchasedNFTs[indexPath.row] else { return UITableViewCell() }
        
        cell.delegate = self
        cell.configureCell(image: nfts.images?[0],
                           doesNftHasLike: presenter?.doesNftHasLike(id: nfts.id),
                           nftName: nfts.name,
                           rating: nfts.rating,
                           author: presenter?.getAuthorName(for: nfts.author ?? "",
                                                            from: presenter?.users ?? []),
                           price: convert(price: nfts.price ?? 0.0))
        
        return cell
    }
}

//MARK: UITableViewDelegate
extension MyNFTViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let nftModel = presenter?.purchasedNFTs[indexPath.row] else { return }
        switchToNFTCardVC(nftModel: nftModel,
                          isLiked: presenter?.doesNftHasLike(id: nftModel.id) ?? false)
    }
}

//MARK: MyNFTTableViewCellDelegate
extension MyNFTViewController: MyNFTTableViewCellDelegate {
    func didTapLike(_ cell: MyNFTTableViewCell) {
        guard let indexPath = myNFTView.myNFTTableView.indexPath(for: cell),
              let presenter = presenter else { return }
        let nftID = presenter.purchasedNFTs[indexPath.row].id
        presenter.changeLike(nftID ?? "")
        analyticsService.report(event: .click, screen: .myNFTsVC, item: .like)
        cell.setLiked(presenter.doesNftHasLike(id: nftID))
    }
}

//MARK: Alerts
extension MyNFTViewController {
    func showNFTsErrorAlert() {
        guard let model = presenter?.getNFTsErrorModel() else { return }
        DispatchQueue.main.async {
            self.alertService.showErrorAlert(model: model, controller: self)
        }
    }
    
    func showUsersErrorAlert() {
        guard let model = presenter?.getUsersErrorModel() else { return }
        DispatchQueue.main.async {
            self.alertService.showErrorAlert(model: model, controller: self)
        }
    }
    
    func showLikeErrorAlert(id: String) {
        guard let model = presenter?.getLikeErrorModel(id: id) else { return }
        DispatchQueue.main.async {
            self.alertService.showErrorAlert(model: model, controller: self)
        }
    }
}

//MARK: SetupViews
extension MyNFTViewController {
    private func setupNavigationBar() {
        let rightButton = UIButton(type: .system)
        rightButton.setImage(Resourses.Images.Sort.sort, for: .normal)
        rightButton.tintColor = .blackDay
        rightButton.addTarget(self, action: #selector(sort), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }
}

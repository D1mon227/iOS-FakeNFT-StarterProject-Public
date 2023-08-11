import UIKit
import SnapKit

final class MyNFTViewController: UIViewController, MyNFTViewControllerProtocol {
    var presenter: MyNFTViewPresenterProtocol?
    private var profilePresenter: ProfileViewPresenterProtocol?
    private let myNFTView = MyNFTView()
    private let alertService = AlertService()
    
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
        setupNavigationBar()
        setupTableView()
        presenter?.fetchNFTs()
        presenter?.fetchUsers()
        setupTitle()
    }
    
    private func setupTableView() {
        myNFTView.myNFTTableView.dataSource = self
        myNFTView.myNFTTableView.delegate = self
        myNFTView.myNFTTableView.register(MyNFTTableViewCell.self, forCellReuseIdentifier: "MyNFTTableViewCell")
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
        alertService.showAlert(title: LocalizableConstants.Sort.sort,
                               actions: [.byPrice, .byRating, .byTitle, .close],
                               controller: self) { [weak self] option in
            guard let self = self else { return }
            self.presenter?.sortNFT(by: option)
        }
    }
}

//MARK: UITableViewDataSource
extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.purchasedNFTs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyNFTTableViewCell", for: indexPath) as? MyNFTTableViewCell,
              let nfts = presenter?.purchasedNFTs[indexPath.row] else { return UITableViewCell() }
        
        cell.delegate = self
        cell.configureCell(image: nfts.images?[0],
                           doesNftHasLike: presenter?.doesNftHasLike(id: nfts.id),
                           nftName: nfts.name,
                           rating: nfts.rating,
                           author: presenter?.getAuthorName(for: nfts.author ?? "",
                                                            from: presenter?.users ?? []),
                           price: String(nfts.price ?? 0.0) + " ETH")
        
        return cell
    }
}

extension MyNFTViewController: MyNFTTableViewCellDelegate {
    func didTapLike(_ cell: MyNFTTableViewCell) {
        guard let indexPath = myNFTView.myNFTTableView.indexPath(for: cell),
              let presenter = presenter else { return }
        let nftID = presenter.purchasedNFTs[indexPath.row].id
        presenter.changeLike(nftID)
        cell.setLiked(presenter.doesNftHasLike(id: nftID))
    }
}

//MARK: UITableViewDelegate
extension MyNFTViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
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

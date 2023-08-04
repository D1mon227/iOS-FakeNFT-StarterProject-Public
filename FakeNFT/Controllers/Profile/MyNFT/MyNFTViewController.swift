import UIKit
import SnapKit

final class MyNFTViewController: UIViewController, MyNFTViewControllerProtocol {
    var presenter: MyNFTViewPresenterProtocol?
    var profilePresenter: ProfileViewPresenterProtocol?
    private let myNFTView = MyNFTView()
    private let alertService = AlertService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchNFTs()
        setupNavigationBar()
        setupViews()
        setupTableView()
    }
    
    init(profilePresenter: ProfileViewPresenterProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.profilePresenter = profilePresenter
        self.presenter = MyNFTViewPresenter(profilePresenter: profilePresenter)
        self.presenter?.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        myNFTView.myNFTTableView.dataSource = self
        myNFTView.myNFTTableView.delegate = self
        myNFTView.myNFTTableView.register(MyNFTTableViewCell.self, forCellReuseIdentifier: "MyNFTTableViewCell")
    }
    
    @objc private func sort() {
        alertService.showAlert(title: LocalizableConstants.Sort.sort,
                               actions: [.byPrice, .byRating, .byTitle, .close],
                               controller: self) { [weak self] option in
            guard let self = self else { return }
            self.sortNFT(by: option)
        }
    }
    
    private func sortNFT(by: Sort) {
        switch by {
        case .byPrice:
            print("Sort by price")
        case .byRating:
            print("Sort by rating")
        case .byTitle:
            print("Sort by title")
        default:
            break
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.myNFTView.myNFTTableView.reloadData()
        }
    }
}

//MARK: UITableViewDataSource
extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.nfts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyNFTTableViewCell", for: indexPath) as? MyNFTTableViewCell,
              let nfts = presenter?.nfts?[indexPath.row] else { return UITableViewCell() }
        
        cell.configureCell(image: nfts.images[0],
                           favoriteButtonColor: .white,
                           nftName: nfts.name,
                           rating: nfts.rating,
                           author: nfts.author,
                           price: String(nfts.price))
        
        return cell
    }
}

//MARK: UITableViewDelegate
extension MyNFTViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
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
    
    private func setupViews() {
        view.backgroundColor = .backgroundDay
        view.addSubview(myNFTView.myNFTTableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        myNFTView.myNFTTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

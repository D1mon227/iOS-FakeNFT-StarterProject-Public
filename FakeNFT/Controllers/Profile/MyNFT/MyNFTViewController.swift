import UIKit
import SnapKit

final class MyNFTViewController: UIViewController {
    private let myNFTView = MyNFTView()
    private let alertService = AlertService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupTableView()
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
}

//MARK: UITableViewDataSource
extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyNFTTableViewCell", for: indexPath) as? MyNFTTableViewCell else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            cell.configureCell(image: Resourses.Images.NFT.nftCard1,
                               favoriteButtonColor: .white,
                               nftName: "Lilo",
                               starColor: .yellowUniversal,
                               author: "John Doe",
                               price: "1,78 ETH")
        case 1:
            cell.configureCell(image: Resourses.Images.NFT.nftCard2,
                               favoriteButtonColor: .redUniversal,
                               nftName: "Spring",
                               starColor: .yellowUniversal,
                               author: "John Doe",
                               price: "1,78 ETH")
        case 2:
            cell.configureCell(image: Resourses.Images.NFT.nftCard3,
                               favoriteButtonColor: .white,
                               nftName: "April",
                               starColor: .yellowUniversal,
                               author: "John Doe",
                               price: "1,78 ETH")
        default:
            break
        }
        
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

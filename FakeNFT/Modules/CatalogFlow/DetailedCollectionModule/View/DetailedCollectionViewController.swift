import UIKit

final class DetailedCollectionViewController: UIViewController {
    
    private let presenter: DetailedCollectionPresenterProtocol
    private lazy var tableView = UITableView()
    private var viewModels: [DetailedCollectionTableViewCellProtocol] = []
    
    init(presenter: DetailedCollectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupViews()
        setupTableView()
    }
}

extension DetailedCollectionViewController: DetailedCollectionViewProtocol {
    func updateViewModel(with viewModels: [DetailedCollectionTableViewCellProtocol]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }
    
    func present(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}

private extension DetailedCollectionViewController {
    func setupViews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupTableView() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CollectionDetailsCell.self,
                           forCellReuseIdentifier: CollectionDetailsCell.identifier)
        tableView.register(NFTCollectionTableViewCell.self,
                           forCellReuseIdentifier: NFTCollectionTableViewCell.identifier)
    }
}

extension DetailedCollectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: CollectionDetailsCell.identifier) as? CollectionDetailsCell,
           let detailedCollectionViewModel = viewModel as? CollectionDetailsTableViewCellModel {
            cell.configure(with: detailedCollectionViewModel)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: NFTCollectionTableViewCell.identifier) as? NFTCollectionTableViewCell,
                  let nftsViewModel = viewModel as? NFTCollectionTableViewCellViewModel {
            cell.configure(with: nftsViewModel)
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}

extension DetailedCollectionViewController: CollectionDetailsCellProtocol {
    func didTapOnLink(url: URL?) {
        presenter.didTapOnLink(url: url)
    }
}

extension DetailedCollectionViewController: NFTCollectionTableViewCellDelegate {
    func didTapNFTLikeButton(id: String) {
        presenter.didTapLikeButton(id: id)
    }
    
    func didTapNFTCartButton(id: String) {
        presenter.didTapCartButton(id: id)
    }

}


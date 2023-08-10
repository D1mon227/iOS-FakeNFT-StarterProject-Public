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
    }
}

extension DetailedCollectionViewController: DetailedCollectionViewProtocol {
    func updateViewModel(with nftsViewModel: NFTCollectionTableViewCellViewModel) {
        viewModels += [nftsViewModel]
        tableView.reloadData()
    }
    
    func updateViewModel(with detailedDescriptionModel: CollectionDetailsTableViewCellModel) {
        viewModels += [detailedDescriptionModel]
        tableView.reloadData()
    }
}

private extension DetailedCollectionViewController {
    func setupViews() {
        
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
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: NFTCollectionTableViewCell.identifier) as? NFTCollectionTableViewCell,
                  let nftsViewModel = viewModel as? NFTCollectionTableViewCellViewModel {
            cell.configure(with: nftsViewModel)
        }
        
        return UITableViewCell()
    }
    
}


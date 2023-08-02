import UIKit

protocol CatalogViewControllerDelegate: AnyObject {
    
}

final class CatalogViewController: UIViewController {
    
    // MARK: - Layout elements
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.identifier)
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.allowsMultipleSelection = false
        table.backgroundColor = .clear
        return table
    }()
    
    // MARK: - Properties
    
    weak var delegate: CatalogViewControllerDelegate?
    private let presenter: CatalogPresenterProtocol
    private var viewModels: [CatalogTableViewCellViewModel] = []
    
    
    // MARK: - Lifecycle

    init(presenter: CatalogPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupConstraints()

    }
    
    // MARK: - Actions
    
    @objc private func didTapSortingByButton() {
        
    }
}

// MARK: - Layout methods

private extension CatalogViewController {
    
    func setupTableView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigationBar() {
        let rightButton = UIBarButtonItem(
            image: UIImage(named:"sortingBy"),
            style: .plain,
            target: self,
            action: #selector(didTapSortingByButton)
        )
        rightButton.tintColor = .blackDay
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            //tableView
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor, constant: -16),
        ])
    }

}

// MARK: - UITableViewDelegate

extension CatalogViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogTableViewCell.identifier) as? CatalogTableViewCell else {
            return UITableViewCell()
        }
        
        let viewModel = viewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    
}

extension CatalogViewController: CatalogViewProtocol {
    func update(with viewModels: [CatalogTableViewCellViewModel]) {
        self.viewModels += viewModels
        tableView.reloadData()
    }
    
    func displayAlert(model: AlertProtocol) {
        presentAlertWith(model: model)
    }
}



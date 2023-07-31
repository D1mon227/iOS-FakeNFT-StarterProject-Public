import UIKit

final class CatalogViewController: UIViewController {
    
    private let presenter: CatalogPresenterProtocol
    private var viewModels: [CatalogTableViewCellViewModel] = []
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.identifier)
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.allowsMultipleSelection = false
        table.backgroundColor = .clear
        return table
    }()
    
    private lazy var sortingByButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(
                systemName: "sortingBy",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 18,
                    weight: .bold
                )
            )!,
            target: self, action: #selector(didTapsortingByButton))
        button.tintColor = .blackDay
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        
        //navBar
        let catalogViewController = CatalogViewController(presenter: presenter)
        let navigationController = UINavigationController(rootViewController: catalogViewController)
        navigationController.isModalInPresentation = true
        present(navigationController, animated: true)
    }
    
    @objc private func didTapsortingByButton() {
        
    }
}

private extension CatalogViewController {
    
    func setupTableView() {
        
    }
    
    func setupNavigationBar() {
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // sortingByButton
            sortingByButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            sortingByButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 13),
            //tableView
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: sortingByButton.topAnchor, constant: -16),
        ])
    }
}

extension CatalogViewController: UITableViewDelegate {
    
}

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



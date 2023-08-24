import UIKit

final class CatalogViewController: UIViewController {
    
    // MARK: - Layout elements
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.identifier)
        table.separatorStyle = .none
        table.isScrollEnabled = true
        table.allowsMultipleSelection = false
        table.backgroundColor = .backgroundDay
        return table
    }()
    
    // MARK: - Properties
    
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
        
        view.backgroundColor = .backgroundDay
        
        presenter.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewDidDisappear()
    }

    // MARK: - Actions
    
    @objc private func didTapSortingByButton() {
        presenter.didTapSortingButton()
    }
}

// MARK: - Layout methods

private extension CatalogViewController {
    
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigationBar() {
        let rightButton = UIBarButtonItem(
            image: Resourses.Images.Sort.sort,
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
        ])
    }
    
}

// MARK: - UITableViewDelegate

extension CatalogViewController: UITableViewDelegate {}

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CatalogTableViewCell,
              let id = cell.viewModel?.id else {
            return
        }
        
        presenter.didSelectCell(with: id)
    }
}

extension CatalogViewController: CatalogViewProtocol {
    func update(with viewModels: [CatalogTableViewCellViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }
    
    func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func displayAlert(model: AlertProtocol) {
        presentAlertWith(model: model)
    }
    
    func showLoadingIndicator() {
        UIBlockingProgressHUD.show()
    }
    
    func hideLoadingIndicator() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func showNetworkError(model: NetworkErrorViewModel) {
        DispatchQueue.main.async {
            self.hideLoadingIndicator()
            self.addNetworkErrorView(model: model)
        }
    }
    
    func hideNetworkError() {
        removeNetworkErrorView()
    }
}



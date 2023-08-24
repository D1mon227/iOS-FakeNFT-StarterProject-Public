import UIKit
import Kingfisher

final class CartViewController: UIViewController, CartViewControllerProtocol {
    // MARK: - Properties
    var presenter: CartPresenterProtocol?
    private var containerView: UIView!
    private let alertService = AlertService()
    private let analyticsService = AnalyticsService.shared
    private var isDeleteViewVisible = false
    private var indexToDelete: IndexPath?
    
    private lazy var placeholderView: UIView = {
        let message = NSLocalizedString("cart.emptyCart", comment: "")
        return UIView.placeholderView(message: message)
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0.0
        blurView.frame = UIScreen.main.bounds
        return blurView
    }()
    
    private lazy var imageToDelete: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var deleteText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = LocalizableConstants.Cart.deleteQuestion
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackDay
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.setTitle(LocalizableConstants.Cart.delete, for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(nil, action: #selector(deleteNFT), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackDay
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.setTitleColor(.backgroundDay, for: .normal)
        button.addTarget(nil, action: #selector(cancel), for: .touchUpInside)
        button.setTitle(LocalizableConstants.Cart.goBack, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackDay
        button.setTitleColor(.backgroundDay, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(nil, action: #selector(payButtonTapped), for: .touchUpInside)
        button.setTitle(LocalizableConstants.Cart.checkout, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var cartTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var countOfNFTS: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceOfNFTS: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.11, green: 0.62, blue: 0, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cartInfo: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGreyDay
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        analyticsService.report(event: .open, screen: .cartVC, item: nil)
        view.backgroundColor = .backgroundDay
        addPlaceholder()
        setupView()
        setupNavigationBar()
        presenter = CartPresenter()
        presenter?.view = self
        cartTable.dataSource = self
        cartTable.backgroundColor = .backgroundDay
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
        cartTable.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.cartNFTs()
    }
    
    func reloadViews() {
        presenter?.areOrderIsEmpty() ?? false ? addPlaceholder() : addTableView()
    }
    
    private func addPlaceholder() {
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.isHidden = true
            self.cartInfo.isHidden = true
            self.payButton.isHidden = true
            self.countOfNFTS.isHidden = true
            self.priceOfNFTS.isHidden = true
            self.cartTable.removeFromSuperview()
            self.view.addSubview(self.placeholderView)
            self.placeholderView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.placeholderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.placeholderView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
        }
    }
    
    private func addTableView() {
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.isHidden = false
            self.cartInfo.isHidden = false
            self.payButton.isHidden = false
            self.countOfNFTS.isHidden = false
            self.priceOfNFTS.isHidden = false
            self.placeholderView.removeFromSuperview()
            self.view.addSubview(self.cartTable)
            NSLayoutConstraint.activate([
                self.cartTable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                self.cartTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.cartTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.cartTable.bottomAnchor.constraint(equalTo: self.payButton.topAnchor, constant: -16),
            ])
            self.fillInfo()
            self.cartTable.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func payButtonTapped() {
        analyticsService.report(event: .click, screen: .cartVC, item: .checkout)
        guard let customNC = navigationController as? CustomNavigationController else { return }
        let payVC = PaymentViewController()
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 17) // Use any bold font you prefer
        ]
        
        payVC.navigationItem.title = NSAttributedString(string: NSLocalizedString("cart.paymentMethod", comment: ""), attributes: titleAttributes).string
        
        customNC.pushViewController(payVC, animated: true)
    }
    
    @objc
    private func sort() {
        guard let model = presenter?.getSortModel() else { return }
        alertService.showSortAlert(model: model, controller: self)
    }
    
    @objc private func sortButtonTapped() {
        analyticsService.report(event: .click, screen: .myNFTsVC, item: .sort)
        sort()
    }
    
    private func fillPictureToDelete(url: URL) {
        imageToDelete.kf.setImage(with: url)
    }
    
    @objc
    private func deleteNFT() {
        guard let presenter = presenter,
              let indexPath = indexToDelete else { return }
        let nftID = presenter.nfts[indexPath.row].id
        presenter.deleteFromCart(id: nftID ?? "")
        
        isDeleteViewVisible = false
        indexToDelete = nil
        
        blurView.removeFromSuperview()
        imageToDelete.removeFromSuperview()
        deleteText.removeFromSuperview()
        deleteButton.removeFromSuperview()
        cancelButton.removeFromSuperview()
        
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc
    private func cancel() {
        isDeleteViewVisible = false
        indexToDelete = nil
        
        blurView.removeFromSuperview()
        imageToDelete.removeFromSuperview()
        deleteText.removeFromSuperview()
        deleteButton.removeFromSuperview()
        cancelButton.removeFromSuperview()
        
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    // Summurize info about all NFT's in cart
    private func fillInfo() {
        guard let nftCount = presenter?.nfts.count else { return }
        countOfNFTS.text = "\(nftCount) NFT"
        countOfNFTS.textColor = .blackDay
        
        let totalPrice = presenter?.nfts.reduce(0.0) { $0 + ($1.price ?? 0.0) }
        let formattedTotalPrice = convert(price: totalPrice ?? 0.0) + " ETH" // Using the convert function
        
        priceOfNFTS.text = formattedTotalPrice
    }
    
    // MARK: - Components
    
    private func setupNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            navBar.backgroundColor = .clear  // Change this to the desired background color
            navBar.tintColor = .clear
            let sortButton = UIButton(type: .custom)
            sortButton.setImage(Resourses.Images.Sort.sort, for: .normal)
            sortButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
            
            let imageBarButtonItem = UIBarButtonItem(customView: sortButton)
            navBar.topItem?.setRightBarButton(imageBarButtonItem, animated: false)
        }
    }
}
    
    // MARK: - UITableViewDataSource
extension CartViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.nfts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as? CartCell,
              let nfts = presenter?.nfts[indexPath.row] else { return UITableViewCell() }
        
        cell.delegate = self
        cell.configure(nftModel: nfts)
        
        return cell
    }
}

// MARK: - Extension for UIView

extension UIView {
    static func placeholderView(message: String) -> UIView {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .blackDay
        label.text = message
        label.numberOfLines = 0
        label.textAlignment = .center
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.alignment = .center
        
        vStack.addArrangedSubview(label)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        return vStack
    }
}

// MARK: - Extension for UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - Extension for CartCellDelegate
extension CartViewController: CartCellDelegate {
    private enum Constants {
        static let imageHeightWidth = CGFloat(108)
        static let labelWidth = CGFloat(180)
    }
    
    func showDeleteView(cell: CartCell) {
        guard let indexPath = cartTable.indexPath(for: cell) else { return }
        if isDeleteViewVisible {
            return
        }
        
        isDeleteViewVisible = true
        indexToDelete = indexPath
        
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        
        blurView.isUserInteractionEnabled = true
        view.addSubview(blurView)
        blurView.contentView.addSubview(imageToDelete)
        blurView.contentView.addSubview(deleteText)
        blurView.contentView.addSubview(cancelButton)
        blurView.contentView.addSubview(deleteButton)
        
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        
        guard let url = presenter?.nfts[indexPath.row].images?[0] else { return }
        fillPictureToDelete(url: url)
        
        UIView.animate(withDuration: 0.3) {
            self.blurView.alpha = 1.0
            NSLayoutConstraint.activate([
                self.deleteText.centerYAnchor.constraint(equalTo: self.blurView.centerYAnchor),
                self.deleteText.centerXAnchor.constraint(equalTo: self.blurView.centerXAnchor),
                self.deleteText.widthAnchor.constraint(equalToConstant: Constants.labelWidth),
                self.imageToDelete.centerXAnchor.constraint(equalTo: self.blurView.centerXAnchor),
                self.imageToDelete.bottomAnchor.constraint(equalTo: self.deleteText.topAnchor, constant: -12),
                self.imageToDelete.widthAnchor.constraint(equalToConstant: Constants.imageHeightWidth),
                self.imageToDelete.heightAnchor.constraint(equalToConstant: Constants.imageHeightWidth),
                self.deleteButton.widthAnchor.constraint(equalToConstant: 127),
                self.deleteButton.heightAnchor.constraint(equalToConstant: 44),
                self.deleteButton.topAnchor.constraint(equalTo: self.deleteText.bottomAnchor, constant: 20),
                self.deleteButton.centerXAnchor.constraint(equalTo: self.blurView.centerXAnchor,constant: -70),
                self.cancelButton.widthAnchor.constraint(equalToConstant: 127),
                self.cancelButton.heightAnchor.constraint(equalToConstant: 44),
                self.cancelButton.topAnchor.constraint(equalTo: self.deleteText.bottomAnchor, constant: 20),
                self.cancelButton.centerXAnchor.constraint(equalTo: self.blurView.centerXAnchor,constant: 70)
            ])
        }
    }
}

extension CartViewController {
    func showErrorAlertAndRetry(message: String) {
        let alertController = UIAlertController(title: "Failed to fetch cart",
                                                message: message,
                                                preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: NSLocalizedString("Retry", comment: ""),
                                        style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.cartNFTs()
        }
        alertController.addAction(retryAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension CartViewController {
    // MARK: - UI Setup
    private func setupView() {
        view.backgroundColor = .backgroundDay
        
        view.addSubview(cartInfo)
        view.addSubview(payButton)
        view.addSubview(countOfNFTS)
        view.addSubview(priceOfNFTS)
        
        NSLayoutConstraint.activate([
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            payButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 240),
            payButton.heightAnchor.constraint(equalToConstant: 44),
            
            cartInfo.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cartInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartInfo.heightAnchor.constraint(equalToConstant: 76),
            
            countOfNFTS.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            countOfNFTS.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            
            priceOfNFTS.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            priceOfNFTS.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
        
        cartTable.separatorStyle = .none
        cartTable.allowsSelection = false
        cartTable.register(CartCell.self, forCellReuseIdentifier: "cartCell")
    }
}

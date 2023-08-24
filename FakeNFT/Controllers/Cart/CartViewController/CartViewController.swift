import UIKit
import Kingfisher

final class CartViewController: UIViewController, UITableViewDataSource {
    
    // MARK: - Properties
    
    private var containerView: UIView!
    
    private var cartArray: [Cart] = []
    
    private var presenter: CartPresenterProtocol?
    
    private var myOrders: [Order] = []
    
    private let numberFormatter = NumberFormatter()
    
    private let analyticsService = AnalyticsService.shared
    
    private var isDeleteViewVisible = false
    
    private var indexToDelete: Int?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        analyticsService.report(event: .open, screen: .cartVC, item: nil)
        view.backgroundColor = .backgroundDay
        addPlaceholder()
        setupView()
        setupNavigationBar()
        presenter = CartPresenter()
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
        fetchDataFromAPI()
    }
    
    // MARK: - UI Setup
    
    private func setupView() {
        view.backgroundColor = .backgroundDay
        
        view.addSubview(cartTable)
        view.addSubview(cartInfo)
        view.addSubview(payButton)
        view.addSubview(countOfNFTS)
        view.addSubview(priceOfNFTS)
        
        NSLayoutConstraint.activate([
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            payButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 240),
            payButton.heightAnchor.constraint(equalToConstant: 44),
            
            cartTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cartTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartTable.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -16),
            
            cartInfo.topAnchor.constraint(equalTo: cartTable.bottomAnchor),
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
    
    // MARK: - Components
    
    private lazy var placeholderView: UIView = {
        let message = NSLocalizedString("cart.emptyCart", comment: "")
        return UIView.placeholderView(message: message)
    }()
    
    private var selectedSortOption: Sort {
        get {
            if let rawValue = UserDefaults.standard.string(forKey: "selectedSortOption"),
               let sortOption = Sort(rawValue: rawValue) {
                return sortOption
            }
            return .byName // Default sorting option
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedSortOption")
        }
    }
    
    private func fetchDataFromAPI() {
        UIBlockingProgressHUD.show()
        cartArray = []
        
        presenter?.cartNFTs { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let cartModelDecodable):
                // Assuming cartModelDecodable contains an array of nft IDs as strings
                let nftIDs = cartModelDecodable.nfts
                
                if nftIDs.isEmpty {
                    DispatchQueue.main.async {
                        UIBlockingProgressHUD.dismiss()
                        self.sortBy(selectedSortOption: self.selectedSortOption)
                        self.cartTable.reloadData()
                        self.view?.isUserInteractionEnabled = true
                    }
                    return
                }
                
                var fetchCount = nftIDs.count
                nftIDs.forEach { nftID in
                    self.presenter?.getNFTsFromAPI(nftID: nftID) { [weak self] result in
                        guard let self = self else { return }
                        
                        switch result {
                        case .success(let cartDetails):
                            self.cartArray.append(cartDetails)
                        case .failure(let error):
                            print("Error fetching NFT details: \(error)")
                            self.showErrorAlertAndRetry(message: "Please check your internet connection and try again")
                        }
                        fetchCount -= 1
                        if fetchCount == 0 {
                            DispatchQueue.main.async {
                                UIBlockingProgressHUD.dismiss()
                                // Apply the selected sorting option here
                                self.sortBy(selectedSortOption: self.selectedSortOption)
                                self.cartTable.reloadData()
                                
                                // Update UI elements here
                                self.view?.isUserInteractionEnabled = true
                            }
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                    // Show error alert with retry option
                    self.showErrorAlertAndRetry(message: "Please check your internet connection and try again")
                    
                    self.view?.isUserInteractionEnabled = true
                }
                print("Error fetching cart data: \(error)")
            }
        }
    }
    
    
    
    private lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0.0
        blurView.frame = UIScreen.main.bounds
        return blurView
    }()
    
    private let imageToDelete: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let deleteText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = LocalizableConstants.Cart.deleteQuestion
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deleteButton: UIButton = {
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
    
    private let cancelButton: UIButton = {
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
    
    private let payButton: UIButton = {
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
    
    
    private let cartTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let countOfNFTS: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceOfNFTS: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.11, green: 0.62, blue: 0, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cartInfo: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGreyDay
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    // MARK: - Appearance
    
    private func addPlaceholder() {
        view.backgroundColor = .blackDay
        view.addSubview(placeholderView)
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fillInfo()
        if cartArray.isEmpty {
            tableView.isHidden = true
            cartInfo.isHidden = true
            cartTable.isHidden = true
            countOfNFTS.isHidden = true
            priceOfNFTS.isHidden = true
            payButton.isHidden = true
            navigationController?.navigationBar.isHidden = true
        } else {
            tableView.isHidden = false
            cartInfo.isHidden = false
            cartTable.isHidden = false
            countOfNFTS.isHidden = false
            priceOfNFTS.isHidden = false
            payButton.isHidden = false
            navigationController?.navigationBar.isHidden = false
        }
        return cartArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as? CartCell else {
            return UITableViewCell() // Return a fallback cell if needed
        }
        
        // Reset cell properties
        cell.nftImage.image = nil
        cell.nftName.text = ""
        cell.nftPrice.text = ""
        
        // Configure cell with new data
        let rating = cartArray[indexPath.row].nftRating
        let name = cartArray[indexPath.row].nftName
        let priceValue = cartArray[indexPath.row].nftPrice
        let imageURL = URL(string: cartArray[indexPath.row].nftImages.first ?? "")
        let formattedPriceWithCurrency = convert(price: priceValue) + " ETH"
        
        cell.setupRating(rating: rating)
        cell.nftName.text = name
        cell.nftPrice.text = formattedPriceWithCurrency
        cell.nftImage.kf.setImage(with: imageURL)
        cell.indexCell = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    
    // MARK: - Actions
    
    @objc
    func payButtonTapped() {
        analyticsService.report(event: .click, screen: .cartVC, item: .checkout)
        guard let customNC = navigationController as? CustomNavigationController else { return }
        let payVC = PaymentViewController()
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 17) // Use any bold font you prefer
        ]
        
        payVC.navigationItem.title = NSAttributedString(string: NSLocalizedString("cart.paymentMethod", comment: ""), attributes: titleAttributes).string
        
        customNC.pushViewController(payVC, animated: true)
    }
    
    
    
    @objc private func sortButtonTapped() {
        analyticsService.report(event: .click, screen: .myNFTsVC, item: .sort)
        showMenu()
    }
    
    private func fillPictureToDelete(urlStr: String) {
        let url = URL(string: urlStr)
        imageToDelete.kf.setImage(with: url)
    }
    
    @objc
    func deleteNFT() {
        if let indexToDelete = indexToDelete, indexToDelete >= 0 && indexToDelete < cartArray.count {
            let nftIDToDelete = cartArray[indexToDelete].nftID
            
            cartArray.remove(at: indexToDelete)
            
            let updatedOrder = Order(nfts: cartArray.map { $0.nftID }, id: "1")
            
            presenter?.changeCart(order: updatedOrder) { [weak self] in
                self?.fetchDataFromAPI() // Fetch updated cart data
                
                self?.isDeleteViewVisible = false
                self?.indexToDelete = nil
                
                self?.blurView.removeFromSuperview()
                self?.imageToDelete.removeFromSuperview()
                self?.deleteText.removeFromSuperview()
                self?.deleteButton.removeFromSuperview()
                self?.cancelButton.removeFromSuperview()
                
                self?.navigationController?.isNavigationBarHidden = false
                self?.tabBarController?.tabBar.isHidden = false
            }
        } else {
            print("Invalid indexToDelete value")
        }
    }
    
    @objc
    func cancel() {
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
    
    private func showMenu() {
        let alertController = UIAlertController(title: LocalizableConstants.Sort.sort, message: nil, preferredStyle: .actionSheet)
        
        // Add sorting actions in the desired order
        let sortByPriceAction = UIAlertAction(title: Sort.byPrice.localizedString, style: .default) { [weak self] _ in
            self?.sortBy(selectedSortOption: .byPrice)
            self?.cartTable.reloadData()
        }
        alertController.addAction(sortByPriceAction)
        
        let sortByRatingAction = UIAlertAction(title: Sort.byRating.localizedString, style: .default) { [weak self] _ in
            self?.sortBy(selectedSortOption: .byRating)
            self?.cartTable.reloadData()
        }
        alertController.addAction(sortByRatingAction)
        
        let sortByNameAction = UIAlertAction(title: Sort.byName.localizedString, style: .default) { [weak self] _ in
            self?.sortBy(selectedSortOption: .byName)
            self?.cartTable.reloadData()
        }
        alertController.addAction(sortByNameAction)
        
        let cancelAction = UIAlertAction(title: LocalizableConstants.Sort.close, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Sorting
    private func sortBy(selectedSortOption: Sort) {
        self.selectedSortOption = selectedSortOption
        switch selectedSortOption {
        case .byName:
            cartArray = cartArray.sorted(by: { $0.nftName < $1.nftName })
        case .byPrice:
            cartArray = cartArray.sorted(by: { $0.nftPrice < $1.nftPrice })
        case .byRating:
            cartArray = cartArray.sorted(by: { $0.nftRating > $1.nftRating })
        default:
            break
        }
        cartTable.reloadData()
    }
    
    // Summurize info about all NFT's in cart
    private func fillInfo() {
        countOfNFTS.text = "\(cartArray.count) NFT"
        countOfNFTS.textColor = .blackDay
        
        let totalPrice = cartArray.reduce(0.0) { $0 + $1.nftPrice }
        let formattedTotalPrice = convert(price: totalPrice) + " ETH" // Using the convert function
        
        priceOfNFTS.text = formattedTotalPrice
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
    
    func showDeleteView(index: Int) {
        
        if isDeleteViewVisible {
            return
        }
        
        isDeleteViewVisible = true
        indexToDelete = index
        
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
        
        let urlStr = cartArray[index].nftImages.first ?? ""
        fillPictureToDelete(urlStr: urlStr)
        
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
                self.cancelButton.centerXAnchor.constraint(equalTo: self.blurView.centerXAnchor,constant: 70),
                
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
            self?.fetchDataFromAPI() // Retry fetching data
        }
        alertController.addAction(retryAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

import UIKit
import Kingfisher

final class CartViewController: UIViewController, UITableViewDataSource{
    
    // MARK: - Properties
    
    private var containerView: UIView!
    var cartArray: [CartStruct] = []
    
    var presenter: CartPresenterProtocol?
    
    var indexNFTToDelete: Int?
    
    var myOrders = [String]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .backgroundDay
        addPlaceholder()
        setupView()
        setupNavigationBar()
        presenter = CartPresenter()
        fetchDataFromAPI()
        cartTable.dataSource = self
        cartTable.backgroundColor = .backgroundDay
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
    
    private func fetchDataFromAPI() {
        myOrders = []
        cartArray = []
        presenter?.cartNFTs { orders in
            if let orders = orders {
                self.myOrders = orders.nfts
                self.myOrders.forEach { i in
                    self.presenter?.getNFTsFromAPI(nftID: i) { cart in
                        if let cart = cart {
                            self.cartArray.append(cart)
                            DispatchQueue.main.async {
                                self.cartTable.reloadData()
                            }
                        } else {
                            print("Error fetching cart data")
                        }
                    }
                }
            } else {
                print("Error fetching orders")
            }
        }
    }
    
    lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0.0
        blurView.frame = UIScreen.main.bounds
        return blurView
    }()
    
    let imageToDelete: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let deleteText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = NSLocalizedString("cart.deleteQuestion", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackDay
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.setTitle(NSLocalizedString("cart.delete", comment: ""), for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(nil, action: #selector(deleteNFT), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackDay
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.setTitleColor(.backgroundDay, for: .normal)
        button.addTarget(nil, action: #selector(cancel), for: .touchUpInside)
        button.setTitle(NSLocalizedString("cart.goBack", comment: ""), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let payButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackDay
        button.setTitleColor(.backgroundDay, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(nil, action: #selector(payButtonTapped), for: .touchUpInside)
        button.setTitle(NSLocalizedString("cart.checkout", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let cartTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let countOfNFTS: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceOfNFTS: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.11, green: 0.62, blue: 0, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cartInfo: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGreyDay
        //        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
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
            sortButton.setImage(UIImage(named: NSLocalizedString("sort.sort", comment: "")), for: .normal)
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
        let rating = cartArray[indexPath.row].nftRating
        let name = cartArray[indexPath.row].nftName
        let price = "\(cartArray[indexPath.row].nftPrice) ETH"
        let imageURL = URL(string: cartArray[indexPath.row].nftImages.first ?? "")
        cell.setupRating(rating: rating)
        cell.nftName.text = name
        cell.nftPrice.text = String(price)
        cell.nftImage.kf.setImage(with: imageURL)
        cell.indexCell = indexPath.row
        cell.delegate = self
        return cell
    }
    
    // MARK: - Actions
    
    @objc
    func payButtonTapped() {
        guard let customNC = navigationController as? CustomNavigationController else { return }
        let payVC = PaymentViewController()
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 17) // Use any bold font you prefer
        ]
        
        payVC.navigationItem.title = NSAttributedString(string: NSLocalizedString("cart.paymentMethod", comment: ""), attributes: titleAttributes).string
        
        customNC.pushViewController(payVC, animated: true)
    }
    
    
    
    @objc private func sortButtonTapped() {
        showMenu()
    }
    
    private func fillPictureToDelete(urlStr: String) {
        let url = URL(string: urlStr)
        imageToDelete.kf.setImage(with: url)
    }
    
    @objc
    func deleteNFT() {
        
        guard let indexToDelete = indexNFTToDelete else {
            return
        }
        
        myOrders.remove(at: indexToDelete)
        presenter?.changeCart(newArray: myOrders, completion: {
            self.fetchDataFromAPI()
        })
        
        blurView.removeFromSuperview()
        imageToDelete.removeFromSuperview()
        deleteText.removeFromSuperview()
        deleteButton.removeFromSuperview()
        cancelButton.removeFromSuperview()
        
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc
    func cancel() {
        print("CANCEL")
        blurView.removeFromSuperview()
        imageToDelete.removeFromSuperview()
        deleteText.removeFromSuperview()
        deleteButton.removeFromSuperview()
        cancelButton.removeFromSuperview()
        
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    private func showMenu() {
        let alertController = UIAlertController(title: NSLocalizedString("sort.sort", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        for sortingOption in Sort.allCases {
            if sortingOption != .byTitle && sortingOption != .close && sortingOption != .byNFTQuantity {
                let action = UIAlertAction(title: sortingOption.localizedString, style: .default) { _ in
                    self.sortBy(option: sortingOption)
                }
                alertController.addAction(action)
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("sort.close", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Sorting
    private func sortBy(option: Sort) {
        switch option {
        case .byName:
            cartArray = cartArray.sorted(by: { $0.nftName < $1.nftName })
            cartTable.reloadData()
        case .byPrice:
            cartArray = cartArray.sorted(by: { $0.nftPrice > $1.nftPrice })
            cartTable.reloadData()
        case .byRating:
            cartArray = cartArray.sorted(by: { $0.nftRating > $1.nftRating })
            cartTable.reloadData()
        default:
            break
        }
    }
    
    // Summurize info about all NFT's in cart
    private func fillInfo() {
        countOfNFTS.text = "\(cartArray.count) NFT"
        countOfNFTS.textColor = .blackDay
        var price = 0.0
        cartArray.forEach { cart in
            price += cart.nftPrice
        }
        priceOfNFTS.text = "\(String(format: "%.2f", price)) ETH"
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
        indexNFTToDelete = index
        print(index)
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

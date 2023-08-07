import UIKit
import Kingfisher

final class CartViewController: UIViewController, UITableViewDataSource{

    // MARK: - Properties

    private var containerView: UIView!
    var cartArray: [CartStruct] = []
    
    var viewModel: CartModelProtocol?


    // MARK: - Lifecycle

    override func viewDidLoad() {

        super.viewDidLoad()
        addPlaceholder()
        setupView()
        setupNavigationBar()
        cartArray = CartMockData.shared.mockCart
        cartTable.dataSource = self
    }

    // MARK: - UI Setup

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(payButton)
        view.addSubview(cartTable)
        view.addSubview(cartInfo)
        view.addSubview(countOfNFTS)
        view.addSubview(priceOfNFTS)
        
        NSLayoutConstraint.activate([
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            payButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 240),
            payButton.heightAnchor.constraint(equalToConstant: 44),
            
            cartTable.topAnchor.constraint(equalTo: view.topAnchor),
            cartTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartTable.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -16),

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
        let message = "Корзина пуста"
        return UIView.placeholderView(message: message)
    }()

    let payButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(nil, action: #selector(payButtonTapped), for: .touchUpInside)
        button.setTitle("К оплате", for: .normal)
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
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private func setupNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            let sortButton = UIButton(type: .custom)
            sortButton.setImage(UIImage(named: "Vector"), for: .normal)
            sortButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)

            let imageBarButtonItem = UIBarButtonItem(customView: sortButton)
            navBar.topItem?.setRightBarButton(imageBarButtonItem, animated: false)
        }
    }


    // MARK: - Appearance

    private func addPlaceholder() {
        view.addSubview(placeholderView)
        placeholderView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func sortButtonTapped() {
        showMenu()
    }

    private func showMenu() {
        let alertController = UIAlertController(title: "Sort Cart", message: nil, preferredStyle: .actionSheet)
        
        for sortingOption in Sort.allCases {
            if sortingOption != .byTitle && sortingOption != .close && sortingOption != .byNFTQuantity {
                let action = UIAlertAction(title: sortingOption.localizedString, style: .default) { _ in
                    self.sortBy(option: sortingOption)
                }
                alertController.addAction(action)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }



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



    
    private func fillInfo() {
        countOfNFTS.text = "\(cartArray.count) NFT"
        var price = 0.0
        cartArray.forEach { cart in
            price += cart.nftPrice
        }
        priceOfNFTS.text = "\(String(format: "%.2f", price)) ETH"
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
        } else {
            tableView.isHidden = false
            cartInfo.isHidden = false
            cartTable.isHidden = false
            countOfNFTS.isHidden = false
            priceOfNFTS.isHidden = false
            payButton.isHidden = false
        }
        return cartArray.count
    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as? CartCell else {
//            fatalError("Error: Unable to dequeue CartCell")
//        }
//        let nft = cartArray[indexPath.row]
//        cell.nftName.text = nft.nftName
//        cell.nftPrice.text = "\(nft.nftPrice) ETH"
//        cell.setupRating(rating: nft.nftRating)
//
//        if let imageURL = URL(string: nft.nftImages.first ?? "") {
//            cell.nftImage.kf.setImage(with: imageURL)
//        }
//
//        cell.indexCell = indexPath.row
//        cell.delegate = self
//
//        return cell
//    }
    
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
    
    
    
    
    private func getData(ids: [String]) {
        ids.forEach { id in
            viewModel?.getNFT(nftID: id, completion: { cart in
                self.cartArray.append(cart)
                DispatchQueue.main.async {
                    self.cartTable.reloadData()
                }
            })
        }
    }

    // MARK: - Actions

    @objc
    func payButtonTapped() {
        let failedVC = PaymentViewController()
        failedVC.modalPresentationStyle = .fullScreen
        failedVC.modalTransitionStyle = .crossDissolve
        present(failedVC, animated: true)
    }
}

// MARK: - Extension for CartCellDelegate

extension CartViewController: CartCellDelegate {
    func showDeleteView(index: Int) {
        let alertController = UIAlertController(title: "Delete NFT", message: "Are you sure you want to delete this NFT?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            // Perform the delete operation based on the index, e.g., remove the NFT from cartArray
            self.cartArray.remove(at: index)
            // Reload the table view to reflect the changes
            self.cartTable.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}


extension UIView {
    static func placeholderView(message: String) -> UIView {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
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


    



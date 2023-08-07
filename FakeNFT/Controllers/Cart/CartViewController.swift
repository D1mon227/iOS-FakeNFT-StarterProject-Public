import UIKit
import Kingfisher

final class CartViewController: UIViewController, UITableViewDataSource {

    // MARK: - Properties

    private var containerView: UIView!
    var cartArray: [CartStruct] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addPlaceholder()
        setupView()
        setupNavigationBar()
        cartArray = CartMockData.shared.mockCart

//        cartArray = CartMockData.shared.mockCart
        cartTable.dataSource = self
    }

    // MARK: - UI Setup

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(payButton)
        view.addSubview(cartTable)

        NSLayoutConstraint.activate([
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            payButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 240),
            payButton.heightAnchor.constraint(equalToConstant: 44),

            cartTable.topAnchor.constraint(equalTo: view.topAnchor),
            cartTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartTable.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -16)
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

    private func setupNavigationBar() {
        if let navBar = navigationController?.navigationBar {
            let sortButton = UIButton(type: .custom)
            sortButton.setImage(UIImage(named: "Vector"), for: .normal)
            sortButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)

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

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as? CartCell else {
            fatalError("Error: Unable to dequeue CartCell")
        }
        let nft = cartArray[indexPath.row]
        cell.nftName.text = nft.nftName
        cell.nftPrice.text = "\(nft.nftPrice) ETH"
        cell.setupRating(rating: nft.nftRating)

        if let imageURL = URL(string: nft.nftImages.first ?? "") {
            cell.nftImage.kf.setImage(with: imageURL)
        }

        cell.indexCell = indexPath.row
        cell.delegate = self

        return cell
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

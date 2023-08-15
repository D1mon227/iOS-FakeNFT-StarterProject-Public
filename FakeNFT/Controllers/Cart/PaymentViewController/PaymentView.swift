//
//  PaymentView.swift
//  FakeNFT
//
//  Created by Денис on 10.08.2023.
//

import UIKit

final class PaymentView: UIView {
    
    weak var delegate: PaymentViewDelegate? // Delegate for communication with the view controller
    
    var paymentArray: [PaymentStruct] = [] {
        didSet {
            paymentCollection.reloadData()
        }
    }
    
    var isCellSelected: Int = 0
    
    private let paymentCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isScrollEnabled = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let collectionViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let paymentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackDay
        button.setTitleColor(.backgroundDay, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapPaymentButton), for: .touchUpInside) // Ensure this line is added
        button.setTitle(NSLocalizedString("cart.pay", comment: "payment"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    private let cartInfo: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGreyDay
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userAgreementText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = NSLocalizedString("cart.terms", comment: "terms")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userAgreementLink: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .link
        label.textAlignment = .left
        label.text = NSLocalizedString("cart.conditions", comment: "")
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func updateCurrencies(_ currencies: [PaymentStruct]) {
        // Update your collection view data
        paymentCollection.reloadData()
        print("Number of items in paymentArray: \(paymentArray.count)")
        
    }
    
    private func commonInit() {
        backgroundColor = .backgroundDay
        
        setupViewHierarchy()
        setupConstraints()    }
    
    private func setupViewHierarchy() {
        addSubview(collectionViewContainer) // Add collectionViewContainer as a subview
        
        collectionViewContainer.addSubview(paymentCollection)
        collectionViewContainer.addSubview(cartInfo)
        
        addSubview(paymentButton) // Add paymentButton directly to PaymentView
        addSubview(userAgreementText) // Add userAgreementText directly to PaymentView
        addSubview(userAgreementLink) // Add userAgreementLink directly to PaymentView
        
        paymentCollection.register(PaymentCell.self, forCellWithReuseIdentifier: "paymentCell")
        paymentCollection.dataSource = self
        paymentCollection.delegate = self
        paymentCollection.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        userAgreementLink.addGestureRecognizer(tapGesture)
    }
    
    
    @objc private func didTapPaymentButton() {
        delegate?.payButtonTapped(selectedIndex: isCellSelected) // Pass the selected index
        print("didTapPaymentButton called")
    }
    
    
    
    @objc private func labelTapped() {
        delegate?.labelTapped()
        print("tap")
    }
    
    // Set up layout constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionViewContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionViewContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionViewContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionViewContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -300), // Adjust the constant as needed
            
            paymentCollection.leadingAnchor.constraint(equalTo: collectionViewContainer.leadingAnchor), // Align with container's leading
            paymentCollection.trailingAnchor.constraint(equalTo: collectionViewContainer.trailingAnchor), // Align with container's trailing
            paymentCollection.topAnchor.constraint(equalTo: collectionViewContainer.topAnchor), // Align with container's top
            paymentCollection.bottomAnchor.constraint(equalTo: collectionViewContainer.bottomAnchor), // Align with container's bottom
            
            cartInfo.bottomAnchor.constraint(equalTo: bottomAnchor),
            cartInfo.leadingAnchor.constraint(equalTo: leadingAnchor),
            cartInfo.trailingAnchor.constraint(equalTo: trailingAnchor),
            cartInfo.heightAnchor.constraint(equalToConstant: 186),
            
            paymentButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            paymentButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            paymentButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            paymentButton.heightAnchor.constraint(equalToConstant: 60),
            
            userAgreementText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            userAgreementText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            userAgreementText.topAnchor.constraint(equalTo: cartInfo.topAnchor, constant: 16),
            userAgreementText.heightAnchor.constraint(equalToConstant: 18),
            
            userAgreementLink.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            userAgreementLink.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            userAgreementLink.topAnchor.constraint(equalTo: userAgreementText.bottomAnchor, constant: 5),
            userAgreementLink.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
}


extension PaymentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        paymentArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paymentCell", for: indexPath) as? PaymentCell
        else { return UICollectionViewCell() }
        let imageURL = URL(string: paymentArray[indexPath.row].image)
        cell.image.kf.setImage(with: imageURL)
        let name = paymentArray[indexPath.row].title
        cell.name.text = name
        let shortName = paymentArray[indexPath.row].name
        cell.shortName.text = shortName
        
        return cell
    }}

extension PaymentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isCellSelected = indexPath.row + 1
        paymentButton.isEnabled = true
    }
}

protocol PaymentViewDelegate: AnyObject {
    func payButtonTapped(selectedIndex: Int) // Add this method
    func labelTapped()
}

extension PaymentView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 46) / 2 // Calculate cell width with spacing
        return CGSize(width: 168, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}





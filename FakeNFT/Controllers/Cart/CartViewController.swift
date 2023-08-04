import UIKit

final class CartViewController: UIViewController {
    private var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPlaceholder()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(succeedButton)
        view.addSubview(failedButton)
        
        NSLayoutConstraint.activate([
            succeedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            succeedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            failedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            failedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }

    
    // MARK: - Components
    
    private lazy var placeholderView: UIView = {
        let message = "Корзина пуста"
        
        return UIView.placeholderView(message: message)
    }()
    
    let failedButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(nil, action: #selector(failedTapped), for: .touchUpInside)
        button.setTitle("Попробовать еще раз", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let succeedButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(nil, action: #selector(succeedTapped), for: .touchUpInside)
        button.setTitle("Попробовать еще раз", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Appearance
    
    private func addPlaceholder() {
        view.backgroundColor = .white
        view.addSubview(placeholderView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
    }
    
    
    @objc
    func failedTapped() {
        let failedVC = FailedPaymentViewController()
        failedVC.modalPresentationStyle = .fullScreen
        failedVC.modalTransitionStyle = .crossDissolve
        present(failedVC, animated: true)
    }
    
    
    @objc
    func succeedTapped() {
        let succeedVC = SucceedPaymentViewController()
        succeedVC.modalPresentationStyle = .fullScreen
        succeedVC.modalTransitionStyle = .crossDissolve
        present(succeedVC, animated: true)
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


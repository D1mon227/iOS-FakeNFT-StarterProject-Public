import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {
    
    private lazy var backgrounView = UIImageView()
    
    private lazy var pageControlStack: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 8
        element.distribution = .fillProportionally
        return element
    }()
    
    private lazy var closeButton: UIButton = {
        let element = UIButton(type: .system)
        element.setImage(Resourses.Images.Button.closeButton, for: .normal)
        element.tintColor = .white
        element.addTarget(self, action: #selector(switchToTabbarVC), for: .touchUpInside)
        return element
    }()
    
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.font = .headline5
        element.textColor = .white
        return element
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let element = UILabel()
        element.font = .caption1
        element.textColor = .white
        element.textAlignment = .left
        element.numberOfLines = 0
        return element
    }()
    
    private lazy var letsStartButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle(LocalizableConstants.Onboarding.letsStartButton, for: .normal)
        element.setTitleColor(.white, for: .normal)
        element.titleLabel?.font = .bodyBold
        element.layer.cornerRadius = 16
        element.addTarget(self, action: #selector(switchToTabbarVC), for: .touchUpInside)
        element.backgroundColor = .black
        return element
    }()
    
    private var pageControlImageViews: [UIImageView] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setupPageControlStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGradient()
    }
    
    @objc private func switchToTabbarVC() {
        OnboardingManager.hasCompletedOnboarding = true
        let tabbar = TabBarController()
        tabbar.modalPresentationStyle = .fullScreen
        tabbar.modalTransitionStyle = .flipHorizontal
        present(tabbar, animated: true)
    }
    
    func setupFirstSecondScreens(image: UIImage?, page: Int?, titleText: String?, descriptionText: String?) {
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(42)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(28)
        }
        backgrounView.image = image
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText
        updatePageControlBackground(page)
    }
    
    func setupThirdScreen(page: Int?) {
        backgrounView.image = Resourses.Images.Onboarding.thirdScreen
        titleLabel.text = LocalizableConstants.Onboarding.thirdTitle
        descriptionLabel.text = LocalizableConstants.Onboarding.thirdDescription
        updatePageControlBackground(page)
        view.addSubview(letsStartButton)
        letsStartButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-32)
        }
    }
}

extension OnboardingViewController {
    private func setupViews() {
        view.addSubview(backgrounView)
        view.addSubview(pageControlStack)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        setupConstraints()
    }
    
    private func setupGradient() {
        let colorTop = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1).cgColor
        let colorBottom = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).cgColor
        
        let gradient = CAGradientLayer()
        gradient.bounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height + 206)
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0, 1]
        gradient.position = view.center
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        backgrounView.layer.addSublayer(gradient)
    }
    
    private func setupPageControlStack() {
        for _ in 0..<3 {
            let imageView = UIImageView()
            imageView.backgroundColor = .lightGrey
            imageView.layer.cornerRadius = 2
            imageView.snp.makeConstraints { make in
                make.height.equalTo(4)
                make.width.greaterThanOrEqualTo(109)
            }
            pageControlStack.addArrangedSubview(imageView)
            pageControlImageViews.append(imageView)
        }
    }
    
    private func updatePageControlBackground(_ page: Int?) {
        guard let page = page else { return }
        
        pageControlImageViews[page].backgroundColor = .white
    }
    
    private func setupConstraints() {
        backgrounView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        pageControlStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(186)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
    }
}

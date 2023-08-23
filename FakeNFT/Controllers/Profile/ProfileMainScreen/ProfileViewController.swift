import UIKit
import SnapKit
import Kingfisher

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    private let profileView = ProfileView()
    private let analyticsService = AnalyticsService.shared
    private let alertService = AlertService()
    
    init(presenter: ProfileViewPresenterProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        analyticsService.report(event: .open, screen: .profileVC, item: nil)
        setupNavigationBar()
        setupViews()
        setupTargets()
        setupProfileTableView()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		presenter?.fetchProfile()
	}
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: .close, screen: .profileVC, item: nil)
    }
    
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
        DispatchQueue.main.async {
            self.profileView.profileName.text = profile.name
            self.profileView.profileDescription.text = profile.description
            self.profileView.websiteButton.setTitle(profile.website, for: .normal)
            self.profileView.profileImage.kf.indicatorType = .activity
            self.profileView.profileImage.kf.setImage(with: profile.avatar, placeholder: UIImage(named: "placeholderImage"), options: [.transition(.fade(0.5))])
            self.profileView.profileTableView.reloadData()
        }
    }
    
    private func setupProfileTableView() {
        profileView.profileTableView.dataSource = self
        profileView.profileTableView.delegate = self
        profileView.profileTableView.register(ProfileTableViewCell.self,
                                              forCellReuseIdentifier: "ProfileTableViewCell")
    }
    
    private func setupTargets() {
        profileView.websiteButton.addTarget(self, action: #selector(switchToAuthorInformation), for: .touchUpInside)
        profileView.websiteButton.addTarget(self, action: #selector(sendReport), for: .touchUpInside)
    }
    
    @objc private func switchToAuthorInformation() {
        guard let customNC = navigationController as? CustomNavigationController,
              let webViewController = presenter?.switchToAuthorInformation() else { return }
        customNC.pushViewController(webViewController, animated: true)
    }
    
    @objc private func sendReport() {
        analyticsService.report(event: .click, screen: .profileVC, item: .profileWebsite)
    }
    
    @objc private func swithToEditingVC() {
        let editingProfileVC = EditingProfileViewController(profilePresenter: presenter)
        analyticsService.report(event: .click, screen: .profileVC, item: .editProfile)
        present(editingProfileVC, animated: true)
    }
    
    @objc private func switchToMyNFTViewController() {
        guard let customNC = navigationController as? CustomNavigationController else { return }
        let myNFTVC = MyNFTViewController(profilePresenter: presenter, likes: presenter?.profile?.likes)
        analyticsService.report(event: .click, screen: .profileVC, item: .myNFTs)
        customNC.pushViewController(myNFTVC, animated: true)
    }
    
    @objc private func switchToFavoritesNFTViewController() {
        guard let customNC = navigationController as? CustomNavigationController else { return }
        let favoritesNFTVC = FavoritesNFTViewController()
        analyticsService.report(event: .click, screen: .profileVC, item: .favoriteNFTs)
        customNC.pushViewController(favoritesNFTVC, animated: true)
    }
}

//MARK: UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell,
              let presenter = presenter else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            cell.configureCell(label: LocalizableConstants.Profile.myNFT + " (\(presenter.profile?.nfts?.count ?? 0))")
        case 1:
            cell.configureCell(label: LocalizableConstants.Profile.nftFavorites + " (\(presenter.profile?.likes?.count ?? 0))")
        case 2:
            cell.configureCell(label: LocalizableConstants.Profile.aboutDeveloper)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
    
}

//MARK: UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            switchToMyNFTViewController()
        case 1:
            switchToFavoritesNFTViewController()
        case 2:
            analyticsService.report(event: .click, screen: .profileVC, item: .aboutDeveloper)
            switchToAuthorInformation()
        default:
            break
        }
    }
}

//MARK: Alerts
extension ProfileViewController {
    func showErrorAlert() {
        guard let model = presenter?.getErrorModel() else { return }
        DispatchQueue.main.async {
            self.alertService.showErrorAlert(model: model, controller: self)
        }
    }
}

//MARK: setupViews
extension ProfileViewController {
    private func setupNavigationBar() {
        let rightButton = UIButton(type: .system)
        rightButton.setImage(Resourses.Images.Button.editingButton, for: .normal)
        rightButton.tintColor = .blackDay
        rightButton.addTarget(self, action: #selector(swithToEditingVC), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupViews() {
        view.backgroundColor = .backgroundDay
        view.addSubview(profileView.profileImage)
        view.addSubview(profileView.profileName)
        view.addSubview(profileView.profileDescription)
        view.addSubview(profileView.websiteButton)
        view.addSubview(profileView.profileTableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        profileView.profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        profileView.profileName.snp.makeConstraints { make in
            make.leading.equalTo(profileView.profileImage.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(profileView.profileImage)
        }
        
        profileView.profileDescription.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(profileView.profileImage.snp.bottom).offset(20)
        }
        
        profileView.websiteButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-16)
            make.top.equalTo(profileView.profileDescription.snp.bottom).offset(8)
        }
        
        profileView.profileTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(162)
            make.top.equalTo(profileView.websiteButton.snp.bottom).offset(40)
        }
    }
}

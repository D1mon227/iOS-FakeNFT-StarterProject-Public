import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    private let profileView = ProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupProfileTableView()
    }
    
    private func setupProfileTableView() {
        profileView.profileTableView.dataSource = self
        profileView.profileTableView.delegate = self
        profileView.profileTableView.register(ProfileTableViewCell.self,
                                              forCellReuseIdentifier: "ProfileTableViewCell")
    }
    
    @objc private func swithToEditingVC() {
        let editingProfileVC = EditingProfileViewController()
        present(editingProfileVC, animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            cell.configureCell(label: LocalizableConstants.Profile.myNFT + " (112)")
        case 1:
            cell.configureCell(label: LocalizableConstants.Profile.nftFavorites + " (11)")
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

extension ProfileViewController: UITableViewDelegate {
    
}

extension ProfileViewController {
    private func setupNavigationBar() {
        let rightButton = UIButton(type: .system)
        rightButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        rightButton.tintColor = .blackDay
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        rightButton.addTarget(self, action: #selector(swithToEditingVC), for: .touchUpInside)
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

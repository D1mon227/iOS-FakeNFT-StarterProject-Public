import UIKit
import SnapKit
import Kingfisher

final class EditingProfileViewController: UIViewController, EditingProfileViewControllerProtocol {
    var presenter: EditingProfileViewPresenterProtocol?
    private var profilePresenter: ProfileViewPresenterProtocol?
    private let editingProfileView = EditingProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupEditingTableView()
        setupTarget()
        presenter?.getProfileInfo()
    }
    
    init(profilePresenter: ProfileViewPresenterProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.profilePresenter = profilePresenter
        self.presenter = EditingProfileViewPresenter(profilePresenter: profilePresenter)
        self.presenter?.view = self
        self.presenter?.newProfile = NewProfile()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.editProfile()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupEditingTableView() {
        editingProfileView.editingTableView.dataSource = self
        editingProfileView.editingTableView.delegate = self
        editingProfileView.editingTableView.register(EditingProfileTableViewCell.self, forCellReuseIdentifier: "EditingProfileTableViewCell")
        editingProfileView.editingTableView.register(EditingProfileTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "EditingProfileTableViewHeader")
    }
    
    private func setupTarget() {
        editingProfileView.closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    func reloadTableView() {
        guard let avatar = presenter?.editingInfo?.avatar else { return }
        editingProfileView.editingTableView.reloadData()
        editingProfileView.profileImage.kf.setImage(with: avatar)
    }
}

extension EditingProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditingProfileTableViewCell", for: indexPath) as? EditingProfileTableViewCell,
              let profile = presenter?.editingInfo else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            cell.configureCell(text: profile.name)
        case 1:
            cell.configureMiddleCell(text: profile.description)
        case 2:
            cell.configureCell(text: profile.website)
        default:
            break
        }
        
        cell.didTextChange = { [weak self] newText in
            guard let self = self else { return }
            switch indexPath.section {
            case 0:
                self.presenter?.newProfile?.name = newText
            case 1:
                self.presenter?.newProfile?.description = newText
            case 2:
                self.presenter?.newProfile?.website = newText
            default:
                break
            }
        }
        
        return cell
    }
}

extension EditingProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "EditingProfileTableViewHeader") as? EditingProfileTableViewHeader else { return UIView() }
        
        switch section {
        case 0:
            header.configureHeader(text: LocalizableConstants.Profile.name)
        case 1:
            header.configureHeader(text: LocalizableConstants.Profile.description)
        case 2:
            header.configureHeader(text: LocalizableConstants.Profile.website)
        default:
            break
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 44
        case 1:
            return 120
        case 2:
            return 44
        default:
            return 120
        }
    }
}

extension EditingProfileViewController {
    private func setupViews() {
        view.backgroundColor = .backgroundDay
        view.addSubview(editingProfileView.closeButton)
        view.addSubview(editingProfileView.profileImage)
        view.addSubview(editingProfileView.frontImage)
        view.addSubview(editingProfileView.editingPhotoButton)
        view.addSubview(editingProfileView.editingTableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        editingProfileView.closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(42)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(30)
        }
        
        editingProfileView.profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.centerX.equalToSuperview()
            make.top.equalTo(editingProfileView.closeButton.snp.bottom).offset(22)
        }
        
        editingProfileView.frontImage.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.centerX.equalToSuperview()
            make.top.equalTo(editingProfileView.closeButton.snp.bottom).offset(22)
        }
        
        editingProfileView.editingPhotoButton.snp.makeConstraints { make in
            make.center.equalTo(editingProfileView.profileImage)
            make.width.height.equalTo(70)
        }
        
        editingProfileView.editingTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(editingProfileView.profileImage.snp.bottom).offset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

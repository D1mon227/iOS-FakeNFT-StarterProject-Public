import UIKit
import SnapKit

final class EditingProfileViewController: UIViewController {
    private let editingProfileView = EditingProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupEditingTableView()
        setupTarget()
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
}

extension EditingProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension EditingProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditingProfileTableViewCell", for: indexPath) as? EditingProfileTableViewCell else { return UITableViewCell() }
        
        cell.editingTextField.delegate = self
        cell.editingTextView.delegate = self
        
        switch indexPath.section {
        case 0:
            cell.configureCell(text: "Joaquin Phoenix")
        case 1:
            cell.configureMiddleCell(text: "Дизайнер из Казани, люблю цифровое искусство\nи бейглы. В моей коллекции уже 100+ NFT,\nи еще больше — на моём сайте. Открыт\nк коллаборациям.")
        case 2:
            cell.configureCell(text: "Joaquin Phoenix.com")
        default:
            break
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

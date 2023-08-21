import Foundation

final class EditingProfileViewPresenter: EditingProfileViewPresenterProtocol {
    weak var view: EditingProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private var profilePresenter: ProfileViewPresenterProtocol?
    
    var newProfile: NewProfile?
    var editingInfo: Profile? {
        didSet {
            view?.reloadTableView()
        }
    }
    
    init(profilePresenter: ProfileViewPresenterProtocol?) {
        self.profilePresenter = profilePresenter
    }
    
    func getProfileInfo() {
        guard let profile = profilePresenter?.profile else { return }
        editingInfo = profile
        newProfile = NewProfile(name: profile.name,
                                description: profile.description,
                                website: profile.website)
    }
    
    func editProfile() {
        guard let newProfile = newProfile,
              let oldProfile = profilePresenter?.profile else { return }
        
        if newProfile.isEqual(to: oldProfile) {
            return
        } else {
            profileService.editProfile(newProfile: newProfile) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let newProfile):
                    self.profilePresenter?.profile = newProfile
                case .failure(_):
                    self.view?.showErrorAlert()
                }
            }
        }
    }
    
    func getErrorModel() -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.failedLoadDataMessage,
                                    buttonText: LocalizableConstants.Auth.Alert.tryAgainButton) { [weak self] in
            guard let self = self else { return }
            self.editProfile()
        }
        return model
    }
}

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
            profileService.editProfile(newProfile: newProfile) { result in
                switch result {
                case .success(let newProfile):
                    self.profilePresenter?.profile = newProfile
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

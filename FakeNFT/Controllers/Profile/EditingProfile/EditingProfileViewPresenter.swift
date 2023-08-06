import Foundation

final class EditingProfileViewPresenter: EditingProfileViewPresenterProtocol {
    weak var view: EditingProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private var profilePresenter: ProfileViewPresenterProtocol?
    
    var editingInfo: Profile? {
        didSet {
            view?.reloadTableView()
        }
    }
    
    init(profilePresenter: ProfileViewPresenterProtocol?) {
        self.profilePresenter = profilePresenter
    }
    
    func editProfile(newProfile: NewProfile?) {
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

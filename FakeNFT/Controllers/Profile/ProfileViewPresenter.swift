import Foundation

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    
    var profile: Profile? {
        didSet {
            DispatchQueue.main.async {
                self.view?.updateProfileDetails(profile: self.profile)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    func fetchProfile() {
        profileService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

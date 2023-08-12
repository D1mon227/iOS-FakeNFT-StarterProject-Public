import Foundation

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
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
    
    func switchToAuthorInformation() -> WebViewController? {
        guard let website = profile?.website,
              let url = URL(string: website) else { return nil }
        let webViewPresenter = WebViewPresenter(urlRequest: URLRequest(url: url))
        let webViewController = WebViewController(presenter: webViewPresenter)
        webViewPresenter.view = webViewController
        
        return webViewController
    }
}

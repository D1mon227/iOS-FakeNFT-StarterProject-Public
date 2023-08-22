import Foundation

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    
    var profile: Profile? {
        didSet {
            DispatchQueue.main.async {
                self.view?.updateProfileDetails(profile: self.profile)
            }
        }
    }
    
    func fetchProfile() {
        profileService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(_):
                self.view?.showErrorAlert()
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
    
    func getErrorModel() -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.failedLoadDataMessage,
                                    buttonText: LocalizableConstants.Auth.Alert.tryAgainButton) { [weak self] in
            guard let self = self else { return }
            self.fetchProfile()
        }
        return model
    }
}

import UIKit

protocol WebViewPresenterProtocol {
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
}

final class WebViewPresenter {
    
    //MARK: - Properties
    weak var view: WebViewControllerProtocol?
    private let urlRequest: URLRequest
    
    //MARK: - LifeCycle
    init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }
    
    //MARK: - Functions
    func viewDidLoad() {
        view?.load(request: urlRequest)
        
        didUpdateProgressValue(0)
    }
}

extension WebViewPresenter: WebViewPresenterProtocol {
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
}

import UIKit

enum Sort: String, CaseIterable {
    case byName
    case byNFTQuantity
    case byPrice
    case byRating
    case byTitle
    case close
    
    var localizedString: String {
        switch self {
        case .byName:
            return LocalizableConstants.Sort.byName
        case .byNFTQuantity:
            return LocalizableConstants.Sort.byNFTQuantity
        case .byPrice:
            return LocalizableConstants.Sort.byPrice
        case .byRating:
            return LocalizableConstants.Sort.byRating
        case .byTitle:
            return LocalizableConstants.Sort.byTitle
        case .close:
            return LocalizableConstants.Sort.close
        }
    }
}

final class AlertService {
    func showAlert(title: String?, actions: [Sort], controller: UIViewController, completion: @escaping (Sort) -> Void) {
        
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        for action in actions {
            if action == .close {
                let action = UIAlertAction(title: action.localizedString, style: .cancel) { _ in
                    completion(action)
                }
                alert.addAction(action)
            } else {
                let action = UIAlertAction(title: action.localizedString, style: .default) { _ in
                    completion(action)
                }
                alert.addAction(action)
            }
        }
        controller.present(alert, animated: true, completion: nil)
    }
}

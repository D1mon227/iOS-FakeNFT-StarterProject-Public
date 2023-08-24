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

final class AlertService: AlertServiceProtocol {
    func showSortAlert(model: AlertSortModel, controller: UIViewController) {
        
        let alert = UIAlertController(title: LocalizableConstants.Sort.sort,
                                      message: nil,
                                      preferredStyle: .actionSheet)

        for action in model.actions {
            if action == .close {
                let action = UIAlertAction(title: action.localizedString, style: .cancel) { _ in
                    model.completion(action)
                }
                alert.addAction(action)
            } else {
                let action = UIAlertAction(title: action.localizedString, style: .default) { _ in
                    model.completion(action)
                }
                alert.addAction(action)
            }
        }
        controller.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(model: AlertErrorModel, controller: UIViewController) {

        let alert = UIAlertController(title: LocalizableConstants.Auth.Alert.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let leftAction = UIAlertAction(title: model.leftButton, style: .cancel)
        alert.addAction(leftAction)
        
        if model.numberOfButtons == 2 {
            let rightAction = UIAlertAction(title: model.rightButton, style: .default) { _ in
                model.completion()
            }
            alert.addAction(rightAction)
        }
        
        controller.present(alert, animated: true, completion: nil)
    }
}

import UIKit

extension UIViewController {
    func presentAlertWith(model: AlertProtocol) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: model.preferredStyle
        )
        
        model.actions.forEach { actionModel in
            let action = UIAlertAction(title: actionModel.title,
                                       style: actionModel.style,
                                       handler: actionModel.handler)
            action.setValue(actionModel.titleTextColor,
                            forKey: "titleTextColor")
            
            alert.addAction(action)
            alert.preferredAction = action
        }
        
        present(alert, animated: true, completion: nil)
    }
}



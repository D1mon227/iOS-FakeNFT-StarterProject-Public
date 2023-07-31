import UIKit

extension UIViewController {
    func presentAlertWith(model: AlertProtocol) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: model.preferredStyle
        )
        if let firstActionModel = model.firstAction {
            let firstAction = UIAlertAction(title: firstActionModel.title,
                                            style: firstActionModel.style,
                                            handler: firstActionModel.handler)
            firstAction.setValue(firstActionModel.titleTextColor,
                                 forKey: "titleTextColor")
            
            alert.addAction(firstAction)
            alert.preferredAction = firstAction
        }
        
        if let secondActionModel = model.secondAction {
            let secondAction = UIAlertAction(title: secondActionModel.title,
                                             style: secondActionModel.style,
                                             handler: secondActionModel.handler)
            secondAction.setValue(secondActionModel.titleTextColor,
                                  forKey: "titleTextColor")
            
            alert.addAction(secondAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
}


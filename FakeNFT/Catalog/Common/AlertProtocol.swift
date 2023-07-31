import UIKit

protocol AlertProtocol {
    var title: String { get }
    var message: String? { get }
    var preferredStyle: UIAlertController.Style { get }
    var firstAction: AlertActionProtocol? { get }
    var secondAction: AlertActionProtocol? { get }
    var tintColor: UIColor { get }
}

protocol AlertActionProtocol {
    var title: String { get }
    var style: UIAlertAction.Style { get }
    var handler: ((UIAlertAction) -> Void)? { get }
    var titleTextColor: UIColor { get }
}

struct AlertModel: AlertProtocol {
    let title: String
    let message: String?
    let firstAction: AlertActionProtocol?
    let secondAction: AlertActionProtocol?
    let preferredStyle: UIAlertController.Style
    let tintColor: UIColor
    
    init(title: String,
         message: String? = nil,
         firstAction: AlertActionProtocol? = nil,
         secondAction: AlertActionProtocol? = nil,
         preferredStyle: UIAlertController.Style = .alert,
         tintColor: UIColor) {
        self.title = title
        self.message = message
        self.firstAction = firstAction
        self.secondAction = secondAction
        self.preferredStyle = preferredStyle
        self.tintColor = tintColor
    }
}

struct AlertActionModel: AlertActionProtocol {
    let title: String
    let style: UIAlertAction.Style
    let handler: ((UIAlertAction) -> Void)?
    let titleTextColor: UIColor
    
    init(title: String,
         style: UIAlertAction.Style,
         titleTextColor: UIColor,
         handler: ((UIAlertAction) -> Void)? = nil) {
        self.title = title
        self.style = style
        self.titleTextColor = titleTextColor
        self.handler = handler
    }
}

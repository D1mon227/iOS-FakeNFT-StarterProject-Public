import Foundation

protocol EditingProfileViewPresenterProtocol: AnyObject {
    var view: EditingProfileViewControllerProtocol? { get set }
    var editingInfo: Profile? { get set }
    func editProfile(newProfile: NewProfile?)
}

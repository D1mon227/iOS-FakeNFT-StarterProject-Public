import Foundation

protocol EditingProfileViewPresenterProtocol: AnyObject {
    var view: EditingProfileViewControllerProtocol? { get set }
    var editingInfo: Profile? { get set }
    var newProfile: NewProfile? { get set }
    func getProfileInfo()
    func editProfile()
}

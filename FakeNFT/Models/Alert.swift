import Foundation

struct AlertSortModel {
    let actions: [Sort]
    let completion: ((Sort) -> Void)
}

struct AlertErrorModel {
    let message: String?
    let leftButton: String?
    let rightButton: String?
    let numberOfButtons: Int
    let completion: (() -> Void)
}

import Foundation

struct AlertSortModel {
    let title: String?
    let actions: [Sort]
    let completion: ((Sort) -> Void)
}

struct AlertErrorModel {
    let message: String?
    let buttonText: String?
    let completion: (() -> Void)
}

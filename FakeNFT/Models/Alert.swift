import Foundation

struct AlertSortModel {
    let title: String?
    let actions: [Sort]
    let completion: ((Sort) -> Void)
}

struct AlertErrorModel {
    let title: String?
    let message: String?
}

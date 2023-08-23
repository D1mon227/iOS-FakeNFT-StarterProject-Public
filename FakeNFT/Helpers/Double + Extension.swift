import Foundation

protocol PriceConvertable {
	func convert(price: Double) -> String
}

extension Double {
	static let numberFormatter: NumberFormatter = {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .decimal
		numberFormatter.decimalSeparator = ","
		numberFormatter.minimumFractionDigits = 1
		numberFormatter.maximumFractionDigits = 2
		return numberFormatter
	}()

	func formattedPrice() -> String {
		return Double.numberFormatter.string(from: NSNumber(value: self)) ?? ""
	}
}

extension PriceConvertable {
	func convert(price: Double) -> String {
		return price.formattedPrice()
	}
}

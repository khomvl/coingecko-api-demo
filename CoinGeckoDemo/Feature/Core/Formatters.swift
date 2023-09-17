import Foundation

enum Formatters {
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 8
        formatter.numberStyle = .currency
        return formatter
    }()
}

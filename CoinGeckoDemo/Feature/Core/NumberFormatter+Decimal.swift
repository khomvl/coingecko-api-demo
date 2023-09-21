import Foundation

extension NumberFormatter {
    func string(from decimal: Decimal?) -> String {
        guard let decimal else {
            return "—"
        }
        
        return string(from: NSDecimalNumber(decimal: decimal)) ?? "—"
    }
}

import Foundation

extension NumberFormatter {
    func string(from double: Double?) -> String {
        guard let double else {
            return "—"
        }
        
        return string(from: NSNumber(value: double)) ?? "—"
    }
}

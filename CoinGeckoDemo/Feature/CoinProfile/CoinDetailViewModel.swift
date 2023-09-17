import SwiftUI

struct CoinDetailViewModel: Identifiable {
    var id: String {
        title
    }
    let title: String
    let value: String
}

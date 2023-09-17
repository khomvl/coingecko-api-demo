import SwiftUI

struct CoinDetailView<Value: View>: View {
    let title: String
    @ViewBuilder var value: () -> Value
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
            Spacer()
            value()
        }
    }
}

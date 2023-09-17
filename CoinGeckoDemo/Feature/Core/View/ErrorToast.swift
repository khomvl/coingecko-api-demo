import SwiftUI
import CoinGeckoAPI

struct ErrorToast: View {
    @Binding var error: Error?
    
    var body: some View {
        //TODO: ErrorToast should not be aware of APIError
        if let error = error as? APIError {
            Text(error.status.errorMessage)
                .foregroundColor(.textError)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.backgroundWarningLight))
                .padding(.horizontal)
                .shadow(color: .gray.opacity(0.5), radius: 3)
        } else {
            EmptyView()
        }
    }
}

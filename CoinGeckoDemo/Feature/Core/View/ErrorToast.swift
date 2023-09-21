import SwiftUI
import CoinGeckoAPI

struct ErrorToast: View {
    @Binding var showErrorToast: Bool
    @Binding var errorMessage: String?

    var body: some View {
        VStack {
            if showErrorToast {
                Text(errorMessage ?? "")
                    .foregroundColor(.textError)
                    .font(.body)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.backgroundWarningLight))
                    .padding(.horizontal)
                    .shadow(color: .gray.opacity(0.5), radius: 3)
                    .onTapGesture {
                        withAnimation {
                            self.showErrorToast = false
                        }
                    }
            }
            Spacer()
        }
    }
}

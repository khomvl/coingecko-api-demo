import SwiftUI

struct CoinListItemView: View {
    var viewModel: CoinListItemViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: viewModel.imageUrl) {
                $0.resizable().scaledToFill()
            } placeholder: {
                Circle().shimmer()
            }
            .frame(width: 24, height: 24)
            
            VStack(spacing: 8) {
                HStack {
                    VStack(spacing: 4) {
                        HStack {
                            Text(viewModel.title)
                                .font(.headline)
                                .lineLimit(1)
                            Spacer()
                        }
                        
                        HStack {
                            Text(viewModel.subtitle)
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            Spacer()
                        }
                    }
                    
                    VStack(spacing: 4) {
                        HStack {
                            Spacer()
                            Text(viewModel.price)
                                .font(.callout.bold())
                        }
                        HStack {
                            Spacer()
                            Text(viewModel.priceChange)
                                .font(.caption2)
                        }
                    }
                    .foregroundColor(viewModel.priceColor)
                }
            }
        }
    }
}

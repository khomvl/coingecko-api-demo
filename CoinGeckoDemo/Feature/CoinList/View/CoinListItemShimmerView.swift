import SwiftUI

struct CoinListItemShimmerView: View {
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .shimmer()
                .frame(width: 24, height: 24)
            
            VStack(spacing: 8) {
                HStack {
                    VStack(spacing: 4) {
                        HStack {
                            Rectangle()
                                .shimmer()
                                .frame(width: 80, height: 20)
                            Spacer()
                        }
                        
                        HStack {
                            Rectangle()
                                .shimmer()
                                .frame(width: 120, height: 14)
                            Spacer()
                        }
                    }
                    
                    VStack(spacing: 4) {
                        HStack {
                            Spacer()
                            Rectangle()
                                .shimmer()
                                .frame(width: 120, height: 24)
                        }
                        HStack {
                            Spacer()
                            Rectangle()
                                .shimmer()
                                .frame(width: 50, height: 12)
                        }
                    }
                }
            }
        }
    }
}

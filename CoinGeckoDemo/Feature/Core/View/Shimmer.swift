import SwiftUI

struct Shimmer: View {
    enum Style {
        case primary
        
        var from: Color {
            switch self {
            case .primary:
                return .shimmerPrimaryFrom
            }
        }
        
        var to: Color {
            switch self {
            case .primary:
                return .shimmerPrimaryTo
            }
        }
    }
    
    var style: Style = .primary
    
    @State private var animating: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: style.from, location: 0.0),
                    .init(color: style.from, location: 0.25),
                    .init(color: style.to, location: 0.5),
                    .init(color: style.from, location: 0.75),
                    .init(color: style.from, location: 1),
                ],
                startPoint: UnitPoint(x: animating ? 3 : 1, y: 0.5),
                endPoint: UnitPoint(x: animating ? 0 : -3, y: 0.5)
            )
        }
        .task {
            // FIXME: this makes them animating chaotically
            withAnimation(
                Animation.easeOut
                    .speed(0.3)
                    .repeatForever(autoreverses: false)
            ) {
                animating.toggle()
            }
        }
    }
}

extension Shape {
    func shimmer(_ style: Shimmer.Style = .primary) -> some View {
        Shimmer(style: style).clipShape(self)
    }
}

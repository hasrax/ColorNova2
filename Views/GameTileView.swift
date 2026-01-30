import SwiftUI

struct GameTileView: View {
    let color: Color
    let shape: TileShape
    let size: CGFloat
    let isWrong: Bool
    let shapeMode: Bool
    
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 12)
                .fill(isWrong ? Color.red.opacity(0.3) : Color.white.opacity(0.05))
                .frame(width: size, height: size)
            
            // Shape or circle
            if shapeMode {
                shape.view(color: color, size: size * 0.6)
            } else {
                Circle()
                    .fill(color)
                    .frame(width: size * 0.7, height: size * 0.7)
            }
        }
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .animation(.easeInOut(duration: 0.2), value: isWrong)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

#Preview {
    ZStack {
        GalaxyBackgroundView()
        HStack(spacing: 20) {
            GameTileView(color: .cyan, shape: .circle, size: 80, isWrong: false, shapeMode: false)
            GameTileView(color: .purple, shape: .star, size: 80, isWrong: false, shapeMode: true)
            GameTileView(color: .red, shape: .diamond, size: 80, isWrong: true, shapeMode: true)
        }
    }
}

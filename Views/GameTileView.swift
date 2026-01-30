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
            // Background with border for better visibility
            RoundedRectangle(cornerRadius: 12)
                .fill(isWrong ? Color.red.opacity(0.3) : Color.white.opacity(0.08))
                .frame(width: size, height: size)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
            
            // Shape or circle - Increased size ratio for better visibility
            if shapeMode {
                shape.view(color: color, size: size * 0.7)  // Increased from 0.6
            } else {
                Circle()
                    .fill(color)
                    .frame(width: size * 0.8, height: size * 0.8)  // Increased from 0.7
                    .shadow(color: color.opacity(0.5), radius: 3)  // Added glow
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

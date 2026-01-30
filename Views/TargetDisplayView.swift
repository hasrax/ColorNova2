import SwiftUI

struct TargetDisplayView: View {
    let color: Color
    let shape: TileShape
    let shapeMode: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Find This:")
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
            
            if shapeMode {
                // Show shape
                shape.view(color: color, size: 60)
                    .shadow(color: color.opacity(0.8), radius: 15)
            } else {
                // Show color only
                Circle()
                    .fill(color)
                    .frame(width: 60, height: 60)
                    .shadow(color: color.opacity(0.8), radius: 15)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
    }
}

#Preview {
    ZStack {
        GalaxyBackgroundView()
        VStack(spacing: 30) {
            TargetDisplayView(color: .cyan, shape: .circle, shapeMode: false)
            TargetDisplayView(color: .purple, shape: .star, shapeMode: true)
        }
    }
}

import SwiftUI

struct PlanetNodeView: View {
    let mode: GameMode
    @State private var isPulsing = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Planet circle
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                mode.accentColor.opacity(0.6),
                                mode.accentColor.opacity(0.0)
                            ],
                            center: .center,
                            startRadius: 30,
                            endRadius: 70
                        )
                    )
                    .frame(width: 140, height: 140)
                    .blur(radius: 10)
                    .scaleEffect(isPulsing ? 1.2 : 1.0)
                
                // Planet body
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                mode.accentColor.opacity(0.8),
                                mode.accentColor.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                    .shadow(color: mode.accentColor.opacity(0.5), radius: 15)
                
                // Planet emoji/icon
                Text(mode.planetEmoji)
                    .font(.system(size: 40))
            }
            .scaleEffect(isPulsing ? 1.05 : 1.0)
            
            // Mode name
            VStack(spacing: 2) {
                Text(mode.title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(mode.subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
            ) {
                isPulsing = true
            }
        }
    }
}

#Preview {
    ZStack {
        GalaxyBackgroundView()
        
        VStack(spacing: 40) {
            PlanetNodeView(mode: .easy)
            PlanetNodeView(mode: .moderate)
            PlanetNodeView(mode: .hard)
            PlanetNodeView(mode: .bonus)
        }
    }
}

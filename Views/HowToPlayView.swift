import SwiftUI

struct HowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    @State private var demoColors: [Color] = []
    @State private var demoTarget: Color = .cyan
    
    let steps = [
        ("👀", "Find the Match", "Look at the target color shown at the top"),
        ("👆", "Tap Quickly", "Find and tap the matching tile in the grid"),
        ("⚡️", "Speed Bonus", "Tap within 2 seconds for extra points!"),
        ("🔥", "Build Streaks", "Chain correct answers for massive bonuses"),
        ("⏱️", "Beat the Clock", "Each round has a time limit - stay focused!")
    ]
    
    var body: some View {
        ZStack {
            GalaxyBackgroundView()
            
            VStack(spacing: 0) {
                // Header - FIXED at top
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Text("How to Play")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 50)
                }
                .frame(height: 60)
                .background(Color.black.opacity(0.3))
                
                // Content - MORE SPACE
                ScrollView {
                    VStack(spacing: 20) {
                        // Demo Section - Compact
                        VStack(spacing: 12) {
                            Text("Live Demo")
                                .font(.headline)
                                .foregroundColor(.cyan)
                            
                            HStack(spacing: 20) {
                                // Target
                                VStack(spacing: 6) {
                                    Text("Find This")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                    Circle()
                                        .fill(demoTarget)
                                        .frame(width: 50, height: 50)
                                        .shadow(color: demoTarget.opacity(0.5), radius: 8)
                                }
                                
                                // Arrow
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.white.opacity(0.5))
                                
                                // Grid
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 3), spacing: 6) {
                                    ForEach(0..<9, id: \.self) { index in
                                        Circle()
                                            .fill(index < demoColors.count ? demoColors[index] : Color.gray)
                                            .frame(width: 35, height: 35)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        Divider()
                            .background(Color.white.opacity(0.2))
                            .padding(.horizontal)
                        
                        // Instructions - Compact
                        VStack(spacing: 10) {
                            Text("Instructions")
                                .font(.headline)
                                .foregroundColor(.cyan)
                            
                            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                                HStack(alignment: .top, spacing: 10) {
                                    Text(step.0)
                                        .font(.system(size: 30))
                                        .frame(width: 40)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(step.1)
                                            .font(.subheadline.bold())
                                            .foregroundColor(.white)
                                        Text(step.2)
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    
                                    Spacer()
                                }
                                .padding(10)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Tips - Compact
                        VStack(spacing: 8) {
                            Text("💡 Pro Tips")
                                .font(.headline)
                                .foregroundColor(.yellow)
                            
                            TipRow(icon: "eye.fill", text: "Use peripheral vision", color: .cyan)
                            TipRow(icon: "bolt.fill", text: "Speed = More Points!", color: .orange)
                            TipRow(icon: "flame.fill", text: "5-streak = +5 bonus", color: .red)
                            TipRow(icon: "star.fill", text: "Practice Easy mode first", color: .yellow)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Start button
                        Button(action: { dismiss() }) {
                            Text("Got it! Let's Play")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [.cyan, .blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            generateDemoColors()
        }
    }
    
    func generateDemoColors() {
        var colors: [Color] = []
        let goldenRatio: CGFloat = 0.618033988749895
        var hue: CGFloat = CGFloat.random(in: 0...1)
        
        for _ in 0..<9 {
            hue += goldenRatio
            hue = hue.truncatingRemainder(dividingBy: 1.0)
            colors.append(Color(hue: hue, saturation: 0.9, brightness: 0.85))
        }
        
        demoColors = colors.shuffled()
        demoTarget = demoColors.randomElement() ?? .cyan
    }
}

struct TipRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.body)
                .frame(width: 25)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

#Preview {
    HowToPlayView()
}

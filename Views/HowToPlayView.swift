import SwiftUI

struct HowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    @State private var demoColors: [Color] = []
    @State private var demoTarget: Color = .cyan
    
    let steps = [
        ("👀 Find the Match", "Look at the target color shown at the top"),
        ("👆 Tap Quickly", "Find and tap the matching tile in the grid"),
        ("⚡️ Speed Bonus", "Tap within 2 seconds for extra points!"),
        ("🔥 Build Streaks", "Chain correct answers for massive bonuses"),
        ("⏱️ Beat the Clock", "Each round has a time limit - stay focused!")
    ]
    
    var body: some View {
        ZStack {
            GalaxyBackgroundView()
            
            VStack(spacing: 0) {
                // Header - FIXED positioning
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
                    
                    // Spacer for symmetry
                    Color.clear.frame(width: 50)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .background(Color.black.opacity(0.3))
                
                // FIXED: Proper ScrollView starting from top
                ScrollView {
                    VStack(spacing: 25) {
                        // Demo Section
                        VStack(spacing: 15) {
                            Text("Live Demo")
                                .font(.title2.bold())
                                .foregroundColor(.cyan)
                                .padding(.top, 20)
                            
                            // Target Display
                            VStack(spacing: 10) {
                                Text("Find This Color")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Circle()
                                    .fill(demoTarget)
                                    .frame(width: 60, height: 60)
                                    .shadow(color: demoTarget.opacity(0.6), radius: 10)
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(15)
                            
                            // Demo Grid
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                                ForEach(0..<9, id: \.self) { index in
                                    Circle()
                                        .fill(index < demoColors.count ? demoColors[index] : Color.gray)
                                        .frame(height: 60)
                                        .shadow(color: (index < demoColors.count ? demoColors[index] : Color.gray).opacity(0.4), radius: 5)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(15)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                            .padding(.vertical, 10)
                        
                        // Instructions
                        VStack(spacing: 15) {
                            Text("Instructions")
                                .font(.title2.bold())
                                .foregroundColor(.cyan)
                            
                            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                                HStack(alignment: .top, spacing: 12) {
                                    Text(step.0)
                                        .font(.system(size: 35))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(step.1)
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white.opacity(0.08))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Tips
                        VStack(spacing: 12) {
                            Text("💡 Pro Tips")
                                .font(.title3.bold())
                                .foregroundColor(.yellow)
                            
                            TipRow(icon: "eye.fill", text: "Use peripheral vision", color: .cyan)
                            TipRow(icon: "bolt.fill", text: "Speed = More Points!", color: .orange)
                            TipRow(icon: "flame.fill", text: "5-streak = +5 bonus", color: .red)
                            TipRow(icon: "star.fill", text: "Practice Easy mode first", color: .yellow)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(15)
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
                                .cornerRadius(15)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
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
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
                .frame(width: 30)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }
}

#Preview {
    HowToPlayView()
}

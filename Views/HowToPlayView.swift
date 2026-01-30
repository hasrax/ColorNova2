import SwiftUI

struct HowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentStep = 0
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
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("How to Play")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 30)
                }
                .padding()
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Demo Section
                        VStack(spacing: 20) {
                            Text("Live Demo")
                                .font(.title2.bold())
                                .foregroundColor(.cyan)
                            
                            // Target Display
                            VStack(spacing: 10) {
                                Text("Find This Color")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Circle()
                                    .fill(demoTarget)
                                    .frame(width: 80, height: 80)
                                    .shadow(color: demoTarget.opacity(0.6), radius: 15)
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(20)
                            
                            // Demo Grid
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                                ForEach(0..<9, id: \.self) { index in
                                    Circle()
                                        .fill(index < demoColors.count ? demoColors[index] : Color.gray)
                                        .frame(height: 70)
                                        .shadow(color: (index < demoColors.count ? demoColors[index] : Color.gray).opacity(0.5), radius: 5)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(20)
                        }
                        .padding()
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                            .padding(.vertical)
                        
                        // Instructions
                        VStack(spacing: 20) {
                            Text("Instructions")
                                .font(.title2.bold())
                                .foregroundColor(.cyan)
                            
                            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                                HStack(alignment: .top, spacing: 15) {
                                    Text(step.0)
                                        .font(.system(size: 40))
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(step.1)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white.opacity(0.08))
                                .cornerRadius(15)
                            }
                        }
                        .padding()
                        
                        // Tips
                        VStack(spacing: 15) {
                            Text("💡 Pro Tips")
                                .font(.title3.bold())
                                .foregroundColor(.yellow)
                            
                            TipRow(icon: "eye.fill", text: "Use your peripheral vision - don't fixate!", color: .cyan)
                            TipRow(icon: "bolt.fill", text: "Speed = More Points!", color: .orange)
                            TipRow(icon: "flame.fill", text: "5-streak = +5 bonus points", color: .red)
                            TipRow(icon: "star.fill", text: "Practice on Easy mode first", color: .yellow)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(20)
                        .padding()
                        
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
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }
}

#Preview {
    HowToPlayView()
}

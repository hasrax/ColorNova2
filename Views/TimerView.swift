import SwiftUI

struct TimerView: View {
    let icon: String
    let label: String
    let time: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text("\(time)s")
                .font(.title3.bold())
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(color.opacity(0.2))
        .cornerRadius(15)
    }
}

#Preview {
    ZStack {
        GalaxyBackgroundView()
        HStack {
            TimerView(icon: "hourglass", label: "Session", time: 45, color: .cyan)
            TimerView(icon: "timer", label: "Round", time: 15, color: .purple)
        }
    }
}

import SwiftUI

struct AchievementsView: View {
    @StateObject private var viewModel = AchievementViewModel()
    @Environment(\.dismiss) var dismiss
    
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
                    
                    Text("⭐️ Achievements")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 50)
                }
                .frame(height: 60)
                .background(Color.black.opacity(0.3))
                
                // Progress bar - Compact
                VStack(spacing: 6) {
                    HStack {
                        Text("Progress")
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(viewModel.unlockedCount)/\(viewModel.totalCount)")
                            .font(.subheadline.bold())
                            .foregroundColor(.cyan)
                    }
                    
                    ProgressView(value: viewModel.progressPercentage)
                        .tint(.cyan)
                        .scaleEffect(y: 1.5)
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                // Achievements list - MORE SPACE
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.achievements) { achievement in
                            AchievementRowView(achievement: achievement)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct AchievementRowView: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Text(achievement.emoji)
                .font(.system(size: 35))
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(achievement.unlocked ? Color.yellow.opacity(0.2) : Color.white.opacity(0.05))
                )
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.subheadline.bold())
                    .foregroundColor(achievement.unlocked ? .white : .white.opacity(0.5))
                
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
                
                if achievement.unlocked, let date = achievement.dateUnlocked {
                    Text("Unlocked \(date.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption2)
                        .foregroundColor(.cyan)
                }
            }
            
            Spacer()
            
            // Lock/unlock indicator
            Image(systemName: achievement.unlocked ? "checkmark.circle.fill" : "lock.fill")
                .foregroundColor(achievement.unlocked ? .green : .white.opacity(0.3))
                .font(.title3)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(achievement.unlocked ? Color.white.opacity(0.1) : Color.white.opacity(0.03))
        )
        .opacity(achievement.unlocked ? 1.0 : 0.6)
    }
}

#Preview {
    AchievementsView()
}

import SwiftUI

struct AchievementsView: View {
    @StateObject private var viewModel = AchievementViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            GalaxyBackgroundView()
            
            VStack(spacing: 0) {
                // Header - MOVED HIGHER
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("⭐️ Achievements")
                        .font(.largeTitle.bold())  // Made bigger
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 30)
                }
                .padding(.horizontal)
                .padding(.top, 20)  // Added top padding
                .padding(.bottom, 30)  // More space below title
                
                // Progress bar
                VStack(spacing: 8) {
                    HStack {
                        Text("Progress")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(viewModel.unlockedCount)/\(viewModel.totalCount)")
                            .font(.headline)
                            .foregroundColor(.cyan)
                    }
                    
                    ProgressView(value: viewModel.progressPercentage)
                        .tint(.cyan)
                        .scaleEffect(y: 2)
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(15)
                .padding(.horizontal)
                .padding(.bottom, 20)  // More space before achievements
                
                // Achievements list
                ScrollView {
                    VStack(spacing: 15) {  // Increased spacing
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
        HStack(spacing: 15) {
            // Icon
            Text(achievement.emoji)
                .font(.system(size: 40))
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(achievement.unlocked ? Color.yellow.opacity(0.2) : Color.white.opacity(0.05))
                )
            
            // Info
            VStack(alignment: .leading, spacing: 6) {  // More spacing
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(achievement.unlocked ? .white : .white.opacity(0.5))
                
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                
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
            RoundedRectangle(cornerRadius: 15)
                .fill(achievement.unlocked ? Color.white.opacity(0.1) : Color.white.opacity(0.03))
        )
        .opacity(achievement.unlocked ? 1.0 : 0.6)
    }
}

#Preview {
    AchievementsView()
}

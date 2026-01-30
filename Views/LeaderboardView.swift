import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            GalaxyBackgroundView()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("🏆 Leaderboard")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Color.clear.frame(width: 30)
                }
                .padding()
                
                // Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        FilterButton(
                            title: "All Modes",
                            isSelected: viewModel.selectedMode == nil
                        ) {
                            viewModel.selectedMode = nil
                        }
                        
                        ForEach(GameMode.allCases.filter { $0 != .bonus }) { mode in
                            FilterButton(
                                title: mode.title,
                                isSelected: viewModel.selectedMode == mode
                            ) {
                                viewModel.selectedMode = mode
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Top scores list
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(Array(viewModel.filteredScores.enumerated()), id: \.element.id) { index, entry in
                            LeaderboardRowView(
                                rank: index + 1,
                                entry: entry
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.fetchTopScores()
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundColor(isSelected ? .black : .white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? Color.yellow : Color.white.opacity(0.1))
                .cornerRadius(20)
        }
    }
}

struct LeaderboardRowView: View {
    let rank: Int
    let entry: ScoreEntry
    
    var body: some View {
        HStack(spacing: 15) {
            // Rank medal
            Text(rankEmoji)
                .font(.title2)
                .frame(width: 40)
            
            // Player info
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    Text(entry.mode.title)
                        .font(.caption)
                        .foregroundColor(entry.mode.accentColor)
                    
                    if entry.shapeMode {
                        Text("✨ Shapes")
                            .font(.caption)
                            .foregroundColor(.purple)
                    }
                }
            }
            
            Spacer()
            
            // Score
            Text("\(entry.score)")
                .font(.title2.bold())
                .foregroundColor(.yellow)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(rank <= 3 ? 0.15 : 0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(rank <= 3 ? Color.yellow.opacity(0.5) : Color.clear, lineWidth: 2)
                )
        )
    }
    
    var rankEmoji: String {
        switch rank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "\(rank)"
        }
    }
}

#Preview {
    LeaderboardView()
}

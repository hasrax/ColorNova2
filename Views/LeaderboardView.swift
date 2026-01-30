import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
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
                    
                    Text("🏆 Leaderboard")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 50)
                }
                .frame(height: 60)
                .background(Color.black.opacity(0.3))
                
                // Filters - Compact
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
                .frame(height: 50)
                .padding(.vertical, 10)
                
                // Top scores list - MORE SPACE
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(Array(viewModel.aggregatedScores.enumerated()), id: \.element.userId) { index, entry in
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
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.yellow : Color.white.opacity(0.1))
                .cornerRadius(20)
        }
    }
}

struct LeaderboardRowView: View {
    let rank: Int
    let entry: AggregatedScore
    
    var body: some View {
        HStack(spacing: 12) {
            // Rank
            Text(rankEmoji)
                .font(.title3)
                .frame(width: 35)
            
            // Player info
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 6) {
                    Text(entry.mode.title)
                        .font(.caption)
                        .foregroundColor(entry.mode.accentColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(entry.mode.accentColor.opacity(0.2))
                        .cornerRadius(6)
                    
                    if entry.shapeMode {
                        HStack(spacing: 2) {
                            Image(systemName: "sparkles")
                                .font(.caption2)
                            Text("Shapes")
                                .font(.caption)
                        }
                        .foregroundColor(.purple)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.purple.opacity(0.2))
                        .cornerRadius(6)
                    }
                }
            }
            
            Spacer()
            
            // Total Score
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(entry.totalScore)")
                    .font(.title3.bold())
                    .foregroundColor(.yellow)
                Text("total")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(rank <= 3 ? 0.15 : 0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(rank <= 3 ? Color.yellow.opacity(0.5) : Color.clear, lineWidth: 1.5)
                )
        )
    }
    
    private var rankEmoji: String {
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

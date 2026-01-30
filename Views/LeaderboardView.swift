import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
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
                    
                    Text("🏆 Leaderboard")
                        .font(.largeTitle.bold())  // Made bigger
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Color.clear.frame(width: 30)
                }
                .padding(.horizontal)
                .padding(.top, 20)  // Added top padding
                .padding(.bottom, 30)  // More space below title
                
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
                .padding(.bottom, 20)  // More space before scores
                
                // Top scores list
                ScrollView {
                    VStack(spacing: 15) {  // Increased spacing
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
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? Color.yellow : Color.white.opacity(0.1))
                .cornerRadius(20)
        }
    }
}

struct LeaderboardRowView: View {
    let rank: Int
    let entry: AggregatedScore
    
    var body: some View {
        HStack(spacing: 15) {
            // Rank medal
            Text(rankEmoji)
                .font(.title2)
                .frame(width: 40)
            
            // Player info
            VStack(alignment: .leading, spacing: 6) {  // More spacing
                Text(entry.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    Text(entry.mode.title)
                        .font(.caption)
                        .foregroundColor(entry.mode.accentColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(entry.mode.accentColor.opacity(0.2))
                        .cornerRadius(8)
                    
                    // ADDED: Show shape mode info
                    if entry.shapeMode {
                        HStack(spacing: 4) {
                            Image(systemName: "sparkles")
                                .font(.caption2)
                            Text("Shapes")
                                .font(.caption)
                        }
                        .foregroundColor(.purple)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.purple.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
            }
            
            Spacer()
            
            // Total Score
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(entry.totalScore)")
                    .font(.title2.bold())
                    .foregroundColor(.yellow)
                Text("total")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.5))
            }
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
    
    private var rankEmoji: String {
        switch rank {
        case 1: return "����"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "\(rank)"
        }
    }
}

#Preview {
    LeaderboardView()
}

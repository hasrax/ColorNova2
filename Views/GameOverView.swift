import SwiftUI

struct GameOverView: View {
    @ObservedObject var viewModel: GameViewModel
    let mode: GameMode
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var leaderboardViewModel = LeaderboardViewModel()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Rank emoji
                Text(rankEmoji)
                    .font(.system(size: 80))
                
                Text("Game Over!")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                // Score card
                VStack(spacing: 15) {
                    ScoreRowView(label: "Final Score", value: "\(viewModel.score)", color: .yellow)
                    ScoreRowView(label: "Best Streak", value: "\(viewModel.streak)", color: .orange)
                    ScoreRowView(label: "Rank", value: viewModel.getRank(), color: .cyan)
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(20)
                
                // Buttons
                VStack(spacing: 12) {
                    // Play Again
                    Button(action: {
                        viewModel.resetGame()
                        viewModel.startGame(mode: mode)
                    }) {
                        Text("Play Again")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.green, .blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                    }
                    
                    // Back to Map
                    Button(action: {
                        saveScore()
                        viewModel.resetGame()
                        dismiss()
                    }) {
                        Text("Back to Galaxy Map")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 40)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.15, green: 0.1, blue: 0.25),
                                Color(red: 0.1, green: 0.05, blue: 0.2)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: mode.accentColor.opacity(0.5), radius: 30)
            )
            .padding(30)
        }
        .onAppear {
            saveScore()
        }
    }
    
    var rankEmoji: String {
        switch viewModel.score {
        case 0..<20: return "🌱"
        case 20..<50: return "🌟"
        case 50..<80: return "💫"
        case 80..<120: return "🌌"
        default: return "👑"
        }
    }
    
    func saveScore() {
        guard let user = authViewModel.user else { return }
        Task {
            // Save to leaderboard
            await leaderboardViewModel.saveScore(
                userId: user.id,
                name: user.name,
                score: viewModel.score,
                mode: mode,
                shapeMode: viewModel.shapeMode
            )
            
            // Update user stats
            await authViewModel.updateGameStats(score: viewModel.score)
        }
    }
}

struct ScoreRowView: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.white.opacity(0.7))
            Spacer()
            Text(value)
                .font(.title3.bold())
                .foregroundColor(color)
        }
    }
}

#Preview {
    GameOverView(viewModel: GameViewModel(), mode: .easy)
        .environmentObject(AuthViewModel())
}

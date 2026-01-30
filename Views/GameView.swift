import SwiftUI

struct GameView: View {
    let mode: GameMode
    @StateObject private var viewModel = GameViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            GalaxyBackgroundView()
            
            VStack(spacing: 20) {
                // Top bar - FIXED: All in one frame, no spacers
                HStack(spacing: 0) {
                    Button(action: {
                        viewModel.resetGame()
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .frame(width: 80, alignment: .leading)
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("Score")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text("\(viewModel.score)")
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .monospacedDigit()  // Fixed width numbers
                    }
                    .frame(width: 100)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.togglePause()
                    }) {
                        Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .frame(width: 80, alignment: .trailing)
                }
                .frame(height: 60)
                .padding(.horizontal)
                
                HStack(spacing: 20) {
                    TimerView(icon: "hourglass", label: "Session", time: viewModel.sessionTimeRemaining, color: .cyan)
                        .frame(width: 100)
                    
                    VStack(spacing: 4) {
                        Text("🔥")
                            .font(.title2)
                        Text("\(viewModel.streak)")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .monospacedDigit()
                        Text("Streak")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(width: 80)
                    .padding()
                    .background(Color.orange.opacity(0.2))
                    .cornerRadius(15)
                    
                    TimerView(icon: "timer", label: "Round", time: viewModel.roundTimeRemaining, color: .blue)
                        .frame(width: 100)
                }
                .frame(height: 100)
                .padding(.horizontal)
                
                TargetDisplayView(color: viewModel.targetColor, shape: viewModel.targetShape, shapeMode: viewModel.shapeMode)
                    .frame(height: 100)
                    .padding(.vertical, 10)
                
                if viewModel.isGameActive {
                    GameGridView(viewModel: viewModel)
                        .padding()
                } else {
                    VStack(spacing: 20) {
                        Button(action: {
                            viewModel.startGame(mode: mode)
                        }) {
                            Text("Start Game")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(colors: [mode.accentColor, mode.accentColor.opacity(0.6)], startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(15)
                        }
                        .padding(.horizontal, 40)
                        
                        Toggle(isOn: $viewModel.shapeMode) {
                            HStack {
                                Text("✨ Shape Mode")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("(Harder)")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        .tint(.cyan)
                        .padding(.horizontal, 40)
                    }
                }
                
                Spacer()
            }
            
            if let bonus = viewModel.bonusMessage {
                VStack {
                    Text(bonus)
                        .font(.title2.bold())
                        .foregroundColor(.yellow)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(15)
                        .padding(.top, 100)
                    Spacer()
                }
            }
            
            if viewModel.isPaused {
                PauseOverlayView(viewModel: viewModel)
            }
            
            if viewModel.showGameOver {
                GameOverView(viewModel: viewModel, mode: mode)
            }
        }
        .navigationBarBackButtonHidden(true)
        .transaction { transaction in
            transaction.animation = nil  // CRITICAL: Disable ALL animations
        }
    }
}

#Preview {
    GameView(mode: .easy)
        .environmentObject(AuthViewModel())
}

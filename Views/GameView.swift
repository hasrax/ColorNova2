import SwiftUI

struct GameView: View {
    let mode: GameMode
    @StateObject private var viewModel = GameViewModel()
    @State private var showSettings = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            GalaxyBackgroundView()
            
            VStack(spacing: 20) {
                // Top bar
                HStack {
                    // Back button
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
                    
                    Spacer()
                    
                    // Score
                    VStack(spacing: 4) {
                        Text("Score")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text("\(viewModel.score)")
                            .font(.title.bold())
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Pause button
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
                }
                .padding(.horizontal)
                
                // Timer and streak bar
                HStack(spacing: 20) {
                    // Session time
                    TimerView(
                        icon: "hourglass",
                        label: "Session",
                        time: viewModel.sessionTimeRemaining,
                        color: .cyan
                    )
                    
                    // Streak
                    VStack(spacing: 4) {
                        Text("🔥")
                            .font(.title2)
                        Text("\(viewModel.streak)")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        Text("Streak")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding()
                    .background(Color.orange.opacity(0.2))
                    .cornerRadius(15)
                    
                    // Round time
                    TimerView(
                        icon: "timer",
                        label: "Round",
                        time: viewModel.roundTimeRemaining,
                        color: .purple
                    )
                }
                .padding(.horizontal)
                
                // Target display
                TargetDisplayView(
                    color: viewModel.targetColor,
                    shape: viewModel.targetShape,
                    shapeMode: viewModel.shapeMode
                )
                .padding(.vertical, 10)
                
                // Game grid
                if viewModel.isGameActive {
                    GameGridView(viewModel: viewModel)
                        .padding()
                } else {
                    // Start button
                    Button(action: {
                        viewModel.startGame(mode: mode)
                    }) {
                        Text("Start Game")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [mode.accentColor, mode.accentColor.opacity(0.6)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                    }
                    .padding(.horizontal, 40)
                }
                
                // Shape mode toggle
                if !viewModel.isGameActive {
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
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
                    .padding(.horizontal, 40)
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                
                // Tip
                Text("💡 \(mode.tip)")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
            
            // Bonus message overlay
            if let bonus = viewModel.bonusMessage {
                VStack {
                    Text(bonus)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green.opacity(0.8))
                        .cornerRadius(15)
                        .shadow(radius: 10)
                        .transition(.scale.combined(with: .opacity))
                    Spacer()
                }
                .padding(.top, 100)
            }
            
            // Pause overlay
            if viewModel.isPaused && viewModel.isGameActive {
                PauseOverlayView(viewModel: viewModel)
            }
            
            // Game over screen
            if viewModel.showGameOver {
                GameOverView(viewModel: viewModel, mode: mode)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    GameView(mode: .easy)
}

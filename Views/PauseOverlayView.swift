import SwiftUI

struct PauseOverlayView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("⏸️")
                    .font(.system(size: 60))
                
                Text("Game Paused")
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    // Resume
                    Button(action: {
                        viewModel.togglePause()
                    }) {
                        Text("Resume")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(15)
                    }
                    
                    // Shuffle
                    Button(action: {
                        viewModel.shuffleBoard()
                        viewModel.togglePause()
                    }) {
                        Text("🔀 Shuffle Board")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(15)
                    }
                    
                    // Quit
                    Button(action: {
                        viewModel.resetGame()
                        dismiss()
                    }) {
                        Text("Quit Game")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 40)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(red: 0.1, green: 0.05, blue: 0.2))
                    .shadow(radius: 20)
            )
            .padding(40)
        }
    }
}

#Preview {
    PauseOverlayView(viewModel: GameViewModel())
}

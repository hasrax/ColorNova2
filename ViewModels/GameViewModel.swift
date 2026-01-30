import Foundation
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var tiles: [Int] = []  // Just store indices
    @Published var colors: [Color] = []
    @Published var targetIndex: Int = 0
    @Published var targetColor: Color = .clear
    @Published var targetShape: TileShape = .circle
    @Published var score: Int = 0
    @Published var streak: Int = 0
    @Published var roundTimeRemaining: Int = 0
    @Published var sessionTimeRemaining: Int = 0
    @Published var isGameActive: Bool = false
    @Published var isPaused: Bool = false
    @Published var showGameOver: Bool = false
    @Published var shapeMode: Bool = false
    @Published var bonusMessage: String? = nil
    @Published var wrongTileIndex: Int? = nil
    
    var mode: GameMode = .easy
    private var roundTimer: Timer?
    private var sessionTimer: Timer?
    
    func startGame(mode: GameMode) {
        self.mode = mode
        score = 0
        streak = 0
        roundTimeRemaining = mode.roundTime
        sessionTimeRemaining = mode.sessionSeconds
        isGameActive = true
        isPaused = false
        showGameOver = false
        
        generateNewBoard()
        startTimers()
        
        print("✅ GAME STARTED")
    }
    
    func generateNewBoard() {
        let gridCount = mode.gridSize * mode.gridSize
        
        // Generate colors
        colors = []
        let goldenRatio: CGFloat = 0.618033988749895
        var hue: CGFloat = CGFloat.random(in: 0...1)
        
        for _ in 0..<gridCount {
            hue += goldenRatio
            hue = hue.truncatingRemainder(dividingBy: 1.0)
            colors.append(Color(hue: hue, saturation: 0.9, brightness: 0.85))
        }
        
        // Create tile indices (0, 1, 2, 3, etc.)
        tiles = Array(0..<gridCount)
        
        // Shuffle
        tiles.shuffle()
        
        // Pick random target
        targetIndex = Int.random(in: 0..<gridCount)
        targetColor = colors[targetIndex]
        
        print("🎮 NEW BOARD | Target index: \(targetIndex)")
    }
    
    func tileTapped(at index: Int) {
        guard isGameActive, !isPaused else {
            print("⚠️ Game not active")
            return
        }
        guard index < tiles.count else {
            print("⚠️ Invalid index")
            return
        }
        
        let tileValue = tiles[index]
        
        print("👆 TAPPED index \(index), tile value: \(tileValue), target: \(targetIndex)")
        
        if tileValue == targetIndex {
            print("   ✅ CORRECT!")
            handleCorrectTap()
        } else {
            print("   ❌ WRONG!")
            handleWrongTap(at: index)
        }
    }
    
    func handleCorrectTap() {
        var points = 1
        
        let timeTaken = mode.roundTime - roundTimeRemaining
        if timeTaken <= 2 {
            points += 3
            showBonus("⚡️ Speed Bonus +3")
        } else if timeTaken <= 5 {
            points += 2
            showBonus("💨 Quick Bonus +2")
        }
        
        streak += 1
        if streak == 5 {
            points += 5
            showBonus("🔥 5-Streak Bonus +5")
        } else if streak == 3 {
            points += 2
            showBonus("✨ 3-Streak Bonus +2")
        }
        
        score += points
        print("💰 SCORE: \(score) (+\(points))")
        
        roundTimeRemaining = mode.roundTime
        
        // Small delay before new board
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.generateNewBoard()
        }
    }
    
    func handleWrongTap(at index: Int) {
        streak = 0
        wrongTileIndex = index
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.wrongTileIndex = nil
        }
    }
    
    func showBonus(_ message: String) {
        bonusMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.bonusMessage = nil
        }
    }
    
    func startTimers() {
        roundTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, !self.isPaused else { return }
            
            if self.roundTimeRemaining > 0 {
                self.roundTimeRemaining -= 1
            } else {
                self.streak = 0
                self.roundTimeRemaining = self.mode.roundTime
                self.generateNewBoard()
            }
        }
        
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, !self.isPaused else { return }
            
            if self.sessionTimeRemaining > 0 {
                self.sessionTimeRemaining -= 1
            } else {
                self.endGame()
            }
        }
    }
    
    func stopTimers() {
        roundTimer?.invalidate()
        sessionTimer?.invalidate()
    }
    
    func togglePause() {
        isPaused.toggle()
    }
    
    func shuffleBoard() {
        tiles.shuffle()
    }
    
    func endGame() {
        isGameActive = false
        stopTimers()
        showGameOver = true
    }
    
    func resetGame() {
        stopTimers()
        score = 0
        streak = 0
        isGameActive = false
        showGameOver = false
    }
    
    func getRank() -> String {
        switch score {
        case 0..<20: return "Cosmic Rookie"
        case 20..<50: return "Space Explorer"
        case 50..<100: return "Star Navigator"
        case 100..<200: return "Galaxy Master"
        default: return "Universe Legend"
        }
    }
}

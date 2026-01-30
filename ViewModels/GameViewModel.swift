import Foundation
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var tiles: [(color: Color, shape: TileShape)] = []
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
    private var lastTapTime: Date?
    
    // MARK: - Start Game
    
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
    }
    
    // MARK: - Generate Board
    
    func generateNewBoard() {
        let gridCount = mode.gridSize * mode.gridSize
        tiles = []
        
        // Generate distinct colors
        let colors = generateDistinctColors(count: gridCount)
        
        if shapeMode {
            // Generate random shapes
            let shapes = (0..<gridCount).map { _ in TileShape.allCases.randomElement()! }
            
            // Pick a random target
            let targetIndex = Int.random(in: 0..<gridCount)
            targetColor = colors[targetIndex]
            targetShape = shapes[targetIndex]
            
            // Create tiles
            for i in 0..<gridCount {
                tiles.append((color: colors[i], shape: shapes[i]))
            }
        } else {
            // Color-only mode
            targetColor = colors.randomElement()!
            targetShape = .circle // Not used in color-only mode
            
            for color in colors {
                tiles.append((color: color, shape: .circle))
            }
        }
    }
    
    // MARK: - Color Generation
    
    func generateDistinctColors(count: Int) -> [Color] {
        var colors: [Color] = []
        let goldenRatio: CGFloat = 0.618033988749895
        var hue: CGFloat = CGFloat.random(in: 0...1)
        
        for _ in 0..<count {
            hue += goldenRatio
            hue = hue.truncatingRemainder(dividingBy: 1.0)
            let color = Color(hue: hue, saturation: 0.9, brightness: 0.85)
            colors.append(color)
        }
        
        return colors.shuffled()
    }
    
    // MARK: - Tile Tap Logic
    
    func tileTapped(at index: Int) {
        guard isGameActive, !isPaused else { return }
        
        let tile = tiles[index]
        let isCorrect: Bool
        
        if shapeMode {
            isCorrect = (tile.color == targetColor && tile.shape == targetShape)
        } else {
            isCorrect = (tile.color == targetColor)
        }
        
        if isCorrect {
            handleCorrectTap()
        } else {
            handleWrongTap(at: index)
        }
    }
    
    func handleCorrectTap() {
        // Base point
        var points = 1
        
        // Speed bonus
        let timeTaken = mode.roundTime - roundTimeRemaining
        if timeTaken <= 2 {
            points += 3
            showBonus("⚡️ Speed Bonus +3")
        } else if timeTaken <= 5 {
            points += 2
            showBonus("💨 Quick Bonus +2")
        }
        
        // Streak bonus
        streak += 1
        if streak == 5 {
            points += 5
            showBonus("🔥 5-Streak Bonus +5")
        } else if streak == 3 {
            points += 2
            showBonus("✨ 3-Streak Bonus +2")
        }
        
        score += points
        roundTimeRemaining = mode.roundTime
        generateNewBoard()
        lastTapTime = Date()
    }
    
    func handleWrongTap(at index: Int) {
        streak = 0
        wrongTileIndex = index
        
        // Flash red animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.wrongTileIndex = nil
        }
    }
    
    // MARK: - Bonus Message
    
    func showBonus(_ message: String) {
        bonusMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.bonusMessage = nil
        }
    }
    
    // MARK: - Timers
    
    func startTimers() {
        roundTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, !self.isPaused else { return }
            
            if self.roundTimeRemaining > 0 {
                self.roundTimeRemaining -= 1
            } else {
                // Round expired - reset streak and new board
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
                // Game over
                self.endGame()
            }
        }
    }
    
    func stopTimers() {
        roundTimer?.invalidate()
        sessionTimer?.invalidate()
        roundTimer = nil
        sessionTimer = nil
    }
    
    // MARK: - Pause/Resume
    
    func togglePause() {
        isPaused.toggle()
    }
    
    // MARK: - Shuffle
    
    func shuffleBoard() {
        generateNewBoard()
        // Timer keeps running - no penalty
    }
    
    // MARK: - End Game
    
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
        tiles = []
    }
    
    // MARK: - Rank
    
    func getRank() -> String {
        switch score {
        case 0..<20: return "Cosmic Rookie"
        case 20..<50: return "Space Explorer"
        case 50..<80: return "Star Runner"
        case 80..<120: return "Nova Pro"
        default: return "Galaxy Legend"
        }
    }
}

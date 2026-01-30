import Foundation
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var tiles: [(color: Color, shape: TileShape, colorData: ColorData)] = []
    @Published var targetColor: Color = .clear
    @Published var targetColorData: ColorData?
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
    
    // MARK: - Color Data Structure
    struct ColorData: Equatable {
        let hue: CGFloat
        let saturation: CGFloat
        let brightness: CGFloat
        
        static func == (lhs: ColorData, rhs: ColorData) -> Bool {
            return abs(lhs.hue - rhs.hue) < 0.001 &&
                   abs(lhs.saturation - rhs.saturation) < 0.001 &&
                   abs(lhs.brightness - rhs.brightness) < 0.001
        }
    }
    
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
        let colorPairs = generateDistinctColors(count: gridCount)
        
        if shapeMode {
            // Generate random shapes
            let shapes = (0..<gridCount).map { _ in TileShape.allCases.randomElement()! }
            
            // Pick a random target
            let targetIndex = Int.random(in: 0..<gridCount)
            targetColor = colorPairs[targetIndex].color
            targetColorData = colorPairs[targetIndex].colorData
            targetShape = shapes[targetIndex]
            
            // Create tiles
            for i in 0..<gridCount {
                tiles.append((
                    color: colorPairs[i].color,
                    shape: shapes[i],
                    colorData: colorPairs[i].colorData
                ))
            }
        } else {
            // Color-only mode
            let targetIndex = Int.random(in: 0..<gridCount)
            targetColor = colorPairs[targetIndex].color
            targetColorData = colorPairs[targetIndex].colorData
            targetShape = .circle
            
            for pair in colorPairs {
                tiles.append((
                    color: pair.color,
                    shape: .circle,
                    colorData: pair.colorData
                ))
            }
        }
        
        print("🎮 New board generated. Target color: H:\(targetColorData?.hue ?? 0), S:\(targetColorData?.saturation ?? 0), B:\(targetColorData?.brightness ?? 0)")
    }
    
    // MARK: - Shuffle Board
    
    func shuffleBoard() {
        tiles.shuffle()
    }
    
    // MARK: - Get Rank
    
    func getRank() -> String {
        switch score {
        case 0..<20: return "Novice"
        case 20..<50: return "Explorer"
        case 50..<80: return "Star Pilot"
        case 80..<120: return "Galaxy Master"
        default: return "Cosmic Legend"
        }
    }
    
    // MARK: - Color Generation
    
    func generateDistinctColors(count: Int) -> [(color: Color, colorData: ColorData)] {
        var colors: [(color: Color, colorData: ColorData)] = []
        let goldenRatio: CGFloat = 0.618033988749895
        var hue: CGFloat = CGFloat.random(in: 0...1)
        
        for _ in 0..<count {
            hue += goldenRatio
            hue = hue.truncatingRemainder(dividingBy: 1.0)
            
            let colorData = ColorData(hue: hue, saturation: 0.9, brightness: 0.85)
            let color = Color(hue: hue, saturation: 0.9, brightness: 0.85)
            
            colors.append((color: color, colorData: colorData))
        }
        
        return colors.shuffled()
    }
    
    // MARK: - Tile Tap Logic - FIXED
    
    func tileTapped(at index: Int) {
        guard isGameActive, !isPaused else { return }
        guard index < tiles.count else { return }
        
        let tile = tiles[index]
        let isCorrect: Bool
        
        print("🎯 Tile tapped at index \(index)")
        print("   Tile color: H:\(tile.colorData.hue), S:\(tile.colorData.saturation), B:\(tile.colorData.brightness)")
        print("   Target color: H:\(targetColorData?.hue ?? 0), S:\(targetColorData?.saturation ?? 0), B:\(targetColorData?.brightness ?? 0)")
        
        if shapeMode {
            // FIXED: Compare both color AND shape
            isCorrect = (tile.colorData == targetColorData && tile.shape == targetShape)
            print("   Shape mode: Tile shape=\(tile.shape), Target shape=\(targetShape)")
        } else {
            // Color-only mode
            isCorrect = (tile.colorData == targetColorData)
        }
        
        print("   Match result: \(isCorrect ? "✅ CORRECT" : "❌ WRONG")")
        
        if isCorrect {
            handleCorrectTap()
        } else {
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
        print("✅ Correct tap! Score: \(score), Points added: \(points)")
        
        roundTimeRemaining = mode.roundTime
        generateNewBoard()
        lastTapTime = Date()
    }
    
    func handleWrongTap(at index: Int) {
        streak = 0
        wrongTileIndex = index
        print("❌ Wrong tap! Streak reset.")
        
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
    
    // MARK: - Timers
    
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
    
    func endGame() {
        isGameActive = false
        showGameOver = true
        roundTimer?.invalidate()
        sessionTimer?.invalidate()
    }
    
    func togglePause() {
        isPaused.toggle()
    }
    
    func resetGame() {
        isGameActive = false
        roundTimer?.invalidate()
        sessionTimer?.invalidate()
        score = 0
        streak = 0
    }
}

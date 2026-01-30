import SwiftUI

enum GameMode: String, CaseIterable, Identifiable, Codable {
    case easy, moderate, hard, bonus
    
    var id: String { rawValue }
    
    var gridSize: Int {
        switch self {
        case .easy: return 3
        case .moderate: return 5
        case .hard: return 7
        case .bonus: return 4
        }
    }
    
    var roundTime: Int {
        switch self {
        case .easy: return 15
        case .moderate: return 25
        case .hard: return 35
        case .bonus: return 20
        }
    }
    
    var sessionSeconds: Int {
        switch self {
        case .easy: return 45
        case .moderate: return 60
        case .hard: return 75
        case .bonus: return 50
        }
    }
    
    var title: String {
        rawValue.capitalized
    }
    
    var subtitle: String {
        switch self {
        case .easy: return "3×3 Grid"
        case .moderate: return "5×5 Grid"
        case .hard: return "7×7 Grid"
        case .bonus: return "Coming Soon"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .easy: return Color.cyan
        case .moderate: return Color.blue  // Changed from purple
        case .hard: return Color.orange
        case .bonus: return Color.yellow
        }
    }
    
    var planetIcon: String {
        switch self {
        case .easy: return "moon.stars.fill"
        case .moderate: return "sparkles"
        case .hard: return "flame.fill"
        case .bonus: return "star.fill"
        }
    }
    
    var tip: String {
        switch self {
        case .easy: return "Scan corners first — the match pops out."
        case .moderate: return "Use peripheral vision — don't stare too long."
        case .hard: return "Scan rows/columns — it's faster than random."
        case .bonus: return "Multiplayer mode coming soon!"
        }
    }
}

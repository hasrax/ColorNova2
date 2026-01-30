import Foundation

struct ScoreEntry: Identifiable, Codable {
    var id: String = UUID().uuidString
    let userId: String
    let name: String
    let score: Int
    let mode: GameMode
    let shapeMode: Bool
    let timestamp: Date
    
    init(id: String = UUID().uuidString, userId: String, name: String, score: Int, mode: GameMode, shapeMode: Bool, timestamp: Date = Date()) {
        self.id = id
        self.userId = userId
        self.name = name
        self.score = score
        self.mode = mode
        self.shapeMode = shapeMode
        self.timestamp = timestamp
    }
}

import Foundation

struct Achievement: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    var unlocked: Bool
    var dateUnlocked: Date?
    let emoji: String
    
    init(
        id: String,
        title: String,
        description: String,
        unlocked: Bool = false,
        dateUnlocked: Date? = nil,
        emoji: String
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.unlocked = unlocked
        self.dateUnlocked = dateUnlocked
        self.emoji = emoji
    }
    
    // Galaxy-themed achievements
    static let allAchievements: [Achievement] = [
        Achievement(
            id: "first_win",
            title: "Cosmic Beginner",
            description: "Complete your first game",
            emoji: "🌱"
        ),
        Achievement(
            id: "streak_3",
            title: "Nebula Navigator",
            description: "Achieve a 3-streak",
            emoji: "🌌"
        ),
        Achievement(
            id: "streak_5",
            title: "Supernova Speedster",
            description: "Achieve a 5-streak",
            emoji: "💫"
        ),
        Achievement(
            id: "score_50",
            title: "Star Collector",
            description: "Score 50+ points in a game",
            emoji: "⭐️"
        ),
        Achievement(
            id: "score_100",
            title: "Galaxy Legend",
            description: "Score 100+ points in a game",
            emoji: "👑"
        ),
        Achievement(
            id: "hard_mode",
            title: "Black Hole Survivor",
            description: "Complete a Hard mode game",
            emoji: "🕳️"
        ),
        Achievement(
            id: "shape_master",
            title: "Constellation Master",
            description: "Win 5 games in Shape Mode",
            emoji: "✨"
        )
    ]
}

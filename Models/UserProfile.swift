import Foundation

struct UserProfile: Codable, Identifiable {
    let id: String
    var name: String
    var email: String
    var createdAt: Date
    var acceptedPrivacy: Bool
    var totalGamesPlayed: Int
    var highestScore: Int
    
    init(
        id: String,
        name: String,
        email: String,
        createdAt: Date = Date(),
        acceptedPrivacy: Bool = false,
        totalGamesPlayed: Int = 0,
        highestScore: Int = 0
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.createdAt = createdAt
        self.acceptedPrivacy = acceptedPrivacy
        self.totalGamesPlayed = totalGamesPlayed
        self.highestScore = highestScore
    }
}

import Foundation
import SwiftUI
import Combine

class AchievementViewModel: ObservableObject {
    @Published var achievements: [Achievement] = Achievement.allAchievements
    @Published var newlyUnlockedAchievement: Achievement? = nil
    
    // MARK: - Check Achievements
    
    func checkAchievements(score: Int, streak: Int, mode: GameMode, shapeMode: Bool, gamesPlayed: Int) {
        // First win
        if gamesPlayed == 1 {
            unlock(id: "first_win")
        }
        
        // Streak achievements
        if streak >= 3 {
            unlock(id: "streak_3")
        }
        if streak >= 5 {
            unlock(id: "streak_5")
        }
        
        // Score achievements
        if score >= 50 {
            unlock(id: "score_50")
        }
        if score >= 100 {
            unlock(id: "score_100")
        }
        
        // Hard mode
        if mode == .hard {
            unlock(id: "hard_mode")
        }
        
        // TODO: Track shape mode wins for constellation master
    }
    
    // MARK: - Unlock Achievement
    
    func unlock(id: String) {
        guard let index = achievements.firstIndex(where: { $0.id == id }),
              !achievements[index].unlocked else { return }
        
        achievements[index].unlocked = true
        achievements[index].dateUnlocked = Date()
        
        // Show notification
        newlyUnlockedAchievement = achievements[index]
        
        // TODO: Save to Firebase
        
        // Hide notification after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.newlyUnlockedAchievement = nil
        }
    }
    
    // MARK: - Progress
    
    var unlockedCount: Int {
        achievements.filter { $0.unlocked }.count
    }
    
    var totalCount: Int {
        achievements.count
    }
    
    var progressPercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(unlockedCount) / Double(totalCount)
    }
}

import Foundation
import SwiftUI
import Combine
import FirebaseFirestore

class LeaderboardViewModel: ObservableObject {
    @Published var topScores: [ScoreEntry] = []
    @Published var isLoading = false
    @Published var selectedMode: GameMode?
    @Published var selectedShapeFilter: Bool?
    
    private let db = Firestore.firestore()
    
    init() {
        Task {
            await fetchTopScores()
        }
    }
    
    // MARK: - Fetch Scores
    
    func fetchTopScores() async {
        await MainActor.run { isLoading = true }
        
        do {
            let snapshot = try await db.collection("leaderboard")
                .order(by: "score", descending: true)
                .limit(to: 100)
                .getDocuments()
            
            let scores = snapshot.documents.compactMap { doc -> ScoreEntry? in
                let data = doc.data()
                guard let userId = data["userId"] as? String,
                      let name = data["name"] as? String,
                      let score = data["score"] as? Int,
                      let modeString = data["mode"] as? String,
                      let mode = GameMode.allCases.first(where: { $0.title == modeString }),
                      let shapeMode = data["shapeMode"] as? Bool else {
                    return nil
                }
                
                return ScoreEntry(
                    id: doc.documentID,
                    userId: userId,
                    name: name,
                    score: score,
                    mode: mode,
                    shapeMode: shapeMode,
                    timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                )
            }
            
            await MainActor.run {
                self.topScores = scores
                self.isLoading = false
            }
        } catch {
            print("Error fetching leaderboard: \(error.localizedDescription)")
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Save Score
    
    func saveScore(userId: String, name: String, score: Int, mode: GameMode, shapeMode: Bool) async {
        let data: [String: Any] = [
            "userId": userId,
            "name": name,
            "score": score,
            "mode": mode.title,
            "shapeMode": shapeMode,
            "timestamp": Timestamp(date: Date())
        ]
        
        do {
            try await db.collection("leaderboard").addDocument(data: data)
            await fetchTopScores() // Refresh the list
        } catch {
            print("Error saving score: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Filter Scores
    
    var filteredScores: [ScoreEntry] {
        var scores = topScores
        
        if let mode = selectedMode {
            scores = scores.filter { $0.mode == mode }
        }
        
        if let shapeFilter = selectedShapeFilter {
            scores = scores.filter { $0.shapeMode == shapeFilter }
        }
        
        return Array(scores.prefix(10))
    }
}

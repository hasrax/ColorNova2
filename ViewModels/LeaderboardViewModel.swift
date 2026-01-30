import Foundation
import SwiftUI
import Combine
import FirebaseFirestore

// NEW: Aggregated score structure
struct AggregatedScore: Identifiable {
    let id = UUID()
    let userId: String
    let name: String
    let totalScore: Int
    let mode: GameMode
    let shapeMode: Bool
}

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
                .limit(to: 500)  // Increased to get more data for aggregation
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
    
    // NEW: Aggregate scores by user, mode, and shape mode
    var aggregatedScores: [AggregatedScore] {
        var scores = topScores
        
        // Apply filters
        if let mode = selectedMode {
            scores = scores.filter { $0.mode == mode }
        }
        
        if let shapeFilter = selectedShapeFilter {
            scores = scores.filter { $0.shapeMode == shapeFilter }
        }
        
        // Group by userId + mode + shapeMode and sum scores
        let grouped = Dictionary(grouping: scores) { entry in
            "\(entry.userId)_\(entry.mode.rawValue)_\(entry.shapeMode)"
        }
        
        let aggregated = grouped.map { (key, entries) -> AggregatedScore in
            let totalScore = entries.reduce(0) { $0 + $1.score }
            let first = entries.first!
            return AggregatedScore(
                userId: first.userId,
                name: first.name,
                totalScore: totalScore,
                mode: first.mode,
                shapeMode: first.shapeMode
            )
        }
        
        // Sort by total score and return top 10
        return Array(aggregated.sorted { $0.totalScore > $1.totalScore }.prefix(10))
    }
}

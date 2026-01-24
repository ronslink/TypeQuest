import Foundation

@MainActor
class ProgressTracker: ObservableObject {
    static let shared = ProgressTracker()
    
    @Published var userStats: UserStats
    
    init() {
        self.userStats = UserStats(
            overallWPM: 0,
            overallAccuracy: 1.0,
            totalTypingTime: 0,
            currentStreak: 0,
            longestStreak: 0,
            stageProgress: [:],
            homeRowMastery: 0,
            columnMastery: 0,
            ngramFluency: 0,
            wordAutomaticity: 0,
            weakestKeys: [],
            weakestNGrams: [],
            commonErrors: [:]
        )
    }
    
    struct UserStats {
        var overallWPM: Double
        var overallAccuracy: Double
        var totalTypingTime: TimeInterval
        var currentStreak: Int
        var longestStreak: Int
        
        // Stage-wise progress
        var stageProgress: [Int: StageProgress]
        
        // Skill breakdown
        var homeRowMastery: Double
        var columnMastery: Double
        var ngramFluency: Double
        var wordAutomaticity: Double
        
        // Problem areas
        var weakestKeys: [Character]
        var weakestNGrams: [String]
        var commonErrors: [Character: Int]
    }
    
    struct StageProgress {
        var completed: Bool
        var averageWPM: Double
        var averageAccuracy: Double
        var timeSpent: TimeInterval
        var lessonsCompleted: [String]
    }
}

import Foundation

@MainActor
class GamificationEngine: ObservableObject {
    
    private let levelViewModel: LevelViewModel
    private let streakViewModel: StreakViewModel
    
    @Published var currentDailyGoals: [DailyGoal] = []
    
    init(levelViewModel: LevelViewModel = LevelViewModel(), streakViewModel: StreakViewModel = StreakViewModel()) {
        self.levelViewModel = levelViewModel
        self.streakViewModel = streakViewModel
        refreshDailyGoals()
    }
    
    func awardExperience(for session: TypingSession, lesson: Lesson, userProfile: UserProfile) -> [Reward] {
        var xpEarned = 0
        var rewards: [Reward] = []
        
        // Base XP
        let baseXP = Int(Double(session.wpm * 2) * session.accuracy)
        xpEarned += baseXP
        
        // Perfect Lesson Bonus
        if session.accuracy == 1.0 {
            xpEarned += 50
            rewards.append(Reward(name: "Perfect Accuracy", type: .badge, value: 50))
        }
        
        // Apply Multiplier
        let totalXP = Int(Double(xpEarned) * lesson.difficulty.xpMultiplier)
        
        // Update Models
        levelViewModel.addXP(totalXP)
        streakViewModel.updateStreak() // Assuming simple daily check
        
        return rewards
    }
    
    func updateDailyGoals(with session: TypingSession) -> [DailyGoal] {
        // Simple logic to increment progress on active goals
        // This is a placeholder for more complex goal logic
        return []
    }
    
    private func refreshDailyGoals() {
        // Reset or load goals
    }
}

struct DailyGoal: Identifiable, Codable {
    let id: UUID
    let description: String
    var current: Int
    let target: Int
    var isCompleted: Bool
}

struct Reward: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: RewardType
    let value: Int
}

enum RewardType: String, Codable {
    case xp, badge, item
}

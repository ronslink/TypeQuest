import Foundation
import Combine
import SwiftUI

@MainActor
final class LevelViewModel: ObservableObject {
    @Published var currentLevel: Int = 1
    @Published var currentXP: Int = 0
    @Published var xpToNextLevel: Int = 1000
    @Published var progress: Double = 0.0
    
    // Notification for level up events
    let levelUpPublisher = PassthroughSubject<Int, Never>()
    
    private let dataManager = DataManager.shared
    
    init() {
        loadUserData()
    }
    
    func loadUserData() {
        if let user = dataManager.currentUser {
            currentLevel = user.currentLevel
            currentXP = user.totalXP
            calculateProgress()
        }
    }
    
    func addXP(_ amount: Int) {
        currentXP += amount
        
        // Simple leveling formula: Each level requires Level * 1000 XP (cumulative or threshold?)
        // Let's use threshold: level * 1000
        // e.g. Level 1 -> 2 needs 1000 XP. Level 2 -> 3 needs 2000 XP.
        
        let xpRequired = calculateXPRequired(for: currentLevel)
        
        if currentXP >= xpRequired {
            levelUp()
        }
        
        calculateProgress()
        saveProgress()
    }
    
    private func levelUp() {
        currentLevel += 1
        // Reset XP for next level calculation if we want "XP per level", 
        // OR keep cumulative XP. Design says "Total XP".
        // Let's stick to Total XP determining level.
        // Actually, easiest MVP is: Level = Floor(TotalXP / 1000) + 1
        
        let calculatedLevel = (currentXP / 1000) + 1
        if calculatedLevel > currentLevel { // Logic check
             currentLevel = calculatedLevel
        }
        
        levelUpPublisher.send(currentLevel)
    }
    
    private func calculateXPRequired(for level: Int) -> Int {
        return level * 1000
    }
    
    private func calculateProgress() {
        let xpRequired = calculateXPRequired(for: currentLevel)
        let prevLevelXP = calculateXPRequired(for: currentLevel - 1)
        
        // Progress within current level
        let numerator = Double(currentXP - prevLevelXP)
        let denominator = Double(xpRequired - prevLevelXP)
        
        progress = max(0, min(1.0, numerator / denominator))
        xpToNextLevel = xpRequired - currentXP
    }
    
    private func saveProgress() {
        dataManager.saveXP(currentXP, level: currentLevel)
    }
}

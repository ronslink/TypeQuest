import Foundation
import Combine

@MainActor
final class StreakViewModel: ObservableObject {
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    
    // Just a flag to show "Streak Extended!" animation
    @Published var streakExtendedChanged: Bool = false
    
    private let dataManager = DataManager.shared
    
    init() {
        loadData()
        checkStreakValidity()
    }
    
    func loadData() {
        if let user = dataManager.currentUser {
            currentStreak = user.currentStreak
            longestStreak = user.longestStreak
        }
    }
    
    func updateStreak() {
        let calendar = Calendar.current
        let now = Date()
        
        guard let lastDate = dataManager.lastPracticeDate else {
            // First time ever
            incrementStreak()
            return
        }
        
        if calendar.isDateInToday(lastDate) {
            // Already practiced today, do nothing
            return
        }
        
        if calendar.isDateInYesterday(lastDate) {
            // Practiced yesterday, keep streak alive
            incrementStreak()
        } else {
            // Broken streak
            resetStreak()
            incrementStreak() // Start new streak today
        }
    }
    
    private func incrementStreak() {
        currentStreak += 1
        if currentStreak > longestStreak {
            longestStreak = currentStreak
        }
        save()
        streakExtendedChanged = true
        // Allow UI to react
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.streakExtendedChanged = false
        }
    }
    
    private func resetStreak() {
        currentStreak = 0
    }
    
    private func checkStreakValidity() {
        // Run on app launch to see if streak was broken while away
        let calendar = Calendar.current
        guard let lastDate = dataManager.lastPracticeDate else { return }
        
        if !calendar.isDateInToday(lastDate) && !calendar.isDateInYesterday(lastDate) {
             currentStreak = 0
             save()
        }
    }
    
    private func save() {
        dataManager.saveStreak(currentStreak, longest: longestStreak)
    }
}

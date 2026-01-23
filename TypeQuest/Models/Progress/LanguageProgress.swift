import Foundation
import SwiftData

@Model
final class LanguageProgress {
    @Attribute(.unique) var id: UUID
    var language: String
    var unlockedStages: [Int]
    var completedLessons: [String]
    var bestWPM: Double
    var bestAccuracy: Double
    var totalPracticeTime: TimeInterval
    
    var userProfile: UserProfile?
    
    init(
        id: UUID = UUID(),
        language: String,
        unlockedStages: [Int] = [1],
        completedLessons: [String] = [],
        bestWPM: Double = 0,
        bestAccuracy: Double = 0,
        totalPracticeTime: TimeInterval = 0
    ) {
        self.id = id
        self.language = language
        self.unlockedStages = unlockedStages
        self.completedLessons = completedLessons
        self.bestWPM = bestWPM
        self.bestAccuracy = bestAccuracy
        self.totalPracticeTime = totalPracticeTime
    }
}

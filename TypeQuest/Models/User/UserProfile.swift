import Foundation
import SwiftData

@Model
final class UserProfile {
    @Attribute(.unique) var id: UUID
    var username: String
    var ageGroup: AgeGroup
    var primaryLanguage: String
    var avatarId: UUID
    var currentLevel: Int
    var totalXP: Int
    var inkCurrency: Int
    var currentStreak: Int
    var longestStreak: Int
    var createdDate: Date
    var lastPracticeDate: Date
    
    @Relationship(deleteRule: .cascade)
    var settings: UserSettings?
    
    @Relationship(deleteRule: .cascade, inverse: \LanguageProgress.userProfile)
    var progress: [LanguageProgress]?
    
    var layout: KeyboardLayout {
        settings?.layout ?? .qwerty
    }
    
    init(
        id: UUID = UUID(),
        username: String,
        ageGroup: AgeGroup = .adult,
        primaryLanguage: String = "en"
    ) {
        self.id = id
        self.username = username
        self.ageGroup = ageGroup
        self.primaryLanguage = primaryLanguage
        self.avatarId = UUID()
        self.currentLevel = 1
        self.totalXP = 0
        self.inkCurrency = 0
        self.currentStreak = 0
        self.longestStreak = 0
        self.createdDate = Date()
        self.lastPracticeDate = Date()
    }
}

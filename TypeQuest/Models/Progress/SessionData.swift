import Foundation
import SwiftData

@Model
final class SessionData {
    @Attribute(.unique) var id: UUID
    var timestamp: Date
    var duration: TimeInterval
    var wpm: Double
    var accuracy: Double
    var rawAccuracy: Double
    var correctedAccuracy: Double
    var totalCharacters: Int
    var uncorrectedErrors: Int
    var backspaceCount: Int
    var language: String
    var lessonId: String?
    
    @Relationship(deleteRule: .cascade)
    var keyData: [KeyPerformance]?
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        duration: TimeInterval = 0,
        wpm: Double = 0,
        accuracy: Double = 100,
        rawAccuracy: Double = 100,
        correctedAccuracy: Double = 100,
        totalCharacters: Int = 0,
        uncorrectedErrors: Int = 0,
        backspaceCount: Int = 0,
        language: String = "en",
        lessonId: String? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.duration = duration
        self.wpm = wpm
        self.accuracy = accuracy
        self.rawAccuracy = rawAccuracy
        self.correctedAccuracy = correctedAccuracy
        self.totalCharacters = totalCharacters
        self.uncorrectedErrors = uncorrectedErrors
        self.backspaceCount = backspaceCount
        self.language = language
        self.lessonId = lessonId
    }
}

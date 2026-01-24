import Foundation
import CoreGraphics

public struct KeystrokeEvent: Codable, Sendable {
    public let key: String
    public let expectedKey: String? // Added for verification
    public let timestamp: Date
    public let reactionTime: TimeInterval
    public let position: CGPoint // Logical position
    public let isCorrect: Bool
    
    public init(key: String, expectedKey: String? = nil, timestamp: Date, reactionTime: TimeInterval, position: CGPoint, isCorrect: Bool) {
        self.key = key
        self.expectedKey = expectedKey
        self.timestamp = timestamp
        self.reactionTime = reactionTime
        self.position = position
        self.isCorrect = isCorrect
    }
}

public struct TypingSession: Identifiable, Codable, Sendable {
    public let id: UUID
    public let startTime: Date
    public let duration: TimeInterval
    public let wpm: Double
    public let accuracy: Double
    public let consistency: Double
    public let errors: [KeystrokeEvent]
    public let lessonId: String
    
    public init(id: UUID = UUID(), startTime: Date, duration: TimeInterval, wpm: Double, accuracy: Double, consistency: Double, errors: [KeystrokeEvent], lessonId: String) {
        self.id = id
        self.startTime = startTime
        self.duration = duration
        self.wpm = wpm
        self.accuracy = accuracy
        self.consistency = consistency
        self.errors = errors
        self.lessonId = lessonId
    }
}

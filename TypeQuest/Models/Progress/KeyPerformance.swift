import Foundation
import SwiftData

@Model
final class KeyPerformance {
    @Attribute(.unique) var id: UUID
    var key: String
    var pressCount: Int
    var errorCount: Int
    var avgLatency: Double
    var struggleScore: Double
    var sessionId: UUID
    
    init(
        id: UUID = UUID(),
        key: String,
        pressCount: Int = 0,
        errorCount: Int = 0,
        avgLatency: Double = 0,
        struggleScore: Double = 0,
        sessionId: UUID
    ) {
        self.id = id
        self.key = key
        self.pressCount = pressCount
        self.errorCount = errorCount
        self.avgLatency = avgLatency
        self.struggleScore = struggleScore
        self.sessionId = sessionId
    }
}

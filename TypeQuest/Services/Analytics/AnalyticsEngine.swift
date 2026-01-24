import Foundation
import SwiftData

@MainActor
class AnalyticsEngine {
    
    func recordSession(_ session: TypingSession, lesson: Lesson) {
        // 1. Save Session to Persistence
        let sessionData = SessionData(
            id: session.id,
            timestamp: session.startTime,
            duration: session.duration,
            wpm: session.wpm,
            accuracy: session.accuracy,
            lessonId: lesson.id
        )
        DataManager.shared.saveSession(sessionData)
        
        // 2. Update ProgressTracker aggregated stats
        ProgressTracker.shared.recordSession(session)
        
        // 3. Analyze Key Performance
        analyzeKeyPerformance(session.errors)
    }
    
    private func analyzeKeyPerformance(_ errors: [KeystrokeEvent]) {
        // Aggregate problems keys and update persistent stats
        // This logic is partially in TypingViewModel already, eventually move it here completely
    }
}

extension ProgressTracker {
    func recordSession(_ session: TypingSession) {
        // Update total time, wpm average, etc.
        userStats.totalTypingTime += session.duration
        
        // Moving average for WPM
        let oldWPM = userStats.overallWPM
        let count = Double(userStats.stageProgress.values.reduce(0) { $0 + $1.lessonsCompleted.count }) + 1
        userStats.overallWPM = oldWPM + (session.wpm - oldWPM) / count
        
        // Similarly for accuracy
        let oldAcc = userStats.overallAccuracy
        userStats.overallAccuracy = oldAcc + (session.accuracy - oldAcc) / count
        
        // Update stage progress placeholder
        // ...
    }
}

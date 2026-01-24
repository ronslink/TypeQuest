import Foundation

class TypingSessionController {
    let lesson: Lesson
    let exercises: [Exercise]
    let feedbackEngine: FeedbackEngine
    let userProfile: UserProfile
    
    private var currentExerciseIndex = 0
    private var sessionStart: Date
    private var allKeystrokes: [KeystrokeEvent] = []
    
    init(lesson: Lesson, exercises: [Exercise], feedbackEngine: FeedbackEngine, userProfile: UserProfile) {
        self.lesson = lesson
        self.exercises = exercises
        self.feedbackEngine = feedbackEngine
        self.userProfile = userProfile
        self.sessionStart = Date()
    }
    
    func processKeystroke(_ char: Character, expected: Character, position: CGPoint) {
        let event = KeystrokeEvent(
            key: String(char),
            expectedKey: String(expected),
            timestamp: Date(),
            reactionTime: 0, // In real implementation, diff from last timestamp
            position: position,
            isCorrect: char == expected
        )
        
        allKeystrokes.append(event)
        
        // Note: engines usually return specific advice or actions here, simplified for now
        _ = feedbackEngine.processKeystroke(event, expected: expected, userProfile: userProfile)
    }
    
    func finishSession() -> TypingSession {
        let duration = Date().timeIntervalSince(sessionStart)
        let wpm = calculateWPM()
        let accuracy = calculateAccuracy()
        let consistency = calculateConsistency()
        let errors = allKeystrokes.filter { !$0.isCorrect }
        
        return TypingSession(
            id: UUID(),
            startTime: sessionStart,
            duration: duration,
            wpm: wpm,
            accuracy: accuracy,
            consistency: consistency,
            errors: errors,
            lessonId: lesson.id
        )
    }
    
    private func calculateWPM() -> Double {
        let duration = Date().timeIntervalSince(sessionStart)
        let minutes = duration / 60.0
        let words = Double(allKeystrokes.count) / 5.0  // Standard: 5 chars = 1 word
        return words / minutes
    }
    
    private func calculateAccuracy() -> Double {
        guard !allKeystrokes.isEmpty else { return 0 }
        let correct = allKeystrokes.filter { $0.isCorrect }.count
        return Double(correct) / Double(allKeystrokes.count)
    }
    
    private func calculateConsistency() -> Double {
        // Measure standard deviation of inter-keystroke intervals
        guard allKeystrokes.count > 2 else { return 0 }
        
        var intervals: [TimeInterval] = []
        for i in 1..<allKeystrokes.count {
            let interval = allKeystrokes[i].timestamp.timeIntervalSince(allKeystrokes[i-1].timestamp)
            intervals.append(interval)
        }
        
        let mean = intervals.reduce(0, +) / Double(intervals.count)
        let variance = intervals.map { pow($0 - mean, 2) }.reduce(0, +) / Double(intervals.count)
        let stdDev = sqrt(variance)
        
        // Consistency score: 1.0 - (stdDev / mean), capped at 0-1
        return max(0, min(1, 1.0 - (stdDev / mean)))
    }
}

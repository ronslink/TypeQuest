import Foundation

class FeedbackEngine {
    
    enum FeedbackType {
        case audio(SoundType)
        case haptic
        case visual(String)
    }
    
    // Config
    var isAudioEnabled: Bool = true
    var isHapticsEnabled: Bool = true
    
    // State
    private var consecutiveErrors: Int = 0
    private var lastKeystrokeTime: Date?
    
    func processKeystroke(_ event: KeystrokeEvent, expected: Character, userProfile: UserProfile) -> FeedbackType? {
        
        // 1. Immediate Audio Feedback
        if event.isCorrect {
            consecutiveErrors = 0
            return .audio(.correctKey)
        } else {
            consecutiveErrors += 1
            
            // Adaptive feedback based on profile
            if consecutiveErrors >= 3 {
                 return .visual("Take a breath. Focus on accuracy.")
            }
            
            return .audio(.errorKey)
        }
    }
    
    func generateCoachingTip(_ session: TypingSession) -> String? {
        if session.accuracy < 0.9 {
            return "Accuracy is key. Slow down to speed up."
        }
        if session.consistency < 0.7 {
            return "Try to keep a steady rhythm."
        }
        return nil
    }
}

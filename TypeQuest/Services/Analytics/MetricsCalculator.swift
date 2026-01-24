import Foundation

final class MetricsCalculator: Sendable {
    static let shared = MetricsCalculator()
    
    private let standardWordLength = 5.0
    
    private init() {}
    
    /// WPM = ((Total Characters / 5) - Uncorrected Errors) / Time(min)
    func calculateWPM(characters: Int, uncorrectedErrors: Int, time: TimeInterval) -> Double {
        guard time > 0 else { return 0 }
        let netCharacters = Double(characters) - Double(uncorrectedErrors)
        let words = netCharacters / standardWordLength
        let minutes = time / 60
        return max(0, words / minutes)
    }
    
    func calculateRawAccuracy(correct: Int, total: Int) -> Double {
        guard total > 0 else { return 100 }
        return Double(correct) / Double(total) * 100
    }
    
    func calculateCorrectedAccuracy(correct: Int, errors: Int, backspaces: Int) -> Double {
        let correctedErrors = max(0, errors - backspaces)
        let total = correct + correctedErrors
        guard total > 0 else { return 100 }
        return Double(correct) / Double(total) * 100
    }
}

import Foundation

@MainActor
final class AnalyticsService: ObservableObject {
    static let shared = AnalyticsService()
    
    private let dataManager = DataManager.shared
    
    private init() {}
    
    /// Identifies the user's weakest keys based on weighted accuracy and recency
    func identifyWeakKeys(limit: Int = 3) -> [String] {
        // Algorithm:
        // 1. Fetch recent performance data
        // 2. Weight recent sessions higher (Exponential Moving Average)
        // 3. Combine low accuracy and high latency
        
        // MVP Implementation: relying on DataManager's existing fetch
        // In a real implementation, we would query granular key logs
        return dataManager.fetchWeakestKeys(limit: limit)
    }
    
    /// Calculates a composite struggle score (0-100) for a given key
    /// Usage: Used to determine if a key needs immediate remedial practice
    func calculateStruggleScore(accuracy: Double, avgLatency: Double) -> Double {
        // Factors:
        // - Accuracy (0.0 - 1.0): Weight 60%
        // - Latency (seconds): Weight 40% (normalized)
        
        let accuracyFactor = (1.0 - accuracy) * 100.0 // 90% acc = 10 pts, 50% acc = 50 pts
        
        // Latency normalization: 200ms is expert, 800ms is struggling
        // Cap latency impact at 1.0s
        let cappedLatency = min(1.0, max(0.2, avgLatency))
        let latencyFactor = ((cappedLatency - 0.2) / 0.8) * 100.0
        
        let score = (accuracyFactor * 0.6) + (latencyFactor * 0.4)
        
        return min(100, score)
    }
    
    /// Generates targeted n-gram practice for weak keys
    func generateAdaptiveNgrams(for keys: [String]) -> [String] {
        guard !keys.isEmpty else { return [] }
        
        var ngrams: [String] = []
        let commonNgrams = ["th", "he", "in", "er", "an", "re", "on", "at", "en", "nd"]
        
        for key in keys {
            // Find common n-grams containing this key
            let relevant = commonNgrams.filter { $0.contains(key) }
            ngrams.append(contentsOf: relevant)
            
            // Generate synthetic practice pairs if none found
            if relevant.isEmpty {
                ngrams.append("\(key)\(key)")
                ngrams.append("a\(key)")
                ngrams.append("\(key)e")
            }
        }
        
        return Array(Set(ngrams)).shuffled().prefix(4).map { String($0) }
    }
}

import Foundation
import CoreGraphics

class PostureMonitor {
    
    private var suspicionScore: [PostureIssue: Double] = [:]
    private let detectionThreshold: Double = 0.7
    
    func check(
        keystrokePattern: [KeystrokeEvent],
        currentEvent: KeystrokeEvent
    ) -> [PostureIssue] {
        
        var detectedIssues: [PostureIssue] = []
        
        // Detection 1: Looking at keyboard (long pauses + errors)
        if detectsLookingDown(keystrokePattern) {
            detectedIssues.append(.likelyLookingDown)
        }
        
        // Detection 2: Pecking (hunting for keys)
        if detectsPecking(keystrokePattern) {
            detectedIssues.append(.possiblePecking)
        }
        
        // Detection 3: Wrist strain (inconsistent timing)
        if detectsWristStrain(keystrokePattern) {
            detectedIssues.append(.wristStrain)
        }
        
        return detectedIssues
    }
    
    private func detectsLookingDown(_ pattern: [KeystrokeEvent]) -> Bool {
        guard pattern.count >= 10 else { return false }
        
        let recent = Array(pattern.suffix(10))
        
        // Looking down indicators:
        // 1. Variable reaction times (searching)
        // 2. Frequent errors
        // 3. Sudden speed changes
        
        let reactionTimes = recent.map { $0.reactionTime }
        let avgReaction = reactionTimes.reduce(0, +) / Double(reactionTimes.count)
        let sumSquaredDiff = reactionTimes.map { pow($0 - avgReaction, 2) }.reduce(0, +)
        let variance = sumSquaredDiff / Double(reactionTimes.count)
        
        let highVariance = sqrt(variance) > avgReaction * 0.6
        let slowReactions = avgReaction > 0.4
        
        let errors = recent.filter { !$0.isCorrect }.count
        let errorRate = Double(errors) / Double(recent.count)
        let frequentErrors = errorRate > 0.2 // More than 20% errors
        
        return (highVariance && slowReactions) || (slowReactions && frequentErrors)
    }
    
    private func detectsPecking(_ pattern: [KeystrokeEvent]) -> Bool {
        guard pattern.count >= 15 else { return false }
        
        // Pecking indicators:
        // 1. Large positional jumps (hand movement)
        // 2. No return to home position (simplified here as distance)
        
        let recent = Array(pattern.suffix(15))
        var totalDistance: CGFloat = 0
        
        for i in 1..<recent.count {
            let distance = recent[i].position.distance(to: recent[i-1].position)
            totalDistance += distance
        }
        
        let avgDistance = totalDistance / CGFloat(recent.count - 1)
        
        // Large average distance suggests hand movement rather than finger movement
        return avgDistance > 50  // pixels/logical units
    }
    
    private func detectsWristStrain(_ pattern: [KeystrokeEvent]) -> Bool {
        guard pattern.count >= 20 else { return false }
        
        // Wrist strain indicators:
        // 1. Increasing reaction times (fatigue)
        
        let recent = Array(pattern.suffix(20))
        let firstHalf = Array(recent.prefix(10))
        let secondHalf = Array(recent.suffix(10))
        
        let firstAvg = firstHalf.map { $0.reactionTime }.reduce(0, +) / 10
        let secondAvg = secondHalf.map { $0.reactionTime }.reduce(0, +) / 10
        
        let slowing = secondAvg > firstAvg * 1.3  // 30% slower
        
        return slowing
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let dx = x - point.x
        let dy = y - point.y
        return sqrt(dx * dx + dy * dy)
    }
}

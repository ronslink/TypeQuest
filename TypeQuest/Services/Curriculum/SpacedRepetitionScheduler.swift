import Foundation

class SpacedRepetitionScheduler {
    
    struct ReviewItem: Codable {
        let lessonId: String
        var nextReviewDate: Date
        var interval: TimeInterval // Days
        var easeFactor: Double
    }
    
    private(set) var reviewQueue: [ReviewItem] = []
    
    // SuperMemo-2 Algorithm implementation
    func scheduleLesson(_ lesson: Lesson, performance: LessonPerformance) {
        
        // Calculate quality of response (0-5)
        // 5 = Perfect response
        // 0 = Complete blackout
        let q = calculateQuality(performance)
        
        var item = reviewQueue.first(where: { $0.lessonId == lesson.id }) ?? ReviewItem(lessonId: lesson.id, nextReviewDate: Date(), interval: 0, easeFactor: 2.5)
        
        if q >= 3 {
             if item.interval == 0 {
                 item.interval = 1
             } else if item.interval == 1 {
                 item.interval = 6
             } else {
                 item.interval = item.interval * item.easeFactor
             }
            
            item.easeFactor = item.easeFactor + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
            if item.easeFactor < 1.3 { item.easeFactor = 1.3 }
        } else {
            item.interval = 1
            // Ease factor unchanged
        }
        
        item.nextReviewDate = Date().addingTimeInterval(item.interval * 86400)
        
        // Update queue
        if let index = reviewQueue.firstIndex(where: { $0.lessonId == lesson.id }) {
            reviewQueue[index] = item
        } else {
            reviewQueue.append(item)
        }
        
        saveQueue()
    }
    
    func rebuildReviewQueue() {
        // Sort by dates
        reviewQueue.sort { $0.nextReviewDate < $1.nextReviewDate }
    }
    
    private func calculateQuality(_ p: LessonPerformance) -> Double {
        if p.accuracy < 0.8 { return 1 }
        if p.accuracy < 0.9 { return 2 }
        if p.accuracy < 0.95 { return 3 }
        if p.accuracy < 0.98 { return 4 }
        return 5
    }
    
    private func saveQueue() {
        // Persist to UserDefaults or DataManager
    }
}

struct LessonPerformance {
    let accuracy: Double
    let wpm: Double
    let duration: TimeInterval
    let errorsCount: Int
}

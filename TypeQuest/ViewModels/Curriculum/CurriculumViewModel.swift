import Foundation
import Combine
import SwiftUI

@MainActor
final class CurriculumViewModel: ObservableObject {
    @Published var stages: [Stage] = []
    
    // Tracking unlocked state
    // Map of LessonID -> Verified
    @Published var completedLessons: Set<String> = []
    
    // Adaptive Recommendation
    @Published var adaptiveLesson: Lesson?
    
    private let curriculumService = CurriculumService.shared
    private let analyticsService = AnalyticsService.shared
    
    init() {
        loadData()
    }
    
    func loadData() {
        stages = curriculumService.getAllStages()
        // Determine completed lessons (mock for now, should read from DataManager)
        // For MVP, nothing completed, just first lesson unlocked by logic
        
        checkForAdaptiveLesson()
    }
    
    func checkForAdaptiveLesson() {
        let weakKeys = analyticsService.identifyWeakKeys()
        if !weakKeys.isEmpty {
            adaptiveLesson = curriculumService.generateAdaptiveLesson(targetKeys: weakKeys)
        }
    }
    
    func isLessonUnlocked(_ lesson: Lesson) -> Bool {
        // Logic: Lesson is unlocked if it's the first one OR the previous lesson in order is completed
        if lesson.order == 1 && lesson.moduleId == "1.1" { // Hardcode start
            return true
        }
        
        // Simplified Logic: Find previous lesson ID
        // (In a real app, we'd lookup the graph. Here we assume sequential IDs for demo)
        if lesson.id == "1.1.2" {
            return completedLessons.contains("1.1.1")
        }
        
        return false
    }
    
    func markLessonComplete(_ lessonId: String) {
        completedLessons.insert(lessonId)
        objectWillChange.send()
    }
}

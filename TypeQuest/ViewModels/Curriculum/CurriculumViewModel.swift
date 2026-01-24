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
        // Only trigger analysis if we have enough data (>= 5 errors on a key) to avoid premature nagging
        let weakKeys = analyticsService.identifyWeakKeys(limit: 3, minErrors: 5)
        
        if !weakKeys.isEmpty {
            adaptiveLesson = curriculumService.generateAdaptiveLesson(targetKeys: weakKeys)
        } else {
            adaptiveLesson = nil
        }
    }
    
    func isLessonUnlocked(_ lesson: Lesson) -> Bool {
        // 1. Initial Lesson is always unlocked
        if lesson.stageId == 1 && lesson.order == 1 && (lesson.moduleId == "1.1") {
            return true
        }
        
        // 2. Stage-level Gatekeeper check
        // If lesson is in Stage N (N > 1), check if Stage N-1's Gatekeeper is completed
        if lesson.stageId > 1 {
            let previousStageId = lesson.stageId - 1
            if let prevStage = stages.first(where: { $0.id == previousStageId }) {
                // Find the gatekeeper of the previous stage
                let gatekeeper = prevStage.modules.flatMap { $0.lessons }.first(where: { $0.isGatekeeper })
                if let gateId = gatekeeper?.id {
                    guard completedLessons.contains(gateId) else { return false }
                }
            }
        }
        
        // 3. Intra-stage Sequential check
        // Find previous lesson in the hierarchy
        // For the MVP, we assume lessons are linear across modules within a stage
        let stageLessons = stages.first(where: { $0.id == lesson.stageId })?.modules
            .sorted(by: { $0.order < $1.order })
            .flatMap { $0.lessons.sorted(by: { $0.order < $1.order }) } ?? []
            
        if let currentIdx = stageLessons.firstIndex(where: { $0.id == lesson.id }), currentIdx > 0 {
            let previousLesson = stageLessons[currentIdx - 1]
            return completedLessons.contains(previousLesson.id)
        }
        
        // Fallback for first lesson of a non-first stage (already passed gatekeeper check above)
        return true
    }
    
    func markLessonComplete(_ lessonId: String) {
        completedLessons.insert(lessonId)
        objectWillChange.send()
    }
}

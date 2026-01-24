import Foundation

@MainActor
class TypingSystemCoordinator: ObservableObject {
    
    // All subsystems
    let curriculumService: CurriculumService
    let exerciseGenerator: ExerciseGenerator
    let feedbackEngine: FeedbackEngine
    let gamificationEngine: GamificationEngine
    let analyticsEngine: AnalyticsEngine
    let spacedRepetitionScheduler: SpacedRepetitionScheduler
    let progressTracker: ProgressTracker
    
    init() {
        self.curriculumService = CurriculumService.shared
        self.exerciseGenerator = ExerciseGenerator()
        self.feedbackEngine = FeedbackEngine()
        self.gamificationEngine = GamificationEngine()
        self.analyticsEngine = AnalyticsEngine()
        self.spacedRepetitionScheduler = SpacedRepetitionScheduler()
        self.progressTracker = ProgressTracker.shared
    }
    
    // MARK: - Session Management
    
    func startSession(for userProfile: UserProfile) -> TypingSessionController {
        // Get recommended lesson from spaced repetition
        spacedRepetitionScheduler.rebuildReviewQueue()
        
        var lesson: Lesson
        if let reviewItem = spacedRepetitionScheduler.reviewQueue.first,
           let lessonObj = curriculumService.getLesson(id: reviewItem.lessonId) {
            // Review session
            lesson = lessonObj
        } else {
            // New content
            lesson = curriculumService.getNextLesson(for: userProfile)
        }
        
        // Generate exercises
        let exercises = curriculumService.generateExercisesForLesson(lesson, userProfile: userProfile)
        
        // Create session controller
        return TypingSessionController(
            lesson: lesson,
            exercises: exercises,
            feedbackEngine: feedbackEngine,
            userProfile: userProfile
        )
    }
    
    func completeSession(_ session: TypingSession, lesson: Lesson) {
        // 1. Update analytics
        analyticsEngine.recordSession(session, lesson: lesson)
        
        // 2. Award XP and achievements
        let rewards = gamificationEngine.awardExperience(
            for: session,
            lesson: lesson,
            userProfile: DataManager.shared.currentUser ?? UserProfile(username: "Guest")
        )
        
        // 3. Update spaced repetition
        let performance = LessonPerformance(
            accuracy: session.accuracy,
            wpm: session.wpm,
            duration: session.duration,
            errorsCount: session.errors.count
        )
        spacedRepetitionScheduler.scheduleLesson(lesson, performance: performance)
        
        // 4. Update progress tracker (Analytics engine already does this essentially, but can be explicit here if separate)
        
        // 5. Check daily goals
        let completedGoals = gamificationEngine.updateDailyGoals(with: session)
        
        // 6. Show session summary
        presentSessionSummary(
            session: session,
            rewards: rewards,
            completedGoals: completedGoals
        )
    }
    
    private func presentSessionSummary(
        session: TypingSession,
        rewards: [Reward],
        completedGoals: [DailyGoal]
    ) {
        // This would trigger UI presentation
        print("Session Complete! WPM: \(session.wpm), Rewards: \(rewards.count)")
    }
}

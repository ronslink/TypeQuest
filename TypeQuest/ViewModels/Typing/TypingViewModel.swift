import Foundation
import Combine
import SwiftUI

@MainActor
final class TypingViewModel: ObservableObject {
    
    // Dependencies
    private let levelViewModel = LevelViewModel()
    private let streakViewModel = StreakViewModel()
    
    // MARK: - Published Properties
    
    @Published var currentText: String = ""
    @Published var typedText: String = ""
    @Published var currentIndex: Int = 0
    @Published var isSessionActive: Bool = false
    @Published var isPaused: Bool = false
    @Published var sessionStartTime: Date?
    @Published var elapsedTime: TimeInterval = 0
    @Published var wpm: Double = 0
    @Published var accuracy: Double = 100
    @Published var rawAccuracy: Double = 100
    @Published var correctedAccuracy: Double = 100
    @Published var errorCount: Int = 0
    @Published var backspaceCount: Int = 0
    @Published var totalCharacters: Int = 0
    @Published var uncorrectedErrors: Int = 0
    @Published var isComplete: Bool = false
    @Published var isLessonPassed: Bool = false
    @Published var isCurrentError: Bool = false
    @Published var debugStatus: String = "Ready"
    @Published var currentLesson: Lesson?
    @Published var currentPostureIssues: [PostureIssue] = []
    
    // Logic Buffers
    private var keystrokeBuffer: [KeystrokeEvent] = []
    private let postureMonitor = PostureMonitor()
    @Published var exerciseQueue: [Exercise] = []
    @Published var currentExerciseIndex: Int = 0
    @Published var totalExercisesInLesson: Int = 0
    
    // UI Adaptation
    @Published var isLargeTextMode: Bool = false
    
    // Key Performance Tracking
    // Key -> (presses, errors, latency accum)
    private var sessionKeyStats: [String: (presses: Int, errors: Int, latency: Double)] = [:]
    private var lastKeyTime: Date?
    
    private var lessonWPMs: [Double] = []
    private var lessonAccuracies: [Double] = []
    
    // MARK: - Private Properties
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private let metricsCalculator = MetricsCalculator.shared
    private let audioManager = AudioManager.shared
    private let keyboardManager = KeyboardManager.shared
    

    // MARK: - Initialization
    
    init() {
        setupKeyboardHandling()
        checkForLargeTextMode()
        
        // Listen for User Profile/Language changes
        NotificationCenter.default.addObserver(self, selector: #selector(handleProfileUpdate), name: NSNotification.Name("UserProfileLoaded"), object: nil)
        
        // Subscribe to level up events
        levelViewModel.levelUpPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] newLevel in
                self?.newLevel = newLevel
                self?.showLevelUp = true
                AudioManager.shared.playSound(.sessionComplete) // Or a specific level up sound
            }
            .store(in: &cancellables)
    }
    
    @Published var showLevelUp: Bool = false
    @Published var newLevel: Int = 1
    
    private func checkForLargeTextMode() {
        if let user = DataManager.shared.currentUser {
            self.isLargeTextMode = (user.ageGroup == .senior)
        }
    }
    
    // MARK: - Public Methods
    
    func startSession(lesson: Lesson? = nil) {
        self.currentLesson = lesson
        self.isLessonPassed = false
        
        if let lesson = lesson {
            // Generate full lesson exercises
            let user = DataManager.shared.currentUser ?? UserProfile(username: "Guest", ageGroup: .adult)
            let exercises = CurriculumService.shared.generateExercisesForLesson(lesson, userProfile: user)
            self.exerciseQueue = exercises
            self.currentExerciseIndex = 0
            self.totalExercisesInLesson = exercises.count
            self.lessonWPMs = []
            self.lessonAccuracies = []
            
            loadNextExercise()
        } else {
             // Practice Mode: detailed per-language text
             loadPracticeText()
             exerciseQueue = [] // Single continuous session or just one text? 
                                // Let's treat it as a single "exercise" for now, or just setting currentText direct.
             startNewExerciseSession()
        }
    }
    
    private func loadPracticeText() {
        let language = DataManager.shared.currentUser?.primaryLanguage ?? "en"
        let sentences = PracticeTextProvider.shared.sentences(for: language)
        currentText = sentences.randomElement() ?? "The quick brown fox jumps over the lazy dog."
    }
    
    @objc private func handleProfileUpdate() {
        // Refresh text if we are in practice mode (no active lesson) and not currently typing (maybe?)
        // For now, if not in session or just finished, we can refresh.
        // Or if the user explicitly changed language, they likely want to see it immediately.
        if !isSessionActive && currentLesson == nil {
            loadPracticeText()
            // Reset typed text to match new language text
            typedText = ""
            currentIndex = 0
        }
    }
    
    func startRemedialSession() {
        guard let lesson = currentLesson else { return }
        
        let user = DataManager.shared.currentUser ?? UserProfile(username: "Guest", ageGroup: .adult)
        let generator = ExerciseGenerator()
        
        // 1. Analyze Failure Mode
        // We look at the accumulated stats from the failed attempt (before they are cleared)
        let avgWPM = lessonWPMs.isEmpty ? 0 : lessonWPMs.reduce(0, +) / Double(lessonWPMs.count)
        let avgAccuracy = lessonAccuracies.isEmpty ? 100 : lessonAccuracies.reduce(0, +) / Double(lessonAccuracies.count)
        
        let failedAccuracy = avgAccuracy < lesson.passingRequirements.minAccuracy
        let failedSpeed = avgWPM < lesson.passingRequirements.minWPM
        
        var remedialQueue: [Exercise] = []
        
        // 2. Generate Targeted Remediation
        if failedAccuracy {
            // STRATEGY: Accuracy Focus
            // Prepend an anchor drill for the required keys to rebuild muscle memory
            if let keys = lesson.requiredKeys, !keys.isEmpty {
                let drill = generator.generateAnchorExercise(
                    targetKeys: keys,
                    difficulty: Double(lesson.difficulty.xpMultiplier) * 0.8, // Slightly easier
                    duration: 60,
                    userProfile: user
                )
                remedialQueue.append(drill)
            } else {
                // Fallback for word-based lessons without specific key targets
                // Use a slower accuracy-focused repetition of the content
                let drill = Exercise(
                    type: .accuracy,
                    content: lesson.contentPattern,
                    targetMetric: MetricTarget(metric: .accuracy, threshold: lesson.passingRequirements.minAccuracy),
                    timeLimit: nil,
                    repetitions: 2
                )
                remedialQueue.append(drill)
            }
            
            // Notification / Feedback (In a real app, we'd set a 'coachMessage' property here)
            // print("Coach: Slow down and focus on hitting the right keys.")
            
        } else if failedSpeed {
            // STRATEGY: Speed Builder
            // Use sprints or flow practice
            // If it's a word lesson, maybe break it into chunks
            let sprint = Exercise(
                type: .speed,
                content: lesson.contentPattern,
                targetMetric: MetricTarget(metric: .wpm, threshold: lesson.passingRequirements.minWPM), // Keep target, but maybe shorter duration implicitly by content
                timeLimit: 30, // Force a sprint
                repetitions: 3
            )
            remedialQueue.append(sprint)
             
            // print("Coach: Trust your fingers. Don't look down. Keep the rhythm.")
        } else {
            // Balanced / General Failure (or just close)
            // Retry the main content but perhaps with a "warmup" first
            remedialQueue.append(contentsOf: CurriculumService.shared.generateExercisesForLesson(lesson, userProfile: user))
        }
        
        // 3. Append Original Lesson Content (if we generated drills)
        // If we generated specific drills (first 2 cases), we want to follow up with the actual lesson content
        // so they can pass it this time.
        if remedialQueue.count < 3 { // Arbitrary check to avoid massive queues if we fell through to 'Balanced'
             let originalContent = CurriculumService.shared.generateExercisesForLesson(lesson, userProfile: user)
             remedialQueue.append(contentsOf: originalContent)
        }
        
        // 4. Reset & Load
        self.exerciseQueue = remedialQueue
        self.currentExerciseIndex = 0
        self.totalExercisesInLesson = remedialQueue.count
        
        // Clear stats for the new attempt
        self.lessonWPMs = []
        self.lessonAccuracies = []
        self.isLessonPassed = false
        
        loadNextExercise()
    }
    
    private func loadNextExercise() {
        guard currentExerciseIndex < exerciseQueue.count else {
            completeLesson()
            return
        }
        
        let exercise = exerciseQueue[currentExerciseIndex]
        currentText = exercise.content
        startNewExerciseSession()
    }
    
    private func startNewExerciseSession() {
        typedText = ""
        currentIndex = 0
        errorCount = 0
        backspaceCount = 0
        totalCharacters = 0
        uncorrectedErrors = 0
        elapsedTime = 0
        wpm = 0
        accuracy = 100
        isComplete = false
        isCurrentError = false
        sessionStartTime = Date()
        isSessionActive = true
        isPaused = false
        
        sessionKeyStats = [:]
        lastKeyTime = Date()
        
        startTimer()
        keyboardManager.startMonitoring()
    }
    
    func pauseSession() {
        isPaused = true
        stopTimer()
    }
    
    func resumeSession() {
        isPaused = false
        startTimer()
    }
    
    func endSession() {
        stopTimer()
        // Ensure final update using exact elapsed time
        if isComplete { updateWPM() }
        isSessionActive = false
        keyboardManager.stopMonitoring()
    }
    
    func resetSession() {
        endSession()
        isComplete = false
        isLessonPassed = false
        if currentLesson != nil {
            startSession(lesson: currentLesson)
        } else {
            startSession()
        }
    }
    
    func processKeyPress(_ key: String) {
        guard isSessionActive && !isPaused else { return }
        guard currentIndex < currentText.count else { return }
        
        let targetCharIndex = currentText.index(currentText.startIndex, offsetBy: currentIndex)
        let targetChar = String(currentText[targetCharIndex])
        
        // Track Latency
        let now = Date()
        let latency = now.timeIntervalSince(lastKeyTime ?? now)
        lastKeyTime = now
        
        let isCorrect = key == targetChar
        isCurrentError = !isCorrect
        
        // Update Key Stats
        let statKey = targetChar.lowercased()
        var currentStat = sessionKeyStats[statKey, default: (0, 0, 0.0)]
        currentStat.presses += 1
        currentStat.latency += latency
        if !isCorrect { currentStat.errors += 1 }
        sessionKeyStats[statKey] = currentStat
        
        if isCorrect {
            typedText.append(currentText[targetCharIndex])
            currentIndex += 1
            totalCharacters += 1
            audioManager.playSound(.correctKey)
        } else {
            errorCount += 1
            uncorrectedErrors += 1
            totalCharacters += 1
            audioManager.playSound(.errorKey)
            
            #if os(iOS)
            UIAccessibility.post(notification: .announcement, argument: "Error on \(targetChar)")
            #endif
        }
        
        updateMetrics()
        
        // Posture Monitoring
        let currentLayout = DataManager.shared.currentUser?.layout ?? .qwerty
        let event = KeystrokeEvent(
            key: key,
            expectedKey: targetChar,
            timestamp: now,
            reactionTime: latency,
            position: LayoutAdapter.shared.logicalPosition(for: key, layout: currentLayout),
            isCorrect: isCorrect
        )
        keystrokeBuffer.append(event)
        
        let issues = postureMonitor.check(keystrokePattern: keystrokeBuffer, currentEvent: event)
        if !issues.isEmpty {
            self.currentPostureIssues = issues
            // Optionally play a subtle warning sound or haptic here in future
        }
        
        if currentIndex >= currentText.count {
            completeExercise()
        }
    }
    
    func processBackspace() {
        guard isSessionActive && !isPaused && currentIndex > 0 else { return }
        
        backspaceCount += 1
        currentIndex -= 1
        if !typedText.isEmpty {
            typedText.removeLast()
        }
        
        // Clear error state on backspace
        isCurrentError = false
        
        if uncorrectedErrors > 0 {
            uncorrectedErrors -= 1
        }
        audioManager.playSound(.backspace)
        updateMetrics()
    }
    
    // MARK: - Private Methods
    
    private func setupKeyboardHandling() {
        keyboardManager.onKeyDown = { [weak self] characters, keyCode in
            Task { @MainActor in
                guard let self = self else { return }
                
                // Handle backspace (keyCode 51)
                if keyCode == 51 {
                    self.processBackspace()
                } else if !characters.isEmpty && characters != "\r" && characters != "\t" {
                    // Process printable characters (ignore return and tab)
                    self.processKeyPress(characters)
                }
            }
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.elapsedTime += 0.1
                self?.updateWPM()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateMetrics() {
        let totalKeys = typedText.count + errorCount
        guard totalKeys > 0 else { return }
        
        rawAccuracy = metricsCalculator.calculateRawAccuracy(correct: typedText.count, total: totalKeys)
        correctedAccuracy = metricsCalculator.calculateCorrectedAccuracy(
            correct: typedText.count,
            errors: errorCount,
            backspaces: backspaceCount
        )
        accuracy = (rawAccuracy + correctedAccuracy) / 2
    }
    
    private func updateWPM() {
        wpm = metricsCalculator.calculateWPM(
            characters: totalCharacters,
            uncorrectedErrors: uncorrectedErrors,
            time: elapsedTime
        )
    }
    
    private func completeExercise() {
        stopTimer()
        audioManager.playSound(.correctKey) // Extra feedback for end of line
        
        lessonWPMs.append(wpm)
        lessonAccuracies.append(accuracy)
        
        currentExerciseIndex += 1
        
        if currentExerciseIndex < exerciseQueue.count {
            // Short delay or transition could be added here
            loadNextExercise()
        } else {
            completeLesson()
        }
    }
    
    private func completeLesson() {
        isComplete = true
        endSession()
        audioManager.playSound(.sessionComplete)
        
        // Calculate average metrics for the whole lesson
        let avgWPM = lessonWPMs.isEmpty ? 0 : lessonWPMs.reduce(0, +) / Double(lessonWPMs.count)
        let avgAccuracy = lessonAccuracies.isEmpty ? 100 : lessonAccuracies.reduce(0, +) / Double(lessonAccuracies.count)
        
        // Update published values for UI display of result
        self.wpm = avgWPM
        self.accuracy = avgAccuracy
        
        if let lesson = currentLesson {
            let passed = avgWPM >= (lesson.passingRequirements.minWPM) && avgAccuracy >= (lesson.passingRequirements.minAccuracy)
            self.isLessonPassed = passed
            
            if passed {
                // Award XP
                let baseXP = 150 // Buffed for multisession lessons
                let accuracyBonus = Int(avgAccuracy * 2)
                let wpmBonus = Int(avgWPM * 5)
                let totalXP = Int((Double(baseXP + accuracyBonus + wpmBonus) * (lesson.difficulty.xpMultiplier)))
                
                levelViewModel.addXP(totalXP)
                streakViewModel.updateStreak()
                
                // Submit to Game Center
                GameCenterManager.shared.submitWPMScore(Int(avgWPM))
                GameCenterManager.shared.submitXPScore(levelViewModel.currentXP)
                GameCenterManager.shared.submitStreakScore(streakViewModel.currentStreak)
                
                // Notify
                NotificationCenter.default.post(name: .lessonCompleted, object: nil, userInfo: ["lessonId": lesson.id])
            }
        }
        
        savePerformanceData()
    }
    
    private func savePerformanceData() {
        let sessionId = UUID()
        var performanceList: [KeyPerformance] = []
        
        for (key, stats) in sessionKeyStats {
            let avgLatency = stats.presses > 0 ? stats.latency / Double(stats.presses) : 0
            let perf = KeyPerformance(
                key: key,
                pressCount: stats.presses,
                errorCount: stats.errors,
                avgLatency: avgLatency,
                struggleScore: 0,
                sessionId: sessionId
            )
            performanceList.append(perf)
        }
        
        Task { @MainActor in
            DataManager.shared.saveKeyPerformance(performanceList)
        }
    }
}

extension Notification.Name {
    static let lessonCompleted = Notification.Name("lessonCompleted")
}

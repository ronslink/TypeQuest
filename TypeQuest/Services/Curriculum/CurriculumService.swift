import Foundation

@MainActor
final class CurriculumService: ObservableObject {
    static let shared = CurriculumService()
    
    @Published private(set) var stages: [Stage] = []
    
    private let layoutAdapter = LayoutAdapter.shared
    
    private init() {
        loadCurriculum()
        setupUserObserver()
    }
    
    private func setupUserObserver() {
        // Observe DataManager and reload if language changes
        // For MVP, we'll just reload manually if we detect a profile change
        NotificationCenter.default.addObserver(forName: NSNotification.Name("UserProfileLoaded"), object: nil, queue: .main) { [weak self] _ in
            self?.loadCurriculum()
        }
    }
    
    func getAllStages() -> [Stage] {
        return stages
    }
    
    func getLesson(id: String) -> Lesson? {
        for stage in stages {
            for module in stage.modules {
                if let lesson = module.lessons.first(where: { $0.id == id }) {
                    return lesson
                }
            }
        }
        return nil
    }
    
    func getNextLesson(for userProfile: UserProfile) -> Lesson {
        // Simple logic: return the first lesson of the first incomplete stage/module
        // In a real app, this would check userProfile.progress
        // For MVP, if we don't have progress tracking linked here yet, return first lesson
        
        // Check if we have progress referencing specific lesson IDs locally or in profile
        // Since UserProfile tracks progress (LanguageProgress), we could check that.
        // For now, let's just find the first available lesson.
        
        // Ensure curriculum matches user language
        if stages.isEmpty || !stages.first!.modules.first!.lessons.first!.id.contains(userProfile.primaryLanguage) {
             loadCurriculum(language: userProfile.primaryLanguage)
        }

        // Iterate through all lessons in order
        for stage in stages {
            for module in stage.modules {
                for lesson in module.lessons {
                    // Check if completed
                    // If not completed, return it
                    if !isLessonCompleted(lesson, user: userProfile) {
                        return lesson
                    }
                }
            }
        }
        
        // If all completed, return the last one or a random mastery lesson
        return stages.first?.modules.first?.lessons.first ?? generateAdaptiveLesson(targetKeys: [])
    }
    
    private func isLessonCompleted(_ lesson: Lesson, user: UserProfile) -> Bool {
        // Find progress for the lesson's language (inferred or explicit)
        // Since Lesson doesn't strictly store 'language' code but ID prefixes often have it (e.g. "es."),
        // we should rely on the UserProfile's primary language or search all progress.
        // Better yet, search for the lesson ID in ANY language progress.
        
        guard let progressList = user.progress else { return false }
        
        for langProgress in progressList {
            if langProgress.completedLessons.contains(lesson.id) {
                return true
            }
        }
        
        return false
    }
    
    func generateContent(for lesson: Lesson, layout: KeyboardLayout = .qwerty) -> String {
        guard let keys = lesson.requiredKeys, !keys.isEmpty else {
            // Static content fallback
            return lesson.contentPattern
        }
        
        // Dynamic content generation based on layout
        // 1. Map abstract keys to user's layout characters
        let chars = keys.compactMap { key -> String? in
            let char = layoutAdapter.characters(for: key, layout: layout)
            return char == "?" ? nil : char
        }
        
        guard !chars.isEmpty else { return lesson.contentPattern }
        
        // 2. Generate Pattern
        // If it's a Stage 1 or 2 drills lesson, we prefer the dynamic pattern
        // If it's Stage 4 (Words) or 5 (Sentences), we might want to stick to the intended words
        // UNLESS the words contain impossible keys. 
        // For MVP, valid assumption: Stage 1 & 2 are purely mechanical.
        
        if lesson.stageId <= 2 {
            // Biomechanical Drill Generation
            // Pattern: simple repetition of available characters
            
            if chars.count == 2 {
                let a = chars[0]
                let b = chars[1]
                // "fff jjj fff jjj fj jf fj jf"
                return "\(a)\(a)\(a) \(b)\(b)\(b) \(a)\(a)\(a) \(b)\(b)\(b) \(a)\(b) \(b)\(a) \(a)\(b) \(b)\(a)"
            } else if chars.count <= 4 {
                // "asdf asdf fdsa fdsa"
                let forward = chars.joined(separator: "")
                let backward = String(chars.reversed().joined(separator: ""))
                var pattern = ""
                for _ in 0..<3 {
                    pattern += "\(forward) \(forward) \(backward) \(backward) "
                }
                // Mix in doubles
                // "aa ss dd ff"
                for char in chars {
                    pattern += "\(char)\(char)\(char) "
                }
                return pattern.trimmingCharacters(in: .whitespaces)
            } else {
                // Larger sets (Full row)
                // "asdfg hjkl;"
                let full = chars.joined(separator: "")
                var pattern = ""
                for _ in 0..<5 {
                     pattern += "\(full) \(String(full.reversed())) "
                }
                return pattern.trimmingCharacters(in: .whitespaces)
            }
        }
        
        return lesson.contentPattern
    }
    
    func generateAdaptiveLesson(targetKeys: [String]) -> Lesson {
        let title = "Weakness Training: " + targetKeys.joined(separator: ", ").uppercased()
        let content = generateContentForKeys(targetKeys)
        
        // Map string keys back to AbstractKeys for visuals
        // This is a rough mapping for the MVP to ensure visuals work
        // We assume targetKeys are single characters like "a", "s"
        var mappedKeys: [AbstractKey] = []
        // Simple static map for common keys to ensure at least some match
        for key in targetKeys {
             if let char = key.first {
                 // Reuse basic mapping logic (simplified)
                 if "qaz".contains(char) { mappedKeys.append(.homeLeftPinky) }
                 else if "wsx".contains(char) { mappedKeys.append(.homeLeftRing) }
                 else if "edc".contains(char) { mappedKeys.append(.homeLeftMiddle) }
                 else if "rtfgvb".contains(char) { mappedKeys.append(.homeLeftIndex) }
                 else if "yuhjnm".contains(char) { mappedKeys.append(.homeRightIndex) }
                 else if "ik,".contains(char) { mappedKeys.append(.homeRightMiddle) }
                 else if "ol.".contains(char) { mappedKeys.append(.homeRightRing) }
                 else { mappedKeys.append(.homeRightPinky) }
             }
        }
        
        return Lesson(
            id: "adaptive_" + UUID().uuidString,
            name: "Focus: " + targetKeys.joined(separator: "").uppercased(),
            description: "Personalized practice to improve your accuracy.",
            stageId: 0, // Special stage
            moduleId: "adaptive",
            order: 0,
            difficulty: .intermediate,
            contentPattern: content,
            passingRequirements: .init(minAccuracy: 95, minWPM: 15),
            requiredKeys: mappedKeys.isEmpty ? [.homeLeftIndex, .homeRightIndex] : mappedKeys // Fallback
        )
    }
    
    private func generateContentForKeys(_ keys: [String]) -> String {
        guard !keys.isEmpty else { return "asdf jkl;" }
        
        // Simple procedural generation: repeat keys with spaces
        // Better: use a dictionary to find words containing these keys
        // MVP: "k k k k" pattern
        var pattern = ""
        for _ in 0..<10 {
            let k = keys.randomElement() ?? ""
            let k2 = keys.randomElement() ?? ""
            pattern += "\(k)\(k2)\(k) \(k)\(k2) \(k)\(k2)\(k2) "
        }
        return pattern.trimmingCharacters(in: .whitespaces)
    }
    
    private func loadCurriculum(language: String? = nil) {
        // Use user language or fallback to English
        let lang = language ?? DataManager.shared.currentUser?.primaryLanguage ?? "en"
        let fullCurriculum = LessonCatalog.shared.generateAllStages(language: lang)
        
        // Monetization: Gate stages 3-6 behind Pro
        let proActive = StoreManager.shared.isPro
        
        self.stages = fullCurriculum.map { stage in
            var mutableStage = stage
            if stage.id > 2 && !proActive {
                mutableStage.isLocked = true
            }
            return mutableStage
        }
    }
}

// MARK: - Exercise Generation
extension CurriculumService {
    
    func generateExercisesForLesson(_ lesson: Lesson, userProfile: UserProfile) -> [Exercise] {
        let generator = ExerciseGenerator()
        var exercises: [Exercise] = []
        
        // Warmup phase
        exercises.append(contentsOf: generateWarmupExercises(lesson, generator, userProfile))
        
        // Main practice phase
        exercises.append(contentsOf: generateMainExercises(lesson, generator, userProfile))
        
        // Cooldown/review phase
        exercises.append(contentsOf: generateCooldownExercises(lesson, generator, userProfile))
        
        return exercises
    }
    
    private func generateWarmupExercises(
        _ lesson: Lesson,
        _ generator: ExerciseGenerator,
        _ userProfile: UserProfile
    ) -> [Exercise] {
        
        var warmups: [Exercise] = []
        
        // Always start with anchor review
        if !(lesson.requiredKeys?.isEmpty ?? true) {
            let anchorWarmup = generator.generateAnchorExercise(
                targetKeys: lesson.requiredKeys ?? [],
                difficulty: Double(lesson.difficulty.xpMultiplier) * 0.7,  // Easier warmup
                duration: 60,
                userProfile: userProfile
            )
            warmups.append(anchorWarmup)
        }
        
        // Add column review if past Stage 1
        if lesson.stageId > 1 && !(lesson.requiredKeys?.isEmpty ?? true) {
            // Determine which column(s) this lesson focuses on
            let columns = identifyRelevantColumns(for: lesson.requiredKeys ?? [])
            for column in columns.prefix(2) {  // Max 2 columns in warmup
                let columnWarmup = generator.generateColumnExercise(
                    targetColumn: column,
                    difficulty: Double(lesson.difficulty.xpMultiplier) * 0.8,
                    previousMastery: 0.7
                )
                warmups.append(columnWarmup)
            }
        }
        
        return warmups
    }
    
    private func generateMainExercises(
        _ lesson: Lesson,
        _ generator: ExerciseGenerator,
        _ userProfile: UserProfile
    ) -> [Exercise] {
        
        var mainExercises: [Exercise] = []
        
        // Exercise selection based on lesson stage
        switch lesson.stageId {
        case 1:  // Stage 1: Anchors
            mainExercises.append(
                generator.generateAnchorExercise(
                    targetKeys: lesson.requiredKeys ?? [],
                    difficulty: Double(lesson.difficulty.xpMultiplier),
                    duration: 180,
                    userProfile: userProfile
                )
            )
            
        case 2:  // Stage 2: Columns
            let columns = identifyRelevantColumns(for: lesson.requiredKeys ?? [])
            for column in columns {
                mainExercises.append(
                    generator.generateColumnExercise(
                        targetColumn: column,
                        difficulty: Double(lesson.difficulty.xpMultiplier),
                        previousMastery: 0.5
                    )
                )
            }
            
        case 3:  // Stage 3: N-grams
            for contextLevel in [ContextLevel.isolated, .embedded, .lexical, .sentential] {
                mainExercises.append(
                    generator.generateNgramExercise(
                        targetNgrams: lesson.targetNGrams,
                        contextLevel: contextLevel,
                        difficulty: Double(lesson.difficulty.xpMultiplier)
                    )
                )
            }
            
        case 4:  // Stage 4: Words
            let stats = getUserStats(userProfile)
            mainExercises.append(
                generator.generateWordExercise(
                    targetWords: lesson.targetWords,
                    allowedKeys: lesson.requiredKeys,
                    userProfile: userProfile,
                    focusArea: .highFrequency,
                    userStats: stats
                )
            )
            
        case 5, 6:  // Stage 5 (Sentences) & Stage 6 (Symbols/Code)
            mainExercises.append(
                generator.generateSentenceExercise(
                    vocabularyLevel: lesson.stageId == 6 ? .advanced : .intermediate,
                    syntaxComplexity: lesson.stageId == 6 ? .complex : .simple,
                    contentDomain: lesson.stageId == 6 ? .technical : .general,
                    userProfile: userProfile
                )
            )
            
        default:
            break
        }
        
        // FALLBACK: If specific generation failed or returned nothing (e.g. empty word cache),
        // use the static content pattern from the lesson definition.
        if mainExercises.isEmpty && !lesson.contentPattern.isEmpty {
            // IF it's a gatekeeper, pick from the pool for randomization
            let content = (lesson.isGatekeeper ? (lesson.contentPool?.randomElement() ?? lesson.contentPattern) : lesson.contentPattern)
            
            mainExercises.append(
                Exercise(
                    type: .sentence,
                    content: content,
                    targetMetric: MetricTarget(metric: .accuracy, threshold: lesson.passingRequirements.minAccuracy),
                    timeLimit: nil,
                    repetitions: 1 // Test only once for high-stakes
                )
            )
        }
        
        return mainExercises
    }
    
    private func generateCooldownExercises(
        _ lesson: Lesson,
        _ generator: ExerciseGenerator,
        _ userProfile: UserProfile
    ) -> [Exercise] {
        
        // Review exercise combining all lesson elements
        return [
            generator.generateWordExercise(
                targetWords: lesson.targetWords,
                allowedKeys: lesson.requiredKeys,
                userProfile: userProfile,
                focusArea: .highFrequency,
                userStats: getUserStats(userProfile)
            )
        ]
    }
    
    private func identifyRelevantColumns(for keys: [AbstractKey]) -> [KeyColumn] {
        var columns = Set<KeyColumn>()
        for key in keys {
            switch key {
            case .homeLeftPinky, .topLeftPinky, .bottomLeftPinky, .numLeftPinky: columns.insert(.leftPinky)
            case .homeLeftRing, .topLeftRing, .bottomLeftRing, .numLeftRing: columns.insert(.leftRing)
            case .homeLeftMiddle, .topLeftMiddle, .bottomLeftMiddle, .numLeftMiddle: columns.insert(.leftMiddle)
            case .homeLeftIndex, .topLeftIndex, .bottomLeftIndex, .numLeftIndex: columns.insert(.leftIndex)
            case .homeRightIndex, .topRightIndex, .bottomRightIndex, .numRightIndex: columns.insert(.rightIndex)
            case .homeRightMiddle, .topRightMiddle, .bottomRightMiddle, .numRightMiddle: columns.insert(.rightMiddle)
            case .homeRightRing, .topRightRing, .bottomRightRing, .numRightRing: columns.insert(.rightRing)
            case .homeRightPinky, .topRightPinky, .bottomRightPinky, .numRightPinky, 
                 .topRightPinky2, .topRightPinky3, .bottomRightPinky2, .bottomRightPinky3,
                 .homeRightPinky2:
                columns.insert(.rightPinky)
            }
        }
        
        return Array(columns)
    }
    
    private func getUserStats(_ userProfile: UserProfile) -> ProgressTracker.UserStats {
        return ProgressTracker.shared.userStats
    }
}

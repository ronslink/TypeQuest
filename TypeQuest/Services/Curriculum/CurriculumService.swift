import Foundation

@MainActor
final class CurriculumService: ObservableObject {
    static let shared = CurriculumService()
    
    @Published private(set) var stages: [Stage] = []
    
    private let layoutAdapter = LayoutAdapter.shared
    
    private init() {
        loadCurriculum()
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
        // Placeholder check
        // Check user.progress or similar
        return false // Always return first lesson for testing if no progress
    }
    
    func generateContent(for lesson: Lesson, layout: KeyboardLayout = .qwerty) -> String {
        guard let keys = lesson.requiredKeys else {
            // Static content fallback
            return lesson.contentPattern
        }
        
        // Dynamic content generation
        let leftIndex = layoutAdapter.characters(for: .homeLeftIndex, layout: layout)
        let rightIndex = layoutAdapter.characters(for: .homeRightIndex, layout: layout)
        
        // Simple MVP pattern generator mostly for Lesson 1
        if keys.contains(.homeLeftIndex) && keys.contains(.homeRightIndex) {
             // Pattern: f j f j ff jj fj
            return "\(leftIndex) \(rightIndex) \(leftIndex) \(rightIndex) \(leftIndex)\(leftIndex) \(rightIndex)\(rightIndex) \(leftIndex)\(rightIndex)"
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
    
    private func loadCurriculum() {
        // Use LessonCatalog for the comprehensive 100+ lesson curriculum
        stages = LessonCatalog.shared.generateAllStages()
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
            mainExercises.append(
                Exercise(
                    type: .sentence,
                    content: lesson.contentPattern,
                    targetMetric: MetricTarget(metric: .wpm, threshold: 20),
                    timeLimit: nil,
                    repetitions: 3
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
            case .homeRightPinky, .topRightPinky, .bottomRightPinky, .numRightPinky, .topRightPinky2, .topRightPinky3, .bottomRightPinky2, .bottomRightPinky3: columns.insert(.rightPinky)
            }
        }
        
        return Array(columns)
    }
    
    private func getUserStats(_ userProfile: UserProfile) -> ProgressTracker.UserStats {
        return ProgressTracker.shared.userStats
    }
}

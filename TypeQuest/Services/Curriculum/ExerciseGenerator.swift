import Foundation

class ExerciseGenerator {
    
    // MARK: - Anchor Exercises
    func generateAnchorExercise(
        targetKeys: [Character],
        difficulty: Double,
        duration: Int,
        userProfile: UserProfile
    ) -> Exercise {
        let keys = targetKeys
        var content = ""
        
        for _ in 0..<10 {
            for key in keys {
                let s = String(key)
                content += "\(s)\(s)\(s) "
            }
        }
        
        // CORRECTION: Ensure we never return empty content, which breaks the UI
        if content.trimmingCharacters(in: .whitespaces).isEmpty {
            // Fallback for when keys are missing or mapping fails
            content = "asdf jkl; asdf jkl;" 
        }
        
        return Exercise(
            type: .anchor,
            content: content.trimmingCharacters(in: .whitespaces),
            targetMetric: MetricTarget(metric: .accuracy, threshold: 0.90 + (difficulty * 0.1)),
            timeLimit: duration,
            repetitions: 1
        )
    }
    
    func generateAnchorExercise(
        targetKeys: [AbstractKey],
        difficulty: Double,
        duration: Int,
        userProfile: UserProfile
    ) -> Exercise {
        let chars = targetKeys.map { LayoutAdapter.shared.characters(for: $0, layout: (userProfile.layout)).first ?? "?" }
        return generateAnchorExercise(targetKeys: chars, difficulty: difficulty, duration: duration, userProfile: userProfile)
    }

    // MARK: - Column Exercises
    func generateColumnExercise(
        targetColumn: KeyColumn,
        difficulty: Double,
        previousMastery: Double
    ) -> Exercise {
        let keys = targetColumn.keys
        var content = ""
        for _ in 0..<8 {
            let k1 = keys.randomElement() ?? " "
            let k2 = keys.randomElement() ?? " "
            let k3 = keys.randomElement() ?? " "
            content += "\(k1)\(k2)\(k3) "
        }
        
        return Exercise(
            type: .column,
            content: content,
            targetMetric: MetricTarget(metric: .accuracy, threshold: 0.9 + difficulty*0.05),
            timeLimit: nil,
            repetitions: 2
        )
    }

    // MARK: - N-Grams
    func generateNgramExercise(
        targetNgrams: [String],
        contextLevel: ContextLevel,
        difficulty: Double
    ) -> Exercise {
        var content = ""
        
        switch contextLevel {
        case .isolated:
            content = targetNgrams.map { "\($0) \($0) \($0)" }.joined(separator: " ")
        case .embedded:
             content = targetNgrams.map { "x\($0)x" }.joined(separator: " ")
        case .lexical:
             content = targetNgrams.joined(separator: " ")
        case .sentential:
             content = targetNgrams.joined(separator: " ")
        }
        
        if content.isEmpty && !targetNgrams.isEmpty {
           content = targetNgrams.joined(separator: " ")
        } else if content.isEmpty {
            content = "th he in er"
        }
        
        return Exercise(
            type: .ngram,
            content: content,
            targetMetric: MetricTarget(metric: .wpm, threshold: 10 + difficulty*20),
            timeLimit: nil,
            repetitions: 3
        )
    }

    // MARK: - Words
    func generateWordExercise(
        targetWords: [String],
        allowedKeys: [AbstractKey]? = nil,
        userProfile: UserProfile,
        focusArea: FocusArea,
        userStats: ProgressTracker.UserStats
    ) -> Exercise {
        var finalWords: [String] = targetWords
        
        if finalWords.isEmpty {
            if let keys = allowedKeys, !keys.isEmpty {
                // Generate dynamic words based on known keys
                let chars = keys.flatMap { LayoutAdapter.shared.characters(for: $0, layout: userProfile.layout) }
                let charSet = Set(chars.map { Character($0.lowercased()) })
                finalWords = LanguageModel.shared.getWords(allowedChars: charSet, count: 10)
            } else {
                finalWords = ["the", "and", "for"]
            }
        }
        
        let content = finalWords.joined(separator: " ")
        return Exercise(
            type: .word,
            content: content,
            targetMetric: MetricTarget(metric: .wpm, threshold: 20),
            timeLimit: nil,
            repetitions: 3
        )
    }
    
    // MARK: - Sentences
    func generateSentenceExercise(
        vocabularyLevel: VocabularyLevel,
        syntaxComplexity: SyntaxComplexity,
        contentDomain: ContentDomain,
        userProfile: UserProfile
    ) -> Exercise {
        let sentences = LanguageModel.shared.generateSentences(
            language: userProfile.primaryLanguage,
            count: 5,
            vocabularyLevel: vocabularyLevel,
            complexity: syntaxComplexity,
            domain: contentDomain,
            ageGroup: userProfile.ageGroup
        )
        let content = sentences.joined(separator: " ")
        return Exercise(
            type: .sentence,
            content: content,
            targetMetric: MetricTarget(metric: .wpm, threshold: 30),
            timeLimit: nil,
            repetitions: 1
        )
    }
}

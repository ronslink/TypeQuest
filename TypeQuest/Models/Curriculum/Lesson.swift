import Foundation

public struct Lesson: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let description: String
    public let stageId: Int
    public let moduleId: String
    public let order: Int
    public let difficulty: LessonDifficulty
    public let contentPattern: String
    public let passingRequirements: PassingRequirements
    
    public let requiredKeys: [AbstractKey]?
    
    // MARK: - Scientific Content
    public var targetNGrams: [String] = []
    public var targetWords: [String] = []
    
    // MARK: - Pedagogical Content
    public var learningGoal: String = ""
    public var habitTip: String = ""
    public var biomechanicalFocus: String = ""
    public var cognitiveStrategy: String = ""
    
    // MARK: - Age Adaptation
    public var childNarrative: String?
    public var adultExplanation: String = ""
    public var seniorFocus: String?
    
    // MARK: - Requirements
    public var recommendedDuration: Int = 5
    
    public enum LessonDifficulty: String, Codable, CaseIterable {
        case beginner, elementary, intermediate, advanced, expert
        
        public var xpMultiplier: Double {
            switch self {
            case .beginner: return 1.0
            case .elementary: return 1.2
            case .intermediate: return 1.5
            case .advanced: return 2.0
            case .expert: return 2.5
            }
        }
    }
    
    public struct PassingRequirements: Codable, Hashable {
        public let minAccuracy: Double
        public let minWPM: Double
        public init(minAccuracy: Double, minWPM: Double) {
            self.minAccuracy = minAccuracy
            self.minWPM = minWPM
        }
    }
}

public enum AbstractKey: String, Codable, Hashable {
    case homeLeftPinky, homeLeftRing, homeLeftMiddle, homeLeftIndex
    case homeRightIndex, homeRightMiddle, homeRightRing, homeRightPinky
    case topLeftPinky, topLeftRing, topLeftMiddle, topLeftIndex
    case topRightIndex, topRightMiddle, topRightRing, topRightPinky
    case bottomLeftPinky, bottomLeftRing, bottomLeftMiddle, bottomLeftIndex
    case bottomRightIndex, bottomRightMiddle, bottomRightRing, bottomRightPinky
    
    // Extended keys
    case topRightPinky2, topRightPinky3
    case bottomRightPinky2, bottomRightPinky3
    case numLeftPinky, numLeftRing, numLeftMiddle, numLeftIndex
    case numRightIndex, numRightMiddle, numRightRing, numRightPinky
}

public struct Exercise: Codable {
    public let type: ExerciseType
    public let content: String
    public let targetMetric: MetricTarget
    public let timeLimit: Int?
    public var repetitions: Int
    public init(type: ExerciseType, content: String, targetMetric: MetricTarget, timeLimit: Int?, repetitions: Int) {
        self.type = type
        self.content = content
        self.targetMetric = targetMetric
        self.timeLimit = timeLimit
        self.repetitions = repetitions
    }
}

public enum ExerciseType: String, Codable {
    case anchor, column, ngram, word, sentence, speed, accuracy
}

public struct MetricTarget: Codable {
    public let metric: Metric
    public let threshold: Double
    public init(metric: Metric, threshold: Double) {
        self.metric = metric
        self.threshold = threshold
    }
}

public enum Metric: String, Codable {
    case wpm, accuracy, consistency, errorRate
}

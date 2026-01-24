import Foundation

public enum ContextLevel: String, Codable, Sendable {
    case isolated, embedded, lexical, sentential
}

public enum FocusArea: String, Codable, Sendable {
    case highFrequency, problemKeys
}

public enum VocabularyLevel: String, Codable, Sendable {
    case beginner, intermediate, advanced
}

public enum SyntaxComplexity: String, Codable, Sendable {
    case simple, compound, complex
}

public enum ContentDomain: String, Codable, Sendable {
    case general, professional, technical
}

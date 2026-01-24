import Foundation

enum SupportedLanguage: String, CaseIterable, Codable {
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case german = "de"
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Español"
        case .french: return "Français"
        case .german: return "Deutsch"
        }
    }
}

final class LanguageModel: Sendable {
    static let shared = LanguageModel() // Singleton for easy access
    
    // Templates by Language -> Complexity -> List
    private let sentenceTemplates: [SupportedLanguage: [SyntaxComplexity: [String]]] = [
        .english: [
            .simple: [
                "{subject} {verb} {object}.",
                "{subject} {verb} {adverb}.",
                "The {noun} is {adjective}.",
                "I {verb} a {adjective} {noun}."
            ],
            .complex: [
                "{subject} {verb} {object} because {reason}.",
                "If {condition}, then {consequence}.",
                "{subject} who {verb} {object} is {adjective}."
            ]
        ],
        .spanish: [
            .simple: [
                "{subject} {verb} {object}.", // El gato come pescado
                "{subject} es {adjective}.", // La casa es grande
                "Yo {verb} un {noun} {adjective}."
            ],
            .complex: [
                "{subject} {verb} {object} porque {reason}.",
                "Si {condition}, entonces {consequence}."
            ]
        ],
        .french: [
            .simple: [
                "{subject} {verb} {object}.", // Le chat mange du poisson
                "{subject} est {adjective}.", // La maison est grande
                "Je {verb} un {noun} {adjective}."
            ],
            .complex: [
                "{subject} {verb} {object} parce que {reason}.",
                "Si {condition}, alors {consequence}."
            ]
        ],
        .german: [
            .simple: [
                "{subject} {verb} {object}.", // Die Katze frisst Fisch
                "{subject} ist {adjective}.", // Das Haus ist groß
                "Ich {verb} ein {adjective} {noun}."
            ],
            .complex: [
                "{subject} {verb} {object}, weil {reason}.",
                "Wenn {condition}, dann {consequence}."
            ]
        ]
    ]
    
    // Vocabulary by Language -> Domain -> Vocab
    private let vocabulary: [SupportedLanguage: [ContentDomain: DomainVocabulary]] = [
        .english: [
            .general: DomainVocabulary(
                subjects: ["the cat", "the dog", "the bird", "I", "you", "we"],
                verbs: ["eat", "see", "find", "take", "make"],
                objects: ["food", "water", "home", "ball", "book"],
                adjectives: ["good", "big", "small", "happy", "blue"]
            ),
             .professional: DomainVocabulary(
                subjects: ["the manager", "the team", "the client"],
                verbs: ["optimize", "deliver", "review"],
                objects: ["the project", "the report", "the data"],
                adjectives: ["efficient", "strategic", "urgent"]
            )
        ],
        .spanish: [
            .general: DomainVocabulary(
                subjects: ["el gato", "el perro", "el pájaro", "yo", "tú", "nosotros"],
                verbs: ["como", "veo", "encuentro", "tomo", "hago"],
                objects: ["comida", "agua", "casa", "pelota", "libro"],
                adjectives: ["bueno", "grande", "pequeño", "feliz", "azul"]
            )
        ],
        .french: [
            .general: DomainVocabulary(
                subjects: ["le chat", "le chien", "l'oiseau", "je", "tu", "nous"],
                verbs: ["mange", "vois", "trouve", "prends", "fais"],
                objects: ["la nourriture", "l'eau", "la maison", "la balle", "le livre"],
                adjectives: ["bon", "grand", "petit", "heureux", "bleu"]
            )
        ],
        .german: [
            .general: DomainVocabulary(
                subjects: ["die Katze", "der Hund", "der Vogel", "ich", "du", "wir"],
                verbs: ["esse", "sehe", "finde", "nehme", "mache"],
                objects: ["Essen", "Wasser", "Haus", "Ball", "Buch"],
                adjectives: ["gut", "groß", "klein", "glücklich", "blau"]
            )
        ]
    ]
    
    // Fallback data
    private let defaultConstraints = VocabularyConstraint(maxWordLength: 100, maxSentenceLength: 100, preferredTopics: [], avoidTopics: [])
    
    func generateSentences(
        language: String = "en",
        count: Int,
        vocabularyLevel: VocabularyLevel = .intermediate,
        complexity: SyntaxComplexity = .simple,
        domain: ContentDomain = .general,
        ageGroup: AgeGroup = .adult
    ) -> [String] {
        let langEnum = SupportedLanguage(rawValue: language) ?? .english
        
        // Safety checks for missing localized data
        let templates = sentenceTemplates[langEnum]?[complexity] ?? sentenceTemplates[.english]![.simple]!
        let vocabDict = vocabulary[langEnum] ?? vocabulary[.english]!
        let domainVocab = vocabDict[domain] ?? vocabDict[.general]!
        
        var sentences: [String] = []
        
        for _ in 0..<count {
            let template = templates.randomElement() ?? "{subject} {verb}."
            let sentence = fillTemplate(template, with: domainVocab)
            sentences.append(sentence)
        }
        
        return sentences
    }
    
    private func fillTemplate(_ template: String, with vocab: DomainVocabulary) -> String {
        var result = template
        result = result.replacingOccurrences(of: "{subject}", with: vocab.subjects.randomElement() ?? "something")
        result = result.replacingOccurrences(of: "{verb}", with: vocab.verbs.randomElement() ?? "does")
        result = result.replacingOccurrences(of: "{object}", with: vocab.objects.randomElement() ?? "something")
        result = result.replacingOccurrences(of: "{noun}", with: vocab.objects.randomElement() ?? "thing")
        result = result.replacingOccurrences(of: "{adjective}", with: vocab.adjectives.randomElement() ?? "nice")
        result = result.replacingOccurrences(of: "{adverb}", with: "quickly")
        
        // Complex placeholders fallback
        result = result.replacingOccurrences(of: "{reason}", with: "it is necessary")
        result = result.replacingOccurrences(of: "{condition}", with: "it happens")
        result = result.replacingOccurrences(of: "{consequence}", with: "it works")
        
        // Capitalize first letter
        return result.prefix(1).uppercased() + result.dropFirst()
    }
    
    func getWords(allowedChars: Set<Character>, count: Int = 10) -> [String] {
        // Flatten all vocab for the default language (English for MVP)
        // In a real app, strict dictionary lookup is needed.
        // For MVP, we'll scan the embedded vocab + a small hardcoded beginner list
        
        let commonBeginnerWords = [
            "as", "dad", "sad", "lad", "lass", "fall", "all", "ask", "add", "has", "had", 
            "glass", "flag", "flash", "half", "hall", "slash", "gash", "jag", "salad",
            "fads", "lads", "sads", "dads",
            "j", "f", "k", "d", "l", "s", "a", ";", // Single chars
            "ff", "jj", "kk", "dd", "ll", "ss", "aa" // Doubles
        ]
        
        // Collect candidates
        var candidates: Set<String> = []
        
        // 1. Add beginner list
        candidates.formUnion(commonBeginnerWords)
        
        // 2. Add from internal vocab
        if let vocabDict = vocabulary[.english] {
            for (_, domainVocab) in vocabDict {
                candidates.formUnion(domainVocab.subjects.flatMap { $0.split(separator: " ").map(String.init) })
                candidates.formUnion(domainVocab.verbs)
                candidates.formUnion(domainVocab.objects)
                candidates.formUnion(domainVocab.adjectives)
            }
        }
        
        // Filter
        let validWords = candidates.filter { word in
            let lower = word.lowercased()
             // Allow spaces for multi-word phrases if we were processing them, but here we split
            return !lower.isEmpty && lower.allSatisfy { char in
                allowedChars.contains(char) || char.isWhitespace
            }
        }
        
        if validWords.isEmpty {
            // Extreme fallback: just patterns of the allowed chars
            let chars = Array(allowedChars)
            return (0..<count).map { _ in
                String((0..<4).map { _ in chars.randomElement() ?? "a" })
            }
        }
        
        return Array(validWords.shuffled().prefix(count))
    }
}

// Re-defining supporting structs if they are not in separate files, 
// ensuring they are visible or reusing if they exist in another file. 
// Assuming they were internal to LanguageModel.swift before.

struct DomainVocabulary {
    let subjects: [String]
    let verbs: [String]
    let objects: [String]
    let adjectives: [String]
}

struct VocabularyConstraint {
    let maxWordLength: Int
    let maxSentenceLength: Int
    let preferredTopics: [String]
    let avoidTopics: [String]
}

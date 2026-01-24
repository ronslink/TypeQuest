import Foundation

class WordFrequencyDatabase {
    
    // A simplified mock database of words and their frequencies
    private let words: [String: Int] = [
        "the": 1000000, "be": 800000, "to": 700000, "of": 600000, "and": 500000,
        "that": 400000, "have": 300000, "i": 200000, "it": 150000, "for": 140000,
        "not": 130000, "on": 120000, "with": 110000, "he": 100000, "as": 90000,
        "you": 80000, "do": 75000, "at": 70000, "this": 65000, "but": 60000,
        "his": 55000, "by": 50000, "from": 45000, "they": 40000, "we": 35000,
        "say": 30000, "her": 25000, "she": 20000, "or": 18000, "will": 16000,
        "an": 15000, "my": 14000, "one": 13000, "all": 12000, "would": 11000,
        "there": 10000, "their": 9000, "what": 8000, "so": 7000, "up": 6000,
        "out": 5500, "if": 5000, "about": 4500, "who": 4000, "get": 3500,
        "which": 3000, "go": 2500, "me": 2000, "when": 1500, "make": 1000,
        "can": 900, "like": 800, "time": 750, "no": 700, "just": 650,
        "him": 600, "know": 550, "take": 500, "people": 450, "into": 400,
        "year": 350, "your": 300, "good": 250, "some": 200, "could": 150,
        "them": 100, "see": 90, "other": 80, "than": 70, "then": 60,
        "now": 50, "look": 40, "only": 30, "come": 20, "its": 10
    ]
    
    func findWords(containing ngram: String, minFrequency: Int, limit: Int) -> [String] {
        return words.filter { $0.key.contains(ngram.lowercased()) && $0.value >= minFrequency }
            .sorted { $0.value > $1.value }
            .prefix(limit)
            .map { $0.key }
    }
}

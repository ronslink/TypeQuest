import Foundation

@MainActor
final class LessonCatalog {
    static let shared = LessonCatalog()
    
    private init() {}
    
    // MARK: - Generate All Stages
    func generateAllStages() -> [Stage] {
        return [
            generateStage1(),
            generateStage2(),
            generateStage3(),
            generateStage4(),
            generateStage5(),
            generateStage6()
        ]
    }
    
    // MARK: - Stage 1: Home Row Foundation
    private func generateStage1() -> Stage {
        let lessons1 = [
            createLesson(id: "1.1.1", moduleId: "1.1", name: "A & S Keys", order: 1, content: "aaa sss aaa sss as sa as sa"),
            createLesson(id: "1.1.2", moduleId: "1.1", name: "D & F Keys", order: 2, content: "ddd fff ddd fff df fd df fd"),
            createLesson(id: "1.1.3", moduleId: "1.1", name: "Left Hand Practice", order: 3, content: "asdf asdf fdsa fdsa sad fad")
        ]
        let lessons2 = [
            createLesson(id: "1.2.1", moduleId: "1.2", name: "J & K Keys", order: 1, content: "jjj kkk jjj kkk jk kj jk kj"),
            createLesson(id: "1.2.2", moduleId: "1.2", name: "L & ; Keys", order: 2, content: "lll ;;; lll ;;; l; ;l l; ;l"),
            createLesson(id: "1.2.3", moduleId: "1.2", name: "Right Hand Practice", order: 3, content: "jkl; jkl; ;lkj ;lkj")
        ]
        let lessons3 = [
            createLesson(id: "1.3.1", moduleId: "1.3", name: "Full Home Row", order: 1, content: "asdf jkl; asdf jkl; sad dad lad ask"),
            createLesson(id: "1.3.2", moduleId: "1.3", name: "Home Row Speed", order: 2, content: "all fall flask salad jaffa")
        ]
        
        let modules = [
            Module(id: "1.1", name: "Left Hand Anchors", description: "Master left hand position", stageId: 1, order: 1, lessons: lessons1),
            Module(id: "1.2", name: "Right Hand Anchors", description: "Master right hand position", stageId: 1, order: 2, lessons: lessons2),
            Module(id: "1.3", name: "Home Row Mastery", description: "Combine both hands", stageId: 1, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 1, name: "Home Row Foundation", themeName: "Forest", description: "Master the home row keys", iconName: "hand.raised.fill", modules: modules)
    }
    
    // MARK: - Stage 2: Top Row Expansion
    private func generateStage2() -> Stage {
        let lessons1 = [
            createLesson(id: "2.1.1", moduleId: "2.1", name: "Q & W Keys", order: 1, content: "qqq www qqq www qw wq quick wake"),
            createLesson(id: "2.1.2", moduleId: "2.1", name: "E & R Keys", order: 2, content: "eee rrr eee rrr er re were eer"),
            createLesson(id: "2.1.3", moduleId: "2.1", name: "T Key", order: 3, content: "ttt ttt the that tree treat")
        ]
        let lessons2 = [
            createLesson(id: "2.2.1", moduleId: "2.2", name: "Y & U Keys", order: 1, content: "yyy uuu yyy uuu yu uy you your"),
            createLesson(id: "2.2.2", moduleId: "2.2", name: "I & O Keys", order: 2, content: "iii ooo iii ooo io oi into oil"),
            createLesson(id: "2.2.3", moduleId: "2.2", name: "P Key", order: 3, content: "ppp ppp pip poppur pipe paper")
        ]
        let lessons3 = [
            createLesson(id: "2.3.1", moduleId: "2.3", name: "Full Top Row", order: 1, content: "qwerty uiop qwertyuiop typewriter"),
            createLesson(id: "2.3.2", moduleId: "2.3", name: "Home + Top Flow", order: 2, content: "quiet power write proper tower")
        ]
        
        let modules = [
            Module(id: "2.1", name: "Top Row Left", description: "Q W E R T keys", stageId: 2, order: 1, lessons: lessons1),
            Module(id: "2.2", name: "Top Row Right", description: "Y U I O P keys", stageId: 2, order: 2, lessons: lessons2),
            Module(id: "2.3", name: "Top Row Mastery", description: "Full top row flow", stageId: 2, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 2, name: "Top Row Expansion", themeName: "Mountains", description: "Reach up to the top row", iconName: "arrow.up.circle.fill", modules: modules)
    }
    
    // MARK: - Stage 3: Bottom Row & N-Grams
    private func generateStage3() -> Stage {
        let lessons1 = [
            createLesson(id: "3.1.1", moduleId: "3.1", name: "Z & X Keys", order: 1, content: "zzz xxx zzz xxx zx xz zero fox"),
            createLesson(id: "3.1.2", moduleId: "3.1", name: "C & V Keys", order: 2, content: "ccc vvv ccc vvv cv vc cave vice"),
            createLesson(id: "3.1.3", moduleId: "3.1", name: "B Key", order: 3, content: "bbb bbb bob big bag ball basic")
        ]
        let lessons2 = [
            createLesson(id: "3.2.1", moduleId: "3.2", name: "N & M Keys", order: 1, content: "nnn mmm nnn mmm nm mn name main"),
            createLesson(id: "3.2.2", moduleId: "3.2", name: "Comma & Period", order: 2, content: ",,, ... ,,, ... ,. ., one, two."),
            createLesson(id: "3.2.3", moduleId: "3.2", name: "Slash Key", order: 3, content: "/// /// and/or yes/no on/off")
        ]
        let lessons3 = [
            createLesson(id: "3.3.1", moduleId: "3.3", name: "Common Pairs: th, he", order: 1, content: "th th th the that this then he he he"),
            createLesson(id: "3.3.2", moduleId: "3.3", name: "Common Pairs: in, er", order: 2, content: "in in in re re re inner error"),
            createLesson(id: "3.3.3", moduleId: "3.3", name: "Common Pairs: an, on", order: 3, content: "an an an on on on and one can"),
            createLesson(id: "3.3.4", moduleId: "3.3", name: "Common Pairs: at, en", order: 4, content: "at at at en en en eaten attend"),
            createLesson(id: "3.3.5", moduleId: "3.3", name: "N-Gram Review", order: 5, content: "the and for are but not you all")
        ]
        
        let modules = [
            Module(id: "3.1", name: "Bottom Row Left", description: "Z X C V B keys", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "Bottom Row Right", description: "N M , . / keys", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "Common N-Grams", description: "Master letter pairs", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "Bottom Row & Patterns", themeName: "River", description: "Complete the alphabet", iconName: "arrow.down.circle.fill", modules: modules)
    }
    
    // MARK: - Stage 4: Word Mastery
    private func generateStage4() -> Stage {
        let lessons1 = [
            createLesson(id: "4.1.1", moduleId: "4.1", name: "High Frequency Set 1", order: 1, content: "the and for are but not you all"),
            createLesson(id: "4.1.2", moduleId: "4.1", name: "High Frequency Set 2", order: 2, content: "can had her was one our out day"),
            createLesson(id: "4.1.3", moduleId: "4.1", name: "High Frequency Set 3", order: 3, content: "get has him his how its may new"),
            createLesson(id: "4.1.4", moduleId: "4.1", name: "High Frequency Set 4", order: 4, content: "now old see two way who boy did"),
            createLesson(id: "4.1.5", moduleId: "4.1", name: "High Frequency Set 5", order: 5, content: "let put say she too use man own")
        ]
        let lessons2 = [
            createLesson(id: "4.2.1", moduleId: "4.2", name: "5-Letter Words Set 1", order: 1, content: "about after again being below could"),
            createLesson(id: "4.2.2", moduleId: "4.2", name: "5-Letter Words Set 2", order: 2, content: "first found great house large learn"),
            createLesson(id: "4.2.3", moduleId: "4.2", name: "5-Letter Words Set 3", order: 3, content: "never other place right small sound"),
            createLesson(id: "4.2.4", moduleId: "4.2", name: "5-Letter Words Set 4", order: 4, content: "still study their there these thing"),
            createLesson(id: "4.2.5", moduleId: "4.2", name: "5-Letter Words Set 5", order: 5, content: "think three water where which while")
        ]
        let lessons3 = [
            createLesson(id: "4.3.1", moduleId: "4.3", name: "30-Second Sprint", order: 1, content: "the and for are but not you all can had her was one our out day"),
            createLesson(id: "4.3.2", moduleId: "4.3", name: "60-Second Challenge", order: 2, content: "the quick brown fox jumps over the lazy dog pack my box with five dozen")
        ]
        
        let modules = [
            Module(id: "4.1", name: "Short High-Frequency", description: "3-4 letter common words", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "Medium-Length Words", description: "5+ letter words", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "Word Sprints", description: "Speed challenges", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "Word Mastery", themeName: "Library", description: "Build speed with words", iconName: "text.word.spacing", modules: modules)
    }
    
    // MARK: - Stage 5: Sentence Fluency
    private func generateStage5() -> Stage {
        let lessons1 = [
            createLesson(id: "5.1.1", moduleId: "5.1", name: "Basic Statements", order: 1, content: "The cat sat on the mat. I like to read books."),
            createLesson(id: "5.1.2", moduleId: "5.1", name: "Questions", order: 2, content: "How are you today? What time is it now?"),
            createLesson(id: "5.1.3", moduleId: "5.1", name: "Commands", order: 3, content: "Please close the door. Turn on the light.")
        ]
        let lessons2 = [
            createLesson(id: "5.2.1", moduleId: "5.2", name: "Conjunctions", order: 1, content: "I went to the store, and I bought some bread."),
            createLesson(id: "5.2.2", moduleId: "5.2", name: "Complex Ideas", order: 2, content: "Although it was raining, we decided to go outside.")
        ]
        let lessons3 = [
            createLesson(id: "5.3.1", moduleId: "5.3", name: "Short Paragraphs", order: 1, content: "The sun was setting over the horizon. Birds flew home to their nests."),
            createLesson(id: "5.3.2", moduleId: "5.3", name: "Professional Writing", order: 2, content: "Please find attached the quarterly report. Let me know if you have questions.")
        ]
        
        let modules = [
            Module(id: "5.1", name: "Simple Sentences", description: "Basic sentence flow", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "Compound Sentences", description: "Connected ideas", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "Paragraph Practice", description: "Multi-sentence flow", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "Sentence Fluency", themeName: "Ocean", description: "Type with rhythm", iconName: "text.alignleft", modules: modules)
    }
    
    // MARK: - Stage 6: Numbers & Symbols
    private func generateStage6() -> Stage {
        let lessons1 = [
            createLesson(id: "6.1.1", moduleId: "6.1", name: "1 & 2 Keys", order: 1, content: "111 222 111 222 12 21 12 21"),
            createLesson(id: "6.1.2", moduleId: "6.1", name: "3 & 4 Keys", order: 2, content: "333 444 333 444 34 43 34 43"),
            createLesson(id: "6.1.3", moduleId: "6.1", name: "5 & 6 Keys", order: 3, content: "555 666 555 666 56 65 56 65"),
            createLesson(id: "6.1.4", moduleId: "6.1", name: "7 & 8 Keys", order: 4, content: "777 888 777 888 78 87 78 87"),
            createLesson(id: "6.1.5", moduleId: "6.1", name: "9 & 0 Keys", order: 5, content: "999 000 999 000 90 09 90 09")
        ]
        let lessons2 = [
            createLesson(id: "6.2.1", moduleId: "6.2", name: "! @ # $", order: 1, content: "!!! @@@ ### $$$ !@#$ $#@!"),
            createLesson(id: "6.2.2", moduleId: "6.2", name: "% ^ & *", order: 2, content: "%%% ^^^ &&& *** %^&* *&^%"),
            createLesson(id: "6.2.3", moduleId: "6.2", name: "( ) - =", order: 3, content: "((( ))) --- === (test) a-b c=d"),
            createLesson(id: "6.2.4", moduleId: "6.2", name: "_ + [ ]", order: 4, content: "___ +++ [[[ ]]] _test_ [item]")
        ]
        let lessons3 = [
            createLesson(id: "6.3.1", moduleId: "6.3", name: "Numbers & Letters", order: 1, content: "abc123 def456 ghi789 jkl0"),
            createLesson(id: "6.3.2", moduleId: "6.3", name: "Full Keyboard", order: 2, content: "The quick brown fox jumps over 1,234 lazy dogs!")
        ]
        
        let modules = [
            Module(id: "6.1", name: "Number Row", description: "0-9 keys", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "Common Symbols", description: "Special characters", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "Mixed Practice", description: "Everything combined", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "Numbers & Symbols", themeName: "Lab", description: "Master the full keyboard", iconName: "number.circle.fill", modules: modules)
    }
    
    // MARK: - Lesson Factory
    private func createLesson(id: String, moduleId: String, name: String, order: Int, content: String) -> Lesson {
        let stageId = Int(moduleId.prefix(1)) ?? 1
        
        let keys = deduceKeys(from: name, content: content)
        let words = deduceWords(from: content)
        let ngrams = deduceNgrams(from: content)
        
        return Lesson(
            id: id,
            name: name,
            description: "Practice \(name.lowercased())",
            stageId: stageId,
            moduleId: moduleId,
            order: order,
            difficulty: difficultyFor(stage: stageId),
            contentPattern: content,
            passingRequirements: .init(minAccuracy: 85 + Double(stageId * 2), minWPM: 10 + Double(stageId * 3)),
            requiredKeys: keys,
            targetNGrams: ngrams,
            targetWords: words,
            learningGoal: "Master the \(name.lowercased())",
            habitTip: "Keep your fingers on home row"
        )
    }
    
    private func difficultyFor(stage: Int) -> Lesson.LessonDifficulty {
        switch stage {
        case 1: return .beginner
        case 2: return .elementary
        case 3: return .intermediate
        case 4: return .intermediate
        case 5: return .advanced
        case 6: return .advanced
        default: return .beginner
        }
    }
    
    // MARK: - Metadata Deduction Helpers
    
    private func deduceKeys(from name: String, content: String) -> [AbstractKey] {
        var keys: Set<AbstractKey> = []
        
        // 1. Try to parse from Name (e.g. "A & S Keys")
        let nameParts = name.components(separatedBy: CharacterSet(charactersIn: " &"))
        for part in nameParts {
            if part.count == 1, let char = part.lowercased().first {
                if let key = mapCharToKey(char) {
                    keys.insert(key)
                }
            }
        }
        
        // 2. If empty, scan content frequency
        if keys.isEmpty {
            let uniqueChars = Set(content.lowercased().filter { $0 != " " })
            for char in uniqueChars {
                if let key = mapCharToKey(char) {
                    keys.insert(key)
                }
            }
        }
        
        return Array(keys)
    }
    
    private func deduceWords(from content: String) -> [String] {
        let items = content.components(separatedBy: " ")
        return items.filter { $0.count > 3 } // Arbitrary threshold for "Word"
    }
    
    private func deduceNgrams(from content: String) -> [String] {
        let items = content.components(separatedBy: " ")
        return items.filter { $0.count >= 2 && $0.count <= 3 } // Arbitrary threshold for "N-gram"
    }
    
    private func mapCharToKey(_ char: Character) -> AbstractKey? {
        switch char {
        case "a": return .homeLeftPinky
        case "s": return .homeLeftRing
        case "d": return .homeLeftMiddle
        case "f": return .homeLeftIndex
        case "g": return .homeLeftIndex
        case "h": return .homeRightIndex
        case "j": return .homeRightIndex
        case "k": return .homeRightMiddle
        case "l": return .homeRightRing
        case ";": return .homeRightPinky
            
        case "q": return .topLeftPinky
        case "w": return .topLeftRing
        case "e": return .topLeftMiddle
        case "r": return .topLeftIndex
        case "t": return .topLeftIndex
        case "y": return .topRightIndex
        case "u": return .topRightIndex
        case "i": return .topRightMiddle
        case "o": return .topRightRing
        case "p": return .topRightPinky
            
        case "z": return .bottomLeftPinky
        case "x": return .bottomLeftRing
        case "c": return .bottomLeftMiddle
        case "b": return .bottomLeftIndex // Typo fix: V/B usually index
        case "v": return .bottomLeftIndex
        case "n": return .bottomRightIndex
        case "m": return .bottomRightIndex
        case ",": return .bottomRightMiddle
        case ".": return .bottomRightRing
        case "/": return .bottomRightPinky
            
        default: return nil
        }
    }
}

import Foundation

@MainActor
final class LessonCatalog {
    static let shared = LessonCatalog()
    
    private init() {}
    
    // MARK: - Generate All Stages
    func generateAllStages(language: String = "en") -> [Stage] {
        switch language.lowercased() {
        case "es":
            return generateSpanishStages()
        case "de":
            return generateGermanStages()
        case "nl":
            return generateDutchStages()
        case "fr":
            return generateFrenchStages()
        case "it":
            return generateItalianStages()
        case "pl":
            return generatePolishStages()
        case "cs":
            return generateCzechStages()
        case "sv":
            return generateSwedishStages()
        case "no":
            return generateNorwegianStages()
        case "da":
            return generateDanishStages()
        case "hu":
            return generateHungarianStages()
        case "fi":
            return generateFinnishStages()
        case "el":
            return generateGreekStages()
        case "hi":
            return generateHindiStages()
        case "ms":
            return generateMalayStages()
        case "tl":
            return generateTagalogStages()
        default:
            return generateEnglishStages()
        }
    }
    
    private func generateEnglishStages() -> [Stage] {
        return [
            generateEnglishStage1(),
            generateEnglishStage2(),
            generateEnglishStage3(),
            generateEnglishStage4(),
            generateEnglishStage5(),
            generateEnglishStage6()
        ]
    }
    
    // MARK: - Stage 1: Home Row Foundation
    private func generateEnglishStage1() -> Stage {
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
            createLesson(id: "1.3.2", moduleId: "1.3", name: "Home Row Speed", order: 2, content: "all fall flask salad jaffa"),
            createLesson(
                id: "1.4.1", 
                moduleId: "1.4", 
                name: "Stage 1 Pass Test", 
                order: 1, 
                content: "asdf jkl; ask dad sad lad all fall salad jaffa", 
                isGatekeeper: true,
                pool: [
                    "asdf jkl; ask dad sad lad all fall salad jaffa glass add has had half hall sash slash gash jag",
                    "glass salad fads lads sads asdf jkl; all fall flask sad dad ask jaffa flash salt lash flag fall",
                    "sad lads ask dad for salad and glass of salt. all fall down in the hall sash gash jag glass."
                ]
            )
        ]
        
        let modules = [
            Module(id: "1.1", name: "Left Hand Anchors", description: "Master left hand position", stageId: 1, order: 1, lessons: lessons1),
            Module(id: "1.2", name: "Right Hand Anchors", description: "Master right hand position", stageId: 1, order: 2, lessons: lessons2),
            Module(id: "1.3", name: "Home Row Mastery", description: "Combine both hands", stageId: 1, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 1, name: "Home Row Foundation", themeName: "Forest", description: "Master the home row keys", iconName: "hand.raised.fill", modules: modules)
    }
    
    // MARK: - Stage 2: Top Row Expansion
    private func generateEnglishStage2() -> Stage {
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
            createLesson(id: "2.3.2", moduleId: "2.3", name: "Home + Top Flow", order: 2, content: "quiet power write proper tower"),
            createLesson(
                id: "2.4.1", 
                moduleId: "2.4", 
                name: "Stage 2 Pass Test", 
                order: 1, 
                content: "the quick brown fox jumps over the lazy dog", 
                isGatekeeper: true,
                pool: [
                    "quiet power write proper tower together unique property typewriter priority route outer require output upper toward water result street trust youth people you your our their together unique",
                    "top row priority requires unique output. quiet water results in proper power for the street trust. typewriter route outer output upper toward water result street trust youth people.",
                    "proper power and quiet water results in unique route. typewriter output is the priority for the youth people on the street. toward the result we trust the water."
                ]
            )
        ]
        
        let modules = [
            Module(id: "2.1", name: "Top Row Left", description: "Q W E R T keys", stageId: 2, order: 1, lessons: lessons1),
            Module(id: "2.2", name: "Top Row Right", description: "Y U I O P keys", stageId: 2, order: 2, lessons: lessons2),
            Module(id: "2.3", name: "Top Row Mastery", description: "Full top row flow", stageId: 2, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 2, name: "Top Row Expansion", themeName: "Mountains", description: "Reach up to the top row", iconName: "arrow.up.circle.fill", modules: modules)
    }
    
    // MARK: - Stage 3: Bottom Row & N-Grams
    private func generateEnglishStage3() -> Stage {
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
            createLesson(id: "3.3.5", moduleId: "3.3", name: "N-Gram Review", order: 5, content: "the and for are but not you all"),
            createLesson(
                id: "3.4.1", 
                moduleId: "3.4", 
                name: "Stage 3 Pass Test", 
                order: 1, 
                content: "the quick brown fox jumps over the lazy dog", 
                isGatekeeper: true,
                pool: [
                    "the quick brown fox jumps over the lazy dog. sphinx of black quartz, judge my vow. pack my box with five dozen liquor jugs. heavy boxes contain small gifts.",
                    "sixty zippers were quickly picked from the woven basket. crazy fredrick bought many very exquisite opal jewels. jumps over the lazy dog with forty grand prizes.",
                    "a quick movement of the enemy will jeopardize six gunboats. amazingly few discotheques provide jukeboxes. public worldwide was very amazed by the quick fox."
                ]
            )
        ]
        
        let modules = [
            Module(id: "3.1", name: "Bottom Row Left", description: "Z X C V B keys", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "Bottom Row Right", description: "N M , . / keys", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "Common N-Grams", description: "Master letter pairs", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "Bottom Row & Patterns", themeName: "River", description: "Complete the alphabet", iconName: "arrow.down.circle.fill", modules: modules)
    }
    
    // MARK: - Stage 4: Word Mastery
    private func generateEnglishStage4() -> Stage {
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
            createLesson(id: "4.3.2", moduleId: "4.3", name: "60-Second Challenge", order: 2, content: "the quick brown fox jumps over the lazy dog pack my box with five dozen"),
            createLesson(
                id: "4.4.1", 
                moduleId: "4.4", 
                name: "Stage 4 Pass Test", 
                order: 1, 
                content: "the first great thing about being here is learning", 
                isGatekeeper: true,
                pool: [
                    "the first great thing about being here is learning how to use your own voice again. after three weeks of study, we found large improvements in speed and accuracy.",
                    "think about where you were when you started this journey. three things are certain: practice, patience, and progress. which path will you take to reach the next level?",
                    "still study their place right small sound could again being below could after found great house large learn never other place right small sound."
                ]
            )
        ]
        
        let modules = [
            Module(id: "4.1", name: "Short High-Frequency", description: "3-4 letter common words", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "Medium-Length Words", description: "5+ letter words", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "Word Sprints", description: "Speed challenges", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "Word Mastery", themeName: "Library", description: "Build speed with words", iconName: "text.word.spacing", modules: modules)
    }
    
    // MARK: - Stage 5: Sentence Fluency
    private func generateEnglishStage5() -> Stage {
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
            createLesson(id: "5.3.2", moduleId: "5.3", name: "Professional Writing", order: 2, content: "Please find attached the quarterly report. Let me know if you have questions."),
            createLesson(
                id: "5.4.1", 
                moduleId: "5.4", 
                name: "Stage 5 Pass Test", 
                order: 1, 
                content: "TypeQuest is the ultimate way to master touch typing.", 
                isGatekeeper: true,
                pool: [
                    "TypeQuest is the ultimate way to master touch typing. The path to fluency begins here with consistent practice and focused attention. By the time you reach this level, your fingers should move with a comfortable and steady rhythm.",
                    "The quick brown fox jumps over the lazy dog. Although it was raining, we decided to go outside and find the sun. Please find attached the quarterly report for the team to review.",
                    "Reading and writing are the foundations of digital communication. As you type these words, imagine the speed at which ideas can travel from your mind to the screen. Mastery is within reach."
                ]
            )
        ]
        
        let modules = [
            Module(id: "5.1", name: "Simple Sentences", description: "Basic sentence flow", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "Compound Sentences", description: "Connected ideas", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "Paragraph Practice", description: "Multi-sentence flow", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "Sentence Fluency", themeName: "Ocean", description: "Type with rhythm", iconName: "text.alignleft", modules: modules)
    }
    
    // MARK: - Stage 6: Numbers & Symbols
    private func generateEnglishStage6() -> Stage {
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
            createLesson(id: "6.3.2", moduleId: "6.3", name: "Full Keyboard", order: 2, content: "The quick brown fox jumps over 1,234 lazy dogs!"),
            createLesson(
                id: "6.4.1", 
                moduleId: "6.4", 
                name: "Grand Mastery Test", 
                order: 1, 
                content: "Congrats! You've reached Stage 6.", 
                isGatekeeper: true,
                pool: [
                    "Congrats! You've reached Stage 6. Let's verify everything: 123 + 456 = 579. Does (obj.value > 0) { return true }? The quick brown fox jumps over the lazy dog. 100% mastery achieved!",
                    "Final project metrics include: (acc >= 98.0) && (wpm >= 50.0). System check completed: [OK]. Address is 123 Main St, Suite #404. Let's finish this journey together.",
                    "Special characters test: !@#$%^&*()_+ {}:\"<>? |\\. If (user.isExpert) { earnBadge(\"GrandMaster\") }. You have completed the TypeQuest curriculum. Well done!"
                ]
            )
        ]
        
        let modules = [
            Module(id: "6.1", name: "Number Row", description: "0-9 keys", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "Common Symbols", description: "Special characters", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "Mixed Practice", description: "Everything combined", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "Numbers & Symbols", themeName: "Lab", description: "Master the full keyboard", iconName: "number.circle.fill", modules: modules)
    }
    
    // MARK: - Lesson Factory
    private func createLesson(id: String, moduleId: String, name: String, order: Int, content: String, isGatekeeper: Bool = false, pool: [String]? = nil, learningGoal: String? = nil, habitTip: String? = nil, descriptionOverride: String? = nil) -> Lesson {
        let stageId = Int(moduleId.prefix(1)) ?? 1
        
        let keys = deduceKeys(from: name, content: content)
        let words = deduceWords(from: content)
        let ngrams = deduceNgrams(from: content)
        
        let passingAcc = isGatekeeper ? 96.0 : min(95.0, (85.0 + Double(stageId * 2)))
        let passingWPM = isGatekeeper ? (15.0 + Double(stageId * 5)) : (10.0 + Double(stageId * 3))
        
        var lesson = Lesson(
            id: id,
            name: name,
            description: descriptionOverride ?? "Practice \(name.lowercased())",
            stageId: stageId,
            moduleId: moduleId,
            order: order,
            difficulty: difficultyFor(stage: stageId),
            contentPattern: content,
            passingRequirements: .init(minAccuracy: passingAcc, minWPM: passingWPM),
            requiredKeys: keys,
            targetNGrams: ngrams,
            targetWords: words,
            learningGoal: learningGoal ?? "Master the \(name.lowercased())",
            habitTip: habitTip ?? "Keep your fingers on home row"
        )
        lesson.isGatekeeper = isGatekeeper
        lesson.contentPool = pool
        return lesson
    }
    
    // MARK: - Spanish Curriculum
    private func generateSpanishStages() -> [Stage] {
        return [
            generateSpanishStage1(),
            generateSpanishStage2(),
            generateSpanishStage3(),
            generateSpanishStage4(),
            generateSpanishStage5(),
            generateSpanishStage6()
        ]
    }
    
    private func generateSpanishStage1() -> Stage {
        let lessons = [
            createLesson(id: "es.1.1.1", moduleId: "1.1", name: "Teclas A y S", order: 1, content: "aaa sss aaa sss as sa as sa",
                         learningGoal: "Domina las teclas A y S", habitTip: "Mantén los dedos en la fila base", descriptionOverride: "Practica las teclas A y S"),
            createLesson(
                id: "es.1.4.1", 
                moduleId: "1.4", 
                name: "Prueba de Nivel 1", 
                order: 2, 
                content: "asdf jkl; las salas", 
                isGatekeeper: true,
                pool: [
                    "asdf jkl; las salas de sal son sads. asdf jkl; salad salas alas sads.",
                    "alas de sal para las salas. asdf jkl; sads fads lads salad salsa.",
                    "salsa para la sala de sal. asdf jkl; sads fads lads salad salsa alas."
                ],
                learningGoal: "Aprueba la Prueba de Nivel 1", habitTip: "Mantén los dedos en la fila base", descriptionOverride: "Prueba de la fila base"
            )
        ]
        return Stage(id: 1, name: "Cimientos de la Fila Media", themeName: "Selva", description: "Domina las teclas del centro", iconName: "hand.raised.fill", modules: [
            Module(id: "1.1", name: "Anclas Izquierdas", description: "Posición de la mano izquierda", stageId: 1, order: 1, lessons: lessons)
        ])
    }
    
    private func generateSpanishStage2() -> Stage {
        let lessons = [
            createLesson(
                id: "es.2.4.1", 
                moduleId: "2.4", 
                name: "Prueba de Nivel 2", 
                order: 1, 
                content: "el rapido zorro marron", 
                isGatekeeper: true,
                pool: [
                    "el rapido zorro marron salta sobre el perro perezoso. que pequeño es el mundo cuando escribes rapido.",
                    "escribir es una prioridad para el exito. la ruta es larga pero el resultado es unico.",
                    "quiero poder escribir con propiedad y rapidez. todos los jovenes pueden aprender hoy mismo."
                ],
                learningGoal: "Aprueba la Prueba de Nivel 2", habitTip: "Mueve solo el dedo necesario, mantén los demás quietos", descriptionOverride: "Prueba de la fila superior"
            )
        ]
        return Stage(id: 2, name: "Expansión de la Fila Superior", themeName: "Montañas", description: "Alcanza la fila de arriba", iconName: "arrow.up.circle.fill", modules: [
            Module(id: "2.1", name: "Maestría Superior", description: "Flujo de la fila superior", stageId: 2, order: 1, lessons: lessons)
        ])
    }

    // MARK: - Stage 3: Bottom Row & N-Grams (Spanish)
    private func generateSpanishStage3() -> Stage {
        let lessons1 = [
            createLesson(id: "es.3.1.1", moduleId: "3.1", name: "Teclas Z y X", order: 1, content: "zzz xxx zzz xxx zx xz zorro extra",
                         learningGoal: "Domina las teclas Z y X", habitTip: "Mantén los dedos en la fila base", descriptionOverride: "Practica las teclas Z y X"),
            createLesson(id: "es.3.1.2", moduleId: "3.1", name: "Teclas C y V", order: 2, content: "ccc vvv ccc vvv cv vc cinco vaso",
                         learningGoal: "Domina las teclas C y V", habitTip: "Mueve solo el dedo necesario", descriptionOverride: "Practica las teclas C y V"),
            createLesson(id: "es.3.1.3", moduleId: "3.1", name: "Tecla B", order: 3, content: "bbb bbb bob bebe boca baile",
                         learningGoal: "Domina la tecla B", habitTip: "Usa el dedo índice para B", descriptionOverride: "Practica la tecla B")
        ]
        let lessons2 = [
            createLesson(id: "es.3.2.1", moduleId: "3.2", name: "Teclas N y M", order: 1, content: "nnn mmm nnn mmm nm mn nombre mano",
                         learningGoal: "Domina las teclas N y M", habitTip: "Mantén los dedos en la fila base", descriptionOverride: "Practica las teclas N y M"),
            createLesson(id: "es.3.2.2", moduleId: "3.2", name: "Coma y Punto", order: 2, content: ",,, ... ,,, ... ,. ., uno, dos.",
                         learningGoal: "Domina coma y punto", habitTip: "Usa el dedo anular derecho para el punto", descriptionOverride: "Practica coma y punto"),
            createLesson(id: "es.3.2.3", moduleId: "3.2", name: "Tecla Guion", order: 3, content: "--- --- si-no arriba-abajo",
                         learningGoal: "Domina el guion", habitTip: "Usa el dedo meñique derecho", descriptionOverride: "Practica el guion")
        ]
        let lessons3 = [
            createLesson(id: "es.3.3.1", moduleId: "3.3", name: "Pares Comunes: el, la", order: 1, content: "el el el la la la en er es esta",
                         learningGoal: "Domina los pares el y la", habitTip: "Mantén un ritmo fluido", descriptionOverride: "Practica pares de letras comunes"),
            createLesson(id: "es.3.3.2", moduleId: "3.3", name: "Pares Comunes: qu, ue", order: 2, content: "qu qu qu ue ue ue que quien fue",
                         learningGoal: "Domina los pares qu y ue", habitTip: "Escribe los pares como una unidad", descriptionOverride: "Practica pares de letras comunes"),
            createLesson(
                id: "es.3.4.1", 
                moduleId: "3.4", 
                name: "Prueba de Nivel 3", 
                order: 1, 
                content: "el rapido zorro marron salta", 
                isGatekeeper: true,
                pool: [
                    "el rapido zorro marron salta sobre el perro perezoso. que pequeño es el mundo.",
                    "quiero comer cinco tacos de pollo. vamos a la playa mañana por la tarde.",
                    "la musica es muy fuerte en la fiesta. me gusta bailar con mis amigos."
                ],
                learningGoal: "Aprueba la Prueba de Nivel 3", habitTip: "Mantén la calma y escribe de forma uniforme", descriptionOverride: "Prueba de la fila inferior"
            )
        ]
        
        let modules = [
            Module(id: "3.1", name: "Fila Inferior Izquierda", description: "Teclas Z X C V B", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "Fila Inferior Derecha", description: "Teclas N M , . -", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "N-Gramas Comunes", description: "Domina pares de letras", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "Fila Inferior y Patrones", themeName: "Río", description: "Completa el alfabeto", iconName: "arrow.down.circle.fill", modules: modules)
    }

    // MARK: - Stage 4: Word Mastery (Spanish)
    private func generateSpanishStage4() -> Stage {
        let lessons1 = [
            createLesson(id: "es.4.1.1", moduleId: "4.1", name: "Palabras Frecuentes 1", order: 1, content: "el la de que y en un ser se no",
                         learningGoal: "Domina las palabras cortas más frecuentes", habitTip: "Lee la palabra primero, luego escríbela", descriptionOverride: "Practica palabras frecuentes"),
            createLesson(id: "es.4.1.2", moduleId: "4.1", name: "Palabras Frecuentes 2", order: 2, content: "por con su para como estar tener le lo todo",
                         learningGoal: "Amplía tu vocabulario", habitTip: "Escribe palabras completas como un movimiento", descriptionOverride: "Practica palabras frecuentes"),
            createLesson(id: "es.4.1.3", moduleId: "4.1", name: "Palabras Frecuentes 3", order: 3, content: "pero mas o ir ese si me ya ver porque",
                         learningGoal: "Domina más palabras frecuentes", habitTip: "Concéntrate en la precisión antes que la velocidad", descriptionOverride: "Practica palabras frecuentes")
        ]
        let lessons2 = [
            createLesson(id: "es.4.2.1", moduleId: "4.2", name: "Palabras Largas 1", order: 1, content: "tiempo hombre mujer mundo vida",
                         learningGoal: "Domina palabras más largas", habitTip: "Divide las palabras largas en sílabas", descriptionOverride: "Practica palabras largas"),
            createLesson(id: "es.4.2.2", moduleId: "4.2", name: "Palabras Largas 2", order: 2, content: "cabeza puerta calle nuevo brazo",
                         learningGoal: "Mejora la fluidez de palabras", habitTip: "Mantén un ritmo constante", descriptionOverride: "Practica palabras largas"),
            createLesson(id: "es.4.2.3", moduleId: "4.2", name: "Palabras Largas 3", order: 3, content: "blanco equipo juego campo mejor",
                         learningGoal: "Domina palabras complejas", habitTip: "Respira de manera uniforme al escribir", descriptionOverride: "Practica palabras largas")
        ]
        let lessons3 = [
            createLesson(id: "es.4.3.1", moduleId: "4.3", name: "Sprint de 30 Segundos", order: 1, content: "el la de que y en un ser se no por con su para",
                         learningGoal: "Aumenta la velocidad de escritura", habitTip: "¡No mires el teclado!", descriptionOverride: "Sprint de velocidad"),
            createLesson(
                id: "es.4.4.1", 
                moduleId: "4.4", 
                name: "Prueba de Nivel 4", 
                order: 1, 
                content: "la primera gran cosa es aprender", 
                isGatekeeper: true,
                pool: [
                    "la primera gran cosa es aprender a usar tu propia voz de nuevo.",
                    "piensa en donde estabas cuando empezaste este viaje de aprendizaje.",
                    "estudia sus lugares derecho pequeño sonido podria otra vez abajo."
                ],
                learningGoal: "Aprueba la Prueba de Nivel 4", habitTip: "Mantén la calma y escribe de forma uniforme", descriptionOverride: "Prueba de dominio de palabras"
            )
        ]
        
        let modules = [
            Module(id: "4.1", name: "Palabras Cortas", description: "Top 30 palabras", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "Palabras Medias", description: "5+ letras", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "Sprints de Palabras", description: "Construye velocidad", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "Dominio de Palabras", themeName: "Biblioteca", description: "Aumenta tu velocidad", iconName: "text.word.spacing", modules: modules)
    }

    // MARK: - Stage 5: Sentence Fluency (Spanish)
    private func generateSpanishStage5() -> Stage {
        let lessons1 = [
            createLesson(id: "es.5.1.1", moduleId: "5.1", name: "Oraciones Simples", order: 1, content: "El perro ladra fuerte. El gato duerme.",
                         learningGoal: "Escribe oraciones simples con fluidez", habitTip: "Lee la oración completa antes de escribir", descriptionOverride: "Practica oraciones simples"),
            createLesson(id: "es.5.1.2", moduleId: "5.1", name: "Preguntas", order: 2, content: "¿Cómo estás hoy? ¿Qué hora es?",
                         learningGoal: "Domina los signos de interrogación", habitTip: "Presta atención a los signos de puntuación", descriptionOverride: "Practica preguntas"),
            createLesson(id: "es.5.1.3", moduleId: "5.1", name: "Comandos", order: 3, content: "Cierra la puerta por favor. Enciende la luz.",
                         learningGoal: "Escribe comandos con seguridad", habitTip: "No olvides la mayúscula al inicio", descriptionOverride: "Practica comandos")
        ]
        let lessons2 = [
            createLesson(id: "es.5.2.1", moduleId: "5.2", name: "Oraciones Compuestas", order: 1, content: "Fui a la tienda, y compre pan.",
                         learningGoal: "Domina oraciones compuestas", habitTip: "Mantén el flujo constante a través de las comas", descriptionOverride: "Practica oraciones compuestas"),
            createLesson(id: "es.5.2.2", moduleId: "5.2", name: "Ideas Complejas", order: 2, content: "Aunque estaba lloviendo, decidimos salir.",
                         learningGoal: "Escribe oraciones complejas con fluidez", habitTip: "No pares en oraciones largas", descriptionOverride: "Practica ideas complejas")
        ]
        let lessons3 = [
            createLesson(
                id: "es.5.4.1", 
                moduleId: "5.4", 
                name: "Prueba de Nivel 5", 
                order: 1, 
                content: "TypeQuest es la mejor forma de aprender.", 
                isGatekeeper: true,
                pool: [
                    "TypeQuest es la mejor forma de aprender a escribir. Con practica diaria mejoraras rapido.",
                    "El veloz murciélago hindú comía feliz cardillo y kiwi. La cigüeña tocaba el saxofón.",
                    "Leer y escribir son los cimientos de la comunicacion digital. Domina el teclado hoy."
                ],
                learningGoal: "Aprueba la Prueba de Nivel 5", habitTip: "Respira tranquilo y escribe de forma constante", descriptionOverride: "Prueba de fluidez de oraciones"
            )
        ]
        
        let modules = [
            Module(id: "5.1", name: "Oraciones Simples", description: "Flujo básico", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "Oraciones Compuestas", description: "Ideas conectadas", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "Práctica de Párrafos", description: "Flujo de varias oraciones", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "Fluidez de Oraciones", themeName: "Océano", description: "Escribe con ritmo", iconName: "text.alignleft", modules: modules)
    }

    // MARK: - Stage 6: Numbers & Symbols (Spanish)
    private func generateSpanishStage6() -> Stage {
        let lessons1 = [
            createLesson(id: "es.6.1.1", moduleId: "6.1", name: "Teclas 1 y 2", order: 1, content: "111 222 111 222 12 21 12 21",
                         learningGoal: "Domina las teclas 1 y 2", habitTip: "Estira el dedo hacia arriba, no toda la mano", descriptionOverride: "Practica las teclas 1 y 2"),
            createLesson(id: "es.6.1.2", moduleId: "6.1", name: "Teclas 3 y 4", order: 2, content: "333 444 333 444 34 43 34 43",
                         learningGoal: "Domina las teclas 3 y 4", habitTip: "Vuelve a la fila base después de cada número", descriptionOverride: "Practica las teclas 3 y 4"),
            createLesson(id: "es.6.1.3", moduleId: "6.1", name: "Teclas 5 y 6", order: 3, content: "555 666 555 666 56 65 56 65",
                         learningGoal: "Domina las teclas 5 y 6", habitTip: "Usa el dedo índice para 5 y 6", descriptionOverride: "Practica las teclas 5 y 6"),
            createLesson(id: "es.6.1.4", moduleId: "6.1", name: "Teclas 7 y 8", order: 4, content: "777 888 777 888 78 87 78 87",
                         learningGoal: "Domina las teclas 7 y 8", habitTip: "Usa el dedo índice para 7 y medio para 8", descriptionOverride: "Practica las teclas 7 y 8"),
            createLesson(id: "es.6.1.5", moduleId: "6.1", name: "Teclas 9 y 0", order: 5, content: "999 000 999 000 90 09 90 09",
                         learningGoal: "Domina las teclas 9 y 0", habitTip: "Dedos anular y meñique para 9 y 0", descriptionOverride: "Practica las teclas 9 y 0")
        ]
        let lessons2 = [
            createLesson(id: "es.6.2.1", moduleId: "6.2", name: "¡ ! \" · $", order: 1, content: "¡¡¡ !!! \"\"\" ··· $$$",
                         learningGoal: "Domina los caracteres ¡ ! \" · $", habitTip: "Mantén Shift con el meñique", descriptionOverride: "Practica caracteres especiales"),
            createLesson(id: "es.6.2.2", moduleId: "6.2", name: "% & / ( )", order: 2, content: "%%% &&& /// ((( )))",
                         learningGoal: "Domina los caracteres % & / ( )", habitTip: "Practica las combinaciones con Shift despacio", descriptionOverride: "Practica caracteres especiales"),
            createLesson(id: "es.6.2.3", moduleId: "6.2", name: "= ? ¿ * +", order: 3, content: "=== ??? ¿¿¿ *** +++",
                         learningGoal: "Domina los caracteres = ? ¿ * +", habitTip: "Recuerda la posición de cada carácter", descriptionOverride: "Practica caracteres especiales")
        ]
        let lessons3 = [
            createLesson(
                id: "es.6.4.1", 
                moduleId: "6.4", 
                name: "Prueba Final", 
                order: 1, 
                content: "¡Felicidades! Has llegado a la Etapa 6.", 
                isGatekeeper: true,
                pool: [
                    "¡Felicidades! Has llegado a la Etapa 6. Verifiquemos todo: 123 + 456 = 579. ¿Es cierto? ¡Sí!",
                    "Proyecto final: (acc >= 98.0) && (wpm >= 50.0). Prueba completada: [OK].",
                    "Caracteres especiales: ¡@#$%&/()=?¿. Has completado el currículo de TypeQuest. ¡Bien hecho!"
                ],
                learningGoal: "Aprueba la Prueba Final", habitTip: "¡Ya casi lo logras – mantén la concentración!", descriptionOverride: "Prueba final del teclado completo"
            )
        ]
        
        let modules = [
            Module(id: "6.1", name: "Fila de Números", description: "Teclas 0-9", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "Símbolos Comunes", description: "Caracteres especiales", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "Práctica Mixta", description: "Todo combinado", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "Números y Símbolos", themeName: "Laboratorio", description: "Domina el teclado", iconName: "number.circle.fill", modules: modules)
    }

    // MARK: - German Curriculum
    private func generateGermanStages() -> [Stage] {
        return [
            generateGermanStage1(),
            generateGermanStage2(),
            generateGermanStage3(),
            generateGermanStage4(),
            generateGermanStage5(),
            generateGermanStage6()
        ]
    }
    
    private func generateGermanStage1() -> Stage {
        let lessons = [
            createLesson(id: "de.1.1.1", moduleId: "1.1", name: "Tasten A und S", order: 1, content: "aaa sss aaa sss as sa as sa",
                         learningGoal: "Meistere die Tasten A und S", habitTip: "Halte deine Finger auf der Grundreihe", descriptionOverride: "Übe Tasten A und S"),
            createLesson(
                id: "de.1.4.1", 
                moduleId: "1.4", 
                name: "Stufen-Test 1", 
                order: 2, 
                content: "asdf jkl; lass das glas", 
                isGatekeeper: true,
                pool: [
                    "asdf jkl; lass das glas. salat und saft für alle im flur. falls das glas fällt.",
                    "salat fassade flachs salsa jagd glas. asdf jkl; falls das glas fällt.",
                    "saft und salat. asdf jkl; lass das glas. flachs salat fassade jagd salsa."
                ],
                learningGoal: "Bestehe den Stufen-Test 1", habitTip: "Halte deine Finger auf der Grundreihe", descriptionOverride: "Stufen-Test der Grundreihe"
            )
        ]
        return Stage(id: 1, name: "Grundlagen der Grundreihe", themeName: "Wald", description: "Meistere die Tasten der mittleren Reihe", iconName: "hand.raised.fill", modules: [
            Module(id: "1.1", name: "Linke Anker", description: "Position der linken Hand", stageId: 1, order: 1, lessons: lessons)
        ])
    }
    
    private func generateGermanStage2() -> Stage {
        let lessons = [
            createLesson(
                id: "de.2.4.1", 
                moduleId: "2.4", 
                name: "Stufen-Test 2", 
                order: 1, 
                content: "wer heute schreibt wird gut", 
                isGatekeeper: true,
                pool: [
                    "wer heute schreibt wird gut. die katze ist auf dem tisch. wir gehen heute zur party.",
                    "der weg ist weit aber das ziel ist nah. schreiben ist eine gute übung für den kopf.",
                    "höre auf zu reden und fange an zu schreiben. wasser ist wichtig für das leben."
                ],
                learningGoal: "Bestehe den Stufen-Test 2", habitTip: "Bewege nur den nötigen Finger, halte die anderen ruhig", descriptionOverride: "Stufen-Test der oberen Reihe"
            )
        ]
        return Stage(id: 2, name: "Erweiterung Obere Reihe", themeName: "Berge", description: "Erreiche die obere Tastenreihe", iconName: "arrow.up.circle.fill", modules: [
            Module(id: "2.1", name: "Oberreihe Meisterschaft", description: "Fluss der oberen Reihe", stageId: 2, order: 1, lessons: lessons)
        ])
    }

    // MARK: - Stage 3: Bottom Row & N-Grams (German)
    private func generateGermanStage3() -> Stage {
        // QWERTZ: Y is bottom left (where Z is in QWERTY). Z is top row (where Y is in QWERTY).
        // Adapting content to use Y instead of Z for bottom row introduction.
        let lessons1 = [
            createLesson(id: "de.3.1.1", moduleId: "3.1", name: "Tasten Y und X", order: 1, content: "yyy xxx yyy xxx yx xy yeti xylophon",
                         learningGoal: "Meistere die Tasten Y und X", habitTip: "Halte deine Finger auf der Grundreihe", descriptionOverride: "Übe Tasten Y und X"),
            createLesson(id: "de.3.1.2", moduleId: "3.1", name: "Tasten C und V", order: 2, content: "ccc vvv ccc vvv cv vc ca va cave",
                         learningGoal: "Meistere die Tasten C und V", habitTip: "Bewege nur den nötigen Finger", descriptionOverride: "Übe Tasten C und V"),
            createLesson(id: "de.3.1.3", moduleId: "3.1", name: "Taste B", order: 3, content: "bbb bbb bob bib bab bald blaubär",
                         learningGoal: "Meistere die Taste B", habitTip: "Nutze den Zeigefinger für B", descriptionOverride: "Übe die Taste B")
        ]
        let lessons2 = [
            createLesson(id: "de.3.2.1", moduleId: "3.2", name: "Tasten N und M", order: 1, content: "nnn mmm nnn mmm nm mn name mann",
                         learningGoal: "Meistere die Tasten N und M", habitTip: "Halte deine Finger auf der Grundreihe", descriptionOverride: "Übe Tasten N und M"),
            createLesson(id: "de.3.2.2", moduleId: "3.2", name: "Komma und Punkt", order: 2, content: ",,, ... ,,, ... ,. ., eins, zwei.",
                         learningGoal: "Meistere Komma und Punkt", habitTip: "Nutze den rechten Ringfinger für den Punkt", descriptionOverride: "Übe Komma und Punkt"),
            createLesson(id: "de.3.2.3", moduleId: "3.2", name: "Taste Bindestrich", order: 3, content: "--- --- ein-aus ja-nein",
                         learningGoal: "Meistere den Bindestrich", habitTip: "Nutze den rechten kleinen Finger", descriptionOverride: "Übe den Bindestrich")
        ]
        let lessons3 = [
            createLesson(id: "de.3.3.1", moduleId: "3.3", name: "Häufige Paare: en, er", order: 1, content: "en en en er er er den der aber",
                         learningGoal: "Meistere die Paare en und er", habitTip: "Achte auf einen fließenden Rhythmus", descriptionOverride: "Übe häufige Buchstabenpaare"),
            createLesson(id: "de.3.3.2", moduleId: "3.3", name: "Häufige Paare: ch, ei", order: 2, content: "ch ch ch ei ei ei ich ein auch",
                         learningGoal: "Meistere die Paare ch und ei", habitTip: "Tippe die Paare als Einheit", descriptionOverride: "Übe häufige Buchstabenpaare"),
            createLesson(id: "de.3.3.3", moduleId: "3.3", name: "Häufige Paare: un, in", order: 3, content: "un un un in in in und ein kind",
                         learningGoal: "Meistere die Paare un und in", habitTip: "Konzentriere dich auf gleichmäßiges Tempo", descriptionOverride: "Übe häufige Buchstabenpaare"),
            
            createLesson(
                id: "de.3.4.1", 
                moduleId: "3.4", 
                name: "Stufen-Test 3", 
                order: 1, 
                content: "franz jagt im komplett verwahrlosten taxi", 
                isGatekeeper: true,
                pool: [
                    "franz jagt im komplett verwahrlosten taxi quer durch bayern. sylter deich und kalbshaxen.",
                    "zwei boxkämpfer jagen viktor quer über den großen sylter deich. das wetter ist heute schön.",
                    "jeder wackere bayer vertilgt bequem zwo pfund kalbshaxen. übung macht den meister."
                ],
                learningGoal: "Bestehe den Stufen-Test 3", habitTip: "Bleib ruhig und tippe gleichmäßig", descriptionOverride: "Stufen-Test der unteren Reihe"
            )
        ]
        
        let modules = [
            Module(id: "3.1", name: "Untere Reihe Links", description: "Y X C V B Tasten", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "Untere Reihe Rechts", description: "N M , . - Tasten", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "Häufige N-Gramme", description: "Buchstabenpaare meistern", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "Untere Reihe & Muster", themeName: "Fluss", description: "Vervollständige das Alphabet", iconName: "arrow.down.circle.fill", modules: modules)
    }

    // MARK: - Stage 4: Word Mastery (German)
    private func generateGermanStage4() -> Stage {
        let lessons1 = [
            createLesson(id: "de.4.1.1", moduleId: "4.1", name: "Häufige Wörter 1", order: 1, content: "der die das und ist in den von zu mit",
                         learningGoal: "Meistere die häufigsten kurzen Wörter", habitTip: "Lies das Wort zuerst, dann tippe es", descriptionOverride: "Übe häufige Wörter"),
            createLesson(id: "de.4.1.2", moduleId: "4.1", name: "Häufige Wörter 2", order: 2, content: "sich des auf für auch dem an er so",
                         learningGoal: "Erweitere deinen Wortschatz", habitTip: "Tippe ganze Wörter als eine Bewegung", descriptionOverride: "Übe häufige Wörter"),
            createLesson(id: "de.4.1.3", moduleId: "4.1", name: "Häufige Wörter 3", order: 3, content: "eine als nach wie man aber aus durch wenn",
                         learningGoal: "Beherrsche weitere häufige Wörter", habitTip: "Konzentriere dich auf Genauigkeit vor Geschwindigkeit", descriptionOverride: "Übe häufige Wörter")
        ]
        let lessons2 = [
            createLesson(id: "de.4.2.1", moduleId: "4.2", name: "Lange Wörter 1", order: 1, content: "können machen werden stehen lassen gegen",
                         learningGoal: "Meistere längere Wörter", habitTip: "Teile lange Wörter in Silben auf", descriptionOverride: "Übe lange Wörter"),
            createLesson(id: "de.4.2.2", moduleId: "4.2", name: "Lange Wörter 2", order: 2, content: "müssen sagen unter diesen jahren",
                         learningGoal: "Verbessere die Wortflüssigkeit", habitTip: "Halte einen gleichmäßigen Rhythmus", descriptionOverride: "Übe lange Wörter"),
            createLesson(id: "de.4.2.3", moduleId: "4.2", name: "Lange Wörter 3", order: 3, content: "anderer solchen welche deshalb großen",
                         learningGoal: "Beherrsche komplexe Wörter", habitTip: "Atme gleichmäßig beim Tippen", descriptionOverride: "Übe lange Wörter")
        ]
        let lessons3 = [
            createLesson(id: "de.4.3.1", moduleId: "4.3", name: "30-Sekunden Sprint", order: 1, content: "der die das und ist in den von zu mit sich des auf für",
                         learningGoal: "Baue Tippgeschwindigkeit auf", habitTip: "Nicht auf die Tastatur schauen!", descriptionOverride: "Geschwindigkeits-Sprint"),
            createLesson(
                id: "de.4.4.1", 
                moduleId: "4.4", 
                name: "Stufen-Test 4", 
                order: 1, 
                content: "übung macht den meister bei jedem schritt", 
                isGatekeeper: true,
                pool: [
                    "übung macht den meister bei jedem schritt. wir lernen jeden tag etwas neues dazu.",
                    "die sonne scheint und die vögel singen. heute ist ein guter tag zum tippen.",
                    "schnelles schreiben hilft dir in der schule und arbeit. konzentriere dich auf die fehler."
                ],
                learningGoal: "Bestehe den Stufen-Test 4", habitTip: "Bleib ruhig und tippe gleichmäßig", descriptionOverride: "Stufen-Test der Wort-Meisterschaft"
            )
        ]
        
        let modules = [
            Module(id: "4.1", name: "Kurze Häufige Wörter", description: "Die top 30 Wörter", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "Mittellange Wörter", description: "5+ Buchstaben", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "Wort-Sprints", description: "Geschwindigkeit aufbauen", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "Wort-Meisterschaft", themeName: "Bibliothek", description: "Baue Geschwindigkeit auf", iconName: "text.word.spacing", modules: modules)
    }

    // MARK: - Stage 5: Sentence Fluency (German)
    private func generateGermanStage5() -> Stage {
        let lessons1 = [
            createLesson(id: "de.5.1.1", moduleId: "5.1", name: "Einfache Sätze", order: 1, content: "Der Hund bellt laut. Die Katze schläft.",
                         learningGoal: "Tippe einfache Sätze flüssig", habitTip: "Lies den ganzen Satz bevor du tippst", descriptionOverride: "Übe einfache Sätze"),
            createLesson(id: "de.5.1.2", moduleId: "5.1", name: "Fragen", order: 2, content: "Wie geht es dir? Wo ist der Bahnhof?",
                         learningGoal: "Meistere Fragezeichen und Fragesätze", habitTip: "Achte auf Satzzeichen", descriptionOverride: "Übe Fragesätze"),
            createLesson(id: "de.5.1.3", moduleId: "5.1", name: "Befehle", order: 3, content: "Mach bitte das Licht an. Hör gut zu.",
                         learningGoal: "Tippe Befehlssätze sicher", habitTip: "Großbuchstaben am Satzanfang nicht vergessen", descriptionOverride: "Übe Befehlssätze")
        ]
        let lessons2 = [
            createLesson(id: "de.5.2.1", moduleId: "5.2", name: "Nebensätze", order: 1, content: "Ich gehe spazieren, weil die Sonne scheint.",
                         learningGoal: "Meistere zusammengesetzte Sätze", habitTip: "Halte einen gleichmäßigen Fluss über Kommas hinweg", descriptionOverride: "Übe Nebensätze"),
            createLesson(id: "de.5.2.2", moduleId: "5.2", name: "Komplexe Ideen", order: 2, content: "Obwohl es regnete, gingen wir in den Park.",
                         learningGoal: "Tippe komplexe Sätze flüssig", habitTip: "Nicht aufhören bei langen Sätzen", descriptionOverride: "Übe komplexe Sätze")
        ]
        let lessons3 = [
            createLesson(
                id: "de.5.4.1", 
                moduleId: "5.4", 
                name: "Stufen-Test 5", 
                order: 1, 
                content: "TypeQuest ist der beste Weg, das Tippen zu lernen.", 
                isGatekeeper: true,
                pool: [
                    "TypeQuest ist der beste Weg, das Tippen zu lernen. Mit täglicher Übung wirst du schnell besser. Deine Finger werden fliegen.",
                    "Victor jagt zwölf Boxkämpfer quer über den großen Sylter Deich. Heizölrückstoßabdämpfung ist ein langes Wort.",
                    "Lesen und Schreiben sind wichtig für die Kommunikation. Wenn du diese Sätze tippst, denke an den Rhythmus."
                ],
                learningGoal: "Bestehe den Stufen-Test 5", habitTip: "Atme ruhig und tippe gleichmäßig", descriptionOverride: "Stufen-Test des Satzflusses"
            )
        ]
        
        let modules = [
            Module(id: "5.1", name: "Einfache Sätze", description: "Grundlegender Fluss", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "Zusammengesetzte Sätze", description: "Verbundene Ideen", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "Absatz-Übung", description: "Mehrere Sätze", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "Satzfluss", themeName: "Ozean", description: "Schreibe mit Rhythmus", iconName: "text.alignleft", modules: modules)
    }

    // MARK: - Stage 6: Numbers & Symbols (German)
    private func generateGermanStage6() -> Stage {
        let lessons1 = [
            createLesson(id: "de.6.1.1", moduleId: "6.1", name: "Tasten 1 und 2", order: 1, content: "111 222 111 222 12 21 12 21",
                         learningGoal: "Meistere die Tasten 1 und 2", habitTip: "Strecke den Finger nach oben, nicht die ganze Hand", descriptionOverride: "Übe die Tasten 1 und 2"),
            createLesson(id: "de.6.1.2", moduleId: "6.1", name: "Tasten 3 und 4", order: 2, content: "333 444 333 444 34 43 34 43",
                         learningGoal: "Meistere die Tasten 3 und 4", habitTip: "Kehre nach jeder Zahl zur Grundreihe zurück", descriptionOverride: "Übe die Tasten 3 und 4"),
            createLesson(id: "de.6.1.3", moduleId: "6.1", name: "Tasten 5 und 6", order: 3, content: "555 666 555 666 56 65 56 65",
                         learningGoal: "Meistere die Tasten 5 und 6", habitTip: "Nutze den Zeigefinger für 5 und 6", descriptionOverride: "Übe die Tasten 5 und 6"),
            createLesson(id: "de.6.1.4", moduleId: "6.1", name: "Tasten 7 und 8", order: 4, content: "777 888 777 888 78 87 78 87",
                         learningGoal: "Meistere die Tasten 7 und 8", habitTip: "Nutze den Zeigefinger für 7 und Mittelfinger für 8", descriptionOverride: "Übe die Tasten 7 und 8"),
            createLesson(id: "de.6.1.5", moduleId: "6.1", name: "Tasten 9 und 0", order: 5, content: "999 000 999 000 90 09 90 09",
                         learningGoal: "Meistere die Tasten 9 und 0", habitTip: "Ring- und kleiner Finger für 9 und 0", descriptionOverride: "Übe die Tasten 9 und 0")
        ]
        let lessons2 = [
            createLesson(id: "de.6.2.1", moduleId: "6.2", name: "! \" § $", order: 1, content: "!!! \"\"\" §§§ $$$ !\"§$",
                         learningGoal: "Meistere die Sonderzeichen ! \" § $", habitTip: "Halte Shift mit dem kleinen Finger", descriptionOverride: "Übe Sonderzeichen"),
            createLesson(id: "de.6.2.2", moduleId: "6.2", name: "% & / ( )", order: 2, content: "%%% &&& /// ((( )))",
                         learningGoal: "Meistere die Sonderzeichen % & / ( )", habitTip: "Übe die Shift-Kombinationen langsam", descriptionOverride: "Übe Sonderzeichen"),
            createLesson(id: "de.6.2.3", moduleId: "6.2", name: "= ? + * #", order: 3, content: "=== ??? +++ *** ###",
                         learningGoal: "Meistere die Sonderzeichen = ? + * #", habitTip: "Merke dir die Position jedes Zeichens", descriptionOverride: "Übe Sonderzeichen")
        ]
        let lessons3 = [
            createLesson(
                id: "de.6.4.1", 
                moduleId: "6.4", 
                name: "Abschluss-Test", 
                order: 1, 
                content: "Herzlichen Glückwunsch! Du hast Stufe 6 erreicht.", 
                isGatekeeper: true,
                pool: [
                    "Herzlichen Glückwunsch! Du hast Stufe 6 erreicht. Test: 123 + 456 = 579. Sonderzeichen: !\"§$%&/()=? Das war eine tolle Reise.",
                    "Jetzt bist du ein Profi. Deine Geschwindigkeit ist hoch und deine Fehler sind niedrig. 100% Erfolg: [OK].",
                    "Viel Spaß beim Tippen deiner eigenen Texte. Vergiss nicht das Üben: Montag bis Freitag, 09:00 - 17:00."
                ],
                learningGoal: "Bestehe den Abschluss-Test", habitTip: "Du hast es fast geschafft – bleib konzentriert!", descriptionOverride: "Abschluss-Test der gesamten Tastatur"
            )
        ]
        
        let modules = [
            Module(id: "6.1", name: "Zahlenreihe", description: "Tasten 0-9", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "Sonderzeichen", description: "Wichtige Symbole", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "Gemischte Übung", description: "Alles zusammen", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "Zahlen & Symbole", themeName: "Labor", description: "Beherrsche die Tastatur", iconName: "number.circle.fill", modules: modules)
    }


    
    private func generateDutchStage1() -> Stage {
        let lessons = [
            createLesson(id: "nl.1.1.1", moduleId: "1.1", name: "Toetsen A en S", order: 1, content: "aaa sss aaa sss as sa as sa",
                         learningGoal: "Beheers Toetsen A en S", habitTip: "Houd je vingers op de basisrij", descriptionOverride: "Oefen Toetsen A en S"),
            createLesson(
                id: "nl.1.4.1", 
                moduleId: "1.4", 
                name: "Niveau-Test 1", 
                order: 2, 
                content: "asdf jkl; sla de klas", 
                isGatekeeper: true,
                pool: [
                    "asdf jkl; sla de klas. sap op het glas. als de klas slaat.",
                    "glas sap als sla. asdf jkl; de klas slaat op het glas.",
                    "sap en glas voor de klas. asdf jkl; sla de klas als sap."
                ],
                learningGoal: "Haal de Niveau-Test 1", habitTip: "Blijf rustig en typ gelijkmatig", descriptionOverride: "Niveau-test van de 1"
            )
        ]
        return Stage(id: 1, name: "Basisrij Fundament", themeName: "Polder", description: "Beheers de middelste rij", iconName: "hand.raised.fill", modules: [
            Module(id: "1.1", name: "Linker Ankers", description: "Positie van de linkerhand", stageId: 1, order: 1, lessons: lessons)
        ])
    }
    
    private func generateDutchStage2() -> Stage {
        let lessons = [
            createLesson(
                id: "nl.2.4.1", 
                moduleId: "2.4", 
                name: "Niveau-Test 2", 
                order: 1, 
                content: "de snelle bruine vos springt", 
                isGatekeeper: true,
                pool: [
                    "de snelle bruine vos springt over de luie hond. wat is de wereld klein als je snel typt.",
                    "schrijven is een prioriteit voor succes. de route is lang maar het resultaat is uniek.",
                    "ik wil met precisie en snelheid kunnen schrijven. alle jongeren kunnen vandaag leren."
                ],
                learningGoal: "Haal de Niveau-Test 2", habitTip: "Blijf rustig en typ gelijkmatig", descriptionOverride: "Niveau-test van de 2"
            )
        ]
        return Stage(id: 2, name: "Bovenrij Uitbreiding", themeName: "Duinen", description: "Bereik de bovenste rij", iconName: "arrow.up.circle.fill", modules: [
            Module(id: "2.1", name: "Bovenrij Meesterschap", description: "Flow van de bovenste rij", stageId: 2, order: 1, lessons: lessons)
        ])
    }

    // MARK: - Stage 3: Bottom Row & N-Grams (Dutch)
    private func generateDutchStage3() -> Stage {
        let lessons1 = [
            createLesson(id: "nl.3.1.1", moduleId: "3.1", name: "Toetsen Z en X", order: 1, content: "zzz xxx zzz xxx zx xz zee extra",
                         learningGoal: "Beheers Toetsen Z en X", habitTip: "Houd je vingers op de basisrij", descriptionOverride: "Oefen Toetsen Z en X"),
            createLesson(id: "nl.3.1.2", moduleId: "3.1", name: "Toetsen C en V", order: 2, content: "ccc vvv ccc vvv cv vc cel vis",
                         learningGoal: "Beheers Toetsen C en V", habitTip: "Houd je vingers op de basisrij", descriptionOverride: "Oefen Toetsen C en V"),
            createLesson(id: "nl.3.1.3", moduleId: "3.1", name: "Toets B", order: 3, content: "bbb bbb bob ben bal boom",
                         learningGoal: "Beheers Toets B", habitTip: "Houd je vingers op de basisrij", descriptionOverride: "Oefen Toets B")
        ]
        let lessons2 = [
            createLesson(id: "nl.3.2.1", moduleId: "3.2", name: "Toetsen N en M", order: 1, content: "nnn mmm nnn mmm nm mn naam man",
                         learningGoal: "Beheers Toetsen N en M", habitTip: "Houd je vingers op de basisrij", descriptionOverride: "Oefen Toetsen N en M"),
            createLesson(id: "nl.3.2.2", moduleId: "3.2", name: "Komma en Punt", order: 2, content: ",,, ... ,,, ... ,. ., een, twee.",
                         learningGoal: "Beheers Komma en Punt", habitTip: "Houd je vingers op de basisrij", descriptionOverride: "Oefen Komma en Punt"),
            createLesson(id: "nl.3.2.3", moduleId: "3.2", name: "Toets Slash", order: 3, content: "/// /// en/of ja/nee",
                         learningGoal: "Beheers Toets Slash", habitTip: "Houd je vingers op de basisrij", descriptionOverride: "Oefen Toets Slash")
        ]
        let lessons3 = [
            createLesson(id: "nl.3.3.1", moduleId: "3.3", name: "Vaak voorkomende paren: de, en", order: 1, content: "de de de en en en het een in is",
                         learningGoal: "Beheers Vaak voorkomende paren: de, en", habitTip: "Houd een vloeiend ritme aan", descriptionOverride: "Oefen veelvoorkomende letterparen"),
            createLesson(id: "nl.3.3.2", moduleId: "3.3", name: "Vaak voorkomende paren: ik, je", order: 2, content: "ik ik ik je je je hij zij we ze",
                         learningGoal: "Beheers Vaak voorkomende paren: ik, je", habitTip: "Houd een vloeiend ritme aan", descriptionOverride: "Oefen veelvoorkomende letterparen"),
            createLesson(
                id: "nl.3.4.1", 
                moduleId: "3.4", 
                name: "Niveau-Test 3", 
                order: 1, 
                content: "de snelle bruine vos springt", 
                isGatekeeper: true,
                pool: [
                    "de snelle bruine vos springt over de luie hond. de wereld is klein.",
                    "ik wil een lekkere appel eten. laten we morgen naar het strand gaan.",
                    "de muziek staat erg hard op het feest. ik hou van dansen met vrienden."
                ],
                learningGoal: "Haal de Niveau-Test 3", habitTip: "Blijf rustig en typ gelijkmatig", descriptionOverride: "Niveau-test van de 3"
            )
        ]
        
        let modules = [
            Module(id: "3.1", name: "Onderste Rij Links", description: "Toetsen Z X C V B", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "Onderste Rij Rechts", description: "Toetsen N M , . /", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "Veelvoorkomende N-Grammen", description: "Beheers letterparen", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "Onderste Rij & Patronen", themeName: "Rivier", description: "Voltooi het alfabet", iconName: "arrow.down.circle.fill", modules: modules)
    }

    // MARK: - Stage 4: Word Mastery (Dutch)
    private func generateDutchStage4() -> Stage {
        let lessons1 = [
            createLesson(id: "nl.4.1.1", moduleId: "4.1", name: "Veelvoorkomende Woorden 1", order: 1, content: "de van een en het in is dat te zijn",
                         learningGoal: "Beheers Veelvoorkomende Woorden 1", habitTip: "Lees het woord eerst, typ het dan", descriptionOverride: "Oefen veelvoorkomende woorden"),
            createLesson(id: "nl.4.1.2", moduleId: "4.1", name: "Veelvoorkomende Woorden 2", order: 2, content: "op voor met als er was om maar ook bij",
                         learningGoal: "Beheers Veelvoorkomende Woorden 2", habitTip: "Lees het woord eerst, typ het dan", descriptionOverride: "Oefen veelvoorkomende woorden"),
            createLesson(id: "nl.4.1.3", moduleId: "4.1", name: "Veelvoorkomende Woorden 3", order: 3, content: "of door dan aan hem dit nu al wat toch",
                         learningGoal: "Beheers Veelvoorkomende Woorden 3", habitTip: "Lees het woord eerst, typ het dan", descriptionOverride: "Oefen veelvoorkomende woorden")
        ]
        let lessons2 = [
            createLesson(id: "nl.4.2.1", moduleId: "4.2", name: "Lange Woorden 1", order: 1, content: "worden kunnen mensen deze hebben",
                         learningGoal: "Beheers Lange Woorden 1", habitTip: "Focus op nauwkeurigheid vóór snelheid", descriptionOverride: "Oefen lange woorden"),
            createLesson(id: "nl.4.2.2", moduleId: "4.2", name: "Lange Woorden 2", order: 2, content: "alleen andere leven tijd niets",
                         learningGoal: "Beheers Lange Woorden 2", habitTip: "Focus op nauwkeurigheid vóór snelheid", descriptionOverride: "Oefen lange woorden"),
            createLesson(id: "nl.4.2.3", moduleId: "4.2", name: "Lange Woorden 3", order: 3, content: "zullen altijd moeten maken onder",
                         learningGoal: "Beheers Lange Woorden 3", habitTip: "Focus op nauwkeurigheid vóór snelheid", descriptionOverride: "Oefen lange woorden")
        ]
        let lessons3 = [
            createLesson(id: "nl.4.3.1", moduleId: "4.3", name: "Sprint van 30 Seconden", order: 1, content: "de van een en het in is dat te zijn op voor met",
                         learningGoal: "Beheers Sprint van 30 Seconden", habitTip: "Kijk niet naar het toetsenbord!", descriptionOverride: "Snelheidssprint"),
            createLesson(
                id: "nl.4.4.1", 
                moduleId: "4.4", 
                name: "Niveau-Test 4", 
                order: 1, 
                content: "het eerste grote ding is leren", 
                isGatekeeper: true,
                pool: [
                    "het eerste grote ding is leren om je eigen stem weer te gebruiken.",
                    "denk aan waar je was toen je aan deze reis begon.",
                    "bestudeer hun plaats recht klein geluid kon nog eens beneden."
                ],
                learningGoal: "Haal de Niveau-Test 4", habitTip: "Blijf rustig en typ gelijkmatig", descriptionOverride: "Niveau-test van de 4"
            )
        ]
        
        let modules = [
            Module(id: "4.1", name: "Korte Woorden", description: "Top 30 woorden", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "Middellange Woorden", description: "5+ letters", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "Woord Sprints", description: "Bouw snelheid op", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "Woord Beheersing", themeName: "Bibliotheek", description: "Verhoog je snelheid", iconName: "text.word.spacing", modules: modules)
    }

    // MARK: - Stage 5: Sentence Fluency (Dutch)
    private func generateDutchStage5() -> Stage {
        let lessons1 = [
            createLesson(id: "nl.5.1.1", moduleId: "5.1", name: "Simpele Zinnen", order: 1, content: "De hond blaft hard. De kat slaapt.",
                         learningGoal: "Beheers Simpele Zinnen", habitTip: "Lees de hele zin voordat je typt", descriptionOverride: "Oefen simpele zinnen"),
            createLesson(id: "nl.5.1.2", moduleId: "5.1", name: "Vragen", order: 2, content: "Hoe gaat het vandaag? Hoe laat is het?",
                         learningGoal: "Beheers Vragen", habitTip: "Let op de leestekens", descriptionOverride: "Oefen vragen"),
            createLesson(id: "nl.5.1.3", moduleId: "5.1", name: "Opdrachten", order: 3, content: "Doe de deur dicht aub. Doe het licht aan.",
                         learningGoal: "Beheers Opdrachten", habitTip: "Vergeet de hoofdletters aan het begin niet", descriptionOverride: "Oefen opdrachten")
        ]
        let lessons2 = [
            createLesson(id: "nl.5.2.1", moduleId: "5.2", name: "Samengestelde Zinnen", order: 1, content: "Ik ging naar de winkel en kocht brood.",
                         learningGoal: "Beheers Samengestelde Zinnen", habitTip: "Houd een constante stroom over komma's", descriptionOverride: "Oefen samengestelde zinnen"),
            createLesson(id: "nl.5.2.2", moduleId: "5.2", name: "Complexe Ideeën", order: 2, content: "Hoewel het regende, besloten we naar buiten te gaan.",
                         learningGoal: "Beheers Complexe Ideeën", habitTip: "Stop niet bij lange zinnen", descriptionOverride: "Oefen complexe ideeën")
        ]
        let lessons3 = [
            createLesson(
                id: "nl.5.4.1", 
                moduleId: "5.4", 
                name: "Niveau-Test 5", 
                order: 1, 
                content: "TypeQuest is de beste manier om te leren.", 
                isGatekeeper: true,
                pool: [
                    "TypeQuest is de beste manier om te leren typen. Met dagelijkse oefening word je beter.",
                    "De snelle bruine vos springt over de luie hond. Een beroemde zin.",
                    "Lezen en schrijven zijn de fundamenten van digitale communicatie. Beheers het toetsenbord vandaag."
                ],
                learningGoal: "Haal de Niveau-Test 5", habitTip: "Blijf rustig en typ gelijkmatig", descriptionOverride: "Niveau-test van de 5"
            )
        ]
        
        let modules = [
            Module(id: "5.1", name: "Simpele Zinnen", description: "Basis flow", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "Samengestelde Zinnen", description: "Verbonden ideeën", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "Paragraaf Oefening", description: "Multi-zin flow", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "Zinsvloeiendheid", themeName: "Oceaan", description: "Schrijf met ritme", iconName: "text.alignleft", modules: modules)
    }

    // MARK: - Stage 6: Numbers & Symbols (Dutch)
    private func generateDutchStage6() -> Stage {
        let lessons1 = [
            createLesson(id: "nl.6.1.1", moduleId: "6.1", name: "Toetsen 1 en 2", order: 1, content: "111 222 111 222 12 21 12 21",
                         learningGoal: "Beheers Toetsen 1 en 2", habitTip: "Strek je vinger omhoog, niet je hele hand", descriptionOverride: "Oefen Toetsen 1 en 2"),
            createLesson(id: "nl.6.1.2", moduleId: "6.1", name: "Toetsen 3 en 4", order: 2, content: "333 444 333 444 34 43 34 43",
                         learningGoal: "Beheers Toetsen 3 en 4", habitTip: "Strek je vinger omhoog, niet je hele hand", descriptionOverride: "Oefen Toetsen 3 en 4"),
            createLesson(id: "nl.6.1.3", moduleId: "6.1", name: "Toetsen 5 en 6", order: 3, content: "555 666 555 666 56 65 56 65",
                         learningGoal: "Beheers Toetsen 5 en 6", habitTip: "Strek je vinger omhoog, niet je hele hand", descriptionOverride: "Oefen Toetsen 5 en 6"),
            createLesson(id: "nl.6.1.4", moduleId: "6.1", name: "Toetsen 7 en 8", order: 4, content: "777 888 777 888 78 87 78 87",
                         learningGoal: "Beheers Toetsen 7 en 8", habitTip: "Strek je vinger omhoog, niet je hele hand", descriptionOverride: "Oefen Toetsen 7 en 8"),
            createLesson(id: "nl.6.1.5", moduleId: "6.1", name: "Toetsen 9 en 0", order: 5, content: "999 000 999 000 90 09 90 09",
                         learningGoal: "Beheers Toetsen 9 en 0", habitTip: "Strek je vinger omhoog, niet je hele hand", descriptionOverride: "Oefen Toetsen 9 en 0")
        ]
        let lessons2 = [
            createLesson(id: "nl.6.2.1", moduleId: "6.2", name: "! @ # $", order: 1, content: "!!! @@@ ### $$$ !@#$",
                         learningGoal: "Beheers ! @ # $", habitTip: "Houd Shift ingedrukt met je pink", descriptionOverride: "Oefen speciale tekens"),
            createLesson(id: "nl.6.2.2", moduleId: "6.2", name: "% ^ & *", order: 2, content: "%%% ^^^ &&& *** %^&*",
                         learningGoal: "Beheers % ^ & *", habitTip: "Houd Shift ingedrukt met je pink", descriptionOverride: "Oefen speciale tekens"),
            createLesson(id: "nl.6.2.3", moduleId: "6.2", name: "( ) - =", order: 3, content: "((( ))) --- === ()-=",
                         learningGoal: "Beheers ( ) - =", habitTip: "Houd Shift ingedrukt met je pink", descriptionOverride: "Oefen speciale tekens")
        ]
        let lessons3 = [
            createLesson(
                id: "nl.6.4.1", 
                moduleId: "6.4", 
                name: "Eindtoets", 
                order: 1, 
                content: "Gefeliciteerd! Je hebt Fase 6 bereikt.", 
                isGatekeeper: true,
                pool: [
                    "Gefeliciteerd! Je hebt Fase 6 bereikt. Laten we alles controleren: 123 + 456 = 579. Waar? Ja!",
                    "Eindproject: (acc >= 98.0) && (wpm >= 50.0). Test voltooid: [OK].",
                    "Speciale tekens: !@#$%^&*()_+. Je hebt het TypeQuest curriculum voltooid. Goed gedaan!"
                ],
                learningGoal: "Haal de Eindtoets", habitTip: "Je bent er bijna – blijf geconcentreerd!", descriptionOverride: "Eindtest van het complete toetsenbord"
            )
        ]
        
        let modules = [
            Module(id: "6.1", name: "Cijferrij", description: "Toetsen 0-9", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "Veelvoorkomende Symbolen", description: "Speciale tekens", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "Gemengde Oefening", description: "Alles gecombineerd", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "Cijfers & Symbolen", themeName: "Laboratorium", description: "Beheers het toetsenbord", iconName: "number.circle.fill", modules: modules)
    }

    // MARK: - French Curriculum (AZERTY)
    private func generateFrenchStages() -> [Stage] {
        return [
            generateFrenchStage1(),
            generateFrenchStage2(),
            generateFrenchStage3(),
            generateFrenchStage4(),
            generateFrenchStage5(),
            generateFrenchStage6()
        ]
    }
    
    private func generateFrenchStage1() -> Stage {
        // AZERTY Home Row: Q S D F G H J K L M
        let lessons = [
            createLesson(id: "fr.1.1.1", moduleId: "1.1", name: "Touches Q et S", order: 1, content: "qqq sss qqq sss qs sq qs sq",
                         learningGoal: "Maîtrise Touches Q et S", habitTip: "Garde tes doigts sur la rangée de base", descriptionOverride: "Pratique Touches Q et S"),
            createLesson(
                id: "fr.1.4.1", 
                moduleId: "1.4", 
                name: "Test de Niveau 1", 
                order: 2, 
                content: "qsdf jklm la salle de sa", 
                isGatekeeper: true,
                pool: [
                    "qsdf jklm la salle de sa salade. sa salle a sa sas. salade de la salle.",
                    "la salle de sa salade. qsdf jklm sa sas a sa salle. salade de la sa.",
                    "sa salade a la salle. qsdf jklm la salle de sa sas. sa salle a sa."
                ],
                learningGoal: "Réussis le Test de Niveau 1", habitTip: "Reste calme et tape régulièrement", descriptionOverride: "Test de niveau 1"
            )
        ]
        return Stage(id: 1, name: "Fondations de la Base", themeName: "Rivière", description: "Maîtrisez la rangée du milieu", iconName: "hand.raised.fill", modules: [
            Module(id: "1.1", name: "Ancres (AZERTY)", description: "Position de base Q S D F", stageId: 1, order: 1, lessons: lessons)
        ])
    }
    
    private func generateFrenchStage2() -> Stage {
        // AZERTY Top Row: A Z E R T Y U I O P
        let lessons = [
            createLesson(id: "fr.2.1.1", moduleId: "2.1", name: "Touches A et Z", order: 1, content: "aaa zzz aaa zzz az za az za",
                         learningGoal: "Maîtrise Touches A et Z", habitTip: "Garde tes doigts sur la rangée de base", descriptionOverride: "Pratique Touches A et Z"),
            createLesson(
                id: "fr.2.4.1", 
                moduleId: "2.4", 
                name: "Test de Niveau 2", 
                order: 1, 
                content: "le rapide renard brun saute", 
                isGatekeeper: true,
                pool: [
                    "le rapide renard brun saute par-dessus le chien paresseux. le monde est petit quand on écrit vite.",
                    "écrire est une priorité pour le succès. la route est longue mais le résultat est unique.",
                    "je veux écrire avec précision et rapidité. tous les jeunes peuvent apprendre aujourd'hui."
                ],
                learningGoal: "Réussis le Test de Niveau 2", habitTip: "Reste calme et tape régulièrement", descriptionOverride: "Test de niveau 2"
            )
        ]
        return Stage(id: 2, name: "Expansion de la Ligne Haute", themeName: "Alpes", description: "Atteignez la rangée supérieure", iconName: "arrow.up.circle.fill", modules: [
            Module(id: "2.1", name: "Maîtrise Supérieure (AZERTY)", description: "A Z E R T Y U I O P", stageId: 2, order: 1, lessons: lessons)
        ])
    }

    // MARK: - Stage 3: Bottom Row & N-Grams (French)
    private func generateFrenchStage3() -> Stage {
        // AZERTY Bottom Row: W X C V B N ? . /
        let lessons1 = [
            createLesson(id: "fr.3.1.1", moduleId: "3.1", name: "Touches W et X", order: 1, content: "www xxx www xxx wx xw kiwi xénon",
                         learningGoal: "Maîtrise Touches W et X", habitTip: "Garde tes doigts sur la rangée de base", descriptionOverride: "Pratique Touches W et X"), // Using words containing letters
            createLesson(id: "fr.3.1.2", moduleId: "3.1", name: "Touches C et V", order: 2, content: "ccc vvv ccc vvv cv vc ça va cave",
                         learningGoal: "Maîtrise Touches C et V", habitTip: "Garde tes doigts sur la rangée de base", descriptionOverride: "Pratique Touches C et V"),
            createLesson(id: "fr.3.1.3", moduleId: "3.1", name: "Touche B", order: 3, content: "bbb bbb bob bébé beau bien",
                         learningGoal: "Maîtrise Touche B", habitTip: "Garde tes doigts sur la rangée de base", descriptionOverride: "Pratique Touche B")
        ]
        let lessons2 = [
            createLesson(id: "fr.3.2.1", moduleId: "3.2", name: "Touches N et Virgule", order: 1, content: "nnn ,,, nnn ,,, n, ,n non, ni,",
                         learningGoal: "Maîtrise Touches N et Virgule", habitTip: "Garde tes doigts sur la rangée de base", descriptionOverride: "Pratique Touches N et Virgule"), // AZERTY: N is bottom right? Wait.
                                                                                                    // AZERTY: W X C V B N ? . /
                                                                                                    // Keyboards vary. Standard French AFNOR:
                                                                                                    // Row 1: A Z E R T Y U I O P
                                                                                                    // Row 2: Q S D F G H J K L M
                                                                                                    // Row 3: W X C V B N , ; :
                                                                                                    // Let's assume standard behavior.
            createLesson(id: "fr.3.2.2", moduleId: "3.2", name: "Point-Virgule et Deux-Points", order: 2, content: ";;; ::: ;;; ::: un; deux:",
                         learningGoal: "Maîtrise Point-Virgule et Deux-Points", habitTip: "Garde tes doigts sur la rangée de base", descriptionOverride: "Pratique Point-Virgule et Deux-Points"),
            createLesson(id: "fr.3.2.3", moduleId: "3.2", name: "Point d'Exclamation", order: 3, content: "!!! !!! ... non!",
                         learningGoal: "Maîtrise Point d'Exclamation", habitTip: "Garde tes doigts sur la rangée de base", descriptionOverride: "Pratique Point d'Exclamation")
        ]
        let lessons3 = [
            createLesson(id: "fr.3.3.1", moduleId: "3.3", name: "Paires Communes: le, la", order: 1, content: "le le le la la la en et es est",
                         learningGoal: "Maîtrise Paires Communes: le, la", habitTip: "Maintiens un rythme fluide", descriptionOverride: "Pratique les paires de lettres courantes"),
            createLesson(id: "fr.3.3.2", moduleId: "3.3", name: "Paires Communes: qu, ue", order: 2, content: "qu qu qu ue ue ue que qui que",
                         learningGoal: "Maîtrise Paires Communes: qu, ue", habitTip: "Maintiens un rythme fluide", descriptionOverride: "Pratique les paires de lettres courantes"),
            createLesson(
                id: "fr.3.4.1", 
                moduleId: "3.4", 
                name: "Test de Niveau 3", 
                order: 1, 
                content: "le rapide renard brun saute", 
                isGatekeeper: true,
                pool: [
                    "le rapide renard brun saute par-dessus le chien paresseux. le monde est petit.",
                    "je veux manger une pomme rouge. allons a la plage demain apres-midi.",
                    "la musique est très forte a la fête. j'aime danser avec mes amis."
                ],
                learningGoal: "Réussis le Test de Niveau 3", habitTip: "Reste calme et tape régulièrement", descriptionOverride: "Test de niveau 3"
            )
        ]
        
        let modules = [
            Module(id: "3.1", name: "Rangée Inférieure Gauche", description: "Touches W X C V B", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "Rangée Inférieure Droite", description: "Touches N , ; :", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "N-Grammes Communs", description: "Maîtriser les paires", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "Rangée Inférieure & Modèles", themeName: "Rivière", description: "Complétez l'alphabet", iconName: "arrow.down.circle.fill", modules: modules)
    }

    // MARK: - Stage 4: Word Mastery (French)
    private func generateFrenchStage4() -> Stage {
        let lessons1 = [
            createLesson(id: "fr.4.1.1", moduleId: "4.1", name: "Mots Fréquents 1", order: 1, content: "le de la et les un en du a une",
                         learningGoal: "Maîtrise Mots Fréquents 1", habitTip: "Lis le mot d'abord, puis tape-le", descriptionOverride: "Pratique les mots fréquents"),
            createLesson(id: "fr.4.1.2", moduleId: "4.1", name: "Mots Fréquents 2", order: 2, content: "pour dans est il qui que au par sur ne",
                         learningGoal: "Maîtrise Mots Fréquents 2", habitTip: "Lis le mot d'abord, puis tape-le", descriptionOverride: "Pratique les mots fréquents"),
            createLesson(id: "fr.4.1.3", moduleId: "4.1", name: "Mots Fréquents 3", order: 3, content: "pas ce plus se son avec mon ses mais on",
                         learningGoal: "Maîtrise Mots Fréquents 3", habitTip: "Lis le mot d'abord, puis tape-le", descriptionOverride: "Pratique les mots fréquents")
        ]
        let lessons2 = [
            createLesson(id: "fr.4.2.1", moduleId: "4.2", name: "Mots Longs 1", order: 1, content: "votre cette aussi temps faire comme",
                         learningGoal: "Maîtrise Mots Longs 1", habitTip: "Concentre-toi sur la précision avant la vitesse", descriptionOverride: "Pratique les mots longs"),
            createLesson(id: "fr.4.2.2", moduleId: "4.2", name: "Mots Longs 2", order: 2, content: "grand monde entre autre après avoir",
                         learningGoal: "Maîtrise Mots Longs 2", habitTip: "Concentre-toi sur la précision avant la vitesse", descriptionOverride: "Pratique les mots longs"),
            createLesson(id: "fr.4.2.3", moduleId: "4.2", name: "Mots Longs 3", order: 3, content: "toute leurs avant même elles quand",
                         learningGoal: "Maîtrise Mots Longs 3", habitTip: "Concentre-toi sur la précision avant la vitesse", descriptionOverride: "Pratique les mots longs")
        ]
        let lessons3 = [
            createLesson(id: "fr.4.3.1", moduleId: "4.3", name: "Sprint de 30 Secondes", order: 1, content: "le de la et les un en du a une pour dans est",
                         learningGoal: "Maîtrise Sprint de 30 Secondes", habitTip: "Ne regarde pas le clavier !", descriptionOverride: "Sprint de vitesse"),
            createLesson(
                id: "fr.4.4.1", 
                moduleId: "4.4", 
                name: "Test de Niveau 4", 
                order: 1, 
                content: "la première grande chose est d'apprendre", 
                isGatekeeper: true,
                pool: [
                    "la première grande chose est d'apprendre a utiliser votre propre voix a nouveau.",
                    "pensez a l'endroit ou vous étiez lorsque vous avez commencé ce voyage.",
                    "étudier la place droit petit son pourrait encore une fois bas."
                ],
                learningGoal: "Réussis le Test de Niveau 4", habitTip: "Reste calme et tape régulièrement", descriptionOverride: "Test de niveau 4"
            )
        ]
        
        let modules = [
            Module(id: "4.1", name: "Mots Courts", description: "Top 30 mots", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "Mots Moyens", description: "5+ lettres", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "Sprints de Mots", description: "Construire la vitesse", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "Maîtrise des Mots", themeName: "Bibliothèque", description: "Augmentez votre vitesse", iconName: "text.word.spacing", modules: modules)
    }

    // MARK: - Stage 5: Sentence Fluency (French)
    private func generateFrenchStage5() -> Stage {
        let lessons1 = [
            createLesson(id: "fr.5.1.1", moduleId: "5.1", name: "Phrases Simples", order: 1, content: "Le chien aboie fort. Le chat dort.",
                         learningGoal: "Maîtrise Phrases Simples", habitTip: "Lis toute la phrase avant de taper", descriptionOverride: "Pratique les phrases simples"),
            createLesson(id: "fr.5.1.2", moduleId: "5.1", name: "Questions", order: 2, content: "Comment vas-tu aujourd'hui? Quelle heure est-il?",
                         learningGoal: "Maîtrise Questions", habitTip: "Fais attention à la ponctuation", descriptionOverride: "Pratique les questions"),
            createLesson(id: "fr.5.1.3", moduleId: "5.1", name: "Commandes", order: 3, content: "Fermez la porte s'il vous plaît. Allumez la lumière.",
                         learningGoal: "Maîtrise Commandes", habitTip: "N'oublie pas les majuscules au début", descriptionOverride: "Pratique les commandes")
        ]
        let lessons2 = [
            createLesson(id: "fr.5.2.1", moduleId: "5.2", name: "Phrases Composées", order: 1, content: "Je suis allé au magasin, et j'ai acheté du pain.",
                         learningGoal: "Maîtrise Phrases Composées", habitTip: "Lis toute la phrase avant de taper", descriptionOverride: "Pratique les phrases simples"),
            createLesson(id: "fr.5.2.2", moduleId: "5.2", name: "Idées Complexes", order: 2, content: "Bien qu'il pleuve, nous avons décidé de sortir.",
                         learningGoal: "Maîtrise Idées Complexes", habitTip: "Ne t'arrête pas aux phrases longues", descriptionOverride: "Pratique les phrases complexes")
        ]
        let lessons3 = [
            createLesson(
                id: "fr.5.4.1", 
                moduleId: "5.4", 
                name: "Test de Niveau 5", 
                order: 1, 
                content: "TypeQuest est la meilleure façon d'apprendre.", 
                isGatekeeper: true,
                pool: [
                    "TypeQuest est la meilleure façon d'apprendre a taper. Avec une pratique quotidienne, tu t’amélioreras.",
                    "Portez ce vieux whisky au juge blond qui fume. Une phrase célèbre.",
                    "Lire et écrire sont les fondations de la communication numérique. Maîtrisez le clavier aujourd'hui."
                ],
                learningGoal: "Réussis le Test de Niveau 5", habitTip: "Reste calme et tape régulièrement", descriptionOverride: "Test de niveau 5"
            )
        ]
        
        let modules = [
            Module(id: "5.1", name: "Phrases Simples", description: "Flux de base", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "Phrases Composées", description: "Idées connectées", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "Pratique de Paragraphes", description: "Flux multi-phrases", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "Fluidité des Phrases", themeName: "Océan", description: "Écrivez avec rythme", iconName: "text.alignleft", modules: modules)
    }

    // MARK: - Stage 6: Numbers & Symbols (French)
    private func generateFrenchStage6() -> Stage {
        let lessons1 = [
            createLesson(id: "fr.6.1.1", moduleId: "6.1", name: "Touches 1 et 2", order: 1, content: "111 222 111 222 12 21 12 21",
                         learningGoal: "Maîtrise Touches 1 et 2", habitTip: "Étire le doigt vers le haut, pas toute la main", descriptionOverride: "Pratique Touches 1 et 2"),  // Note: On AZERTY, numbers need shift.
                                                                                                    // For basic typing drills, we usually practice the key press. 
                                                                                                    // Key "1" is "&" unshifted. "2" is "é". 
                                                                                                    // Stage 6 title is "Numbers". 
                                                                                                    // Should we teach "&" and "é"? 
                                                                                                    // Or assume user knows Shift? 
                                                                                                    // Let's keep numbers for now as "Symbol/Number Stage".
            createLesson(id: "fr.6.1.2", moduleId: "6.1", name: "Touches 3 et 4", order: 2, content: "333 444 333 444 34 43 34 43",
                         learningGoal: "Maîtrise Touches 3 et 4", habitTip: "Étire le doigt vers le haut, pas toute la main", descriptionOverride: "Pratique Touches 3 et 4"),
            createLesson(id: "fr.6.1.3", moduleId: "6.1", name: "Touches 5 et 6", order: 3, content: "555 666 555 666 56 65 56 65",
                         learningGoal: "Maîtrise Touches 5 et 6", habitTip: "Étire le doigt vers le haut, pas toute la main", descriptionOverride: "Pratique Touches 5 et 6"),
            createLesson(id: "fr.6.1.4", moduleId: "6.1", name: "Touches 7 et 8", order: 4, content: "777 888 777 888 78 87 78 87",
                         learningGoal: "Maîtrise Touches 7 et 8", habitTip: "Étire le doigt vers le haut, pas toute la main", descriptionOverride: "Pratique Touches 7 et 8"),
            createLesson(id: "fr.6.1.5", moduleId: "6.1", name: "Touches 9 et 0", order: 5, content: "999 000 999 000 90 09 90 09",
                         learningGoal: "Maîtrise Touches 9 et 0", habitTip: "Étire le doigt vers le haut, pas toute la main", descriptionOverride: "Pratique Touches 9 et 0")
        ]
        let lessons2 = [
            createLesson(id: "fr.6.2.1", moduleId: "6.2", name: "& é \" '", order: 1, content: "&&& ééé \"\"\" '''",
                         learningGoal: "Maîtrise & é \" ", habitTip: "Maintiens Shift avec l'auriculaire", descriptionOverride: "Pratique les caractères spéciaux"), // Unshifted top row on AZERTY
            createLesson(id: "fr.6.2.2", moduleId: "6.2", name: "( - è _", order: 2, content: "((( --- èèè ___"),
            createLesson(id: "fr.6.2.3", moduleId: "6.2", name: "ç à ) =", order: 3, content: "ççç ààà ))) ===")
        ]
        let lessons3 = [
            createLesson(
                id: "fr.6.4.1", 
                moduleId: "6.4", 
                name: "Test Final", 
                order: 1, 
                content: "Félicitations! Vous avez atteint l'Etape 6.", 
                isGatekeeper: true,
                pool: [
                    "Félicitations! Vous avez atteint l'Etape 6. Vérifions tout: 123 + 456 = 579. C'est vrai? Oui!",
                    "Projet final: (acc >= 98.0) && (wpm >= 50.0). Test terminé: [OK].",
                    "Caractères spéciaux: !@#$%^&*()_+. Vous avez terminé le programme TypeQuest. Bien joué!"
                ],
                learningGoal: "Réussis le Test Final", habitTip: "Tu y es presque – reste concentré !", descriptionOverride: "Test final du clavier complet"
            )
        ]
        
        let modules = [
            Module(id: "6.1", name: "Rangée de Chiffres", description: "Touches 0-9 (Maj)", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "Accents et Symboles", description: "Caractères directs", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "Pratique Mixte", description: "Tout combiné", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "Nombres & Symboles", themeName: "Laboratoire", description: "Maîtrisez le clavier", iconName: "number.circle.fill", modules: modules)
    }

    // MARK: - Italian Curriculum
    private func generateItalianStages() -> [Stage] {
        return [
            generateItalianStage1(),
            generateItalianStage2(),
            generateItalianStage3(),
            generateItalianStage4(),
            generateItalianStage5(),
            generateItalianStage6()
        ]
    }
    
    private func generateItalianStage1() -> Stage {
        let lessons = [
            createLesson(id: "it.1.1.1", moduleId: "1.1", name: "Tasti A e S", order: 1, content: "aaa sss aaa sss as sa as sa",
                         learningGoal: "Padroneggia Tasti A e S", habitTip: "Mantieni le dita sulla riga base", descriptionOverride: "Pratica Tasti A e S"),
            createLesson(
                id: "it.1.4.1", 
                moduleId: "1.4", 
                name: "Test di Livello 1", 
                order: 2, 
                content: "asdf jkl; la sala alla", 
                isGatekeeper: true,
                pool: [
                    "asdf jkl; la sala alla salsa. dalla sala alla salsa. falla sala alla.",
                    "dalla sala alla sala. asdf jkl; la salsa alla sala. falla sala alla.",
                    "la sala alla salsa. asdf jkl; dalla sala alla sala. salsa dalla sala."
                ],
                learningGoal: "Supera il Test di Livello 1", habitTip: "Mantieni la calma e digita in modo uniforme", descriptionOverride: "Test di livello 1"
            )
        ]
        return Stage(id: 1, name: "Fondamenta della Riga Base", themeName: "Colline", description: "Domina la riga centrale", iconName: "hand.raised.fill", modules: [
            Module(id: "1.1", name: "Ancore Sinistre", description: "Posizione della mano sinistra", stageId: 1, order: 1, lessons: lessons)
        ])
    }
    
    private func generateItalianStage2() -> Stage {
        let lessons = [
            createLesson(
                id: "it.2.4.1", 
                moduleId: "2.4", 
                name: "Test di Livello 2", 
                order: 1, 
                content: "la veloce volpe bruna salta", 
                isGatekeeper: true,
                pool: [
                    "la veloce volpe bruna salta sopra il cane pigro. quanto è piccolo il mondo quando scrivi veloce.",
                    "scrivere è una priorità per il successo. la strada è lunga ma il risultato è unico.",
                    "voglio poter scrivere con precisione e rapidità. tutti i giovani possono imparare oggi stesso."
                ],
                learningGoal: "Supera il Test di Livello 2", habitTip: "Mantieni la calma e digita in modo uniforme", descriptionOverride: "Test di livello 2"
            )
        ]
        return Stage(id: 2, name: "Espansione della Riga Superiore", themeName: "Appennini", description: "Raggiungi la riga superiore", iconName: "arrow.up.circle.fill", modules: [
            Module(id: "2.1", name: "Maestria Superiore", description: "Flusso della riga superiore", stageId: 2, order: 1, lessons: lessons)
        ])
    }

    // MARK: - Stage 3: Bottom Row & N-Grams (Italian)
    private func generateItalianStage3() -> Stage {
        let lessons1 = [
            createLesson(id: "it.3.1.1", moduleId: "3.1", name: "Tasti Z e X", order: 1, content: "zzz xxx zzz xxx zx xz zero xilofono",
                         learningGoal: "Padroneggia Tasti Z e X", habitTip: "Mantieni le dita sulla riga base", descriptionOverride: "Pratica Tasti Z e X"),
            createLesson(id: "it.3.1.2", moduleId: "3.1", name: "Tasti C e V", order: 2, content: "ccc vvv ccc vvv cv vc cava viva",
                         learningGoal: "Padroneggia Tasti C e V", habitTip: "Mantieni le dita sulla riga base", descriptionOverride: "Pratica Tasti C e V"),
            createLesson(id: "it.3.1.3", moduleId: "3.1", name: "Tasto B", order: 3, content: "bbb bbb bob bene bella barca",
                         learningGoal: "Padroneggia Tasto B", habitTip: "Mantieni le dita sulla riga base", descriptionOverride: "Pratica Tasto B")
        ]
        let lessons2 = [
            createLesson(id: "it.3.2.1", moduleId: "3.2", name: "Tasti N e M", order: 1, content: "nnn mmm nnn mmm nm mn nome mano",
                         learningGoal: "Padroneggia Tasti N e M", habitTip: "Mantieni le dita sulla riga base", descriptionOverride: "Pratica Tasti N e M"),
            createLesson(id: "it.3.2.2", moduleId: "3.2", name: "Virgola e Punto", order: 2, content: ",,, ... ,,, ... ,. ., uno, due.",
                         learningGoal: "Padroneggia Virgola e Punto", habitTip: "Mantieni le dita sulla riga base", descriptionOverride: "Pratica Virgola e Punto"),
            createLesson(id: "it.3.2.3", moduleId: "3.2", name: "Tasto Slash", order: 3, content: "/// /// e/o si/no",
                         learningGoal: "Padroneggia Tasto Slash", habitTip: "Mantieni le dita sulla riga base", descriptionOverride: "Pratica Tasto Slash")
        ]
        let lessons3 = [
            createLesson(id: "it.3.3.1", moduleId: "3.3", name: "Coppie Comuni: la, le", order: 1, content: "la la la le le le lo il un una",
                         learningGoal: "Padroneggia Coppie Comuni: la, le", habitTip: "Mantieni un ritmo fluido", descriptionOverride: "Pratica le coppie di lettere comuni"),
            createLesson(id: "it.3.3.2", moduleId: "3.3", name: "Coppie Comuni: ch, che", order: 2, content: "ch ch ch che che che chi che",
                         learningGoal: "Padroneggia Coppie Comuni: ch, che", habitTip: "Mantieni un ritmo fluido", descriptionOverride: "Pratica le coppie di lettere comuni"),
            createLesson(
                id: "it.3.4.1", 
                moduleId: "3.4", 
                name: "Test di Livello 3", 
                order: 1, 
                content: "la veloce volpe bruna salta", 
                isGatekeeper: true,
                pool: [
                    "la veloce volpe bruna salta sopra il cane pigro. il mondo è piccolo.",
                    "voglio mangiare una pizza margherita. andiamo al mare domani pomeriggio.",
                    "la musica è molto forte alla festa. mi piace ballare con i miei amici."
                ],
                learningGoal: "Supera il Test di Livello 3", habitTip: "Mantieni la calma e digita in modo uniforme", descriptionOverride: "Test di livello 3"
            )
        ]
        
        let modules = [
            Module(id: "3.1", name: "Riga Inferiore Sinistra", description: "Tasti Z X C V B", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "Riga Inferiore Destra", description: "Tasti N M , . /", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "N-Grammi Comuni", description: "Padroneggia le coppie", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "Riga Inferiore & Modelli", themeName: "Fiume", description: "Completa l'alfabeto", iconName: "arrow.down.circle.fill", modules: modules)
    }

    // MARK: - Stage 4: Word Mastery (Italian)
    private func generateItalianStage4() -> Stage {
        let lessons1 = [
            createLesson(id: "it.4.1.1", moduleId: "4.1", name: "Parole Frequenti 1", order: 1, content: "il di la e i un in del a una",
                         learningGoal: "Padroneggia Parole Frequenti 1", habitTip: "Leggi prima la parola, poi digitala", descriptionOverride: "Pratica le parole frequenti"),
            createLesson(id: "it.4.1.2", moduleId: "4.1", name: "Parole Frequenti 2", order: 2, content: "per non è che con le su da se ma",
                         learningGoal: "Padroneggia Parole Frequenti 2", habitTip: "Leggi prima la parola, poi digitala", descriptionOverride: "Pratica le parole frequenti"),
            createLesson(id: "it.4.1.3", moduleId: "4.1", name: "Parole Frequenti 3", order: 3, content: "al sono più io come questo anche o",
                         learningGoal: "Padroneggia Parole Frequenti 3", habitTip: "Leggi prima la parola, poi digitala", descriptionOverride: "Pratica le parole frequenti")
        ]
        let lessons2 = [
            createLesson(id: "it.4.2.1", moduleId: "4.2", name: "Parole Lunghe 1", order: 1, content: "questo quello anche tempo fare",
                         learningGoal: "Padroneggia Parole Lunghe 1", habitTip: "Concentrati sulla precisione prima della velocità", descriptionOverride: "Pratica le parole lunghe"),
            createLesson(id: "it.4.2.2", moduleId: "4.2", name: "Parole Lunghe 2", order: 2, content: "grande mondo tra altro dopo avere",
                         learningGoal: "Padroneggia Parole Lunghe 2", habitTip: "Concentrati sulla precisione prima della velocità", descriptionOverride: "Pratica le parole lunghe"),
            createLesson(id: "it.4.2.3", moduleId: "4.2", name: "Parole Lunghe 3", order: 3, content: "tutto loro prima stesso quando",
                         learningGoal: "Padroneggia Parole Lunghe 3", habitTip: "Concentrati sulla precisione prima della velocità", descriptionOverride: "Pratica le parole lunghe")
        ]
        let lessons3 = [
            createLesson(id: "it.4.3.1", moduleId: "4.3", name: "Sprint di 30 Secondi", order: 1, content: "il di la e i un in del a una per non è che con le",
                         learningGoal: "Padroneggia Sprint di 30 Secondi", habitTip: "Non guardare la tastiera!", descriptionOverride: "Sprint di velocità"),
            createLesson(
                id: "it.4.4.1", 
                moduleId: "4.4", 
                name: "Test di Livello 4", 
                order: 1, 
                content: "la prima grande cosa è imparare", 
                isGatekeeper: true,
                pool: [
                    "la prima grande cosa è imparare a usare la tua voce di nuovo.",
                    "pensa a dove eri quando hai iniziato questo viaggio.",
                    "studiare il posto giusto piccolo suono potrebbe ancora una volta giù."
                ],
                learningGoal: "Supera il Test di Livello 4", habitTip: "Mantieni la calma e digita in modo uniforme", descriptionOverride: "Test di livello 4"
            )
        ]
        
        let modules = [
            Module(id: "4.1", name: "Parole Corte", description: "Top 30 parole", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "Parole Medie", description: "5+ lettere", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "Sprint di Parole", description: "Costruisci velocità", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "Maestria delle Parole", themeName: "Biblioteca", description: "Aumenta la tua velocità", iconName: "text.word.spacing", modules: modules)
    }

    // MARK: - Stage 5: Sentence Fluency (Italian)
    private func generateItalianStage5() -> Stage {
        let lessons1 = [
            createLesson(id: "it.5.1.1", moduleId: "5.1", name: "Frasi Semplici", order: 1, content: "Il cane abbaia forte. Il gatto dorme.",
                         learningGoal: "Padroneggia Frasi Semplici", habitTip: "Leggi tutta la frase prima di digitare", descriptionOverride: "Pratica le frasi semplici"),
            createLesson(id: "it.5.1.2", moduleId: "5.1", name: "Domande", order: 2, content: "Come stai oggi? Che ore sono?",
                         learningGoal: "Padroneggia Domande", habitTip: "Leggi tutta la frase prima di digitare", descriptionOverride: "Pratica le frasi semplici"),
            createLesson(id: "it.5.1.3", moduleId: "5.1", name: "Comandi", order: 3, content: "Chiudi la porta per favore. Accendi la luce.",
                         learningGoal: "Padroneggia Comandi", habitTip: "Non dimenticare le maiuscole all'inizio", descriptionOverride: "Pratica i comandi")
        ]
        let lessons2 = [
            createLesson(id: "it.5.2.1", moduleId: "5.2", name: "Frasi Composte", order: 1, content: "Sono andato al negozio, e ho comprato il pane.",
                         learningGoal: "Padroneggia Frasi Composte", habitTip: "Leggi tutta la frase prima di digitare", descriptionOverride: "Pratica le frasi semplici"),
            createLesson(id: "it.5.2.2", moduleId: "5.2", name: "Idee Complesse", order: 2, content: "Anche se pioveva, abbiamo deciso di uscire.",
                         learningGoal: "Padroneggia Idee Complesse", habitTip: "Mantieni un flusso costante attraverso le virgole", descriptionOverride: "Pratica le frasi composte")
        ]
        let lessons3 = [
            createLesson(
                id: "it.5.4.1", 
                moduleId: "5.4", 
                name: "Test di Livello 5", 
                order: 1, 
                content: "TypeQuest è il modo migliore per imparare.", 
                isGatekeeper: true,
                pool: [
                    "TypeQuest è il modo migliore per imparare a digitare. Con la pratica quotidiana migliorerai.",
                    "Pranzo d'acqua fa volti sghembi. Una frase pangramma (quasi).",
                    "Leggere e scrivere sono le fondazioni della comunicazione digitale. Padroneggia la tastiera oggi."
                ],
                learningGoal: "Supera il Test di Livello 5", habitTip: "Mantieni la calma e digita in modo uniforme", descriptionOverride: "Test di livello 5"
            )
        ]
        
        let modules = [
            Module(id: "5.1", name: "Frasi Semplici", description: "Flusso base", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "Frasi Composte", description: "Idee connesse", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "Pratica Paragrafi", description: "Flusso multi-frase", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "Fluidità della Frase", themeName: "Oceano", description: "Scrivi con ritmo", iconName: "text.alignleft", modules: modules)
    }

    // MARK: - Stage 6: Numbers & Symbols (Italian)
    private func generateItalianStage6() -> Stage {
        let lessons1 = [
            createLesson(id: "it.6.1.1", moduleId: "6.1", name: "Tasti 1 e 2", order: 1, content: "111 222 111 222 12 21 12 21",
                         learningGoal: "Padroneggia Tasti 1 e 2", habitTip: "Allunga il dito verso l'alto, non tutta la mano", descriptionOverride: "Pratica Tasti 1 e 2"),
            createLesson(id: "it.6.1.2", moduleId: "6.1", name: "Tasti 3 e 4", order: 2, content: "333 444 333 444 34 43 34 43",
                         learningGoal: "Padroneggia Tasti 3 e 4", habitTip: "Allunga il dito verso l'alto, non tutta la mano", descriptionOverride: "Pratica Tasti 3 e 4"),
            createLesson(id: "it.6.1.3", moduleId: "6.1", name: "Tasti 5 e 6", order: 3, content: "555 666 555 666 56 65 56 65",
                         learningGoal: "Padroneggia Tasti 5 e 6", habitTip: "Allunga il dito verso l'alto, non tutta la mano", descriptionOverride: "Pratica Tasti 5 e 6"),
            createLesson(id: "it.6.1.4", moduleId: "6.1", name: "Tasti 7 e 8", order: 4, content: "777 888 777 888 78 87 78 87",
                         learningGoal: "Padroneggia Tasti 7 e 8", habitTip: "Allunga il dito verso l'alto, non tutta la mano", descriptionOverride: "Pratica Tasti 7 e 8"),
            createLesson(id: "it.6.1.5", moduleId: "6.1", name: "Tasti 9 e 0", order: 5, content: "999 000 999 000 90 09 90 09",
                         learningGoal: "Padroneggia Tasti 9 e 0", habitTip: "Allunga il dito verso l'alto, non tutta la mano", descriptionOverride: "Pratica Tasti 9 e 0")
        ]
        let lessons2 = [
            createLesson(id: "it.6.2.1", moduleId: "6.2", name: "! \" £ $", order: 1, content: "!!! \"\"\" £££ $$$ !\"£$",
                         learningGoal: "Padroneggia ! \" ", habitTip: "Tieni premuto Shift con il mignolo", descriptionOverride: "Pratica i caratteri speciali"), // Italian spec
            createLesson(id: "it.6.2.2", moduleId: "6.2", name: "% & / ( )", order: 2, content: "%%% &&& /// ((( )))",
                         learningGoal: "Padroneggia % & / ( )", habitTip: "Tieni premuto Shift con il mignolo", descriptionOverride: "Pratica i caratteri speciali"),
            createLesson(id: "it.6.2.3", moduleId: "6.2", name: "= ? ^ * +", order: 3, content: "=== ??? ^^^ *** +++",
                         learningGoal: "Padroneggia = ? ^ * +", habitTip: "Tieni premuto Shift con il mignolo", descriptionOverride: "Pratica i caratteri speciali")
        ]
        let lessons3 = [
            createLesson(
                id: "it.6.4.1", 
                moduleId: "6.4", 
                name: "Test Finale", 
                order: 1, 
                content: "Congratulazioni! Hai raggiunto lo Stage 6.", 
                isGatekeeper: true,
                pool: [
                    "Congratulazioni! Hai raggiunto lo Stage 6. Verifichiamo tutto: 123 + 456 = 579. Vero? Sì!",
                    "Progetto finale: (acc >= 98.0) && (wpm >= 50.0). Test completato: [OK].",
                    "Caratteri speciali: !\"£$%&/()=?^. Hai completato il curriculum di TypeQuest. Ben fatto!"
                ],
                learningGoal: "Supera il Test Finale", habitTip: "Ci sei quasi – resta concentrato!", descriptionOverride: "Test finale della tastiera completa"
            )
        ]
        
        let modules = [
            Module(id: "6.1", name: "Riga Numerica", description: "Tasti 0-9", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "Simboli Comuni", description: "Caratteri speciali", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "Pratica Mista", description: "Tutto combinato", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "Numeri & Simboli", themeName: "Laboratorio", description: "Padroneggia la tastiera", iconName: "number.circle.fill", modules: modules)
    }

    // MARK: - Dutch Curriculum (NL - QWERTY)
    private func generateDutchStages() -> [Stage] {
        return [
            generateDutchStage1(),
            generateDutchStage2(),
            generateDutchStage3(),
            generateDutchStage4(),
            generateDutchStage5(),
            generateDutchStage6()
        ]
    }
    
    // MARK: - Polish Curriculum
    private func generatePolishStages() -> [Stage] {
        return [
            generatePolishStage1(),
            generatePolishStage2(),
            generatePolishStage3(),
            generatePolishStage4(),
            generatePolishStage5(),
            generatePolishStage6()
        ]
    }

    private func generatePolishStage1() -> Stage {
        let lessons = [
            createLesson(id: "pl.1.1.1", moduleId: "1.1", name: "Klawisze A i S", order: 1, content: "aaa sss aaa sss as sa as sa",
                         learningGoal: "Opanuj Klawisze A i S", habitTip: "Trzymaj palce na rzędzie bazowym", descriptionOverride: "Ćwicz Klawisze A i S"),
            createLesson(
                id: "pl.1.4.1", 
                moduleId: "1.4", 
                name: "Test Poziomu 1", 
                order: 2, 
                content: "asdf jkl; sala lala las", 
                isGatekeeper: true,
                pool: [
                    "asdf jkl; sala lala las. lala lasa sala. salki lasa lala.",
                    "sala lala lasa. asdf jkl; salki sala lala. lasa sala lala salki.",
                    "lala sala lasa. asdf jkl; salki lala sala. lasa salki lala sala."
                ],
                learningGoal: "Zdaj Test Poziomu 1", habitTip: "Zachowaj spokój i pisz równomiernie", descriptionOverride: "Test poziomu 1"
            )
        ]
        return Stage(id: 1, name: "Fundamenty Wiersza Głównego", themeName: "Puszcza", description: "Opanuj środkowy rząd", iconName: "hand.raised.fill", modules: [
            Module(id: "1.1", name: "Kotwice Lewej Ręki", description: "Pozycja lewej ręki", stageId: 1, order: 1, lessons: lessons)
        ])
    }
    
    private func generatePolishStage2() -> Stage {
        let lessons = [
            createLesson(
                id: "pl.2.4.1", 
                moduleId: "2.4", 
                name: "Test Poziomu 2", 
                order: 1, 
                content: "szybki brazowy lis skacze", 
                isGatekeeper: true,
                pool: [
                    "szybki brazowy lis skacze nad leniwym psem. swiat jest maly, gdy piszesz szybko.",
                    "pisanie to priorytet dla sukcesu. droga jest dluga, ale wynik jest wyjatkowy.",
                    "chce pisac precyzyjnie i szybko. kazdy mlody czlowiek moze sie dzis nauczyc."
                ],
                learningGoal: "Zdaj Test Poziomu 2", habitTip: "Zachowaj spokój i pisz równomiernie", descriptionOverride: "Test poziomu 2"
            )
        ]
        return Stage(id: 2, name: "Rozszerzenie GĂłrnego Wiersza", themeName: "GĂłry", description: "Dosiegnij gĂłrnego rzedu", iconName: "arrow.up.circle.fill", modules: [
            Module(id: "2.1", name: "Mistrzostwo GĂłrne", description: "Przeplyw gĂłrnego rzedu", stageId: 2, order: 1, lessons: lessons)
        ])
    }

    // MARK: - Stage 3: Bottom Row & N-Grams (Polish)
    private func generatePolishStage3() -> Stage {
        let lessons1 = [
            createLesson(id: "pl.3.1.1", moduleId: "3.1", name: "Klawisze Z i X", order: 1, content: "zzz xxx zzz xxx zx xz zero xero",
                         learningGoal: "Opanuj Klawisze Z i X", habitTip: "Trzymaj palce na rzędzie bazowym", descriptionOverride: "Ćwicz Klawisze Z i X"),
            createLesson(id: "pl.3.1.2", moduleId: "3.1", name: "Klawisze C i V", order: 2, content: "ccc vvv ccc vvv cv vc co ve",
                         learningGoal: "Opanuj Klawisze C i V", habitTip: "Trzymaj palce na rzędzie bazowym", descriptionOverride: "Ćwicz Klawisze C i V"),
            createLesson(id: "pl.3.1.3", moduleId: "3.1", name: "Klawisz B", order: 3, content: "bbb bbb bob bez bo byc",
                         learningGoal: "Opanuj Klawisz B", habitTip: "Trzymaj palce na rzędzie bazowym", descriptionOverride: "Ćwicz Klawisz B")
        ]
        let lessons2 = [
            createLesson(id: "pl.3.2.1", moduleId: "3.2", name: "Klawisze N i M", order: 1, content: "nnn mmm nnn mmm nm mn na ma",
                         learningGoal: "Opanuj Klawisze N i M", habitTip: "Trzymaj palce na rzędzie bazowym", descriptionOverride: "Ćwicz Klawisze N i M"),
            createLesson(id: "pl.3.2.2", moduleId: "3.2", name: "Przecinek i Kropka", order: 2, content: ",,, ... ,,, ... ,. ., raz, dwa.",
                         learningGoal: "Opanuj Przecinek i Kropka", habitTip: "Trzymaj palce na rzędzie bazowym", descriptionOverride: "Ćwicz Przecinek i Kropka"),
            createLesson(id: "pl.3.2.3", moduleId: "3.2", name: "Klawisz Slash", order: 3, content: "/// /// i/lub tak/nie",
                         learningGoal: "Opanuj Klawisz Slash", habitTip: "Trzymaj palce na rzędzie bazowym", descriptionOverride: "Ćwicz Klawisz Slash")
        ]
        let lessons3 = [
            createLesson(id: "pl.3.3.1", moduleId: "3.3", name: "Czeste Pary: na, w", order: 1, content: "na na na w w w to co z",
                         learningGoal: "Opanuj Czeste Pary: na, w", habitTip: "Utrzymuj płynny rytm", descriptionOverride: "Practice pairs"),
            createLesson(id: "pl.3.3.2", moduleId: "3.3", name: "Czeste Pary: ch, sz", order: 2, content: "ch ch ch sz sz sz cz rz",
                         learningGoal: "Opanuj Czeste Pary: ch, sz", habitTip: "Utrzymuj płynny rytm", descriptionOverride: "Practice pairs"),
            createLesson(
                id: "pl.3.4.1", 
                moduleId: "3.4", 
                name: "Test Poziomu 3", 
                order: 1, 
                content: "szybki brazowy lis biegnie", 
                isGatekeeper: true,
                pool: [
                    "szybki brazowy lis biegnie przez las. swiat jest piekny.",
                    "chce zjesc dobra kolacje dzis wieczorem. idziemy do kina.",
                    "muzyka gra glosno na imprezie. lubie tanczyc z przyjaciolmi."
                ],
                learningGoal: "Zdaj Test Poziomu 3", habitTip: "Zachowaj spokój i pisz równomiernie", descriptionOverride: "Test poziomu 3"
            )
        ]
        
        let modules = [
            Module(id: "3.1", name: "Dolny Rzad Lewy", description: "Klawisze Z X C V B", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "Dolny Rzad Prawy", description: "Klawisze N M , . /", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "Czeste N-Gramy", description: "Opanuj pary liter", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "Dolny Rzad & Wzorce", themeName: "Rzeka", description: "Uzupelnij alfabet", iconName: "arrow.down.circle.fill", modules: modules)
    }

    // MARK: - Stage 4: Word Mastery (Polish)
    private func generatePolishStage4() -> Stage {
        let lessons1 = [
            createLesson(id: "pl.4.1.1", moduleId: "4.1", name: "Czeste Slowa 1", order: 1, content: "w z i na do sie jak o to",
                         learningGoal: "Opanuj Czeste Slowa 1", habitTip: "Przeczytaj słowo, potem je wpisz", descriptionOverride: "Ćwicz częste słowa"),
            createLesson(id: "pl.4.1.2", moduleId: "4.1", name: "Czeste Slowa 2", order: 2, content: "co po je a tak ze dla za",
                         learningGoal: "Opanuj Czeste Slowa 2", habitTip: "Przeczytaj słowo, potem je wpisz", descriptionOverride: "Ćwicz częste słowa"),
            createLesson(id: "pl.4.1.3", moduleId: "4.1", name: "Czeste Slowa 3", order: 3, content: "ale czy nie go tej ma od",
                         learningGoal: "Opanuj Czeste Slowa 3", habitTip: "Przeczytaj słowo, potem je wpisz", descriptionOverride: "Ćwicz częste słowa")
        ]
        let lessons2 = [
            createLesson(id: "pl.4.2.1", moduleId: "4.2", name: "Dlugie Slowa 1", order: 1, content: "tylko przez przed teraz jeden",
                         learningGoal: "Opanuj Dlugie Slowa 1", habitTip: "Przeczytaj słowo, potem je wpisz", descriptionOverride: "Ćwicz częste słowa"),
            createLesson(id: "pl.4.2.2", moduleId: "4.2", name: "Dlugie Slowa 2", order: 2, content: "bardzo trzeba mozna zaraz",
                         learningGoal: "Opanuj Dlugie Slowa 2", habitTip: "Przeczytaj słowo, potem je wpisz", descriptionOverride: "Ćwicz częste słowa"),
            createLesson(id: "pl.4.2.3", moduleId: "4.2", name: "Dlugie Slowa 3", order: 3, content: "jeszcze zawsze wlasnie dlaczego",
                         learningGoal: "Opanuj Dlugie Slowa 3", habitTip: "Przeczytaj słowo, potem je wpisz", descriptionOverride: "Ćwicz częste słowa")
        ]
        let lessons3 = [
            createLesson(id: "pl.4.3.1", moduleId: "4.3", name: "Sprint 30 Sekund", order: 1, content: "w z i na do sie jak o to co po je a tak ze",
                         learningGoal: "Opanuj Sprint 30 Sekund", habitTip: "Nie patrz na klawiaturę!", descriptionOverride: "Sprint szybkości"),
            createLesson(
                id: "pl.4.4.1", 
                moduleId: "4.4", 
                name: "Test Poziomu 4", 
                order: 1, 
                content: "pierwsza wielka rzecza jest nauka", 
                isGatekeeper: true,
                pool: [
                    "pierwsza wielka rzecza jest nauka uzywania wlasnego glosu.",
                    "pomysl gdzie byles kiedy zaczales te podroz.",
                    "cwicz swoje miejsce prawo maly dzwiek mogl znowu dół."
                ],
                learningGoal: "Zdaj Test Poziomu 4", habitTip: "Zachowaj spokój i pisz równomiernie", descriptionOverride: "Test poziomu 4"
            )
        ]
        
        let modules = [
            Module(id: "4.1", name: "Krotkie Slowa", description: "Top 30 slow", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "Srednie Slowa", description: "5+ liter", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "Sprinty Slowne", description: "Buduj predkosc", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "Mistrzostwo Slow", themeName: "Biblioteka", description: "Zwieksz predkosc", iconName: "text.word.spacing", modules: modules)
    }

    // MARK: - Stage 5: Sentence Fluency (Polish)
    private func generatePolishStage5() -> Stage {
        let lessons1 = [
            createLesson(id: "pl.5.1.1", moduleId: "5.1", name: "Proste Zdania", order: 1, content: "Pies szczeka glosno. Kot spi.",
                         learningGoal: "Opanuj Proste Zdania", habitTip: "Przeczytaj całe zdanie przed pisaniem", descriptionOverride: "Ćwicz proste zdania"),
            createLesson(id: "pl.5.1.2", moduleId: "5.1", name: "Pytania", order: 2, content: "Jak sie masz dzis? Ktora jest godzina?",
                         learningGoal: "Opanuj Pytania", habitTip: "Zachowaj spokój i pisz równomiernie", descriptionOverride: "Practice questions"),
            createLesson(id: "pl.5.1.3", moduleId: "5.1", name: "Polecenia", order: 3, content: "Zamknij drzwi prosze. Wlacz swiatlo.",
                         learningGoal: "Opanuj Polecenia", habitTip: "Zachowaj spokój i pisz równomiernie", descriptionOverride: "Practice commands")
        ]
        let lessons2 = [
            createLesson(id: "pl.5.2.1", moduleId: "5.2", name: "Zdania Zlozone", order: 1, content: "Poszedlem do sklepu i kupilem chleb.",
                         learningGoal: "Opanuj Zdania Zlozone", habitTip: "Przeczytaj całe zdanie przed pisaniem", descriptionOverride: "Ćwicz proste zdania"),
            createLesson(id: "pl.5.2.2", moduleId: "5.2", name: "Zlozone Idee", order: 2, content: "Chociaz padalo, zdecydowalismy wyjsc.",
                         learningGoal: "Opanuj Zlozone Idee", habitTip: "Zachowaj spokój i pisz równomiernie", descriptionOverride: "Practice complex sentences")
        ]
        let lessons3 = [
            createLesson(
                id: "pl.5.4.1", 
                moduleId: "5.4", 
                name: "Test Poziomu 5", 
                order: 1, 
                content: "TypeQuest to najlepszy sposob na nauke.", 
                isGatekeeper: true,
                pool: [
                    "TypeQuest to najlepszy sposob na nauke pisania. Z codzienna praktyka bedziesz lepszy.",
                    "Szybki brazowy lis skacze nad leniwym psem. Znane zdanie.",
                    "Czytanie i pisanie to fundamenty komunikacji cyfrowej. Opanuj klawiature dzis."
                ],
                learningGoal: "Zdaj Test Poziomu 5", habitTip: "Zachowaj spokój i pisz równomiernie", descriptionOverride: "Test poziomu 5"
            )
        ]
        
        let modules = [
            Module(id: "5.1", name: "Proste Zdania", description: "Podstawowy przeplyw", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "Zdania Zlozone", description: "Polaczone idee", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "Cwiczenie Akapitow", description: "Wiele zdan", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "Plynnosc Zdan", themeName: "Ocean", description: "Pisz z rytmem", iconName: "text.alignleft", modules: modules)
    }

    // MARK: - Stage 6: Numbers & Symbols (Polish)
    private func generatePolishStage6() -> Stage {
        let lessons1 = [
            createLesson(id: "pl.6.1.1", moduleId: "6.1", name: "Klawisze 1 i 2", order: 1, content: "111 222 111 222 12 21 12 21",
                         learningGoal: "Opanuj Klawisze 1 i 2", habitTip: "Trzymaj palce na rzędzie bazowym", descriptionOverride: "Ćwicz Klawisze 1 i 2"),
            createLesson(id: "pl.6.1.2", moduleId: "6.1", name: "Klawisze 3 i 4", order: 2, content: "333 444 333 444 34 43 34 43",
                         learningGoal: "Opanuj Klawisze 3 i 4", habitTip: "Trzymaj palce na rzędzie bazowym", descriptionOverride: "Ćwicz Klawisze 3 i 4"),
            createLesson(id: "pl.6.1.3", moduleId: "6.1", name: "Klawisze 5 i 6", order: 3, content: "555 666 555 666 56 65 56 65",
                         learningGoal: "Opanuj Klawisze 5 i 6", habitTip: "Trzymaj palce na rzędzie bazowym", descriptionOverride: "Ćwicz Klawisze 5 i 6"),
            createLesson(id: "pl.6.1.4", moduleId: "6.1", name: "Klawisze 7 i 8", order: 4, content: "777 888 777 888 78 87 78 87",
                         learningGoal: "Opanuj Klawisze 7 i 8", habitTip: "Trzymaj palce na rzędzie bazowym", descriptionOverride: "Ćwicz Klawisze 7 i 8"),
            createLesson(id: "pl.6.1.5", moduleId: "6.1", name: "Klawisze 9 i 0", order: 5, content: "999 000 999 000 90 09 90 09",
                         learningGoal: "Opanuj Klawisze 9 i 0", habitTip: "Trzymaj palce na rzędzie bazowym", descriptionOverride: "Ćwicz Klawisze 9 i 0")
        ]
        let lessons2 = [
            createLesson(id: "pl.6.2.1", moduleId: "6.2", name: "! @ # $", order: 1, content: "!!! @@@ ### $$$ !@#$",
                         learningGoal: "Opanuj ! @ # $", habitTip: "Przytrzymaj Shift małym palcem", descriptionOverride: "Ćwicz znaki specjalne"),
            createLesson(id: "pl.6.2.2", moduleId: "6.2", name: "% ^ & *", order: 2, content: "%%% ^^^ &&& *** %^&*",
                         learningGoal: "Opanuj % ^ & *", habitTip: "Przytrzymaj Shift małym palcem", descriptionOverride: "Ćwicz znaki specjalne"),
            createLesson(id: "pl.6.2.3", moduleId: "6.2", name: "( ) - =", order: 3, content: "((( ))) --- === ()-=",
                         learningGoal: "Opanuj ( ) - =", habitTip: "Przytrzymaj Shift małym palcem", descriptionOverride: "Ćwicz znaki specjalne")
        ]
        let lessons3 = [
            createLesson(
                id: "pl.6.4.1", 
                moduleId: "6.4", 
                name: "Test Koncowy", 
                order: 1, 
                content: "Gratulacje! Osiagnales Etap 6.", 
                isGatekeeper: true,
                pool: [
                    "Gratulacje! Osiagnales Etap 6. Sprawdzmy wszystko: 123 + 456 = 579. Prawda? Tak!",
                    "Projekt koncowy: (acc >= 98.0) && (wpm >= 50.0). Test ukonczony: [OK].",
                    "Znaki specjalne: !@#$%^&*()_+. Ukonczyles program TypeQuest. Dobra robota!"
                ],
                learningGoal: "Zdaj Test Koncowy", habitTip: "Prawie gotowe – skup się!", descriptionOverride: "Test końcowy całej klawiatury"
            )
        ]
        
        let modules = [
            Module(id: "6.1", name: "Wiersz Liczbowy", description: "Klawisze 0-9", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "Symbole", description: "Znaki specjalne", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "Cwiczenie Mieszane", description: "Wszystko razem", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "Liczby & Symbole", themeName: "Laboratorium", description: "Opanuj klawiature", iconName: "number.circle.fill", modules: modules)
    }

    // MARK: - Czech Curriculum
    private func generateCzechStages() -> [Stage] {
        return [
            generateCzechStage1(),
            generateCzechStage2(),
            generateCzechStage3(),
            generateCzechStage4(),
            generateCzechStage5(),
            generateCzechStage6()
        ]
    }
    
    private func generateCzechStage1() -> Stage {
        let lessons = [
            createLesson(id: "cs.1.1.1", moduleId: "1.1", name: "Klávesy A a S", order: 1, content: "aaa sss aaa sss as sa as sa",
                         learningGoal: "Ovládni Klávesy A a S", habitTip: "Drž prsty na základní řadě", descriptionOverride: "Procvič Klávesy A a S"),
            createLesson(
                id: "cs.1.4.1", 
                moduleId: "1.4", 
                name: "Úroveň Test 1", 
                order: 2, 
                content: "asdf jkl; salát sádlo sál", 
                isGatekeeper: true,
                pool: [
                    "asdf jkl; salát sádlo sál. sál sádlo salát. sádla sál salát.",
                    "salát sádlo sála. asdf jkl; sádla sál salát. sádlo sál salát sádla.",
                    "sádlo salát sála. asdf jkl; sádla sádlo salát. sádlo sála sádlo sál."
                ],
                learningGoal: "Splň Úroveň Test 1", habitTip: "Zachovej klid a piš rovnoměrně", descriptionOverride: "Úrovňový test 1"
            )
        ]
        return Stage(id: 1, name: "Základy Základní Řady", themeName: "Les", description: "Ovládněte střední řadu", iconName: "hand.raised.fill", modules: [
            Module(id: "1.1", name: "Levé Kotvy", description: "Pozice levé ruky", stageId: 1, order: 1, lessons: lessons)
        ])
    }
    
    private func generateCzechStage2() -> Stage {
        let lessons = [
            createLesson(
                id: "cs.2.4.1", 
                moduleId: "2.4", 
                name: "Úroveň Test 2", 
                order: 1, 
                content: "přiliš žluťoučký kůň úpěl", 
                isGatekeeper: true,
                pool: [
                    "přiliš žluťoučký kůň úpěl ďábelské ódy. svět je malý, když píšete rychle.",
                    "psaní je priorita pro úspěch. cesta je dlouhá, ale výsledek je jedinečný.",
                    "chci psát precizně a rychle. každý mladý člověk se dnes může naučit."
                ],
                learningGoal: "Splň Úroveň Test 2", habitTip: "Zachovej klid a piš rovnoměrně", descriptionOverride: "Úrovňový test 2"
            )
        ]
        return Stage(id: 2, name: "Rozšíření Horní Řady", themeName: "Hory", description: "Dosáhněte horní řady", iconName: "arrow.up.circle.fill", modules: [
            Module(id: "2.1", name: "Horní Mistrovství", description: "Tok horní řady", stageId: 2, order: 1, lessons: lessons)
        ])
    }

    // MARK: - Stage 3: Bottom Row & N-Grams (Czech - QWERTZ)
    private func generateCzechStage3() -> Stage {
        // QWERTZ: Bottom Left is Y, Top Left is Z.
        // Stage 3 teaches Bottom Row.
        let lessons1 = [
            createLesson(id: "cs.3.1.1", moduleId: "3.1", name: "Klávesy Y a X", order: 1, content: "yyy xxx yyy xxx yx xy ypsilon xylofon",
                         learningGoal: "Ovládni Klávesy Y a X", habitTip: "Drž prsty na základní řadě", descriptionOverride: "Procvič Klávesy Y a X"),
            createLesson(id: "cs.3.1.2", moduleId: "3.1", name: "Klávesy C a V", order: 2, content: "ccc vvv ccc vvv cv vc co ve",
                         learningGoal: "Ovládni Klávesy C a V", habitTip: "Drž prsty na základní řadě", descriptionOverride: "Procvič Klávesy C a V"),
            createLesson(id: "cs.3.1.3", moduleId: "3.1", name: "Klávesa B", order: 3, content: "bbb bbb bob bez bo byl",
                         learningGoal: "Ovládni Klávesa B", habitTip: "Drž prsty na základní řadě", descriptionOverride: "Procvič Klávesa B")
        ]
        let lessons2 = [
            createLesson(id: "cs.3.2.1", moduleId: "3.2", name: "Klávesy N a M", order: 1, content: "nnn mmm nnn mmm nm mn na ma",
                         learningGoal: "Ovládni Klávesy N a M", habitTip: "Drž prsty na základní řadě", descriptionOverride: "Procvič Klávesy N a M"),
            createLesson(id: "cs.3.2.2", moduleId: "3.2", name: "Čárka a Tečka", order: 2, content: ",,, ... ,,, ... ,. ., jeden, dva.",
                         learningGoal: "Ovládni Čárka a Tečka", habitTip: "Drž prsty na základní řadě", descriptionOverride: "Procvič Čárka a Tečka"),
            createLesson(id: "cs.3.2.3", moduleId: "3.2", name: "Lomítko", order: 3, content: "--- --- a/nebo ano/ne",
                         learningGoal: "Ovládni Lomítko", habitTip: "Drž prsty na základní řadě", descriptionOverride: "Procvič Lomítko")// CZ often uses dash or slash differently but keeping generic pattern
        ]
        let lessons3 = [
            createLesson(id: "cs.3.3.1", moduleId: "3.3", name: "Časté Páry: je, to", order: 1, content: "je je je to to to ve se do",
                         learningGoal: "Ovládni Časté Páry: je, to", habitTip: "Drž prsty na základní řadě", descriptionOverride: "Procvič Časté Páry: je, to"),
            createLesson(id: "cs.3.3.2", moduleId: "3.3", name: "Časté Páry: na, že", order: 2, content: "na na na že že že ale tak",
                         learningGoal: "Ovládni Časté Páry: na, že", habitTip: "Drž prsty na základní řadě", descriptionOverride: "Procvič Časté Páry: na, že"),
            createLesson(
                id: "cs.3.4.1", 
                moduleId: "3.4", 
                name: "Úroveň Test 3", 
                order: 1, 
                content: "rychlá hnědá liška skáče", 
                isGatekeeper: true,
                pool: [
                    "rychlá hnědá liška skáče přes líného psa. svět je krásný.",
                    "chci jíst dobré jídlo. pojďme zítra na pláž.",
                    "hudba hraje na večírku velmi nahlas. rád tančím s přáteli."
                ],
                learningGoal: "Splň Úroveň Test 3", habitTip: "Zachovej klid a piš rovnoměrně", descriptionOverride: "Úrovňový test 3"
            )
        ]
        
        let modules = [
            Module(id: "3.1", name: "Dolní Řada Vlevo", description: "Klávesy Y X C V B", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "Dolní Řada Vpravo", description: "Klávesy N M , . -", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "Časté N-Gramy", description: "Ovládněte páry písmen", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "Dolní Řada & Vzorce", themeName: "Řeka", description: "Dokončete abecedu", iconName: "arrow.down.circle.fill", modules: modules)
    }

    // MARK: - Stage 4: Word Mastery (Czech)
    private func generateCzechStage4() -> Stage {
        let lessons1 = [
            createLesson(id: "cs.4.1.1", moduleId: "4.1", name: "Častá Slova 1", order: 1, content: "a se v na že to je o s z",
                         learningGoal: "Ovládni Častá Slova 1", habitTip: "Přečti si slovo, pak ho napiš", descriptionOverride: "Procvič častá slova"),
            createLesson(id: "cs.4.1.2", moduleId: "4.1", name: "Častá Slova 2", order: 2, content: "do k ne pro za ale jako ve po",
                         learningGoal: "Ovládni Častá Slova 2", habitTip: "Přečti si slovo, pak ho napiš", descriptionOverride: "Procvič častá slova"),
            createLesson(id: "cs.4.1.3", moduleId: "4.1", name: "Častá Slova 3", order: 3, content: "co i když už tak od by jak u",
                         learningGoal: "Ovládni Častá Slova 3", habitTip: "Přečti si slovo, pak ho napiš", descriptionOverride: "Procvič častá slova")
        ]
        let lessons2 = [
            createLesson(id: "cs.4.2.1", moduleId: "4.2", name: "Dlouhá Slova 1", order: 1, content: "který nebo jeho také jsme",
                         learningGoal: "Ovládni Dlouhá Slova 1", habitTip: "Soustřeď se na přesnost před rychlostí", descriptionOverride: "Procvič dlouhá slova"),
            createLesson(id: "cs.4.2.2", moduleId: "4.2", name: "Dlouhá Slova 2", order: 2, content: "bude mezi bude jenž této",
                         learningGoal: "Ovládni Dlouhá Slova 2", habitTip: "Soustřeď se na přesnost před rychlostí", descriptionOverride: "Procvič dlouhá slova"),
            createLesson(id: "cs.4.2.3", moduleId: "4.2", name: "Dlouhá Slova 3", order: 3, content: "všechny jejich ještě pouze proto",
                         learningGoal: "Ovládni Dlouhá Slova 3", habitTip: "Soustřeď se na přesnost před rychlostí", descriptionOverride: "Procvič dlouhá slova")
        ]
        let lessons3 = [
            createLesson(id: "cs.4.3.1", moduleId: "4.3", name: "Sprint 30 Sekund", order: 1, content: "a se v na že to je o s z do k ne pro za",
                         learningGoal: "Ovládni Sprint 30 Sekund", habitTip: "Nedívej se na klávesnici!", descriptionOverride: "Sprint rychlosti"),
            createLesson(
                id: "cs.4.4.1", 
                moduleId: "4.4", 
                name: "Úroveň Test 4", 
                order: 1, 
                content: "první velká věc je učení", 
                isGatekeeper: true,
                pool: [
                    "první velká věc je učení používat svůj vlastní hlas.",
                    "přemýšlej o tom, kde jsi byl, když jsi začal tuto cestu.",
                    "studovat jejich místo vpravo malý zvuk mohl znovu dolů."
                ],
                learningGoal: "Splň Úroveň Test 4", habitTip: "Zachovej klid a piš rovnoměrně", descriptionOverride: "Úrovňový test 4"
            )
        ]
        
        let modules = [
            Module(id: "4.1", name: "Krátká Slova", description: "Top 30 slov", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "Střední Slova", description: "5+ písmen", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "Slovní Sprinty", description: "Budujte rychlost", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "Mistrovství Slov", themeName: "Knihovna", description: "Zvyšte svou rychlost", iconName: "text.word.spacing", modules: modules)
    }

    // MARK: - Stage 5: Sentence Fluency (Czech)
    private func generateCzechStage5() -> Stage {
        let lessons1 = [
            createLesson(id: "cs.5.1.1", moduleId: "5.1", name: "Jednoduché Věty", order: 1, content: "Pes štěká nahlas. Kočka spí.",
                         learningGoal: "Ovládni Jednoduché Věty", habitTip: "Přečti si slovo, pak ho napiš", descriptionOverride: "Procvič jednoduché věty"),
            createLesson(id: "cs.5.1.2", moduleId: "5.1", name: "Otázky", order: 2, content: "Jak se máš dnes? Kolik je hodin?",
                         learningGoal: "Ovládni Otázky", habitTip: "Zachovej klid a piš rovnoměrně", descriptionOverride: "Practice questions"),
            createLesson(id: "cs.5.1.3", moduleId: "5.1", name: "Příkazy", order: 3, content: "Zavři dveře prosím. Rozsviť světlo.",
                         learningGoal: "Ovládni Příkazy", habitTip: "Zachovej klid a piš rovnoměrně", descriptionOverride: "Practice commands")
        ]
        let lessons2 = [
            createLesson(id: "cs.5.2.1", moduleId: "5.2", name: "Složené Věty", order: 1, content: "Šel jsem do obchodu a koupil chléb.",
                         learningGoal: "Ovládni Složené Věty", habitTip: "Zachovej klid a piš rovnoměrně", descriptionOverride: "Practice compound sentences"),
            createLesson(id: "cs.5.2.2", moduleId: "5.2", name: "Komplexní Myšlenky", order: 2, content: "Ačkoliv pršelo, rozhodli jsme se jít ven.",
                         learningGoal: "Ovládni Komplexní Myšlenky", habitTip: "Zachovej klid a piš rovnoměrně", descriptionOverride: "Practice complex sentences")
        ]
        let lessons3 = [
            createLesson(
                id: "cs.5.4.1", 
                moduleId: "5.4", 
                name: "Úroveň Test 5", 
                order: 1, 
                content: "TypeQuest je nejlepší způsob jak se učit.", 
                isGatekeeper: true,
                pool: [
                    "TypeQuest je nejlepší způsob, jak se naučit psát. S denní praxí se budeš zlepšovat.",
                    "Příliš žluťoučký kůň úpěl ďábelské ódy. Známá věta.",
                    "Čtení a psaní jsou základy digitální komunikace. Ovládni klávesnici dnes."
                ],
                learningGoal: "Splň Úroveň Test 5", habitTip: "Zachovej klid a piš rovnoměrně", descriptionOverride: "Úrovňový test 5"
            )
        ]
        
        let modules = [
            Module(id: "5.1", name: "Jednoduché Věty", description: "Základní tok", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "Složené Věty", description: "Propojené myšlenky", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "Cvičení Odstavců", description: "Tok více vět", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "Plynulost Vět", themeName: "Oceán", description: "Pište s rytmem", iconName: "text.alignleft", modules: modules)
    }

    // MARK: - Stage 6: Numbers & Symbols (Czech)
    private func generateCzechStage6() -> Stage {
        let lessons1 = [
            createLesson(id: "cs.6.1.1", moduleId: "6.1", name: "Klávesy 1 a 2", order: 1, content: "111 222 111 222 12 21 12 21",
                         learningGoal: "Ovládni Klávesy 1 a 2", habitTip: "Drž prsty na základní řadě", descriptionOverride: "Procvič Klávesy 1 a 2"),
            createLesson(id: "cs.6.1.2", moduleId: "6.1", name: "Klávesy 3 a 4", order: 2, content: "333 444 333 444 34 43 34 43",
                         learningGoal: "Ovládni Klávesy 3 a 4", habitTip: "Drž prsty na základní řadě", descriptionOverride: "Procvič Klávesy 3 a 4"),
            createLesson(id: "cs.6.1.3", moduleId: "6.1", name: "Klávesy 5 a 6", order: 3, content: "555 666 555 666 56 65 56 65",
                         learningGoal: "Ovládni Klávesy 5 a 6", habitTip: "Drž prsty na základní řadě", descriptionOverride: "Procvič Klávesy 5 a 6"),
            createLesson(id: "cs.6.1.4", moduleId: "6.1", name: "Klávesy 7 a 8", order: 4, content: "777 888 777 888 78 87 78 87",
                         learningGoal: "Ovládni Klávesy 7 a 8", habitTip: "Drž prsty na základní řadě", descriptionOverride: "Procvič Klávesy 7 a 8"),
            createLesson(id: "cs.6.1.5", moduleId: "6.1", name: "Klávesy 9 a 0", order: 5, content: "999 000 999 000 90 09 90 09",
                         learningGoal: "Ovládni Klávesy 9 a 0", habitTip: "Drž prsty na základní řadě", descriptionOverride: "Procvič Klávesy 9 a 0")
        ]
        // Czech top row (unshifted) is + ě š č ř ž ý á í é
        // Numbers are SHIFTED usually. But English curriculum teaches numbers as primary.
        // We will keep numbers as "Numbers" drill.
        
        let lessons2 = [
            createLesson(id: "cs.6.2.1", moduleId: "6.2", name: "ě š č ř", order: 1, content: "ěěě ššš ččč řřř",
                         learningGoal: "Ovládni ě š č ř", habitTip: "Drž prsty na základní řadě", descriptionOverride: "Procvič ě š č ř"),
            createLesson(id: "cs.6.2.2", moduleId: "6.2", name: "ž ý á í", order: 2, content: "žžž ýýý ááá ííí",
                         learningGoal: "Ovládni ž ý á í", habitTip: "Drž prsty na základní řadě", descriptionOverride: "Procvič ž ý á í"),
            createLesson(id: "cs.6.2.3", moduleId: "6.2", name: "é = ´ )", order: 3, content: "ééé === ´´´ )))",
                         learningGoal: "Ovládni é = ´ )", habitTip: "Drž Shift malíčkem", descriptionOverride: "Procvič speciální znaky")
        ]
        let lessons3 = [
            createLesson(
                id: "cs.6.4.1", 
                moduleId: "6.4", 
                name: "Závěrečný Test", 
                order: 1, 
                content: "Gratulujeme! Dosáhli jste Etapy 6.", 
                isGatekeeper: true,
                pool: [
                    "Gratulujeme! Dosáhli jste Etapy 6. Pojďme vše ověřit: 123 + 456 = 579. Pravda? Ano!",
                    "Závěrečný projekt: (acc >= 98.0) && (wpm >= 50.0). Test dokončen: [OK].",
                    "Speciální znaky: ěščřžýáíé. Dokončili jste osnovy TypeQuest. Dobrá práce!"
                ],
                learningGoal: "Splň Závěrečný Test", habitTip: "Jsi skoro tam – soustřeď se!", descriptionOverride: "Závěrečný test celé klávesnice"
            )
        ]
        
        let modules = [
            Module(id: "6.1", name: "Číselná Řada", description: "Klávesy 0-9 (Shift)", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "Diakritika", description: "Háčky a čárky", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "Smíšená Praxe", description: "Vše kombinováno", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "Čísla & Symboly", themeName: "Laboratoř", description: "Ovládněte klávesnici", iconName: "number.circle.fill", modules: modules)
    }

    // MARK: - Swedish Curriculum
    private func generateSwedishStages() -> [Stage] {
        return [
            generateSwedishStage1(),
            generateSwedishStage2(),
            generateSwedishStage3(),
            generateSwedishStage4(),
            generateSwedishStage5(),
            generateSwedishStage6()
        ]
    }
    
    private func generateSwedishStage1() -> Stage {
        let lessons = [
            createLesson(id: "sv.1.1.1", moduleId: "1.1", name: "Tangenter A och S", order: 1, content: "aaa sss aaa sss as sa as sa",
                         learningGoal: "Bemästra Tangenter A och S", habitTip: "Håll fingrarna på hemraden", descriptionOverride: "Öva Tangenter A och S"),
            createLesson(
                id: "sv.1.4.1", 
                moduleId: "1.4", 
                name: "Nivå-Test 1", 
                order: 2, 
                content: "asdf jkl; sallad alla sal", 
                isGatekeeper: true,
                pool: [
                    "asdf jkl; sallad alla sal. sal alla sallad. salla sal alla.",
                    "sallad alla sala. asdf jkl; salla sal alla. alla sal alla salla.",
                    "alla sallad sala. asdf jkl; salla alla sal. alla salla alla sal."
                ],
                learningGoal: "Klara Nivå-Test 1", habitTip: "Var lugn och skriv jämnt", descriptionOverride: "Nivåtest 1"
            )
        ]
        return Stage(id: 1, name: "Grundradens Grunder", themeName: "Skog", description: "Bemästra den mellersta raden", iconName: "hand.raised.fill", modules: [
            Module(id: "1.1", name: "Vänsterankare", description: "Vänsterhands position", stageId: 1, order: 1, lessons: lessons)
        ])
    }
    
    private func generateSwedishStage2() -> Stage {
        let lessons = [
            createLesson(
                id: "sv.2.4.1", 
                moduleId: "2.4", 
                name: "Nivå-Test 2", 
                order: 1, 
                content: "flygande bäckasiner söka", 
                isGatekeeper: true,
                pool: [
                    "flygande bäckasiner söka vilo-platser. världen är liten när du skriver snabbt.",
                    "skrivande är en prioritet för framgång. vägen är lång men resultatet är unikt.",
                    "jag vill kunna skriva med precision och snabbhet. alla ungdomar kan lära sig idag."
                ],
                learningGoal: "Klara Nivå-Test 2", habitTip: "Var lugn och skriv jämnt", descriptionOverride: "Nivåtest 2"
            )
        ]
        return Stage(id: 2, name: "Utökning Övre Raden", themeName: "Fjäll", description: "Nå den övre raden", iconName: "arrow.up.circle.fill", modules: [
            Module(id: "2.1", name: "Övre Raden Mästerskap", description: "Flyt i den övre raden", stageId: 2, order: 1, lessons: lessons)
        ])
    }



    // MARK: - Stage 3: Bottom Row & N-Grams (Swedish)
    private func generateSwedishStage3() -> Stage {
        let lessons1 = [
            createLesson(id: "sv.3.1.1", moduleId: "3.1", name: "Tangenter Z och X", order: 1, content: "zzz xxx zzz xxx zx xz zon yxa",
                         learningGoal: "Bemästra Tangenter Z och X", habitTip: "Håll fingrarna på hemraden", descriptionOverride: "Öva Tangenter Z och X"),
            createLesson(id: "sv.3.1.2", moduleId: "3.1", name: "Tangenter C och V", order: 2, content: "ccc vvv ccc vvv cv vc cykel vit",
                         learningGoal: "Bemästra Tangenter C och V", habitTip: "Håll fingrarna på hemraden", descriptionOverride: "Öva Tangenter C och V"),
            createLesson(id: "sv.3.1.3", moduleId: "3.1", name: "Tangent B", order: 3, content: "bbb bbb bob bra be byta",
                         learningGoal: "Bemästra Tangent B", habitTip: "Håll fingrarna på hemraden", descriptionOverride: "Öva Tangent B")
        ]
        let lessons2 = [
            createLesson(id: "sv.3.2.1", moduleId: "3.2", name: "Tangenter N och M", order: 1, content: "nnn mmm nnn mmm nm mn namn man",
                         learningGoal: "Bemästra Tangenter N och M", habitTip: "Håll fingrarna på hemraden", descriptionOverride: "Öva Tangenter N och M"),
            createLesson(id: "sv.3.2.2", moduleId: "3.2", name: "Komma och Punkt", order: 2, content: ",,, ... ,,, ... ,. ., en, två.",
                         learningGoal: "Bemästra Komma och Punkt", habitTip: "Håll fingrarna på hemraden", descriptionOverride: "Öva Komma och Punkt"),
            createLesson(id: "sv.3.2.3", moduleId: "3.2", name: "Tangent Snedstreck", order: 3, content: "--- --- och/eller ja/nej",
                         learningGoal: "Bemästra Tangent Snedstreck", habitTip: "Håll fingrarna på hemraden", descriptionOverride: "Öva Tangent Snedstreck")// Swedish layout usually has dash near shift or period
        ]
        let lessons3 = [
            createLesson(id: "sv.3.3.1", moduleId: "3.3", name: "Vanliga Par: en, et", order: 1, content: "en en en et et et er el es",
                         learningGoal: "Bemästra Vanliga Par: en, et", habitTip: "Var lugn och skriv jämnt", descriptionOverride: "Practice pairs"),
            createLesson(id: "sv.3.3.2", moduleId: "3.3", name: "Vanliga Par: de, at", order: 2, content: "de de de at at at om och",
                         learningGoal: "Bemästra Vanliga Par: de, at", habitTip: "Var lugn och skriv jämnt", descriptionOverride: "Practice pairs"),
            createLesson(
                id: "sv.3.4.1", 
                moduleId: "3.4", 
                name: "Nivå-Test 3", 
                order: 1, 
                content: "en snabb brun räv hoppar", 
                isGatekeeper: true,
                pool: [
                    "en snabb brun räv hoppar över den lata hunden. världen är liten.",
                    "jag vill äta ett gott äpple. låt oss gå till stranden imorgon.",
                    "musiken är mycket hög på festen. jag gillar att dansa med vänner."
                ],
                learningGoal: "Klara Nivå-Test 3", habitTip: "Var lugn och skriv jämnt", descriptionOverride: "Nivåtest 3"
            )
        ]
        
        let modules = [
            Module(id: "3.1", name: "Nedre Raden Vänster", description: "Tangenter Z X C V B", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "Nedre Raden Höger", description: "Tangenter N M , . -", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "Vanliga N-Gram", description: "Bemästra bokstavspar", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "Nedre Raden & Mönster", themeName: "Älv", description: "Komplettera alfabetet", iconName: "arrow.down.circle.fill", modules: modules)
    }

    // MARK: - Stage 4: Word Mastery (Swedish)
    private func generateSwedishStage4() -> Stage {
        let lessons1 = [
            createLesson(id: "sv.4.1.1", moduleId: "4.1", name: "Vanliga Ord 1", order: 1, content: "en och att det som i på är av med",
                         learningGoal: "Bemästra Vanliga Ord 1", habitTip: "Läs ordet först, skriv det sedan", descriptionOverride: "Öva vanliga ord"),
            createLesson(id: "sv.4.1.2", moduleId: "4.1", name: "Vanliga Ord 2", order: 2, content: "för den inte till de har om ett jag vi",
                         learningGoal: "Bemästra Vanliga Ord 2", habitTip: "Läs ordet först, skriv det sedan", descriptionOverride: "Öva vanliga ord"),
            createLesson(id: "sv.4.1.3", moduleId: "4.1", name: "Vanliga Ord 3", order: 3, content: "man var men sig från så kan han när vid",
                         learningGoal: "Bemästra Vanliga Ord 3", habitTip: "Läs ordet först, skriv det sedan", descriptionOverride: "Öva vanliga ord")
        ]
        let lessons2 = [
            createLesson(id: "sv.4.2.1", moduleId: "4.2", name: "Långa Ord 1", order: 1, content: "eller under skulle kunna andra",
                         learningGoal: "Bemästra Långa Ord 1", habitTip: "Fokusera på precision före hastighet", descriptionOverride: "Öva långa ord"),
            createLesson(id: "sv.4.2.2", moduleId: "4.2", name: "Långa Ord 2", order: 2, content: "kommer finns mycket denna själv",
                         learningGoal: "Bemästra Långa Ord 2", habitTip: "Fokusera på precision före hastighet", descriptionOverride: "Öva långa ord"),
            createLesson(id: "sv.4.2.3", moduleId: "4.2", name: "Långa Ord 3", order: 3, content: "någon mellan sedan också genom",
                         learningGoal: "Bemästra Långa Ord 3", habitTip: "Fokusera på precision före hastighet", descriptionOverride: "Öva långa ord")
        ]
        let lessons3 = [
            createLesson(id: "sv.4.3.1", moduleId: "4.3", name: "Sprint 30 Sekunder", order: 1, content: "en och att det som i på är av med för den inte",
                         learningGoal: "Bemästra Sprint 30 Sekunder", habitTip: "Titta inte på tangentbordet!", descriptionOverride: "Hastighetssprint"),
            createLesson(
                id: "sv.4.4.1", 
                moduleId: "4.4", 
                name: "Nivå-Test 4", 
                order: 1, 
                content: "den första stora saken är att lära", 
                isGatekeeper: true,
                pool: [
                    "den första stora saken är att lära sig att använda din egen röst igen.",
                    "tänk på var du var när du började denna resa.",
                    "studera deras plats höger liten ljud kunde igen ner."
                ],
                learningGoal: "Klara Nivå-Test 4", habitTip: "Var lugn och skriv jämnt", descriptionOverride: "Nivåtest 4"
            )
        ]
        
        let modules = [
            Module(id: "4.1", name: "Korta Ord", description: "Topp 30 ord", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "Medellånga Ord", description: "5+ bokstäver", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "Ord-Sprints", description: "Bygg hastighet", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "Ord Mästare", themeName: "Bibliotek", description: "Öka din hastighet", iconName: "text.word.spacing", modules: modules)
    }

    // MARK: - Stage 5: Sentence Fluency (Swedish)
    private func generateSwedishStage5() -> Stage {
        let lessons1 = [
            createLesson(id: "sv.5.1.1", moduleId: "5.1", name: "Enkla Meningar", order: 1, content: "Hunden skäller högt. Katten sover.",
                         learningGoal: "Bemästra Enkla Meningar", habitTip: "Läs ordet först, skriv det sedan", descriptionOverride: "Öva enkla meningar"),
            createLesson(id: "sv.5.1.2", moduleId: "5.1", name: "Frågor", order: 2, content: "Hur mår du idag? Vad är klockan?",
                         learningGoal: "Bemästra Frågor", habitTip: "Var lugn och skriv jämnt", descriptionOverride: "Practice questions"),
            createLesson(id: "sv.5.1.3", moduleId: "5.1", name: "Kommandon", order: 3, content: "Stäng dörren snälla. Tänd ljuset.",
                         learningGoal: "Bemästra Kommandon", habitTip: "Läs ordet först, skriv det sedan", descriptionOverride: "Öva enkla meningar")
        ]
        let lessons2 = [
            createLesson(id: "sv.5.2.1", moduleId: "5.2", name: "Sammansatta Meningar", order: 1, content: "Jag gick till affären och köpte bröd.",
                         learningGoal: "Bemästra Sammansatta Meningar", habitTip: "Var lugn och skriv jämnt", descriptionOverride: "Practice compound sentences"),
            createLesson(id: "sv.5.2.2", moduleId: "5.2", name: "Komplexa Idéer", order: 2, content: "Även om det regnade, bestämde vi oss för att gå ut.",
                         learningGoal: "Bemästra Komplexa Idéer", habitTip: "Var lugn och skriv jämnt", descriptionOverride: "Practice complex sentences")
        ]
        let lessons3 = [
            createLesson(
                id: "sv.5.4.1", 
                moduleId: "5.4", 
                name: "Nivå-Test 5", 
                order: 1, 
                content: "TypeQuest är det bästa sättet att lära sig.", 
                isGatekeeper: true,
                pool: [
                    "TypeQuest är det bästa sättet att lära sig skriva. Med daglig övning blir du bättre.",
                    "Den snabba bruna räven hoppar över den lata hunden. En känd mening.",
                    "Att läsa och skriva är grunden för digital kommunikation. Bemästra tangentbordet idag."
                ],
                learningGoal: "Klara Nivå-Test 5", habitTip: "Var lugn och skriv jämnt", descriptionOverride: "Nivåtest 5"
            )
        ]
        
        let modules = [
            Module(id: "5.1", name: "Enkla Meningar", description: "Grundläggande flyt", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "Sammansatta Meningar", description: "Kopplade idéer", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "Styckeövning", description: "Många meningar", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "Meningsflyt", themeName: "Hav", description: "Skriv med rytm", iconName: "text.alignleft", modules: modules)
    }

    // MARK: - Stage 6: Numbers & Symbols (Swedish)
    private func generateSwedishStage6() -> Stage {
        let lessons1 = [
            createLesson(id: "sv.6.1.1", moduleId: "6.1", name: "Tangenter 1 och 2", order: 1, content: "111 222 111 222 12 21 12 21",
                         learningGoal: "Bemästra Tangenter 1 och 2", habitTip: "Håll fingrarna på hemraden", descriptionOverride: "Öva Tangenter 1 och 2"),
            createLesson(id: "sv.6.1.2", moduleId: "6.1", name: "Tangenter 3 och 4", order: 2, content: "333 444 333 444 34 43 34 43",
                         learningGoal: "Bemästra Tangenter 3 och 4", habitTip: "Håll fingrarna på hemraden", descriptionOverride: "Öva Tangenter 3 och 4"),
            createLesson(id: "sv.6.1.3", moduleId: "6.1", name: "Tangenter 5 och 6", order: 3, content: "555 666 555 666 56 65 56 65",
                         learningGoal: "Bemästra Tangenter 5 och 6", habitTip: "Håll fingrarna på hemraden", descriptionOverride: "Öva Tangenter 5 och 6"),
            createLesson(id: "sv.6.1.4", moduleId: "6.1", name: "Tangenter 7 och 8", order: 4, content: "777 888 777 888 78 87 78 87",
                         learningGoal: "Bemästra Tangenter 7 och 8", habitTip: "Håll fingrarna på hemraden", descriptionOverride: "Öva Tangenter 7 och 8"),
            createLesson(id: "sv.6.1.5", moduleId: "6.1", name: "Tangenter 9 och 0", order: 5, content: "999 000 999 000 90 09 90 09",
                         learningGoal: "Bemästra Tangenter 9 och 0", habitTip: "Håll fingrarna på hemraden", descriptionOverride: "Öva Tangenter 9 och 0")
        ]
        let lessons2 = [
            createLesson(id: "sv.6.2.1", moduleId: "6.2", name: "! \" # $", order: 1, content: "!!! \"\"\" ### $$$ !\"#$",
                         learningGoal: "Bemästra ! \" ", habitTip: "Håll Shift med lillfingret", descriptionOverride: "Öva specialtecken"),
            createLesson(id: "sv.6.2.2", moduleId: "6.2", name: "% & / ( )", order: 2, content: "%%% &&& /// ((( )))",
                         learningGoal: "Bemästra % & / ( )", habitTip: "Håll Shift med lillfingret", descriptionOverride: "Öva specialtecken"),
            createLesson(id: "sv.6.2.3", moduleId: "6.2", name: "= ? + *", order: 3, content: "=== ??? +++ *** +?*",
                         learningGoal: "Bemästra = ? + *", habitTip: "Håll Shift med lillfingret", descriptionOverride: "Öva specialtecken")
        ]
        let lessons3 = [
            createLesson(
                id: "sv.6.4.1", 
                moduleId: "6.4", 
                name: "Slutprov", 
                order: 1, 
                content: "Grattis! Du har nått Etapp 6.", 
                isGatekeeper: true,
                pool: [
                    "Grattis! Du har nått Etapp 6. Låt oss verifiera allt: 123 + 456 = 579. Sant? Ja!",
                    "Slutprojekt: (acc >= 98.0) && (wpm >= 50.0). Test slutfört: [OK].",
                    "Specialtecken: !\"#%&/()=?+. Du har slutfört TypeQuest-läroplanen. Bra jobbat!"
                ],
                learningGoal: "Klara Slutprov", habitTip: "Du är nästan där – håll fokus!", descriptionOverride: "Sluttest av hela tangentbordet"
            )
        ]
        
        let modules = [
            Module(id: "6.1", name: "Sifferraden", description: "Tangenter 0-9", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "Vanliga Symboler", description: "Specialtecken", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "Blandad Övning", description: "Allt kombinerat", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "Siffror & Symboler", themeName: "Laboratorium", description: "Bemästra tangentbordet", iconName: "number.circle.fill", modules: modules)
    }

    // MARK: - Norwegian Curriculum
    private func generateNorwegianStages() -> [Stage] {
        return [
            generateNorwegianStage1(),
            generateNorwegianStage2(),
            generateNorwegianStage3(),
            generateNorwegianStage4(),
            generateNorwegianStage5(),
            generateNorwegianStage6()
        ]
    }
    
    private func generateNorwegianStage1() -> Stage {
        let lessons = [
            createLesson(id: "no.1.1.1", moduleId: "1.1", name: "Taster A og S", order: 1, content: "aaa sss aaa sss as sa as sa",
                         learningGoal: "Mestre Taster A og S", habitTip: "Hold fingrene på hjemraden", descriptionOverride: "Øv Taster A og S"),
            createLesson(
                id: "no.1.4.1", 
                moduleId: "1.4", 
                name: "Nivå-Test 1", 
                order: 2, 
                content: "asdf jkl; salat alle sal", 
                isGatekeeper: true,
                pool: [
                    "asdf jkl; salat alle sal. sal alle salat. salle sal alle.",
                    "salat alle sala. asdf jkl; salle sal alle. alle sal alle salle.",
                    "alle salat sala. asdf jkl; salle alle sal. alle salle alle sal."
                ],
                learningGoal: "Bestå Nivå-Test 1", habitTip: "Vær rolig og skriv jevnt", descriptionOverride: "Nivåtest 1"
            )
        ]
        return Stage(id: 1, name: "Grunnradens Grunnlag", themeName: "Skog", description: "Mestre den midterste raden", iconName: "hand.raised.fill", modules: [
            Module(id: "1.1", name: "Venstreankere", description: "Venstrehåndens posisjon", stageId: 1, order: 1, lessons: lessons)
        ])
    }
    
    private func generateNorwegianStage2() -> Stage {
        let lessons = [
            createLesson(
                id: "no.2.4.1", 
                moduleId: "2.4", 
                name: "Nivå-Test 2", 
                order: 1, 
                content: "vår særpregede lynhurtige rev", 
                isGatekeeper: true,
                pool: [
                    "vår særpregede lynhurtige rev rømte over fjell i natt. verden er liten når du skriver raskt.",
                    "skriving er en prioritet for suksess. veien er lang, men resultatet er unikt.",
                    "jeg vil kunne skrive med presisjon og hurtighet. alle unge kan lære i dag."
                ],
                learningGoal: "Bestå Nivå-Test 2", habitTip: "Vær rolig og skriv jevnt", descriptionOverride: "Nivåtest 2"
            )
        ]
        return Stage(id: 2, name: "Utvidelse Øvre Rad", themeName: "Fjell", description: "Nå den øvre raden", iconName: "arrow.up.circle.fill", modules: [
            Module(id: "2.1", name: "Øvre Rad Mestring", description: "Flyt i den øvre raden", stageId: 2, order: 1, lessons: lessons)
        ])
    }



    // MARK: - Stage 3: Bottom Row & N-Grams (Norwegian)
    private func generateNorwegianStage3() -> Stage {
        let lessons1 = [
            createLesson(id: "no.3.1.1", moduleId: "3.1", name: "Taster Z og X", order: 1, content: "zzz xxx zzz xxx zx xz zone xylofon",
                         learningGoal: "Mestre Taster Z og X", habitTip: "Hold fingrene på hjemraden", descriptionOverride: "Øv Taster Z og X"),
            createLesson(id: "no.3.1.2", moduleId: "3.1", name: "Taster C og V", order: 2, content: "ccc vvv ccc vvv cv vc celle vi",
                         learningGoal: "Mestre Taster C og V", habitTip: "Hold fingrene på hjemraden", descriptionOverride: "Øv Taster C og V"),
            createLesson(id: "no.3.1.3", moduleId: "3.1", name: "Tast B", order: 3, content: "bbb bbb bob bra bo by",
                         learningGoal: "Mestre Tast B", habitTip: "Hold fingrene på hjemraden", descriptionOverride: "Øv Tast B")
        ]
        let lessons2 = [
            createLesson(id: "no.3.2.1", moduleId: "3.2", name: "Taster N og M", order: 1, content: "nnn mmm nnn mmm nm mn navn mann",
                         learningGoal: "Mestre Taster N og M", habitTip: "Hold fingrene på hjemraden", descriptionOverride: "Øv Taster N og M"),
            createLesson(id: "no.3.2.2", moduleId: "3.2", name: "Komma og Punktum", order: 2, content: ",,, ... ,,, ... ,. ., en, to.",
                         learningGoal: "Mestre Komma og Punktum", habitTip: "Hold fingrene på hjemraden", descriptionOverride: "Øv Komma og Punktum"),
            createLesson(id: "no.3.2.3", moduleId: "3.2", name: "Tast Skråstrek", order: 3, content: "--- --- og/eller ja/nei",
                         learningGoal: "Mestre Tast Skråstrek", habitTip: "Hold fingrene på hjemraden", descriptionOverride: "Øv Tast Skråstrek")
        ]
        let lessons3 = [
            createLesson(id: "no.3.3.1", moduleId: "3.3", name: "Vanlige Par: en, et", order: 1, content: "en en en et et et er el es",
                         learningGoal: "Mestre Vanlige Par: en, et", habitTip: "Vær rolig og skriv jevnt", descriptionOverride: "Practice pairs"),
            createLesson(id: "no.3.3.2", moduleId: "3.3", name: "Vanlige Par: de, at", order: 2, content: "de de de at at at om og",
                         learningGoal: "Mestre Vanlige Par: de, at", habitTip: "Vær rolig og skriv jevnt", descriptionOverride: "Practice pairs"),
            createLesson(
                id: "no.3.4.1", 
                moduleId: "3.4", 
                name: "Nivå-Test 3", 
                order: 1, 
                content: "en rask brun rev hopper", 
                isGatekeeper: true,
                pool: [
                    "en rask brun rev hopper over den late hunden. verden er liten.",
                    "jeg vil spise et godt eple. la oss gå til stranden i morgen.",
                    "musikken er veldig høy på festen. jeg liker å danse med venner."
                ],
                learningGoal: "Bestå Nivå-Test 3", habitTip: "Vær rolig og skriv jevnt", descriptionOverride: "Nivåtest 3"
            )
        ]
        
        let modules = [
            Module(id: "3.1", name: "Nedre Rad Venstre", description: "Taster Z X C V B", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "Nedre Rad Høyre", description: "Taster N M , . -", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "Vanlige N-Gram", description: "Mestre bokstavpar", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "Nedre Rad & Mønster", themeName: "Elv", description: "Fullfør alfabetet", iconName: "arrow.down.circle.fill", modules: modules)
    }

    // MARK: - Stage 4: Word Mastery (Norwegian)
    private func generateNorwegianStage4() -> Stage {
        let lessons1 = [
            createLesson(id: "no.4.1.1", moduleId: "4.1", name: "Vanlige Ord 1", order: 1, content: "og i det som til en av for på at",
                         learningGoal: "Mestre Vanlige Ord 1", habitTip: "Les ordet først, skriv det etterpå", descriptionOverride: "Øv vanlige ord"),
            createLesson(id: "no.4.1.2", moduleId: "4.1", name: "Vanlige Ord 2", order: 2, content: "å med de har den ikke er om et jeg",
                         learningGoal: "Mestre Vanlige Ord 2", habitTip: "Les ordet først, skriv det etterpå", descriptionOverride: "Øv vanlige ord"),
            createLesson(id: "no.4.1.3", moduleId: "4.1", name: "Vanlige Ord 3", order: 3, content: "vi men så var seg han fra vil skal",
                         learningGoal: "Mestre Vanlige Ord 3", habitTip: "Les ordet først, skriv det etterpå", descriptionOverride: "Øv vanlige ord")
        ]
        let lessons2 = [
            createLesson(id: "no.4.2.1", moduleId: "4.2", name: "Lange Ord 1", order: 1, content: "eller under dette kunne etter",
                         learningGoal: "Mestre Lange Ord 1", habitTip: "Fokuser på presisjon før hastighet", descriptionOverride: "Øv lange ord"),
            createLesson(id: "no.4.2.2", moduleId: "4.2", name: "Lange Ord 2", order: 2, content: "kommer over meget denne selv",
                         learningGoal: "Mestre Lange Ord 2", habitTip: "Fokuser på presisjon før hastighet", descriptionOverride: "Øv lange ord"),
            createLesson(id: "no.4.2.3", moduleId: "4.2", name: "Lange Ord 3", order: 3, content: "noen mellom siden også gjennom",
                         learningGoal: "Mestre Lange Ord 3", habitTip: "Fokuser på presisjon før hastighet", descriptionOverride: "Øv lange ord")
        ]
        let lessons3 = [
            createLesson(id: "no.4.3.1", moduleId: "4.3", name: "Sprint 30 Sekunder", order: 1, content: "og i det som til en av for på at å med",
                         learningGoal: "Mestre Sprint 30 Sekunder", habitTip: "Ikke se på tastaturet!", descriptionOverride: "Hastighetssprint"),
            createLesson(
                id: "no.4.4.1", 
                moduleId: "4.4", 
                name: "Nivå-Test 4", 
                order: 1, 
                content: "den første store tingen er læring", 
                isGatekeeper: true,
                pool: [
                    "den første store tingen er læring for å bruke din egen stemme igjen.",
                    "tenk på hvor du var da du startet denne reisen.",
                    "studere deres plass høyre liten lyd kunne igjen ned."
                ],
                learningGoal: "Bestå Nivå-Test 4", habitTip: "Vær rolig og skriv jevnt", descriptionOverride: "Nivåtest 4"
            )
        ]
        
        let modules = [
            Module(id: "4.1", name: "Korte Ord", description: "Topp 30 ord", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "Middels Ord", description: "5+ bokstaver", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "Ord-Sprints", description: "Bygg hurtighet", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "Ord Mestring", themeName: "Bibliotek", description: "Øk hastigheten din", iconName: "text.word.spacing", modules: modules)
    }

    // MARK: - Stage 5: Sentence Fluency (Norwegian)
    private func generateNorwegianStage5() -> Stage {
        let lessons1 = [
            createLesson(id: "no.5.1.1", moduleId: "5.1", name: "Enkle Setninger", order: 1, content: "Hunden bjeffer høyt. Katten sover.",
                         learningGoal: "Mestre Enkle Setninger", habitTip: "Les ordet først, skriv det etterpå", descriptionOverride: "Øv enkle setninger"),
            createLesson(id: "no.5.1.2", moduleId: "5.1", name: "Spørsmål", order: 2, content: "Hvordan går det i dag? Hva er klokken?",
                         learningGoal: "Mestre Spørsmål", habitTip: "Vær rolig og skriv jevnt", descriptionOverride: "Practice questions"),
            createLesson(id: "no.5.1.3", moduleId: "5.1", name: "Kommandoer", order: 3, content: "Lukk døren vær så snill. Slå på lyset.",
                         learningGoal: "Mestre Kommandoer", habitTip: "Les ordet først, skriv det etterpå", descriptionOverride: "Øv enkle setninger")
        ]
        let lessons2 = [
            createLesson(id: "no.5.2.1", moduleId: "5.2", name: "Sammensatte Setninger", order: 1, content: "Jeg gikk til butikken og kjøpte brød.",
                         learningGoal: "Mestre Sammensatte Setninger", habitTip: "Vær rolig og skriv jevnt", descriptionOverride: "Practice compound sentences"),
            createLesson(id: "no.5.2.2", moduleId: "5.2", name: "Komplekse Ideer", order: 2, content: "Selv om det regnet, bestemte vi oss for å gå ut.",
                         learningGoal: "Mestre Komplekse Ideer", habitTip: "Vær rolig og skriv jevnt", descriptionOverride: "Practice complex sentences")
        ]
        let lessons3 = [
            createLesson(
                id: "no.5.4.1", 
                moduleId: "5.4", 
                name: "Nivå-Test 5", 
                order: 1, 
                content: "TypeQuest er den beste måten å lære.", 
                isGatekeeper: true,
                pool: [
                    "TypeQuest er den beste måten å lære å skrive. Med daglig øving blir du bedre.",
                    "Den raske brune reven hopper over den late hunden. En kjent setning.",
                    "Å lese og skrive er grunnlaget for digital kommunikasjon. Mestre tastaturet i dag."
                ],
                learningGoal: "Bestå Nivå-Test 5", habitTip: "Vær rolig og skriv jevnt", descriptionOverride: "Nivåtest 5"
            )
        ]
        
        let modules = [
            Module(id: "5.1", name: "Enkle Setninger", description: "Grunnleggende flyt", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "Sammensatte Setninger", description: "Koblede ideer", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "Avsnittsøving", description: "Fler-setnings flyt", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "Setningsflyt", themeName: "Hav", description: "Skriv med rytme", iconName: "text.alignleft", modules: modules)
    }

    // MARK: - Stage 6: Numbers & Symbols (Norwegian)
    private func generateNorwegianStage6() -> Stage {
        let lessons1 = [
            createLesson(id: "no.6.1.1", moduleId: "6.1", name: "Taster 1 og 2", order: 1, content: "111 222 111 222 12 21 12 21",
                         learningGoal: "Mestre Taster 1 og 2", habitTip: "Hold fingrene på hjemraden", descriptionOverride: "Øv Taster 1 og 2"),
            createLesson(id: "no.6.1.2", moduleId: "6.1", name: "Taster 3 og 4", order: 2, content: "333 444 333 444 34 43 34 43",
                         learningGoal: "Mestre Taster 3 og 4", habitTip: "Hold fingrene på hjemraden", descriptionOverride: "Øv Taster 3 og 4"),
            createLesson(id: "no.6.1.3", moduleId: "6.1", name: "Taster 5 og 6", order: 3, content: "555 666 555 666 56 65 56 65",
                         learningGoal: "Mestre Taster 5 og 6", habitTip: "Hold fingrene på hjemraden", descriptionOverride: "Øv Taster 5 og 6"),
            createLesson(id: "no.6.1.4", moduleId: "6.1", name: "Taster 7 og 8", order: 4, content: "777 888 777 888 78 87 78 87",
                         learningGoal: "Mestre Taster 7 og 8", habitTip: "Hold fingrene på hjemraden", descriptionOverride: "Øv Taster 7 og 8"),
            createLesson(id: "no.6.1.5", moduleId: "6.1", name: "Taster 9 og 0", order: 5, content: "999 000 999 000 90 09 90 09",
                         learningGoal: "Mestre Taster 9 og 0", habitTip: "Hold fingrene på hjemraden", descriptionOverride: "Øv Taster 9 og 0")
        ]
        let lessons2 = [
            createLesson(id: "no.6.2.1", moduleId: "6.2", name: "! \" # $", order: 1, content: "!!! \"\"\" ### $$$ !\"#$",
                         learningGoal: "Mestre ! \" ", habitTip: "Hold Shift med lillefingeren", descriptionOverride: "Øv spesialtegn"),
            createLesson(id: "no.6.2.2", moduleId: "6.2", name: "% & / ( )", order: 2, content: "%%% &&& /// ((( )))",
                         learningGoal: "Mestre % & / ( )", habitTip: "Hold Shift med lillefingeren", descriptionOverride: "Øv spesialtegn"),
            createLesson(id: "no.6.2.3", moduleId: "6.2", name: "= ? + *", order: 3, content: "=== ??? +++ *** +?*",
                         learningGoal: "Mestre = ? + *", habitTip: "Hold Shift med lillefingeren", descriptionOverride: "Øv spesialtegn")
        ]
        let lessons3 = [
            createLesson(
                id: "no.6.4.1", 
                moduleId: "6.4", 
                name: "Sluttprøve", 
                order: 1, 
                content: "Gratulerer! Du har nådd Etappe 6.", 
                isGatekeeper: true,
                pool: [
                    "Gratulerer! Du har nådd Etappe 6. La oss verifisere alt: 123 + 456 = 579. Sant? Ja!",
                    "Sluttprosjekt: (acc >= 98.0) && (wpm >= 50.0). Test fullført: [OK].",
                    "Spesialtegn: !\"#%&/()=?+. Du har fullført TypeQuest-pensumet. Bra jobba!"
                ],
                learningGoal: "Bestå Sluttprøve", habitTip: "Du er nesten der – hold fokus!", descriptionOverride: "Slutttest av hele tastaturet"
            )
        ]
        
        let modules = [
            Module(id: "6.1", name: "Tallrekke", description: "Taster 0-9", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "Vanlige Symboler", description: "Spesialtegn", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "Blandet Øving", description: "Alt kombinert", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "Tall & Symboler", themeName: "Laboratorium", description: "Mestre tastaturet", iconName: "number.circle.fill", modules: modules)
    }

    // MARK: - Danish Curriculum
    private func generateDanishStages() -> [Stage] {
        return [
            generateDanishStage1(),
            generateDanishStage2(),
            generateDanishStage3(),
            generateDanishStage4(),
            generateDanishStage5(),
            generateDanishStage6()
        ]
    }
    
    private func generateDanishStage1() -> Stage {
        let lessons = [
            createLesson(id: "da.1.1.1", moduleId: "1.1", name: "Taster A og S", order: 1, content: "aaa sss aaa sss as sa as sa",
                         learningGoal: "Mestre Taster A og S", habitTip: "Hold fingrene på hjemrækken", descriptionOverride: "Øv Taster A og S"),
            createLesson(
                id: "da.1.4.1", 
                moduleId: "1.4", 
                name: "Niveau-Test 1", 
                order: 2, 
                content: "asdf jkl; salat alle sal", 
                isGatekeeper: true,
                pool: [
                    "asdf jkl; salat alle sal. sal alle salat. salle sal alle.",
                    "salat alle sala. asdf jkl; salle sal alle. alle sal alle salle.",
                    "alle salat sala. asdf jkl; salle alle sal. alle salle alle sal."
                ],
                learningGoal: "Bestå Niveau-Test 1", habitTip: "Vær rolig og skriv jævnt", descriptionOverride: "Niveautest 1"
            )
        ]
        return Stage(id: 1, name: "Grundrække Fundament", themeName: "Skov", description: "Mestre den midterste række", iconName: "hand.raised.fill", modules: [
            Module(id: "1.1", name: "Venstreankre", description: "Venstrehånds position", stageId: 1, order: 1, lessons: lessons)
        ])
    }
    
    private func generateDanishStage2() -> Stage {
        let lessons = [
            createLesson(
                id: "da.2.4.1", 
                moduleId: "2.4", 
                name: "Niveau-Test 2", 
                order: 1, 
                content: "høj bly gom vandt fræk sexquiz", 
                isGatekeeper: true,
                pool: [
                    "høj bly gom vandt fræk sexquiz på wc. verden er lille, når du skriver hurtigt.",
                    "skrivning er en prioritet for succes. vejen er lang, men resultatet er unikt.",
                    "jeg vil kunne skrive med præcision og hurtighed. alle unge kan lære i dag."
                ],
                learningGoal: "Bestå Niveau-Test 2", habitTip: "Vær rolig og skriv jævnt", descriptionOverride: "Niveautest 2"
            )
        ]
        return Stage(id: 2, name: "Udvidelse Øvre Række", themeName: "Klitter", description: "Nå den øverste række", iconName: "arrow.up.circle.fill", modules: [
            Module(id: "2.1", name: "Øvre Række Mestring", description: "Flow i den øverste række", stageId: 2, order: 1, lessons: lessons)
        ])
    }



    // MARK: - Stage 3: Bottom Row & N-Grams (Danish)
    private func generateDanishStage3() -> Stage {
        let lessons1 = [
            createLesson(id: "da.3.1.1", moduleId: "3.1", name: "Taster Z og X", order: 1, content: "zzz xxx zzz xxx zx xz zone xylofon",
                         learningGoal: "Mestre Taster Z og X", habitTip: "Hold fingrene på hjemrækken", descriptionOverride: "Øv Taster Z og X"),
            createLesson(id: "da.3.1.2", moduleId: "3.1", name: "Taster C og V", order: 2, content: "ccc vvv ccc vvv cv vc celle vi",
                         learningGoal: "Mestre Taster C og V", habitTip: "Hold fingrene på hjemrækken", descriptionOverride: "Øv Taster C og V"),
            createLesson(id: "da.3.1.3", moduleId: "3.1", name: "Tast B", order: 3, content: "bbb bbb bob bra bo by",
                         learningGoal: "Mestre Tast B", habitTip: "Hold fingrene på hjemrækken", descriptionOverride: "Øv Tast B")
        ]
        let lessons2 = [
            createLesson(id: "da.3.2.1", moduleId: "3.2", name: "Taster N og M", order: 1, content: "nnn mmm nnn mmm nm mn navn mand",
                         learningGoal: "Mestre Taster N og M", habitTip: "Hold fingrene på hjemrækken", descriptionOverride: "Øv Taster N og M"),
            createLesson(id: "da.3.2.2", moduleId: "3.2", name: "Komma og Punktum", order: 2, content: ",,, ... ,,, ... ,. ., en, to.",
                         learningGoal: "Mestre Komma og Punktum", habitTip: "Hold fingrene på hjemrækken", descriptionOverride: "Øv Komma og Punktum"),
            createLesson(id: "da.3.2.3", moduleId: "3.2", name: "Tast Skråstreg", order: 3, content: "--- --- og/eller ja/nej",
                         learningGoal: "Mestre Tast Skråstreg", habitTip: "Hold fingrene på hjemrækken", descriptionOverride: "Øv Tast Skråstreg")
        ]
        let lessons3 = [
            createLesson(id: "da.3.3.1", moduleId: "3.3", name: "Almindelige Par: en, et", order: 1, content: "en en en et et et er el es",
                         learningGoal: "Mestre Almindelige Par: en, et", habitTip: "Vær rolig og skriv jævnt", descriptionOverride: "Practice pairs"),
            createLesson(id: "da.3.3.2", moduleId: "3.3", name: "Almindelige Par: de, at", order: 2, content: "de de de at at at om og",
                         learningGoal: "Mestre Almindelige Par: de, at", habitTip: "Vær rolig og skriv jævnt", descriptionOverride: "Practice pairs"),
            createLesson(
                id: "da.3.4.1", 
                moduleId: "3.4", 
                name: "Niveau-Test 3", 
                order: 1, 
                content: "en hurtig brun ræv hopper", 
                isGatekeeper: true,
                pool: [
                    "en hurtig brun ræv hopper over den dovne hund. verden er lille.",
                    "jeg vil spise et godt æble. lad os tage til stranden i morgen.",
                    "musikken er meget høj til festen. jeg kan lide at danse med venner."
                ],
                learningGoal: "Bestå Niveau-Test 3", habitTip: "Vær rolig og skriv jævnt", descriptionOverride: "Niveautest 3"
            )
        ]
        
        let modules = [
            Module(id: "3.1", name: "Nedre Række Venstre", description: "Taster Z X C V B", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "Nedre Række Højre", description: "Taster N M , . -", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "Almindelige N-Gram", description: "Mestre bogstavpar", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "Nedre Række & Mønstre", themeName: "Å", description: "Færdiggør alfabetet", iconName: "arrow.down.circle.fill", modules: modules)
    }

    // MARK: - Stage 4: Word Mastery (Danish)
    private func generateDanishStage4() -> Stage {
        let lessons1 = [
            createLesson(id: "da.4.1.1", moduleId: "4.1", name: "Almindelige Ord 1", order: 1, content: "og i det som til en af for på at",
                         learningGoal: "Mestre Almindelige Ord 1", habitTip: "Læs ordet først, skriv det bagefter", descriptionOverride: "Øv hyppige ord"),
            createLesson(id: "da.4.1.2", moduleId: "4.1", name: "Almindelige Ord 2", order: 2, content: "at med de har den ikke er om et jeg",
                         learningGoal: "Mestre Almindelige Ord 2", habitTip: "Læs ordet først, skriv det bagefter", descriptionOverride: "Øv hyppige ord"),
            createLesson(id: "da.4.1.3", moduleId: "4.1", name: "Almindelige Ord 3", order: 3, content: "vi men så var sig han fra vil skal",
                         learningGoal: "Mestre Almindelige Ord 3", habitTip: "Læs ordet først, skriv det bagefter", descriptionOverride: "Øv hyppige ord")
        ]
        let lessons2 = [
            createLesson(id: "da.4.2.1", moduleId: "4.2", name: "Lange Ord 1", order: 1, content: "eller under dette kunne efter",
                         learningGoal: "Mestre Lange Ord 1", habitTip: "Fokuser på præcision før hastighed", descriptionOverride: "Øv lange ord"),
            createLesson(id: "da.4.2.2", moduleId: "4.2", name: "Lange Ord 2", order: 2, content: "kommer over meget denne selv",
                         learningGoal: "Mestre Lange Ord 2", habitTip: "Fokuser på præcision før hastighed", descriptionOverride: "Øv lange ord"),
            createLesson(id: "da.4.2.3", moduleId: "4.2", name: "Lange Ord 3", order: 3, content: "nogen mellem siden også gennem",
                         learningGoal: "Mestre Lange Ord 3", habitTip: "Fokuser på præcision før hastighed", descriptionOverride: "Øv lange ord")
        ]
        let lessons3 = [
            createLesson(id: "da.4.3.1", moduleId: "4.3", name: "Sprint 30 Sekunder", order: 1, content: "og i det som til en af for på at at med",
                         learningGoal: "Mestre Sprint 30 Sekunder", habitTip: "Kig ikke på tastaturet!", descriptionOverride: "Hastighedssprint"),
            createLesson(
                id: "da.4.4.1", 
                moduleId: "4.4", 
                name: "Niveau-Test 4", 
                order: 1, 
                content: "den første store ting er læring", 
                isGatekeeper: true,
                pool: [
                    "den første store ting er læring for at bruge din egen stemme igen.",
                    "tænk på hvor du var da du startede denne rejse.",
                    "studere deres plads højre lille lyd kunne igen ned."
                ],
                learningGoal: "Bestå Niveau-Test 4", habitTip: "Vær rolig og skriv jævnt", descriptionOverride: "Niveautest 4"
            )
        ]
        
        let modules = [
            Module(id: "4.1", name: "Korte Ord", description: "Top 30 ord", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "Mellemlange Ord", description: "5+ bogstaver", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "Ord-Sprints", description: "Opbyg hastighed", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "Ord Mestring", themeName: "Bibliotek", description: "Øg din hastighed", iconName: "text.word.spacing", modules: modules)
    }

    // MARK: - Stage 5: Sentence Fluency (Danish)
    private func generateDanishStage5() -> Stage {
        let lessons1 = [
            createLesson(id: "da.5.1.1", moduleId: "5.1", name: "Enkle Sætninger", order: 1, content: "Hunden gøer højt. Katten sover.",
                         learningGoal: "Mestre Enkle Sætninger", habitTip: "Læs ordet først, skriv det bagefter", descriptionOverride: "Øv simple sætninger"),
            createLesson(id: "da.5.1.2", moduleId: "5.1", name: "Spørgsmål", order: 2, content: "Hvordan går det i dag? Hvad er klokken?",
                         learningGoal: "Mestre Spørgsmål", habitTip: "Vær rolig og skriv jævnt", descriptionOverride: "Practice questions"),
            createLesson(id: "da.5.1.3", moduleId: "5.1", name: "Kommandoer", order: 3, content: "Luk døren venligst. Tænd lyset.",
                         learningGoal: "Mestre Kommandoer", habitTip: "Læs ordet først, skriv det bagefter", descriptionOverride: "Øv simple sætninger")
        ]
        let lessons2 = [
            createLesson(id: "da.5.2.1", moduleId: "5.2", name: "Sammensatte Sætninger", order: 1, content: "Jeg gik til butikken og købte brød.",
                         learningGoal: "Mestre Sammensatte Sætninger", habitTip: "Vær rolig og skriv jævnt", descriptionOverride: "Practice compound sentences"),
            createLesson(id: "da.5.2.2", moduleId: "5.2", name: "Komplekse Ideer", order: 2, content: "Selvom det regnede, besluttede vi os for at gå ud.",
                         learningGoal: "Mestre Komplekse Ideer", habitTip: "Vær rolig og skriv jævnt", descriptionOverride: "Practice complex sentences")
        ]
        let lessons3 = [
            createLesson(
                id: "da.5.4.1", 
                moduleId: "5.4", 
                name: "Niveau-Test 5", 
                order: 1, 
                content: "TypeQuest er den bedste måde at lære.", 
                isGatekeeper: true,
                pool: [
                    "TypeQuest er den bedste måde at lære at skrive. Med daglig øvelse bliver du bedre.",
                    "Den hurtige brune ræv hopper over den dovne hund. En kendt sætning.",
                    "At læse og skrive er fundamentet for digital kommunikation. Mestre tastaturet i dag."
                ],
                learningGoal: "Bestå Niveau-Test 5", habitTip: "Vær rolig og skriv jævnt", descriptionOverride: "Niveautest 5"
            )
        ]
        
        let modules = [
            Module(id: "5.1", name: "Enkle Sætninger", description: "Grundlæggende flow", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "Sammensatte Sætninger", description: "Forbundne ideer", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "Afsnitsøvelse", description: "Fler-sætnings flow", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "Sætningsflow", themeName: "Hav", description: "Skriv med rytme", iconName: "text.alignleft", modules: modules)
    }

    // MARK: - Stage 6: Numbers & Symbols (Danish)
    private func generateDanishStage6() -> Stage {
        let lessons1 = [
            createLesson(id: "da.6.1.1", moduleId: "6.1", name: "Taster 1 og 2", order: 1, content: "111 222 111 222 12 21 12 21",
                         learningGoal: "Mestre Taster 1 og 2", habitTip: "Hold fingrene på hjemrækken", descriptionOverride: "Øv Taster 1 og 2"),
            createLesson(id: "da.6.1.2", moduleId: "6.1", name: "Taster 3 og 4", order: 2, content: "333 444 333 444 34 43 34 43",
                         learningGoal: "Mestre Taster 3 og 4", habitTip: "Hold fingrene på hjemrækken", descriptionOverride: "Øv Taster 3 og 4"),
            createLesson(id: "da.6.1.3", moduleId: "6.1", name: "Taster 5 og 6", order: 3, content: "555 666 555 666 56 65 56 65",
                         learningGoal: "Mestre Taster 5 og 6", habitTip: "Hold fingrene på hjemrækken", descriptionOverride: "Øv Taster 5 og 6"),
            createLesson(id: "da.6.1.4", moduleId: "6.1", name: "Taster 7 og 8", order: 4, content: "777 888 777 888 78 87 78 87",
                         learningGoal: "Mestre Taster 7 og 8", habitTip: "Hold fingrene på hjemrækken", descriptionOverride: "Øv Taster 7 og 8"),
            createLesson(id: "da.6.1.5", moduleId: "6.1", name: "Taster 9 og 0", order: 5, content: "999 000 999 000 90 09 90 09",
                         learningGoal: "Mestre Taster 9 og 0", habitTip: "Hold fingrene på hjemrækken", descriptionOverride: "Øv Taster 9 og 0")
        ]
        let lessons2 = [
            createLesson(id: "da.6.2.1", moduleId: "6.2", name: "! \" # $", order: 1, content: "!!! \"\"\" ### $$$ !\"#$",
                         learningGoal: "Mestre ! \" ", habitTip: "Hold Shift med lillefingeren", descriptionOverride: "Øv specialtegn"),
            createLesson(id: "da.6.2.2", moduleId: "6.2", name: "% & / ( )", order: 2, content: "%%% &&& /// ((( )))",
                         learningGoal: "Mestre % & / ( )", habitTip: "Hold Shift med lillefingeren", descriptionOverride: "Øv specialtegn"),
            createLesson(id: "da.6.2.3", moduleId: "6.2", name: "= ? + *", order: 3, content: "=== ??? +++ *** +?*",
                         learningGoal: "Mestre = ? + *", habitTip: "Hold Shift med lillefingeren", descriptionOverride: "Øv specialtegn")
        ]
        let lessons3 = [
            createLesson(
                id: "da.6.4.1", 
                moduleId: "6.4", 
                name: "Slutprøve", 
                order: 1, 
                content: "Tillykke! Du har nået Etape 6.", 
                isGatekeeper: true,
                pool: [
                    "Tillykke! Du har nået Etape 6. Lad os verificere alt: 123 + 456 = 579. Sandt? Ja!",
                    "Slutprojekt: (acc >= 98.0) && (wpm >= 50.0). Test afsluttet: [OK].",
                    "Specialtegn: !\"#%&/()=?+. Du har afsluttet TypeQuest-pensummet. Godt gået!"
                ],
                learningGoal: "Bestå Slutprøve", habitTip: "Du er næsten der – hold fokus!", descriptionOverride: "Sluttest af hele tastaturet"
            )
        ]
        
        let modules = [
            Module(id: "6.1", name: "Talrække", description: "Taster 0-9", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "Almindelige Symboler", description: "Specialtegn", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "Blandet Øvelse", description: "Alt kombineret", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "Tal & Symboler", themeName: "Laboratorium", description: "Mestre tastaturet", iconName: "number.circle.fill", modules: modules)
    }

    // MARK: - Hungarian Curriculum
    private func generateHungarianStages() -> [Stage] {
        return [
            generateHungarianStage1(),
            generateHungarianStage2(),
            generateHungarianStage3(),
            generateHungarianStage4(),
            generateHungarianStage5(),
            generateHungarianStage6()
        ]
    }
    
    private func generateHungarianStage1() -> Stage {
        let lessons = [
            createLesson(id: "hu.1.1.1", moduleId: "1.1", name: "A és S billentyű", order: 1, content: "aaa sss aaa sss as sa as sa",
                         learningGoal: "Sajátítsd el A és S billentyű", habitTip: "Tartsd az ujjaidat az alapsoron", descriptionOverride: "Gyakorold A és S billentyű"),
            createLesson(
                id: "hu.1.4.1", 
                moduleId: "1.4", 
                name: "Szintvizsga 1", 
                order: 2, 
                content: "asdf jkl; lassú sas sál", 
                isGatekeeper: true,
                pool: [
                    "asdf jkl; lassú sas sál. sál sas lassú. sálak sas sál.",
                    "sas sál lassú. asdf jkl; sálak sas sál. lassú sas sál sálak.",
                    "sas sál lassú. asdf jkl; sálak sas sál. sálak lassú sas sál."
                ],
                learningGoal: "Teljesítsd a Szintvizsga 1", habitTip: "Maradj nyugodt és gépelj egyenletesen", descriptionOverride: "Szintteszt 1"
            )
        ]
        return Stage(id: 1, name: "Alapsor Alapok", themeName: "Erdō", description: "Sajátítsd el a középső sort", iconName: "hand.raised.fill", modules: [
            Module(id: "1.1", name: "Bal kéz horgonyok", description: "Bal kéz pozíciója", stageId: 1, order: 1, lessons: lessons)
        ])
    }
    
    private func generateHungarianStage2() -> Stage {
        let lessons = [
            createLesson(
                id: "hu.2.4.1", 
                moduleId: "2.4", 
                name: "Szintvizsga 2", 
                order: 1, 
                content: "a gyors barna róka átugrik", 
                isGatekeeper: true,
                pool: [
                    "a gyors barna róka átugrik a lusta kutya felett. kicsi a világ, ha gyorsan gépelsz.",
                    "az írás prioritás a sikerhez. az út hosszú, de az eredmény egyedülálló.",
                    "szeretnék precízen és gyorsan írni. ma minden fiatal megtanulhat."
                ],
                learningGoal: "Teljesítsd a Szintvizsga 2", habitTip: "Maradj nyugodt és gépelj egyenletesen", descriptionOverride: "Szintteszt 2"
            )
        ]
        return Stage(id: 2, name: "Felsō sor kibővítése", themeName: "Hegyek", description: "Érd el a felső sort", iconName: "arrow.up.circle.fill", modules: [
            Module(id: "2.1", name: "Felsō sor mesterfok", description: "Felső sor folyamatossága", stageId: 2, order: 1, lessons: lessons)
        ])
    }

    // MARK: - Stage 3: Bottom Row & N-Grams (Hungarian - QWERTZ)
    private func generateHungarianStage3() -> Stage {
        // QWERTZ: Y bottom left.
        let lessons1 = [
            createLesson(id: "hu.3.1.1", moduleId: "3.1", name: "Y és X billentyűk", order: 1, content: "yyy xxx yyy xxx yx xy yoyo xilofon",
                         learningGoal: "Sajátítsd el Y és X billentyűk", habitTip: "Tartsd az ujjaidat az alapsoron", descriptionOverride: "Gyakorold Y és X billentyűk"),
            createLesson(id: "hu.3.1.2", moduleId: "3.1", name: "C és V billentyűk", order: 2, content: "ccc vvv ccc vvv cv vc cica víz",
                         learningGoal: "Sajátítsd el C és V billentyűk", habitTip: "Tartsd az ujjaidat az alapsoron", descriptionOverride: "Gyakorold C és V billentyűk"),
            createLesson(id: "hu.3.1.3", moduleId: "3.1", name: "B billentyű", order: 3, content: "bbb bbb bob bab bor bal",
                         learningGoal: "Sajátítsd el B billentyű", habitTip: "Tartsd az ujjaidat az alapsoron", descriptionOverride: "Gyakorold B billentyű")
        ]
        let lessons2 = [
            createLesson(id: "hu.3.2.1", moduleId: "3.2", name: "N és M billentyűk", order: 1, content: "nnn mmm nnn mmm nm mn nem mam",
                         learningGoal: "Sajátítsd el N és M billentyűk", habitTip: "Tartsd az ujjaidat az alapsoron", descriptionOverride: "Gyakorold N és M billentyűk"),
            createLesson(id: "hu.3.2.2", moduleId: "3.2", name: "Vessző és Pont", order: 2, content: ",,, ... ,,, ... ,. ., egy, ketto.",
                         learningGoal: "Sajátítsd el Vessző és Pont", habitTip: "Tartsd az ujjaidat az alapsoron", descriptionOverride: "Gyakorold Vessző és Pont"),
            createLesson(id: "hu.3.2.3", moduleId: "3.2", name: "Perjel", order: 3, content: "--- --- és/vagy igen/nem",
                         learningGoal: "Sajátítsd el Perjel", habitTip: "Tartsd az ujjaidat az alapsoron", descriptionOverride: "Gyakorold Perjel")
        ]
        let lessons3 = [
            createLesson(id: "hu.3.3.1", moduleId: "3.3", name: "Gyakori párok: a, az", order: 1, content: "a a a az az az egy es",
                         learningGoal: "Sajátítsd el Gyakori párok: a, az", habitTip: "Tartsd az ujjaidat az alapsoron", descriptionOverride: "Gyakorold Gyakori párok: a, az"),
            createLesson(id: "hu.3.3.2", moduleId: "3.3", name: "Gyakori párok: ho, gy", order: 2, content: "ho ho ho gy gy gy hogy vagy",
                         learningGoal: "Sajátítsd el Gyakori párok: ho, gy", habitTip: "Tartsd az ujjaidat az alapsoron", descriptionOverride: "Gyakorold Gyakori párok: ho, gy"),
            createLesson(
                id: "hu.3.4.1", 
                moduleId: "3.4", 
                name: "Szintvizsga 3", 
                order: 1, 
                content: "a gyors barna róka fut", 
                isGatekeeper: true,
                pool: [
                    "a gyors barna róka fut az erdőben. a világ szép.",
                    "szeretnék enni egy finom almát. menjünk a strandra holnap.",
                    "a zene nagyon hangos a buliban. szeretek táncolni a barátaimmal."
                ],
                learningGoal: "Teljesítsd a Szintvizsga 3", habitTip: "Maradj nyugodt és gépelj egyenletesen", descriptionOverride: "Szintteszt 3"
            )
        ]
        
        let modules = [
            Module(id: "3.1", name: "Alsó sor bal", description: "Billentyűk Y X C V B", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "Alsó sor jobb", description: "Billentyűk N M , . -", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "Gyakori N-gramok", description: "Betűpárok mesterfoka", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "Alsó sor és minták", themeName: "Folyó", description: "Egészítsd ki az ábécét", iconName: "arrow.down.circle.fill", modules: modules)
    }

    // MARK: - Stage 4: Word Mastery (Hungarian)
    private func generateHungarianStage4() -> Stage {
        let lessons1 = [
            createLesson(id: "hu.4.1.1", moduleId: "4.1", name: "Gyakori szavak 1", order: 1, content: "a az egy és hogy van nem ez de is",
                         learningGoal: "Sajátítsd el Gyakori szavak 1", habitTip: "Olvasd el a szót, aztán gépeld be", descriptionOverride: "Gyakorold a gyakori szavakat"),
            createLesson(id: "hu.4.1.2", moduleId: "4.1", name: "Gyakori szavak 2", order: 2, content: "meg volt ő mint ha kell csak itt ott",
                         learningGoal: "Sajátítsd el Gyakori szavak 2", habitTip: "Olvasd el a szót, aztán gépeld be", descriptionOverride: "Gyakorold a gyakori szavakat"),
            createLesson(id: "hu.4.1.3", moduleId: "4.1", name: "Gyakori szavak 3", order: 3, content: "mi ki akkor mert már hol minden jó",
                         learningGoal: "Sajátítsd el Gyakori szavak 3", habitTip: "Olvasd el a szót, aztán gépeld be", descriptionOverride: "Gyakorold a gyakori szavakat")
        ]
        let lessons2 = [
            createLesson(id: "hu.4.2.1", moduleId: "4.2", name: "Hosszú szavak 1", order: 1, content: "vagyok neked talán mikor miért",
                         learningGoal: "Sajátítsd el Hosszú szavak 1", habitTip: "A pontosságra koncentrálj a sebesség előtt", descriptionOverride: "Gyakorold a hosszú szavakat"),
            createLesson(id: "hu.4.2.2", moduleId: "4.2", name: "Hosszú szavak 2", order: 2, content: "nagyon sokkal jobban mindig semmi",
                         learningGoal: "Sajátítsd el Hosszú szavak 2", habitTip: "A pontosságra koncentrálj a sebesség előtt", descriptionOverride: "Gyakorold a hosszú szavakat"),
            createLesson(id: "hu.4.2.3", moduleId: "4.2", name: "Hosszú szavak 3", order: 3, content: "viszont közben után előtt alatt",
                         learningGoal: "Sajátítsd el Hosszú szavak 3", habitTip: "A pontosságra koncentrálj a sebesség előtt", descriptionOverride: "Gyakorold a hosszú szavakat")
        ]
        let lessons3 = [
            createLesson(id: "hu.4.3.1", moduleId: "4.3", name: "Sprint 30 másodperc", order: 1, content: "a az egy és hogy van nem ez de is meg volt",
                         learningGoal: "Sajátítsd el Sprint 30 másodperc", habitTip: "Ne nézz a billentyűzetre!", descriptionOverride: "Sebességsprint"),
            createLesson(
                id: "hu.4.4.1", 
                moduleId: "4.4", 
                name: "Szintvizsga 4", 
                order: 1, 
                content: "az első nagy dolog a tanulás", 
                isGatekeeper: true,
                pool: [
                    "az első nagy dolog a tanulás, hogy újra használd a saját hangodat.",
                    "gondolj arra, hol voltál, amikor elkezdted ezt az utazást.",
                    "tanulni a helyüket jobb kis hang lehetne még egyszer le."
                ],
                learningGoal: "Teljesítsd a Szintvizsga 4", habitTip: "Maradj nyugodt és gépelj egyenletesen", descriptionOverride: "Szintteszt 4"
            )
        ]
        
        let modules = [
            Module(id: "4.1", name: "Rövid szavak", description: "Top 30 szó", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "Közepes szavak", description: "5+ betű", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "Szó sprintek", description: "Építs sebességet", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "Szó mester", themeName: "Könyvtár", description: "Növeld a sebességed", iconName: "text.word.spacing", modules: modules)
    }

    // MARK: - Stage 5: Sentence Fluency (Hungarian)
    private func generateHungarianStage5() -> Stage {
        let lessons1 = [
            createLesson(id: "hu.5.1.1", moduleId: "5.1", name: "Egyszerű mondatok", order: 1, content: "A kutya hangosan ugat. A macska alszik.",
                         learningGoal: "Sajátítsd el Egyszerű mondatok", habitTip: "Olvasd el a szót, aztán gépeld be", descriptionOverride: "Gyakorold az egyszerű mondatokat"),
            createLesson(id: "hu.5.1.2", moduleId: "5.1", name: "Kérdések", order: 2, content: "Hogy vagy ma? Mennyi az idő?",
                         learningGoal: "Sajátítsd el Kérdések", habitTip: "Maradj nyugodt és gépelj egyenletesen", descriptionOverride: "Practice questions"),
            createLesson(id: "hu.5.1.3", moduleId: "5.1", name: "Parancsok", order: 3, content: "Csukd be az ajtót kérem. Kapcsold fel a villanyt.",
                         learningGoal: "Sajátítsd el Parancsok", habitTip: "Maradj nyugodt és gépelj egyenletesen", descriptionOverride: "Practice commands")
        ]
        let lessons2 = [
            createLesson(id: "hu.5.2.1", moduleId: "5.2", name: "Összetett mondatok", order: 1, content: "Elmentem a boltba, és vettem kenyeret.",
                         learningGoal: "Sajátítsd el Összetett mondatok", habitTip: "Maradj nyugodt és gépelj egyenletesen", descriptionOverride: "Practice compound sentences"),
            createLesson(id: "hu.5.2.2", moduleId: "5.2", name: "Komplex gondolatok", order: 2, content: "Bár esett az eső, úgy döntöttünk, hogy kimegyünk.",
                         learningGoal: "Sajátítsd el Komplex gondolatok", habitTip: "Maradj nyugodt és gépelj egyenletesen", descriptionOverride: "Practice complex sentences")
        ]
        let lessons3 = [
            createLesson(
                id: "hu.5.4.1", 
                moduleId: "5.4", 
                name: "Szintvizsga 5", 
                order: 1, 
                content: "A TypeQuest a legjobb módja a tanulásnak.", 
                isGatekeeper: true,
                pool: [
                    "A TypeQuest a legjobb módja a gépelés tanulásának. Napi gyakorlással jobb leszel.",
                    "A gyors barna róka átugrik a lusta kutya felett. Egy híres mondat.",
                    "Az olvasás és írás a digitális kommunikáció alapjai. Sajátítsd el a billentyűzetet ma."
                ],
                learningGoal: "Teljesítsd a Szintvizsga 5", habitTip: "Maradj nyugodt és gépelj egyenletesen", descriptionOverride: "Szintteszt 5"
            )
        ]
        
        let modules = [
            Module(id: "5.1", name: "Egyszerű mondatok", description: "Alap folyamat", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "Összetett mondatok", description: "Kapcsolt gondolatok", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "Bekezdés gyakorlás", description: "Több mondatos folyamat", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "Mondat folyékonyság", themeName: "Óceán", description: "Írj ritmussal", iconName: "text.alignleft", modules: modules)
    }

    // MARK: - Stage 6: Numbers & Symbols (Hungarian)
    private func generateHungarianStage6() -> Stage {
        let lessons1 = [
            createLesson(id: "hu.6.1.1", moduleId: "6.1", name: "1 és 2 billentyűk", order: 1, content: "111 222 111 222 12 21 12 21",
                         learningGoal: "Sajátítsd el 1 és 2 billentyűk", habitTip: "Tartsd az ujjaidat az alapsoron", descriptionOverride: "Gyakorold 1 és 2 billentyűk"),
            createLesson(id: "hu.6.1.2", moduleId: "6.1", name: "3 és 4 billentyűk", order: 2, content: "333 444 333 444 34 43 34 43",
                         learningGoal: "Sajátítsd el 3 és 4 billentyűk", habitTip: "Tartsd az ujjaidat az alapsoron", descriptionOverride: "Gyakorold 3 és 4 billentyűk"),
            createLesson(id: "hu.6.1.3", moduleId: "6.1", name: "5 és 6 billentyűk", order: 3, content: "555 666 555 666 56 65 56 65",
                         learningGoal: "Sajátítsd el 5 és 6 billentyűk", habitTip: "Tartsd az ujjaidat az alapsoron", descriptionOverride: "Gyakorold 5 és 6 billentyűk"),
            createLesson(id: "hu.6.1.4", moduleId: "6.1", name: "7 és 8 billentyűk", order: 4, content: "777 888 777 888 78 87 78 87",
                         learningGoal: "Sajátítsd el 7 és 8 billentyűk", habitTip: "Tartsd az ujjaidat az alapsoron", descriptionOverride: "Gyakorold 7 és 8 billentyűk"),
            createLesson(id: "hu.6.1.5", moduleId: "6.1", name: "9 és 0 billentyűk", order: 5, content: "999 000 999 000 90 09 90 09",
                         learningGoal: "Sajátítsd el 9 és 0 billentyűk", habitTip: "Tartsd az ujjaidat az alapsoron", descriptionOverride: "Gyakorold 9 és 0 billentyűk")
        ]
        // Hungarian Top Row: ö ü ó ő ú é á ű í
        let lessons2 = [
            createLesson(id: "hu.6.2.1", moduleId: "6.2", name: "ö ü ó", order: 1, content: "ööü üüó óóö öüó",
                         learningGoal: "Sajátítsd el ö ü ó", habitTip: "Tartsd az ujjaidat az alapsoron", descriptionOverride: "Gyakorold ö ü ó"),
            createLesson(id: "hu.6.2.2", moduleId: "6.2", name: "ő ú é", order: 2, content: "őőú úúé ééő őúé",
                         learningGoal: "Sajátítsd el ő ú é", habitTip: "Tartsd az ujjaidat az alapsoron", descriptionOverride: "Gyakorold ő ú é"),
            createLesson(id: "hu.6.2.3", moduleId: "6.2", name: "á ű í", order: 3, content: "ááű űűí ííá áűí",
                         learningGoal: "Sajátítsd el á ű í", habitTip: "Tartsd az ujjaidat az alapsoron", descriptionOverride: "Gyakorold á ű í")
        ]
        let lessons3 = [
            createLesson(
                id: "hu.6.4.1", 
                moduleId: "6.4", 
                name: "Záróvizsga", 
                order: 1, 
                content: "Gratulálunk! Elérted a 6. szakaszt.", 
                isGatekeeper: true,
                pool: [
                    "Gratulálunk! Elérted a 6. szakaszt. Ellenőrizzünk mindent: 123 + 456 = 579. Igaz? Igen!",
                    "Záróprojekt: (acc >= 98.0) && (wpm >= 50.0). Teszt befejezve: [OK].",
                    "Különleges karakterek: öüóőúéáűí. Befejezted a TypeQuest tananyagot. Szép munka!"
                ],
                learningGoal: "Teljesítsd a Záróvizsga", habitTip: "Már majdnem kész – maradj koncentrált!", descriptionOverride: "Záró teszt a teljes billentyűzethez"
            )
        ]
        
        let modules = [
            Module(id: "6.1", name: "Számsor", description: "Billentyűk 0-9", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "Ékezetek", description: "Magyar karakterek", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "Vegyes gyakorlás", description: "Minden kombinálva", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "Számok és Szimbólumok", themeName: "Laboratórium", description: "Urald a billentyűzetet", iconName: "number.circle.fill", modules: modules)
    }

    // MARK: - Finnish Curriculum
    private func generateFinnishStages() -> [Stage] {
        return [
            generateFinnishStage1(),
            generateFinnishStage2(),
            generateFinnishStage3(),
            generateFinnishStage4(),
            generateFinnishStage5(),
            generateFinnishStage6()
        ]
    }
    
    private func generateFinnishStage1() -> Stage {
        let lessons = [
            createLesson(id: "fi.1.1.1", moduleId: "1.1", name: "Näppäimet A ja S", order: 1, content: "aaa sss aaa sss as sa as sa",
                         learningGoal: "Hallitse Näppäimet A ja S", habitTip: "Pidä sormet perusrivillä", descriptionOverride: "Harjoittele Näppäimet A ja S"),
            createLesson(
                id: "fi.1.4.1", 
                moduleId: "1.4", 
                name: "Tasokoe 1", 
                order: 2, 
                content: "asdf jkl; alas sala sal", 
                isGatekeeper: true,
                pool: [
                    "asdf jkl; alas sala sal. sal sala alas. salla sal sala.",
                    "sala alas salla. asdf jkl; salla sal alas. sala sal alas salla.",
                    "sala alas salla. asdf jkl; salla sala sal. sala salla sala sal."
                ],
                learningGoal: "Läpäise Tasokoe 1", habitTip: "Pysy rauhallisena ja kirjoita tasaisesti", descriptionOverride: "Tasotesti 1"
            )
        ]
        return Stage(id: 1, name: "Perusrivin Perusteet", themeName: "Metsä", description: "Hallitse keskimmäinen rivi", iconName: "hand.raised.fill", modules: [
            Module(id: "1.1", name: "Vasemman käden ankkurit", description: "Vasemman käden asento", stageId: 1, order: 1, lessons: lessons)
        ])
    }
    
    private func generateFinnishStage2() -> Stage {
        let lessons = [
            createLesson(
                id: "fi.2.4.1", 
                moduleId: "2.4", 
                name: "Tasokoe 2", 
                order: 1, 
                content: "nopea ruskea kettu hyppää", 
                isGatekeeper: true,
                pool: [
                    "nopea ruskea kettu hyppää laiskan koiran yli. maailma on pieni, kun kirjoitat nopeasti.",
                    "kirjoittaminen on tärkeysjärjestyksessä korkealla menestyksen kannalta. tie on pitkä, mutta tulos on ainutlaatuinen.",
                    "haluan pystyä kirjoittamaan tarkasti ja nopeasti. kaikki nuoret voivat oppia tänään."
                ],
                learningGoal: "Läpäise Tasokoe 2", habitTip: "Pysy rauhallisena ja kirjoita tasaisesti", descriptionOverride: "Tasotesti 2"
            )
        ]
        return Stage(id: 2, name: "Ylärivin Laajennus", themeName: "Tunturit", description: "Saavuta ylärivi", iconName: "arrow.up.circle.fill", modules: [
            Module(id: "2.1", name: "Ylärivin Mestaruus", description: "Ylärivin sujuvuus", stageId: 2, order: 1, lessons: lessons)
        ])
    }

    // MARK: - Stage 3: Bottom Row & N-Grams (Finnish)
    private func generateFinnishStage3() -> Stage {
        let lessons1 = [
            createLesson(id: "fi.3.1.1", moduleId: "3.1", name: "Näppäimet Z ja X", order: 1, content: "zzz xxx zzz xxx zx xz zebra xylitol",
                         learningGoal: "Hallitse Näppäimet Z ja X", habitTip: "Pidä sormet perusrivillä", descriptionOverride: "Harjoittele Näppäimet Z ja X"),
            createLesson(id: "fi.3.1.2", moduleId: "3.1", name: "Näppäimet C ja V", order: 2, content: "ccc vvv ccc vvv cv vc cola voi",
                         learningGoal: "Hallitse Näppäimet C ja V", habitTip: "Pidä sormet perusrivillä", descriptionOverride: "Harjoittele Näppäimet C ja V"),
            createLesson(id: "fi.3.1.3", moduleId: "3.1", name: "Näppäin B", order: 3, content: "bbb bbb bob banaani bo",
                         learningGoal: "Hallitse Näppäin B", habitTip: "Pidä sormet perusrivillä", descriptionOverride: "Harjoittele Näppäin B")
        ]
        let lessons2 = [
            createLesson(id: "fi.3.2.1", moduleId: "3.2", name: "Näppäimet N ja M", order: 1, content: "nnn mmm nnn mmm nm mn nimi maa",
                         learningGoal: "Hallitse Näppäimet N ja M", habitTip: "Pidä sormet perusrivillä", descriptionOverride: "Harjoittele Näppäimet N ja M"),
            createLesson(id: "fi.3.2.2", moduleId: "3.2", name: "Pilkku ja Piste", order: 2, content: ",,, ... ,,, ... ,. ., yksi, kaksi.",
                         learningGoal: "Hallitse Pilkku ja Piste", habitTip: "Pidä sormet perusrivillä", descriptionOverride: "Harjoittele Pilkku ja Piste"),
            createLesson(id: "fi.3.2.3", moduleId: "3.2", name: "Kauttaviiva", order: 3, content: "--- --- ja/tai kyllä/ei",
                         learningGoal: "Hallitse Kauttaviiva", habitTip: "Pidä sormet perusrivillä", descriptionOverride: "Harjoittele Kauttaviiva")// Using dash/hyphen as standard
        ]
        let lessons3 = [
            createLesson(id: "fi.3.3.1", moduleId: "3.3", name: "Yleiset Parit: on, ja", order: 1, content: "on on on ja ja ja ei se",
                         learningGoal: "Hallitse Yleiset Parit: on, ja", habitTip: "Pysy rauhallisena ja kirjoita tasaisesti", descriptionOverride: "Practice pairs"),
            createLesson(id: "fi.3.3.2", moduleId: "3.3", name: "Yleiset Parit: ta, ka", order: 2, content: "ta ta ta ka ka ka sa ma",
                         learningGoal: "Hallitse Yleiset Parit: ta, ka", habitTip: "Pysy rauhallisena ja kirjoita tasaisesti", descriptionOverride: "Practice pairs"),
            createLesson(
                id: "fi.3.4.1", 
                moduleId: "3.4", 
                name: "Tasokoe 3", 
                order: 1, 
                content: "nopea ruskea kettu juoksee", 
                isGatekeeper: true,
                pool: [
                    "nopea ruskea kettu juoksee metsässä. maailma on kaunis.",
                    "haluan syödä hyvää ruokaa tänään. mennään rannalle huomenna.",
                    "musiikki soi kovaa juhlissa. tykkään tanssia ystävien kanssa."
                ],
                learningGoal: "Läpäise Tasokoe 3", habitTip: "Pysy rauhallisena ja kirjoita tasaisesti", descriptionOverride: "Tasotesti 3"
            )
        ]
        
        let modules = [
            Module(id: "3.1", name: "Alarivi Vasen", description: "Näppäimet Z X C V B", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "Alarivi Oikea", description: "Näppäimet N M , . -", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "Yleiset N-Grammit", description: "Hallitse kirjainparit", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "Alarivi & Kuviot", themeName: "Joki", description: "Täydennä aakkoset", iconName: "arrow.down.circle.fill", modules: modules)
    }

    // MARK: - Stage 4: Word Mastery (Finnish)
    private func generateFinnishStage4() -> Stage {
        let lessons1 = [
            createLesson(id: "fi.4.1.1", moduleId: "4.1", name: "Yleiset Sanat 1", order: 1, content: "ja on ei että se hän oli",
                         learningGoal: "Hallitse Yleiset Sanat 1", habitTip: "Lue sana ensin, kirjoita se sitten", descriptionOverride: "Harjoittele yleisiä sanoja"),
            createLesson(id: "fi.4.1.2", moduleId: "4.1", name: "Yleiset Sanat 2", order: 2, content: "mutta kun kuin myös niin tai",
                         learningGoal: "Hallitse Yleiset Sanat 2", habitTip: "Lue sana ensin, kirjoita se sitten", descriptionOverride: "Harjoittele yleisiä sanoja"),
            createLesson(id: "fi.4.1.3", moduleId: "4.1", name: "Yleiset Sanat 3", order: 3, content: "tämä nyt vain jos ne kaikki",
                         learningGoal: "Hallitse Yleiset Sanat 3", habitTip: "Lue sana ensin, kirjoita se sitten", descriptionOverride: "Harjoittele yleisiä sanoja")
        ]
        let lessons2 = [
            createLesson(id: "fi.4.2.1", moduleId: "4.2", name: "Pitkät Sanat 1", order: 1, content: "sitten heidän kanssaan vuoden",
                         learningGoal: "Hallitse Pitkät Sanat 1", habitTip: "Keskity tarkkuuteen ennen nopeutta", descriptionOverride: "Harjoittele pitkiä sanoja"),
            createLesson(id: "fi.4.2.2", moduleId: "4.2", name: "Pitkät Sanat 2", order: 2, content: "paljon jälkeen mukaan kaksi",
                         learningGoal: "Hallitse Pitkät Sanat 2", habitTip: "Keskity tarkkuuteen ennen nopeutta", descriptionOverride: "Harjoittele pitkiä sanoja"),
            createLesson(id: "fi.4.2.3", moduleId: "4.2", name: "Pitkät Sanat 3", order: 3, content: "sinun oletko tiedät miksi",
                         learningGoal: "Hallitse Pitkät Sanat 3", habitTip: "Keskity tarkkuuteen ennen nopeutta", descriptionOverride: "Harjoittele pitkiä sanoja")
        ]
        let lessons3 = [
            createLesson(id: "fi.4.3.1", moduleId: "4.3", name: "Sprintti 30 Sekuntia", order: 1, content: "ja on ei että se hän oli mutta kun kuin myös",
                         learningGoal: "Hallitse Sprintti 30 Sekuntia", habitTip: "Älä katso näppäimistöä!", descriptionOverride: "Nopeussprint"),
            createLesson(
                id: "fi.4.4.1", 
                moduleId: "4.4", 
                name: "Tasokoe 4", 
                order: 1, 
                content: "ensimmäinen iso asia on oppiminen", 
                isGatekeeper: true,
                pool: [
                    "ensimmäinen iso asia on oppiminen käyttämään omaa ääntäsi uudelleen.",
                    "ajattele missä olit kun aloitit tämän matkan.",
                    "tutki heidän paikkaansa oikea pieni ääni voisi jälleen alas."
                ],
                learningGoal: "Läpäise Tasokoe 4", habitTip: "Pysy rauhallisena ja kirjoita tasaisesti", descriptionOverride: "Tasotesti 4"
            )
        ]
        
        let modules = [
            Module(id: "4.1", name: "Lyhyet Sanat", description: "Top 30 sanaa", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "Keskipitkät Sanat", description: "5+ kirjainta", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "Sanasprintit", description: "Rakenna nopeutta", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "Sanojen Mestaruus", themeName: "Kirjasto", description: "Kasvata nopeuttasi", iconName: "text.word.spacing", modules: modules)
    }

    // MARK: - Stage 5: Sentence Fluency (Finnish)
    private func generateFinnishStage5() -> Stage {
        let lessons1 = [
            createLesson(id: "fi.5.1.1", moduleId: "5.1", name: "Yksinkertaiset Lauseet", order: 1, content: "Koira haukkuu kovaa. Kissa nukkuu.",
                         learningGoal: "Hallitse Yksinkertaiset Lauseet", habitTip: "Lue sana ensin, kirjoita se sitten", descriptionOverride: "Harjoittele yksinkertaisia lauseita"),
            createLesson(id: "fi.5.1.2", moduleId: "5.1", name: "Kysymykset", order: 2, content: "Mitä kuuluu tänään? Paljonko kello on?",
                         learningGoal: "Hallitse Kysymykset", habitTip: "Lue sana ensin, kirjoita se sitten", descriptionOverride: "Harjoittele yksinkertaisia lauseita"),
            createLesson(id: "fi.5.1.3", moduleId: "5.1", name: "Komennot", order: 3, content: "Sulje ovi kiitos. Laita valot päälle.",
                         learningGoal: "Hallitse Komennot", habitTip: "Pysy rauhallisena ja kirjoita tasaisesti", descriptionOverride: "Practice commands")
        ]
        let lessons2 = [
            createLesson(id: "fi.5.2.1", moduleId: "5.2", name: "Yhdistetyt Lauseet", order: 1, content: "Menin kauppaan ja ostin leipää.",
                         learningGoal: "Hallitse Yhdistetyt Lauseet", habitTip: "Pysy rauhallisena ja kirjoita tasaisesti", descriptionOverride: "Practice compound sentences"),
            createLesson(id: "fi.5.2.2", moduleId: "5.2", name: "Monimutkaiset Ideat", order: 2, content: "Vaikka satoi, päätimme mennä ulos.",
                         learningGoal: "Hallitse Monimutkaiset Ideat", habitTip: "Lue sana ensin, kirjoita se sitten", descriptionOverride: "Harjoittele yksinkertaisia lauseita")
        ]
        let lessons3 = [
            createLesson(
                id: "fi.5.4.1", 
                moduleId: "5.4", 
                name: "Tasokoe 5", 
                order: 1, 
                content: "TypeQuest on paras tapa oppia.", 
                isGatekeeper: true,
                pool: [
                    "TypeQuest on paras tapa oppia kirjoittamaan. Päivittäisellä harjoittelulla tulet paremmaksi.",
                    "Nopea ruskea kettu hyppää laiskan koiran yli. Tunnettu lause.",
                    "Lukeminen ja kirjoittaminen ovat digitaalisen viestinnän perusta. Hallitse näppäimistö tänään."
                ],
                learningGoal: "Läpäise Tasokoe 5", habitTip: "Pysy rauhallisena ja kirjoita tasaisesti", descriptionOverride: "Tasotesti 5"
            )
        ]
        
        let modules = [
            Module(id: "5.1", name: "Yksinkertaiset Lauseet", description: "Perusvirtaus", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "Yhdistetyt Lauseet", description: "Yhdistetyt ideat", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "Kappaleharjoittelu", description: "Monen lauseen virtaus", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "Lauseiden Sujuvuus", themeName: "Meri", description: "Kirjoita rytmillä", iconName: "text.alignleft", modules: modules)
    }

    // MARK: - Stage 6: Numbers & Symbols (Finnish)
    private func generateFinnishStage6() -> Stage {
        let lessons1 = [
            createLesson(id: "fi.6.1.1", moduleId: "6.1", name: "Näppäimet 1 ja 2", order: 1, content: "111 222 111 222 12 21 12 21",
                         learningGoal: "Hallitse Näppäimet 1 ja 2", habitTip: "Pidä sormet perusrivillä", descriptionOverride: "Harjoittele Näppäimet 1 ja 2"),
            createLesson(id: "fi.6.1.2", moduleId: "6.1", name: "Näppäimet 3 ja 4", order: 2, content: "333 444 333 444 34 43 34 43",
                         learningGoal: "Hallitse Näppäimet 3 ja 4", habitTip: "Pidä sormet perusrivillä", descriptionOverride: "Harjoittele Näppäimet 3 ja 4"),
            createLesson(id: "fi.6.1.3", moduleId: "6.1", name: "Näppäimet 5 ja 6", order: 3, content: "555 666 555 666 56 65 56 65",
                         learningGoal: "Hallitse Näppäimet 5 ja 6", habitTip: "Pidä sormet perusrivillä", descriptionOverride: "Harjoittele Näppäimet 5 ja 6"),
            createLesson(id: "fi.6.1.4", moduleId: "6.1", name: "Näppäimet 7 ja 8", order: 4, content: "777 888 777 888 78 87 78 87",
                         learningGoal: "Hallitse Näppäimet 7 ja 8", habitTip: "Pidä sormet perusrivillä", descriptionOverride: "Harjoittele Näppäimet 7 ja 8"),
            createLesson(id: "fi.6.1.5", moduleId: "6.1", name: "Näppäimet 9 ja 0", order: 5, content: "999 000 999 000 90 09 90 09",
                         learningGoal: "Hallitse Näppäimet 9 ja 0", habitTip: "Pidä sormet perusrivillä", descriptionOverride: "Harjoittele Näppäimet 9 ja 0")
        ]
        let lessons2 = [
            createLesson(id: "fi.6.2.1", moduleId: "6.2", name: "! \" # $", order: 1, content: "!!! \"\"\" ### $$$ !\"#$",
                         learningGoal: "Hallitse ! \" ", habitTip: "Pidä Shift pohjassa pikkusormella", descriptionOverride: "Harjoittele erikoismerkkejä"),
            createLesson(id: "fi.6.2.2", moduleId: "6.2", name: "% & / ( )", order: 2, content: "%%% &&& /// ((( )))",
                         learningGoal: "Hallitse % & / ( )", habitTip: "Pidä Shift pohjassa pikkusormella", descriptionOverride: "Harjoittele erikoismerkkejä"),
            createLesson(id: "fi.6.2.3", moduleId: "6.2", name: "= ? + *", order: 3, content: "=== ??? +++ *** +?*",
                         learningGoal: "Hallitse = ? + *", habitTip: "Pidä Shift pohjassa pikkusormella", descriptionOverride: "Harjoittele erikoismerkkejä")
        ]
        let lessons3 = [
            createLesson(
                id: "fi.6.4.1", 
                moduleId: "6.4", 
                name: "Loppukoe", 
                order: 1, 
                content: "Onnittelut! Olet saavuttanut Etapin 6.", 
                isGatekeeper: true,
                pool: [
                    "Onnittelut! Olet saavuttanut Etapin 6. Tarkistetaan kaikki: 123 + 456 = 579. Totta? Kyllä!",
                    "Loppuprojekti: (acc >= 98.0) && (wpm >= 50.0). Testi suoritettu: [OK].",
                    "Erikoismerkit: !\"#%&/()=?+. Olet suorittanut TypeQuest-opetussuunnitelman. Hyvää työtä!"
                ],
                learningGoal: "Läpäise Loppukoe", habitTip: "Olet melkein perillä – pysy keskittyneenä!", descriptionOverride: "Lopputesti koko näppäimistölle"
            )
        ]
        
        let modules = [
            Module(id: "6.1", name: "Numerorivi", description: "Näppäimet 0-9", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "Yleiset Symbolit", description: "Erikoismerkit", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "Sekaharjoitus", description: "Kaikki yhdistettynä", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "Numerot & Symbolit", themeName: "Laboratorio", description: "Hallitse näppäimistö", iconName: "number.circle.fill", modules: modules)
    }

    // MARK: - Greek Curriculum
    private func generateGreekStages() -> [Stage] {
        return [
            generateGreekStage1(),
            generateGreekStage2(),
            generateGreekStage3(),
            generateGreekStage4(),
            generateGreekStage5(),
            generateGreekStage6()
        ]
    }
    
    private func generateGreekStage1() -> Stage {
        let lessons = [
            createLesson(id: "el.1.1.1", moduleId: "1.1", name: "Πλήκτρα Α και Σ", order: 1, content: "ααα σσσ ααα σσσ ασ σα ασ σα",
                         learningGoal: "Κατάκτησε Πλήκτρα Α και Σ", habitTip: "Κράτα τα δάχτυλα στη βασική σειρά", descriptionOverride: "Εξάσκησε Πλήκτρα Α και Σ"),
            createLesson(
                id: "el.1.4.1", 
                moduleId: "1.4", 
                name: "Τεστ Επιπέδου 1", 
                order: 2, 
                content: "ασδφ ξκλς αλα σαλα αλς", 
                isGatekeeper: true,
                pool: [
                    "ασδφ ξκλς αλα σαλα αλς. αλς σαλα αλα. σαλλα αλς σαλα.",
                    "σαλα αλα σαλλα. ασδφ ξκλς σαλλα αλς αλα. αλα αλς αλα σαλλα.",
                    "αλα αλα σαλλα. ασδφ ξκλς σαλλα αλα αλα. αλα σαλλα αλα αλα."
                ],
                learningGoal: "Πέρασε το Τεστ Επιπέδου 1", habitTip: "Μείνε ήρεμος και πληκτρολόγησε σταθερά", descriptionOverride: "Τεστ επιπέδου 1"
            )
        ]
        return Stage(id: 1, name: "Θεμέλια Βασικής Σειράς", themeName: "Δάσος", description: "Κατακτήστε τη μεσαία σειρά", iconName: "hand.raised.fill", modules: [
            Module(id: "1.1", name: "Άγκυρες Αριστερού Χεριού", description: "Θέση αριστερού χεριού", stageId: 1, order: 1, lessons: lessons)
        ])
    }
    
    private func generateGreekStage2() -> Stage {
        let lessons = [
            createLesson(
                id: "el.2.4.1", 
                moduleId: "2.4", 
                name: "Τεστ Επιπέδου 2", 
                order: 1, 
                content: "η γρήγορη καφέ αλεπού πηδά", 
                isGatekeeper: true,
                pool: [
                    "η γρήγορη καφέ αλεπού πηδά πάνω από το τεμπέλικο σκυλί. ο κόσμος είναι μικρός όταν γράφεις γρήγορα.",
                    "το γράψιμο είναι προτεραιότητα για την επιτυχία. ο δρόμος είναι μακρύς αλλά το αποτέλεσμα είναι μοναδικό.",
                    "θέλω να μπορώ να γράφω με ακρίβεια και ταχύτητα. όλοι οι νέοι μπορούν να μάθουν σήμερα."
                ],
                learningGoal: "Πέρασε το Τεστ Επιπέδου 2", habitTip: "Μείνε ήρεμος και πληκτρολόγησε σταθερά", descriptionOverride: "Τεστ επιπέδου 2"
            )
        ]
        return Stage(id: 2, name: "Επέκταση Πάνω Σειράς", themeName: "Βουνά", description: "Φτάστε στην πάνω σειρά", iconName: "arrow.up.circle.fill", modules: [
            Module(id: "2.1", name: "Κυριαρχία Πάνω Σειράς", description: "Ροή πάνω σειράς", stageId: 2, order: 1, lessons: lessons)
        ])
    }

    // MARK: - Stage 3: Bottom Row & N-Grams (Greek)
    private func generateGreekStage3() -> Stage {
        // Greek Bottom Row: Ζ Χ Ψ Ω Β Ν Μ , . /
        // Let's create lessons for these keys.
        let lessons1 = [
            createLesson(id: "el.3.1.1", moduleId: "3.1", name: "Πλήκτρα Ζ και Χ", order: 1, content: "ζζζ χχχ ζζζ χχχ ζχ χζ ζώνη χέρι",
                         learningGoal: "Κατάκτησε Πλήκτρα Ζ και Χ", habitTip: "Κράτα τα δάχτυλα στη βασική σειρά", descriptionOverride: "Εξάσκησε Πλήκτρα Ζ και Χ"),
            createLesson(id: "el.3.1.2", moduleId: "3.1", name: "Πλήκτρα Ψ και Ω", order: 2, content: "ψψψ ωωω ψψψ ωωω ψω ωψ ψάρι ώρα",
                         learningGoal: "Κατάκτησε Πλήκτρα Ψ και Ω", habitTip: "Κράτα τα δάχτυλα στη βασική σειρά", descriptionOverride: "Εξάσκησε Πλήκτρα Ψ και Ω"),
            createLesson(id: "el.3.1.3", moduleId: "3.1", name: "Πλήκτρο Β", order: 3, content: "βββ βββ βόλτα βήμα βίος",
                         learningGoal: "Κατάκτησε Πλήκτρο Β", habitTip: "Κράτα τα δάχτυλα στη βασική σειρά", descriptionOverride: "Εξάσκησε Πλήκτρο Β")
        ]
        let lessons2 = [
            createLesson(id: "el.3.2.1", moduleId: "3.2", name: "Πλήκτρα Ν και Μ", order: 1, content: "ννν μμμ ννν μμμ νμ μν ναι μη",
                         learningGoal: "Κατάκτησε Πλήκτρα Ν και Μ", habitTip: "Κράτα τα δάχτυλα στη βασική σειρά", descriptionOverride: "Εξάσκησε Πλήκτρα Ν και Μ"),
            createLesson(id: "el.3.2.2", moduleId: "3.2", name: "Κόμμα και Τελεία", order: 2, content: ",,, ... ,,, ... ,. ., ένα, δύο.",
                         learningGoal: "Κατάκτησε Κόμμα και Τελεία", habitTip: "Κράτα τα δάχτυλα στη βασική σειρά", descriptionOverride: "Εξάσκησε Κόμμα και Τελεία"),
            createLesson(id: "el.3.2.3", moduleId: "3.2", name: "Κάθετος", order: 3, content: "/// /// και/ή ναι/όχι",
                         learningGoal: "Κατάκτησε Κάθετος", habitTip: "Κράτα τα δάχτυλα στη βασική σειρά", descriptionOverride: "Εξάσκησε Κάθετος")
        ]
        let lessons3 = [
            createLesson(id: "el.3.3.1", moduleId: "3.3", name: "Συχνά Ζεύγη: α, το", order: 1, content: "α α α το το το τα τι τε",
                         learningGoal: "Κατάκτησε Συχνά Ζεύγη: α, το", habitTip: "Κράτα τα δάχτυλα στη βασική σειρά", descriptionOverride: "Εξάσκησε Συχνά Ζεύγη: α, το"),
            createLesson(id: "el.3.3.2", moduleId: "3.3", name: "Συχνά Ζεύγη: να, με", order: 2, content: "να να να με με με μου μα",
                         learningGoal: "Κατάκτησε Συχνά Ζεύγη: να, με", habitTip: "Κράτα τα δάχτυλα στη βασική σειρά", descriptionOverride: "Εξάσκησε Συχνά Ζεύγη: να, με"),
            createLesson(
                id: "el.3.4.1", 
                moduleId: "3.4", 
                name: "Τεστ Επιπέδου 3", 
                order: 1, 
                content: "η γρήγορη αλεπού τρέχει", 
                isGatekeeper: true,
                pool: [
                    "η γρήγορη αλεπού τρέχει στο δάσος. ο κόσμος είναι ωραίος.",
                    "θέλω να φάω ένα ωραίο μήλο. πάμε στην παραλία αύριο.",
                    "η μουσική παίζει δυνατά στο πάρτι. μου αρέσει να χορεύω."
                ],
                learningGoal: "Πέρασε το Τεστ Επιπέδου 3", habitTip: "Μείνε ήρεμος και πληκτρολόγησε σταθερά", descriptionOverride: "Τεστ επιπέδου 3"
            )
        ]
        
        let modules = [
            Module(id: "3.1", name: "Κάτω Σειρά Αριστερά", description: "Πλήκτρα Ζ Χ Ψ Ω Β", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "Κάτω Σειρά Δεξιά", description: "Πλήκτρα Ν Μ , . /", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "Συχνά N-Grams", description: "Κατακτήστε τα ζεύγη", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "Κάτω Σειρά & Μοτίβα", themeName: "Ποτάμι", description: "Ολοκληρώστε το αλφάβητο", iconName: "arrow.down.circle.fill", modules: modules)
    }

    // MARK: - Stage 4: Word Mastery (Greek)
    private func generateGreekStage4() -> Stage {
        let lessons1 = [
            createLesson(id: "el.4.1.1", moduleId: "4.1", name: "Συχνές Λέξεις 1", order: 1, content: "και να το θα που δεν με για στο",
                         learningGoal: "Κατάκτησε Συχνές Λέξεις 1", habitTip: "Διάβασε τη λέξη πρώτα, μετά πληκτρολόγησέ τη", descriptionOverride: "Εξάσκησε συχνές λέξεις"),
            createLesson(id: "el.4.1.2", moduleId: "4.1", name: "Συχνές Λέξεις 2", order: 2, content: "από μου είναι ο η τα σου τι",
                         learningGoal: "Κατάκτησε Συχνές Λέξεις 2", habitTip: "Διάβασε τη λέξη πρώτα, μετά πληκτρολόγησέ τη", descriptionOverride: "Εξάσκησε συχνές λέξεις"),
            createLesson(id: "el.4.1.3", moduleId: "4.1", name: "Συχνές Λέξεις 3", order: 3, content: "αν μια σε αυτό έχει ως τη μας",
                         learningGoal: "Κατάκτησε Συχνές Λέξεις 3", habitTip: "Διάβασε τη λέξη πρώτα, μετά πληκτρολόγησέ τη", descriptionOverride: "Εξάσκησε συχνές λέξεις")
        ]
        let lessons2 = [
            createLesson(id: "el.4.2.1", moduleId: "4.2", name: "Μεγάλες Λέξεις 1", order: 1, content: "αλλά πολύ ένας όλα όμως",
                         learningGoal: "Κατάκτησε Μεγάλες Λέξεις 1", habitTip: "Εστίασε στην ακρίβεια πριν την ταχύτητα", descriptionOverride: "Εξάσκησε μεγάλες λέξεις"),
            createLesson(id: "el.4.2.2", moduleId: "4.2", name: "Μεγάλες Λέξεις 2", order: 2, content: "γιατί καλά τώρα μετά",
                         learningGoal: "Κατάκτησε Μεγάλες Λέξεις 2", habitTip: "Εστίασε στην ακρίβεια πριν την ταχύτητα", descriptionOverride: "Εξάσκησε μεγάλες λέξεις"),
            createLesson(id: "el.4.2.3", moduleId: "4.2", name: "Μεγάλες Λέξεις 3", order: 3, content: "μπορεί αυτή ήταν πάλι",
                         learningGoal: "Κατάκτησε Μεγάλες Λέξεις 3", habitTip: "Εστίασε στην ακρίβεια πριν την ταχύτητα", descriptionOverride: "Εξάσκησε μεγάλες λέξεις")
        ]
        let lessons3 = [
            createLesson(id: "el.4.3.1", moduleId: "4.3", name: "Sprint 30 Δευτερόλεπτα", order: 1, content: "και να το θα που δεν με για στο από μου είναι",
                         learningGoal: "Κατάκτησε Sprint 30 Δευτερόλεπτα", habitTip: "Μην κοιτάς το πληκτρολόγιο!", descriptionOverride: "Σπριντ ταχύτητας"),
            createLesson(
                id: "el.4.4.1", 
                moduleId: "4.4", 
                name: "Τεστ Επιπέδου 4", 
                order: 1, 
                content: "το πρώτο μεγάλο πράγμα είναι η μάθηση", 
                isGatekeeper: true,
                pool: [
                    "το πρώτο μεγάλο πράγμα είναι η μάθηση να χρησιμοποιείς ξανά τη δική σου φωνή.",
                    "σκέψου πού ήσουν όταν ξεκίνησες αυτό το ταξίδι.",
                    "μελέτησε την τοποθεσία τους δεξιά μικρός ήχος θα μπορούσε ξανά κάτω."
                ],
                learningGoal: "Πέρασε το Τεστ Επιπέδου 4", habitTip: "Μείνε ήρεμος και πληκτρολόγησε σταθερά", descriptionOverride: "Τεστ επιπέδου 4"
            )
        ]
        
        let modules = [
            Module(id: "4.1", name: "Μικρές Λέξεις", description: "Top 30 λέξεις", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "Μεσαίες Λέξεις", description: "5+ γράμματα", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "Sprint Λέξεων", description: "Χτίστε ταχύτητα", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "Κυριαρχία Λέξεων", themeName: "Βιβλιοθήκη", description: "Αυξήστε την ταχύτητά σας", iconName: "text.word.spacing", modules: modules)
    }

    // MARK: - Stage 5: Sentence Fluency (Greek)
    private func generateGreekStage5() -> Stage {
        let lessons1 = [
            createLesson(id: "el.5.1.1", moduleId: "5.1", name: "Απλές Προτάσεις", order: 1, content: "Ο σκύλος γαβγίζει δυνατά. Η γάτα κοιμάται.",
                         learningGoal: "Κατάκτησε Απλές Προτάσεις", habitTip: "Διάβασε τη λέξη πρώτα, μετά πληκτρολόγησέ τη", descriptionOverride: "Εξάσκησε απλές προτάσεις"),
            createLesson(id: "el.5.1.2", moduleId: "5.1", name: "Ερωτήσεις", order: 2, content: "Πώς είσαι σήμερα; Τι ώρα είναι;",
                         learningGoal: "Κατάκτησε Ερωτήσεις", habitTip: "Μείνε ήρεμος και πληκτρολόγησε σταθερά", descriptionOverride: "Practice questions"),
            createLesson(id: "el.5.1.3", moduleId: "5.1", name: "Εντολές", order: 3, content: "Κλείσε την πόρτα παρακαλώ. Άναψε το φως.",
                         learningGoal: "Κατάκτησε Εντολές", habitTip: "Μείνε ήρεμος και πληκτρολόγησε σταθερά", descriptionOverride: "Practice commands")
        ]
        let lessons2 = [
            createLesson(id: "el.5.2.1", moduleId: "5.2", name: "Σύνθετες Προτάσεις", order: 1, content: "Πήγα στο μαγαζί και αγόρασα ψωμί.",
                         learningGoal: "Κατάκτησε Σύνθετες Προτάσεις", habitTip: "Μείνε ήρεμος και πληκτρολόγησε σταθερά", descriptionOverride: "Practice compound sentences"),
            createLesson(id: "el.5.2.2", moduleId: "5.2", name: "Πολύπλοκες Ιδέες", order: 2, content: "Αν και έβρεχε, αποφασίσαμε να βγούμε έξω.",
                         learningGoal: "Κατάκτησε Πολύπλοκες Ιδέες", habitTip: "Διάβασε τη λέξη πρώτα, μετά πληκτρολόγησέ τη", descriptionOverride: "Εξάσκησε απλές προτάσεις")
        ]
        let lessons3 = [
            createLesson(
                id: "el.5.4.1", 
                moduleId: "5.4", 
                name: "Τεστ Επιπέδου 5", 
                order: 1, 
                content: "Το TypeQuest είναι ο καλύτερος τρόπος.", 
                isGatekeeper: true,
                pool: [
                    "Το TypeQuest είναι ο καλύτερος τρόπος για να μάθεις πληκτρολόγηση. Με καθημερινή εξάσκηση θα βελτιώνεσαι.",
                    "Η γρήγορη καφέ αλεπού πηδά πάνω από το τεμπέλικο σκυλί. Μια γνωστή πρόταση.",
                    "Το διάβασμα και το γράψιμο είναι τα θεμέλια της ψηφιακής επικοινωνίας. Κατάκτησε το πληκτρολόγιο σήμερα."
                ],
                learningGoal: "Πέρασε το Τεστ Επιπέδου 5", habitTip: "Μείνε ήρεμος και πληκτρολόγησε σταθερά", descriptionOverride: "Τεστ επιπέδου 5"
            )
        ]
        
        let modules = [
            Module(id: "5.1", name: "Απλές Προτάσεις", description: "Βασική ροή", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "Σύνθετες Προτάσεις", description: "Συνδεδεμένες ιδέες", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "Εξάσκηση Παραγράφου", description: "Ροή πολλών προτάσεων", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "Ροή Προτάσεων", themeName: "Ωκεανός", description: "Γράψτε με ρυθμό", iconName: "text.alignleft", modules: modules)
    }

    // MARK: - Stage 6: Numbers & Symbols (Greek)
    private func generateGreekStage6() -> Stage {
        let lessons1 = [
            createLesson(id: "el.6.1.1", moduleId: "6.1", name: "Πλήκτρα 1 και 2", order: 1, content: "111 222 111 222 12 21 12 21",
                         learningGoal: "Κατάκτησε Πλήκτρα 1 και 2", habitTip: "Κράτα τα δάχτυλα στη βασική σειρά", descriptionOverride: "Εξάσκησε Πλήκτρα 1 και 2"),
            createLesson(id: "el.6.1.2", moduleId: "6.1", name: "Πλήκτρα 3 και 4", order: 2, content: "333 444 333 444 34 43 34 43",
                         learningGoal: "Κατάκτησε Πλήκτρα 3 και 4", habitTip: "Κράτα τα δάχτυλα στη βασική σειρά", descriptionOverride: "Εξάσκησε Πλήκτρα 3 και 4"),
            createLesson(id: "el.6.1.3", moduleId: "6.1", name: "Πλήκτρα 5 και 6", order: 3, content: "555 666 555 666 56 65 56 65",
                         learningGoal: "Κατάκτησε Πλήκτρα 5 και 6", habitTip: "Κράτα τα δάχτυλα στη βασική σειρά", descriptionOverride: "Εξάσκησε Πλήκτρα 5 και 6"),
            createLesson(id: "el.6.1.4", moduleId: "6.1", name: "Πλήκτρα 7 και 8", order: 4, content: "777 888 777 888 78 87 78 87",
                         learningGoal: "Κατάκτησε Πλήκτρα 7 και 8", habitTip: "Κράτα τα δάχτυλα στη βασική σειρά", descriptionOverride: "Εξάσκησε Πλήκτρα 7 και 8"),
            createLesson(id: "el.6.1.5", moduleId: "6.1", name: "Πλήκτρα 9 και 0", order: 5, content: "999 000 999 000 90 09 90 09",
                         learningGoal: "Κατάκτησε Πλήκτρα 9 και 0", habitTip: "Κράτα τα δάχτυλα στη βασική σειρά", descriptionOverride: "Εξάσκησε Πλήκτρα 9 και 0")
        ]
        let lessons2 = [
            createLesson(id: "el.6.2.1", moduleId: "6.2", name: "! @ # $", order: 1, content: "!!! @@@ ### $$$ !@#$",
                         learningGoal: "Κατάκτησε ! @ # $", habitTip: "Κράτα το Shift με το μικρό δάχτυλο", descriptionOverride: "Εξάσκησε ειδικούς χαρακτήρες"),
            createLesson(id: "el.6.2.2", moduleId: "6.2", name: "% ^ & *", order: 2, content: "%%% ^^^ &&& *** %^&*",
                         learningGoal: "Κατάκτησε % ^ & *", habitTip: "Κράτα το Shift με το μικρό δάχτυλο", descriptionOverride: "Εξάσκησε ειδικούς χαρακτήρες"),
            createLesson(id: "el.6.2.3", moduleId: "6.2", name: "( ) - =", order: 3, content: "((( ))) --- === ()-=",
                         learningGoal: "Κατάκτησε ( ) - =", habitTip: "Κράτα το Shift με το μικρό δάχτυλο", descriptionOverride: "Εξάσκησε ειδικούς χαρακτήρες")
        ]
        // Greek top row has ';'. Often special chars differ. But keeping standard QWERTY-like symbols for now as learning symbols is universal.
        
        let lessons3 = [
            createLesson(
                id: "el.6.4.1", 
                moduleId: "6.4", 
                name: "Τελικό Τεστ", 
                order: 1, 
                content: "Συγχαρητήρια! Φτάσατε στο Στάδιο 6.", 
                isGatekeeper: true,
                pool: [
                    "Συγχαρητήρια! Φτάσατε στο Στάδιο 6. Ας επαληθεύσουμε τα πάντα: 123 + 456 = 579. Αλήθεια; Ναι!",
                    "Τελικό έργο: (acc >= 98.0) && (wpm >= 50.0). Τεστ ολοκληρώθηκε: [OK].",
                    "Ειδικοί χαρακτήρες: !@#$%^&*()_+. Ολοκληρώσατε το πρόγραμμα σπουδών TypeQuest. Μπράβο!"
                ],
                learningGoal: "Πέρασε το Τελικό Τεστ", habitTip: "Σχεδόν τα κατάφερες – μείνε συγκεντρωμένος!", descriptionOverride: "Τελικό τεστ ολόκληρου του πληκτρολογίου"
            )
        ]
        
        let modules = [
            Module(id: "6.1", name: "Σειρά Αριθμών", description: "Πλήκτρα 0-9", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "Κοινά Σύμβολα", description: "Ειδικοί χαρακτήρες", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "Μικτή Εξάσκηση", description: "Όλα μαζί", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "Αριθμοί & Σύμβολα", themeName: "Εργαστήριο", description: "Κατακτήστε το πληκτρολόγιο", iconName: "number.circle.fill", modules: modules)
    }

    // MARK: - Hindi Curriculum
    private func generateHindiStages() -> [Stage] {
        return [
            generateHindiStage1(),
            generateHindiStage2(),
            generateHindiStage3(),
            generateHindiStage4(),
            generateHindiStage5(),
            generateHindiStage6()
        ]
    }


    
    private func generateHindiStage1() -> Stage {
        let lessons = [
            createLesson(id: "hi.1.1.1", moduleId: "1.1", name: "कुंजियाँ क और त", order: 1, content: "ककक ततत ककक ततत कत तक कत तक",
                         learningGoal: "सीखें कुंजियाँ क और त", habitTip: "अपनी उंगलियाँ होम रो पर रखें", descriptionOverride: "अभ्यास करें कुंजियाँ क और त"),
            createLesson(
                id: "hi.1.4.1", 
                moduleId: "1.4", 
                name: "स्तर परीक्षण 1", 
                order: 2, 
                content: "ककक ततत ररर कतरक", 
                isGatekeeper: true,
                pool: [
                    "ककक ततत ररर कतरक। ररर ककक ततत। कतरक ररर ककक।",
                    "ररर ककक ततत कतरक। ककक ररर ततत। कतरक ककक ररर।",
                    "ततत ककक ररर कतरक। ररर ततत ककक। कतरक ररर ततत।"
                ],
                learningGoal: "पास करें स्तर परीक्षण 1", habitTip: "शांत रहें और समान रूप से टाइप करें", descriptionOverride: "स्तर परीक्षा 1"
            )
        ]
        return Stage(id: 1, name: "आधार पंक्ति की नींव", themeName: "नदी", description: "मध्य पंक्ति की कुंजियों में महारत हासिल करें", iconName: "hand.raised.fill", modules: [
            Module(id: "1.1", name: "बाएं हाथ के एंकर", description: "बाएं हाथ की स्थिति", stageId: 1, order: 1, lessons: lessons)
        ])
    }
    
    private func generateHindiStage2() -> Stage {
        let lessons = [
            createLesson(
                id: "hi.2.4.1", 
                moduleId: "2.4", 
                name: "स्तर परीक्षण 2", 
                order: 1, 
                content: "तेज भूरी लोमड़ी कूदती है", 
                isGatekeeper: true,
                pool: [
                    "तेज भूरी लोमड़ी आलसी कुत्ते के ऊपर से कूदती है। जब आप तेजी से टाइप करते हैं तो दुनिया छोटी होती है।",
                    "टाइपिंग सफलता के लिए प्राथमिकता है। रास्ता लंबा है लेकिन परिणाम अद्वितीय है।",
                    "मैं सटीकता और गति के साथ लिखना चाहता हूं। आज हर युवा सीख सकता है।"
                ],
                learningGoal: "पास करें स्तर परीक्षण 2", habitTip: "शांत रहें और समान रूप से टाइप करें", descriptionOverride: "स्तर परीक्षा 2"
            )
        ]
        return Stage(id: 2, name: "शीर्ष पंक्ति विस्तार", themeName: "पहाड़", description: "ऊपरी पंक्ति तक पहुँचें", iconName: "arrow.up.circle.fill", modules: [
            Module(id: "2.1", name: "शीर्ष पंक्ति महारत", description: "ऊपरी पंक्ति का प्रवाह", stageId: 2, order: 1, lessons: lessons)
        ])
    }

    // MARK: - Stage 3: Bottom Row & N-Grams (Hindi)
    private func generateHindiStage3() -> Stage {
        // Hindi (Inscript) Bottom Row: ? . , M N B V C X Z ? (Roughly)
        // We will focus on characters commonly found on bottom row if possible, or just common letters.
        // Let's us common Hindi letters not yet covered.
        // Stage 1: k, t (Home row).
        // Let's add more consonants.
        
        let lessons1 = [
            createLesson(id: "hi.3.1.1", moduleId: "3.1", name: "वर्ण प और न", order: 1, content: "पपप ननन पपप ननन पन नप पानी",
                         learningGoal: "सीखें वर्ण प और न", habitTip: "अपनी उंगलियाँ होम रो पर रखें", descriptionOverride: "अभ्यास करें वर्ण प और न"),
            createLesson(id: "hi.3.1.2", moduleId: "3.1", name: "वर्ण म और य", order: 2, content: "ममम ययय ममम ययय मय यम माँ",
                         learningGoal: "सीखें वर्ण म और य", habitTip: "अपनी उंगलियाँ होम रो पर रखें", descriptionOverride: "अभ्यास करें वर्ण म और य"),
            createLesson(id: "hi.3.1.3", moduleId: "3.1", name: "वर्ण र और ल", order: 3, content: "ररर ललल ररर ललल रल लर लाल",
                         learningGoal: "सीखें वर्ण र और ल", habitTip: "अपनी उंगलियाँ होम रो पर रखें", descriptionOverride: "अभ्यास करें वर्ण र और ल")
        ]
        let lessons2 = [
            createLesson(id: "hi.3.2.1", moduleId: "3.2", name: "वर्ण स और ह", order: 1, content: "ससस हहह ससस हहह सह हस सही",
                         learningGoal: "सीखें वर्ण स और ह", habitTip: "अपनी उंगलियाँ होम रो पर रखें", descriptionOverride: "अभ्यास करें वर्ण स और ह"),
            createLesson(id: "hi.3.2.2", moduleId: "3.2", name: "अल्पविराम और पूर्ण विराम", order: 2, content: ",,, ।।। ,,, ।।। ,। ।, एक, दो।",
                         learningGoal: "सीखें अल्पविराम और पूर्ण विराम", habitTip: "अपनी उंगलियाँ होम रो पर रखें", descriptionOverride: "अभ्यास करें अल्पविराम और पूर्ण विराम"),
            createLesson(id: "hi.3.2.3", moduleId: "3.2", name: "मात्राएँ", order: 3, content: "ााा ििि ीीी ुुु ा ि ी ु",
                         learningGoal: "सीखें मात्राएँ", habitTip: "अपनी उंगलियाँ होम रो पर रखें", descriptionOverride: "अभ्यास करें मात्राएँ")// Vowel marks
        ]
        let lessons3 = [
            createLesson(id: "hi.3.3.1", moduleId: "3.3", name: "सामान्य जोड़े: क, की", order: 1, content: "क क क की की की का के को",
                         learningGoal: "सीखें सामान्य जोड़े: क, की", habitTip: "अपनी उंगलियाँ होम रो पर रखें", descriptionOverride: "अभ्यास करें सामान्य जोड़े: क, की"),
            createLesson(id: "hi.3.3.2", moduleId: "3.3", name: "सामान्य जोड़े: ह, है", order: 2, content: "ह ह ह है है है हो ही",
                         learningGoal: "सीखें सामान्य जोड़े: ह, है", habitTip: "अपनी उंगलियाँ होम रो पर रखें", descriptionOverride: "अभ्यास करें सामान्य जोड़े: ह, है"),
            createLesson(
                id: "hi.3.4.1", 
                moduleId: "3.4", 
                name: "स्तर परीक्षण 3", 
                order: 1, 
                content: "तेज भूरी लोमड़ी", 
                isGatekeeper: true,
                pool: [
                    "तेज भूरी लोमड़ी जंगल में दौड़ रही है। दुनिया सुंदर है।",
                    "मैं एक अच्छा सेब खाना चाहता हूं। चलो कल समुद्र तट पर चलते हैं।",
                    "पार्टी में संगीत बहुत तेज बज रहा है। मुझे दोस्तों के साथ नाचना पसंद है।"
                ],
                learningGoal: "पास करें स्तर परीक्षण 3", habitTip: "शांत रहें और समान रूप से टाइप करें", descriptionOverride: "स्तर परीक्षा 3"
            )
        ]
        
        let modules = [
            Module(id: "3.1", name: "निचली पंक्ति बायां", description: "वर्ण अभ्यास १", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "निचली पंक्ति दायां", description: "वर्ण अभ्यास २", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "सामान्य एन-ग्राम", description: "अक्षर जोड़े", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "निचली पंक्ति और पैटर्न", themeName: "नदी", description: "वर्णमाला पूरी करें", iconName: "arrow.down.circle.fill", modules: modules)
    }

    // MARK: - Stage 4: Word Mastery (Hindi)
    private func generateHindiStage4() -> Stage {
        let lessons1 = [
            createLesson(id: "hi.4.1.1", moduleId: "4.1", name: "सामान्य शब्द 1", order: 1, content: "है के का और से कि में एक नहीं",
                         learningGoal: "सीखें सामान्य शब्द 1", habitTip: "पहले शब्द पढ़ें, फिर टाइप करें", descriptionOverride: "सामान्य शब्दों का अभ्यास करें"),
            createLesson(id: "hi.4.1.2", moduleId: "4.1", name: "सामान्य शब्द 2", order: 2, content: "यह को पर क्या कर भी तो लिए",
                         learningGoal: "सीखें सामान्य शब्द 2", habitTip: "पहले शब्द पढ़ें, फिर टाइप करें", descriptionOverride: "सामान्य शब्दों का अभ्यास करें"),
            createLesson(id: "hi.4.1.3", moduleId: "4.1", name: "सामान्य शब्द 3", order: 3, content: "हैं मैं जो वह इस या सा आप",
                         learningGoal: "सीखें सामान्य शब्द 3", habitTip: "पहले शब्द पढ़ें, फिर टाइप करें", descriptionOverride: "सामान्य शब्दों का अभ्यास करें")
        ]
        let lessons2 = [
            createLesson(id: "hi.4.2.1", moduleId: "4.2", name: "लंबे शब्द 1", order: 1, content: "लेकिन उनके अपने द्वारा किसी",
                         learningGoal: "सीखें लंबे शब्द 1", habitTip: "गति से पहले सटीकता पर ध्यान दें", descriptionOverride: "लंबे शब्दों का अभ्यास करें"),
            createLesson(id: "hi.4.2.2", moduleId: "4.2", name: "लंबे शब्द 2", order: 2, content: "सकता वाले मुझे एवं तथा",
                         learningGoal: "सीखें लंबे शब्द 2", habitTip: "गति से पहले सटीकता पर ध्यान दें", descriptionOverride: "लंबे शब्दों का अभ्यास करें"),
            createLesson(id: "hi.4.2.3", moduleId: "4.2", name: "लंबे शब्द 3", order: 3, content: "जीवन भारत समय काम लोग",
                         learningGoal: "सीखें लंबे शब्द 3", habitTip: "गति से पहले सटीकता पर ध्यान दें", descriptionOverride: "लंबे शब्दों का अभ्यास करें")
        ]
        let lessons3 = [
            createLesson(id: "hi.4.3.1", moduleId: "4.3", name: "स्प्रिंट 30 सेकंड", order: 1, content: "है के का और से कि में एक नहीं यह को पर",
                         learningGoal: "सीखें स्प्रिंट 30 सेकंड", habitTip: "पहले शब्द पढ़ें, फिर टाइप करें", descriptionOverride: "सामान्य शब्दों का अभ्यास करें"),
            createLesson(
                id: "hi.4.4.1", 
                moduleId: "4.4", 
                name: "स्तर परीक्षण 4", 
                order: 1, 
                content: "पहली बड़ी बात सीखना है", 
                isGatekeeper: true,
                pool: [
                    "पहली बड़ी बात अपनी खुद की आवाज का फिर से उपयोग करना सीखना है।",
                    "इस बारे में सोचें कि जब आपने यह यात्रा शुरू की थी तब आप कहां थे।",
                    "उनके स्थान का अध्ययन करें सही छोटी ध्वनि फिर से नीचे हो सकती है।"
                ],
                learningGoal: "पास करें स्तर परीक्षण 4", habitTip: "शांत रहें और समान रूप से टाइप करें", descriptionOverride: "स्तर परीक्षा 4"
            )
        ]
        
        let modules = [
            Module(id: "4.1", name: "छोटे शब्द", description: "शीर्ष 30 शब्द", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "मध्यम शब्द", description: "5+ अक्षर", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "शब्द स्प्रिंट", description: "गति बढ़ाएं", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "शब्द महारत", themeName: "पुस्तकालय", description: "अपनी गति बढ़ाएं", iconName: "text.word.spacing", modules: modules)
    }

    // MARK: - Stage 5: Sentence Fluency (Hindi)
    private func generateHindiStage5() -> Stage {
        let lessons1 = [
            createLesson(id: "hi.5.1.1", moduleId: "5.1", name: "सरल वाक्य", order: 1, content: "कुत्ता जोर से भौंकता है। बिल्ली सो रही है।",
                         learningGoal: "सीखें सरल वाक्य", habitTip: "पहले शब्द पढ़ें, फिर टाइप करें", descriptionOverride: "सरल वाक्यों का अभ्यास करें"),
            createLesson(id: "hi.5.1.2", moduleId: "5.1", name: "प्रश्न", order: 2, content: "आज आप कैसे हैं? अभी समय क्या हुआ है?",
                         learningGoal: "सीखें प्रश्न", habitTip: "शांत रहें और समान रूप से टाइप करें", descriptionOverride: "Practice questions"),
            createLesson(id: "hi.5.1.3", moduleId: "5.1", name: "आदेश", order: 3, content: "कृपया दरवाजा बंद करें। लाइट चालू करें।",
                         learningGoal: "सीखें आदेश", habitTip: "शांत रहें और समान रूप से टाइप करें", descriptionOverride: "Practice commands")
        ]
        let lessons2 = [
            createLesson(id: "hi.5.2.1", moduleId: "5.2", name: "मिश्रित वाक्य", order: 1, content: "मैं दुकान गया और रोटी खरीदी।",
                         learningGoal: "सीखें मिश्रित वाक्य", habitTip: "पहले शब्द पढ़ें, फिर टाइप करें", descriptionOverride: "सरल वाक्यों का अभ्यास करें"),
            createLesson(id: "hi.5.2.2", moduleId: "5.2", name: "जटिल विचार", order: 2, content: "हालांकि बारिश हो रही थी, हमने बाहर जाने का फैसला किया।",
                         learningGoal: "सीखें जटिल विचार", habitTip: "पहले शब्द पढ़ें, फिर टाइप करें", descriptionOverride: "सरल वाक्यों का अभ्यास करें")
        ]
        let lessons3 = [
            createLesson(
                id: "hi.5.4.1", 
                moduleId: "5.4", 
                name: "स्तर परीक्षण 5", 
                order: 1, 
                content: "TypeQuest सीखने का सबसे अच्छा तरीका है।", 
                isGatekeeper: true,
                pool: [
                    "TypeQuest टाइपिंग सीखने का सबसे अच्छा तरीका है। दैनिक अभ्यास के साथ आप बेहतर होंगे।",
                    "तेज भूरी लोमड़ी आलसी कुत्ते के ऊपर से कूदती है। एक प्रसिद्ध वाक्य।",
                    "पढ़ना और लिखना डिजिटल संचार की नींव हैं। आज ही कीबोर्ड में महारत हासिल करें।"
                ],
                learningGoal: "पास करें स्तर परीक्षण 5", habitTip: "शांत रहें और समान रूप से टाइप करें", descriptionOverride: "स्तर परीक्षा 5"
            )
        ]
        
        let modules = [
            Module(id: "5.1", name: "सरल वाक्य", description: "मूल प्रवाह", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "मिश्रित वाक्य", description: "जुड़े हुए विचार", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "अनुच्छेद अभ्यास", description: "बहु-वाक्य प्रवाह", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "वाक्य प्रवाह", themeName: "महासागर", description: "लय के साथ लिखें", iconName: "text.alignleft", modules: modules)
    }

    // MARK: - Stage 6: Numbers & Symbols (Hindi)
    private func generateHindiStage6() -> Stage {
        // Standard numerals often used in Hindi typing (Arabic numerals 0-9)
        let lessons1 = [
            createLesson(id: "hi.6.1.1", moduleId: "6.1", name: "कुंजियाँ 1 और 2", order: 1, content: "111 222 111 222 12 21 12 21",
                         learningGoal: "सीखें कुंजियाँ 1 और 2", habitTip: "अपनी उंगलियाँ होम रो पर रखें", descriptionOverride: "अभ्यास करें कुंजियाँ 1 और 2"),
            createLesson(id: "hi.6.1.2", moduleId: "6.1", name: "कुंजियाँ 3 और 4", order: 2, content: "333 444 333 444 34 43 34 43",
                         learningGoal: "सीखें कुंजियाँ 3 और 4", habitTip: "अपनी उंगलियाँ होम रो पर रखें", descriptionOverride: "अभ्यास करें कुंजियाँ 3 और 4"),
            createLesson(id: "hi.6.1.3", moduleId: "6.1", name: "कुंजियाँ 5 और 6", order: 3, content: "555 666 555 666 56 65 56 65",
                         learningGoal: "सीखें कुंजियाँ 5 और 6", habitTip: "अपनी उंगलियाँ होम रो पर रखें", descriptionOverride: "अभ्यास करें कुंजियाँ 5 और 6"),
            createLesson(id: "hi.6.1.4", moduleId: "6.1", name: "कुंजियाँ 7 और 8", order: 4, content: "777 888 777 888 78 87 78 87",
                         learningGoal: "सीखें कुंजियाँ 7 और 8", habitTip: "अपनी उंगलियाँ होम रो पर रखें", descriptionOverride: "अभ्यास करें कुंजियाँ 7 और 8"),
            createLesson(id: "hi.6.1.5", moduleId: "6.1", name: "कुंजियाँ 9 और 0", order: 5, content: "999 000 999 000 90 09 90 09",
                         learningGoal: "सीखें कुंजियाँ 9 और 0", habitTip: "अपनी उंगलियाँ होम रो पर रखें", descriptionOverride: "अभ्यास करें कुंजियाँ 9 और 0")
        ]
        let lessons2 = [
            createLesson(id: "hi.6.2.1", moduleId: "6.2", name: "! @ # $", order: 1, content: "!!! @@@ ### $$$ !@#$",
                         learningGoal: "सीखें ! @ # $", habitTip: "छोटी उंगली से Shift दबाए रखें", descriptionOverride: "विशेष वर्णों का अभ्यास करें"),
            createLesson(id: "hi.6.2.2", moduleId: "6.2", name: "% ^ & *", order: 2, content: "%%% ^^^ &&& *** %^&*",
                         learningGoal: "सीखें % ^ & *", habitTip: "छोटी उंगली से Shift दबाए रखें", descriptionOverride: "विशेष वर्णों का अभ्यास करें"),
            createLesson(id: "hi.6.2.3", moduleId: "6.2", name: "( ) - =", order: 3, content: "((( ))) --- === ()-=",
                         learningGoal: "सीखें ( ) - =", habitTip: "छोटी उंगली से Shift दबाए रखें", descriptionOverride: "विशेष वर्णों का अभ्यास करें")
        ]
        let lessons3 = [
            createLesson(
                id: "hi.6.4.1", 
                moduleId: "6.4", 
                name: "अंतिम परीक्षण", 
                order: 1, 
                content: "बधाई हो! आप स्टेज 6 तक पहुँच गए हैं।", 
                isGatekeeper: true,
                pool: [
                    "बधाई हो! आप स्टेज 6 तक पहुँच गए हैं। आइए सब कुछ सत्यापित करें: 123 + 456 = 579। सच? हाँ!",
                    "अंतिम परियोजना: (acc >= 98.0) && (wpm >= 50.0)। परीक्षण पूरा हुआ: [ठीक]।",
                    "विशेष वर्ण: !@#$%^&*()_+. आपने TypeQuest पाठ्यक्रम पूरा कर लिया है। बहुत बढ़िया!"
                ],
                learningGoal: "पास करें अंतिम परीक्षण", habitTip: "लगभग हो गया – ध्यान केंद्रित रखें!", descriptionOverride: "संपूर्ण कीबोर्ड की अंतिम परीक्षा"
            )
        ]
        
        let modules = [
            Module(id: "6.1", name: "संख्या पंक्ति", description: "कुंजियाँ 0-9", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "सामान्य प्रतीक", description: "विशेष वर्ण", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "मिश्रित अभ्यास", description: "सभी संयुक्त", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "संख्याएँ और प्रतीक", themeName: "प्रयोगशाला", description: "कीबोर्ड में महारत हासिल करें", iconName: "number.circle.fill", modules: modules)
    }

    // MARK: - Malay Curriculum
    private func generateMalayStages() -> [Stage] {
        return [
            generateMalayStage1(),
            generateMalayStage2(),
            generateMalayStage3(),
            generateMalayStage4(),
            generateMalayStage5(),
            generateMalayStage6()
        ]
    }
    
    private func generateMalayStage1() -> Stage {
        let lessons = [
            createLesson(id: "ms.1.1.1", moduleId: "1.1", name: "Kunci A dan S", order: 1, content: "aaa sss aaa sss as sa as sa",
                         learningGoal: "Kuasai Kunci A dan S", habitTip: "Letak jari pada baris asas", descriptionOverride: "Latih Kunci A dan S"),
            createLesson(
                id: "ms.1.4.1", 
                moduleId: "1.4", 
                name: "Ujian Tahap 1", 
                order: 2, 
                content: "asdf jkl; alas sala sal", 
                isGatekeeper: true,
                pool: [
                    "asdf jkl; alas sala sal. sal sala alas. salla sal sala.",
                    "sala alas salla. asdf jkl; salla sal alas. sala sal alas salla.",
                    "sala alas salla. asdf jkl; salla sala sal. sala salla sala sal."
                ],
                learningGoal: "Lulus Ujian Tahap 1", habitTip: "Kekal tenang dan taip dengan sekata", descriptionOverride: "Ujian tahap 1"
            )
        ]
        return Stage(id: 1, name: "Asas Barisan Utama", themeName: "Hutan", description: "Kuasai barisan tengah", iconName: "hand.raised.fill", modules: [
            Module(id: "1.1", name: "Sauh Tangan Kiri", description: "Kedudukan tangan kiri", stageId: 1, order: 1, lessons: lessons)
        ])
    }
    
    private func generateMalayStage2() -> Stage {
        let lessons = [
            createLesson(
                id: "ms.2.4.1", 
                moduleId: "2.4", 
                name: "Ujian Tahap 2", 
                order: 1, 
                content: "musang coklat yang pantas melompat", 
                isGatekeeper: true,
                pool: [
                    "musang coklat yang pantas melompat melangkaui anjing yang malas. dunia ini kecil apabila anda menaip dengan pantas.",
                    "menaip adalah keutamaan untuk kejayaan. jalannya panjang tetapi hasilnya unik.",
                    "saya mahu dapat menaip dengan ketepatan dan kepantasan. semua anak muda boleh belajar hari ini."
                ],
                learningGoal: "Lulus Ujian Tahap 2", habitTip: "Kekal tenang dan taip dengan sekata", descriptionOverride: "Ujian tahap 2"
            )
        ]
        return Stage(id: 2, name: "Pengembangan Barisan Atas", themeName: "Gunung", description: "Capai barisan atas", iconName: "arrow.up.circle.fill", modules: [
            Module(id: "2.1", name: "Kuasai Barisan Atas", description: "Aliran barisan atas", stageId: 2, order: 1, lessons: lessons)
        ])
    }

    // MARK: - Stage 3: Bottom Row & N-Grams (Malay)
    private func generateMalayStage3() -> Stage {
        let lessons1 = [
            createLesson(id: "ms.3.1.1", moduleId: "3.1", name: "Kunci Z dan X", order: 1, content: "zzz xxx zzz xxx zx xz zon xilofon",
                         learningGoal: "Kuasai Kunci Z dan X", habitTip: "Letak jari pada baris asas", descriptionOverride: "Latih Kunci Z dan X"),
            createLesson(id: "ms.3.1.2", moduleId: "3.1", name: "Kunci C dan V", order: 2, content: "ccc vvv ccc vvv cv vc cara visi",
                         learningGoal: "Kuasai Kunci C dan V", habitTip: "Letak jari pada baris asas", descriptionOverride: "Latih Kunci C dan V"),
            createLesson(id: "ms.3.1.3", moduleId: "3.1", name: "Kunci B", order: 3, content: "bbb bbb bob baik baru biru",
                         learningGoal: "Kuasai Kunci B", habitTip: "Letak jari pada baris asas", descriptionOverride: "Latih Kunci B")
        ]
        let lessons2 = [
            createLesson(id: "ms.3.2.1", moduleId: "3.2", name: "Kunci N dan M", order: 1, content: "nnn mmm nnn mmm nm mn nama mana",
                         learningGoal: "Kuasai Kunci N dan M", habitTip: "Letak jari pada baris asas", descriptionOverride: "Latih Kunci N dan M"),
            createLesson(id: "ms.3.2.2", moduleId: "3.2", name: "Koma dan Titik", order: 2, content: ",,, ... ,,, ... ,. ., ya, tidak.",
                         learningGoal: "Kuasai Koma dan Titik", habitTip: "Letak jari pada baris asas", descriptionOverride: "Latih Koma dan Titik"),
            createLesson(id: "ms.3.2.3", moduleId: "3.2", name: "Sengkang", order: 3, content: "/// /// dan/atau ya/tidak",
                         learningGoal: "Kuasai Sengkang", habitTip: "Letak jari pada baris asas", descriptionOverride: "Latih Sengkang")// Slash
        ]
        let lessons3 = [
            createLesson(id: "ms.3.3.1", moduleId: "3.3", name: "Pasangan Biasa: an, sa", order: 1, content: "an an an sa sa sa yang ada",
                         learningGoal: "Kuasai Pasangan Biasa: an, sa", habitTip: "Letak jari pada baris asas", descriptionOverride: "Latih Pasangan Biasa: an, sa"),
            createLesson(id: "ms.3.3.2", moduleId: "3.3", name: "Pasangan Biasa: di, ke", order: 2, content: "di di di ke ke ke itu ini",
                         learningGoal: "Kuasai Pasangan Biasa: di, ke", habitTip: "Letak jari pada baris asas", descriptionOverride: "Latih Pasangan Biasa: di, ke"),
            createLesson(
                id: "ms.3.4.1", 
                moduleId: "3.4", 
                name: "Ujian Tahap 3", 
                order: 1, 
                content: "musang coklat yang pantas", 
                isGatekeeper: true,
                pool: [
                    "musang coklat yang pantas melompat. dunia ini indah.",
                    "saya mahu makan nasi lemak. mari kita pergi ke pantai esok.",
                    "muzik sangat kuat di pesta itu. saya suka menari dengan kawan-kawan."
                ],
                learningGoal: "Lulus Ujian Tahap 3", habitTip: "Kekal tenang dan taip dengan sekata", descriptionOverride: "Ujian tahap 3"
            )
        ]
        
        let modules = [
            Module(id: "3.1", name: "Barisan Bawah Kiri", description: "Kunci Z X C V B", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "Barisan Bawah Kanan", description: "Kunci N M , . /", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "N-Gram Biasa", description: "Kuasai pasangan huruf", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "Barisan Bawah & Corak", themeName: "Sungai", description: "Lengkapkan abjad", iconName: "arrow.down.circle.fill", modules: modules)
    }

    // MARK: - Stage 4: Word Mastery (Malay)
    private func generateMalayStage4() -> Stage {
        let lessons1 = [
            createLesson(id: "ms.4.1.1", moduleId: "4.1", name: "Perkataan Lazim 1", order: 1, content: "dan yang saya di ke itu ini untuk",
                         learningGoal: "Kuasai Perkataan Lazim 1", habitTip: "Baca perkataan dahulu, kemudian taip", descriptionOverride: "Latih perkataan lazim"),
            createLesson(id: "ms.4.1.2", moduleId: "4.1", name: "Perkataan Lazim 2", order: 2, content: "dengan tidak ada pada dia orang kita",
                         learningGoal: "Kuasai Perkataan Lazim 2", habitTip: "Baca perkataan dahulu, kemudian taip", descriptionOverride: "Latih perkataan lazim"),
            createLesson(id: "ms.4.1.3", moduleId: "4.1", name: "Perkataan Lazim 3", order: 3, content: "akan dari mereka hari apa sudah jika",
                         learningGoal: "Kuasai Perkataan Lazim 3", habitTip: "Baca perkataan dahulu, kemudian taip", descriptionOverride: "Latih perkataan lazim")
        ]
        let lessons2 = [
            createLesson(id: "ms.4.2.1", moduleId: "4.2", name: "Perkataan Panjang 1", order: 1, content: "mereka kerana apabila dalam",
                         learningGoal: "Kuasai Perkataan Panjang 1", habitTip: "Fokus pada ketepatan sebelum kelajuan", descriptionOverride: "Latih perkataan panjang"),
            createLesson(id: "ms.4.2.2", moduleId: "4.2", name: "Perkataan Panjang 2", order: 2, content: "seperti menjadi boleh bukan",
                         learningGoal: "Kuasai Perkataan Panjang 2", habitTip: "Fokus pada ketepatan sebelum kelajuan", descriptionOverride: "Latih perkataan panjang"),
            createLesson(id: "ms.4.2.3", moduleId: "4.2", name: "Perkataan Panjang 3", order: 3, content: "daripada segala antara tempat",
                         learningGoal: "Kuasai Perkataan Panjang 3", habitTip: "Fokus pada ketepatan sebelum kelajuan", descriptionOverride: "Latih perkataan panjang")
        ]
        let lessons3 = [
            createLesson(id: "ms.4.3.1", moduleId: "4.3", name: "Pecutan 30 Saat", order: 1, content: "dan yang saya di ke itu ini untuk dengan tidak",
                         learningGoal: "Kuasai Pecutan 30 Saat", habitTip: "Baca perkataan dahulu, kemudian taip", descriptionOverride: "Latih perkataan lazim"),
            createLesson(
                id: "ms.4.4.1", 
                moduleId: "4.4", 
                name: "Ujian Tahap 4", 
                order: 1, 
                content: "perkara besar pertama adalah belajar", 
                isGatekeeper: true,
                pool: [
                    "perkara besar pertama adalah belajar menggunakan suara anda sendiri lagi.",
                    "fikirkan tentang di mana anda berada apabila anda memulakan perjalanan ini.",
                    "kaji tempat mereka kanan kecil bunyi boleh lagi bawah."
                ],
                learningGoal: "Lulus Ujian Tahap 4", habitTip: "Kekal tenang dan taip dengan sekata", descriptionOverride: "Ujian tahap 4"
            )
        ]
        
        let modules = [
            Module(id: "4.1", name: "Perkataan Pendek", description: "Top 30 perkataan", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "Perkataan Sederhana", description: "5+ huruf", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "Pecutan Perkataan", description: "Bina kelajuan", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "Penguasaan Perkataan", themeName: "Perpustakaan", description: "Tingkatkan kelajuan anda", iconName: "text.word.spacing", modules: modules)
    }

    // MARK: - Stage 5: Sentence Fluency (Malay)
    private func generateMalayStage5() -> Stage {
        let lessons1 = [
            createLesson(id: "ms.5.1.1", moduleId: "5.1", name: "Ayat Mudah", order: 1, content: "Anjing menyalak kuat. Kucing tidur.",
                         learningGoal: "Kuasai Ayat Mudah", habitTip: "Baca perkataan dahulu, kemudian taip", descriptionOverride: "Latih ayat mudah"),
            createLesson(id: "ms.5.1.2", moduleId: "5.1", name: "Soalan", order: 2, content: "Apa khabar hari ini? Pukul berapa?",
                         learningGoal: "Kuasai Soalan", habitTip: "Kekal tenang dan taip dengan sekata", descriptionOverride: "Practice questions"),
            createLesson(id: "ms.5.1.3", moduleId: "5.1", name: "Arahan", order: 3, content: "Sila tutup pintu. Buka lampu.",
                         learningGoal: "Kuasai Arahan", habitTip: "Baca perkataan dahulu, kemudian taip", descriptionOverride: "Latih ayat mudah")
        ]
        let lessons2 = [
            createLesson(id: "ms.5.2.1", moduleId: "5.2", name: "Ayat Majmuk", order: 1, content: "Saya pergi ke kedai dan membeli roti.",
                         learningGoal: "Kuasai Ayat Majmuk", habitTip: "Baca perkataan dahulu, kemudian taip", descriptionOverride: "Latih ayat mudah"),
            createLesson(id: "ms.5.2.2", moduleId: "5.2", name: "Idea Kompleks", order: 2, content: "Walaupun hujan, kami memutuskan untuk keluar.",
                         learningGoal: "Kuasai Idea Kompleks", habitTip: "Baca perkataan dahulu, kemudian taip", descriptionOverride: "Latih ayat mudah")
        ]
        let lessons3 = [
            createLesson(
                id: "ms.5.4.1", 
                moduleId: "5.4", 
                name: "Ujian Tahap 5", 
                order: 1, 
                content: "TypeQuest adalah cara terbaik untuk belajar.", 
                isGatekeeper: true,
                pool: [
                    "TypeQuest adalah cara terbaik untuk belajar menaip. Dengan latihan harian anda akan bertambah baik.",
                    "Musang coklat yang pantas melompat melangkaui anjing yang malas. Satu ayat terkenal.",
                    "Membaca dan menulis adalah asas komunikasi digital. Kuasai papan kekunci hari ini."
                ],
                learningGoal: "Lulus Ujian Tahap 5", habitTip: "Kekal tenang dan taip dengan sekata", descriptionOverride: "Ujian tahap 5"
            )
        ]
        
        let modules = [
            Module(id: "5.1", name: "Ayat Mudah", description: "Aliran asas", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "Ayat Majmuk", description: "Idea bersambung", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "Latihan Perenggan", description: "Aliran pelbagai ayat", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "Kelancaran Ayat", themeName: "Lautan", description: "Tulis dengan ritma", iconName: "text.alignleft", modules: modules)
    }

    // MARK: - Stage 6: Numbers & Symbols (Malay)
    private func generateMalayStage6() -> Stage {
        let lessons1 = [
            createLesson(id: "ms.6.1.1", moduleId: "6.1", name: "Kunci 1 dan 2", order: 1, content: "111 222 111 222 12 21 12 21",
                         learningGoal: "Kuasai Kunci 1 dan 2", habitTip: "Letak jari pada baris asas", descriptionOverride: "Latih Kunci 1 dan 2"),
            createLesson(id: "ms.6.1.2", moduleId: "6.1", name: "Kunci 3 dan 4", order: 2, content: "333 444 333 444 34 43 34 43",
                         learningGoal: "Kuasai Kunci 3 dan 4", habitTip: "Letak jari pada baris asas", descriptionOverride: "Latih Kunci 3 dan 4"),
            createLesson(id: "ms.6.1.3", moduleId: "6.1", name: "Kunci 5 dan 6", order: 3, content: "555 666 555 666 56 65 56 65",
                         learningGoal: "Kuasai Kunci 5 dan 6", habitTip: "Letak jari pada baris asas", descriptionOverride: "Latih Kunci 5 dan 6"),
            createLesson(id: "ms.6.1.4", moduleId: "6.1", name: "Kunci 7 dan 8", order: 4, content: "777 888 777 888 78 87 78 87",
                         learningGoal: "Kuasai Kunci 7 dan 8", habitTip: "Letak jari pada baris asas", descriptionOverride: "Latih Kunci 7 dan 8"),
            createLesson(id: "ms.6.1.5", moduleId: "6.1", name: "Kunci 9 dan 0", order: 5, content: "999 000 999 000 90 09 90 09",
                         learningGoal: "Kuasai Kunci 9 dan 0", habitTip: "Letak jari pada baris asas", descriptionOverride: "Latih Kunci 9 dan 0")
        ]
        let lessons2 = [
            createLesson(id: "ms.6.2.1", moduleId: "6.2", name: "! @ # $", order: 1, content: "!!! @@@ ### $$$ !@#$",
                         learningGoal: "Kuasai ! @ # $", habitTip: "Tahan Shift dengan jari kelingking", descriptionOverride: "Latih aksara khas"),
            createLesson(id: "ms.6.2.2", moduleId: "6.2", name: "% ^ & *", order: 2, content: "%%% ^^^ &&& *** %^&*",
                         learningGoal: "Kuasai % ^ & *", habitTip: "Tahan Shift dengan jari kelingking", descriptionOverride: "Latih aksara khas"),
            createLesson(id: "ms.6.2.3", moduleId: "6.2", name: "( ) - =", order: 3, content: "((( ))) --- === ()-=",
                         learningGoal: "Kuasai ( ) - =", habitTip: "Tahan Shift dengan jari kelingking", descriptionOverride: "Latih aksara khas")
        ]
        let lessons3 = [
            createLesson(
                id: "ms.6.4.1", 
                moduleId: "6.4", 
                name: "Ujian Akhir", 
                order: 1, 
                content: "Tahniah! Anda telah mencapai Peringkat 6.", 
                isGatekeeper: true,
                pool: [
                    "Tahniah! Anda telah mencapai Peringkat 6. Mari kita sahkan semuanya: 123 + 456 = 579. Benar? Ya!",
                    "Projek akhir: (acc >= 98.0) && (wpm >= 50.0). Ujian selesai: [OK].",
                    "Aksara khas: !@#$%^&*()_+. Anda telah menyelesaikan kurikulum TypeQuest. Syabas!"
                ],
                learningGoal: "Lulus Ujian Akhir", habitTip: "Hampir siap – teruskan fokus!", descriptionOverride: "Ujian akhir papan kekunci lengkap"
            )
        ]
        
        let modules = [
            Module(id: "6.1", name: "Barisan Nombor", description: "Kunci 0-9", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "Simbol Biasa", description: "Aksara khas", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "Latihan Campuran", description: "Semua digabungkan", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "Nombor & Simbol", themeName: "Makmal", description: "Kuasai papan kekunci", iconName: "number.circle.fill", modules: modules)
    }

    // MARK: - Tagalog Curriculum
    private func generateTagalogStages() -> [Stage] {
        return [
            generateTagalogStage1(),
            generateTagalogStage2(),
            generateTagalogStage3(),
            generateTagalogStage4(),
            generateTagalogStage5(),
            generateTagalogStage6()
        ]
    }
    
    private func generateTagalogStage1() -> Stage {
        let lessons = [
            createLesson(id: "tl.1.1.1", moduleId: "1.1", name: "Mga Letrang A at S", order: 1, content: "aaa sss aaa sss as sa as sa",
                         learningGoal: "Master ang Mga Letrang A at S", habitTip: "Ilagay ang mga daliri sa home row", descriptionOverride: "Mag-practice ng Mga Letrang A at S"),
            createLesson(
                id: "tl.1.4.1", 
                moduleId: "1.4", 
                name: "Pasulit sa Antas 1", 
                order: 2, 
                content: "asdf jkl; alas sala sal", 
                isGatekeeper: true,
                pool: [
                    "asdf jkl; alas sala sal. sal sala alas. salla sal sala.",
                    "sala alas salla. asdf jkl; salla sal alas. sala sal alas salla.",
                    "sala alas salla. asdf jkl; salla sala sal. sala salla sala sal."
                ],
                learningGoal: "Pumasa sa Pasulit sa Antas 1", habitTip: "Manatiling kalmado at mag-type nang pantay", descriptionOverride: "Level test 1"
            )
        ]
        return Stage(id: 1, name: "Pundasyon ng Gitnang Hanay", themeName: "Gubat", description: "Kabisaduhin ang gitnang hanay", iconName: "hand.raised.fill", modules: [
            Module(id: "1.1", name: "Angkla ng Kaliwang Kamay", description: "Posisyon ng kaliwang kamay", stageId: 1, order: 1, lessons: lessons)
        ])
    }
    
    private func generateTagalogStage2() -> Stage {
        let lessons = [
            createLesson(
                id: "tl.2.4.1", 
                moduleId: "2.4", 
                name: "Pasulit sa Antas 2", 
                order: 1, 
                content: "ang mabilis na soro ay tumalon", 
                isGatekeeper: true,
                pool: [
                    "ang mabilis na sorong kayumanggi ay tumalon sa ibabaw ng asong tamad. maliit ang mundo kapag mabilis kang mag-type.",
                    "ang pag-type ay prayoridad para sa tagumpay. mahaba ang daan ngunit ang resulta ay natatangi.",
                    "gusto kong makapag-type nang may katumpakan at bilis. lahat ng kabataan ay maaaring matuto ngayon."
                ],
                learningGoal: "Pumasa sa Pasulit sa Antas 2", habitTip: "Manatiling kalmado at mag-type nang pantay", descriptionOverride: "Level test 2"
            )
        ]
        return Stage(id: 2, name: "Paglawak ng Itaas na Hanay", themeName: "Bundok", description: "Abutin ang itaas na hanay", iconName: "arrow.up.circle.fill", modules: [
            Module(id: "2.1", name: "Kadalubhasaan sa Itaas na Hanay", description: "Daloy ng itaas na hanay", stageId: 2, order: 1, lessons: lessons)
        ])
    }

    // MARK: - Stage 3: Bottom Row & N-Grams (Tagalog)
    private func generateTagalogStage3() -> Stage {
        let lessons1 = [
            createLesson(id: "tl.3.1.1", moduleId: "3.1", name: "Letrang Z at X", order: 1, content: "zzz xxx zzz xxx zx xz zebra x-ray",
                         learningGoal: "Master ang Letrang Z at X", habitTip: "Ilagay ang mga daliri sa home row", descriptionOverride: "Mag-practice ng Letrang Z at X"),
            createLesson(id: "tl.3.1.2", moduleId: "3.1", name: "Letrang C at V", order: 2, content: "ccc vvv ccc vvv cv vc cactus vinta",
                         learningGoal: "Master ang Letrang C at V", habitTip: "Ilagay ang mga daliri sa home row", descriptionOverride: "Mag-practice ng Letrang C at V"),
            createLesson(id: "tl.3.1.3", moduleId: "3.1", name: "Letrang B", order: 3, content: "bbb bbb bob bata baba",
                         learningGoal: "Master ang Letrang B", habitTip: "Ilagay ang mga daliri sa home row", descriptionOverride: "Mag-practice ng Letrang B")
        ]
        let lessons2 = [
            createLesson(id: "tl.3.2.1", moduleId: "3.2", name: "Letrang N at M", order: 1, content: "nnn mmm nnn mmm nm mn nanay mama",
                         learningGoal: "Master ang Letrang N at M", habitTip: "Ilagay ang mga daliri sa home row", descriptionOverride: "Mag-practice ng Letrang N at M"),
            createLesson(id: "tl.3.2.2", moduleId: "3.2", name: "Kuwit at Tuldok", order: 2, content: ",,, ... ,,, ... ,. ., isa, dalawa.",
                         learningGoal: "Master ang Kuwit at Tuldok", habitTip: "Ilagay ang mga daliri sa home row", descriptionOverride: "Mag-practice ng Kuwit at Tuldok"),
            createLesson(id: "tl.3.2.3", moduleId: "3.2", name: "Slash", order: 3, content: "/// /// at/o oo/hindi",
                         learningGoal: "Master ang Slash", habitTip: "Ilagay ang mga daliri sa home row", descriptionOverride: "Mag-practice ng Slash")
        ]
        let lessons3 = [
            createLesson(id: "tl.3.3.1", moduleId: "3.3", name: "Karaniwang Pares: ang, sa", order: 1, content: "ang ang ang sa sa sa mga ay",
                         learningGoal: "Master ang Karaniwang Pares: ang, sa", habitTip: "Manatiling kalmado at mag-type nang pantay", descriptionOverride: "Practice pairs"),
            createLesson(id: "tl.3.3.2", moduleId: "3.3", name: "Karaniwang Pares: ng, at", order: 2, content: "ng ng ng at at at na ko",
                         learningGoal: "Master ang Karaniwang Pares: ng, at", habitTip: "Manatiling kalmado at mag-type nang pantay", descriptionOverride: "Practice pairs"),
            createLesson(
                id: "tl.3.4.1", 
                moduleId: "3.4", 
                name: "Pagsusulit sa Antas 3", 
                order: 1, 
                content: "ang mabilis na soro", 
                isGatekeeper: true,
                pool: [
                    "ang mabilis na soro ay tumatakbo sa gubat. maganda ang mundo.",
                    "gusto kong kumain ng masarap na mangga. pumunta tayo sa dagat bukas.",
                    "malakas ang musika sa pista. gusto kong sumayaw kasama ang mga kaibigan."
                ],
                learningGoal: "Pumasa sa Pagsusulit sa Antas 3", habitTip: "Manatiling kalmado at mag-type nang pantay", descriptionOverride: "Level test 3"
            )
        ]
        
        let modules = [
            Module(id: "3.1", name: "Ibabang Hanay Kaliwa", description: "Letrang Z X C V B", stageId: 3, order: 1, lessons: lessons1),
            Module(id: "3.2", name: "Ibabang Hanay Kanan", description: "Letrang N M , . /", stageId: 3, order: 2, lessons: lessons2),
            Module(id: "3.3", name: "Karaniwang N-Grams", description: "Kabisaduhin ang mga pares", stageId: 3, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 3, name: "Ibabang Hanay at Padron", themeName: "Ilog", description: "Kumpletuhin ang alpabeto", iconName: "arrow.down.circle.fill", modules: modules)
    }

    // MARK: - Stage 4: Word Mastery (Tagalog)
    private func generateTagalogStage4() -> Stage {
        let lessons1 = [
            createLesson(id: "tl.4.1.1", moduleId: "4.1", name: "Karaniwang Salita 1", order: 1, content: "ang ng sa at na mga ay ko",
                         learningGoal: "Master ang Karaniwang Salita 1", habitTip: "Basahin muna ang salita, pagkatapos i-type", descriptionOverride: "Mag-practice ng madalas na salita"),
            createLesson(id: "tl.4.1.2", moduleId: "4.1", name: "Karaniwang Salita 2", order: 2, content: "ako hindi mo para may ni lang",
                         learningGoal: "Master ang Karaniwang Salita 2", habitTip: "Basahin muna ang salita, pagkatapos i-type", descriptionOverride: "Mag-practice ng madalas na salita"),
            createLesson(id: "tl.4.1.3", moduleId: "4.1", name: "Karaniwang Salita 3", order: 3, content: "siya din ba naman kundi pero dahil",
                         learningGoal: "Master ang Karaniwang Salita 3", habitTip: "Basahin muna ang salita, pagkatapos i-type", descriptionOverride: "Mag-practice ng madalas na salita")
        ]
        let lessons2 = [
            createLesson(id: "tl.4.2.1", moduleId: "4.2", name: "Mahahabang Salita 1", order: 1, content: "kanila ngayon paano kailangan",
                         learningGoal: "Master ang Mahahabang Salita 1", habitTip: "Basahin muna ang salita, pagkatapos i-type", descriptionOverride: "Mag-practice ng madalas na salita"),
            createLesson(id: "tl.4.2.2", moduleId: "4.2", name: "Mahahabang Salita 2", order: 2, content: "marami dahil kapag bago",
                         learningGoal: "Master ang Mahahabang Salita 2", habitTip: "Basahin muna ang salita, pagkatapos i-type", descriptionOverride: "Mag-practice ng madalas na salita"),
            createLesson(id: "tl.4.2.3", moduleId: "4.2", name: "Mahahabang Salita 3", order: 3, content: "walang lahat upang tungkol",
                         learningGoal: "Master ang Mahahabang Salita 3", habitTip: "Basahin muna ang salita, pagkatapos i-type", descriptionOverride: "Mag-practice ng madalas na salita")
        ]
        let lessons3 = [
            createLesson(id: "tl.4.3.1", moduleId: "4.3", name: "Sprint na 30 Segundo", order: 1, content: "ang ng sa at na mga ay ko ako hindi mo",
                         learningGoal: "Master ang Sprint na 30 Segundo", habitTip: "Huwag tumingin sa keyboard!", descriptionOverride: "Speed sprint"),
            createLesson(
                id: "tl.4.4.1", 
                moduleId: "4.4", 
                name: "Pagsusulit sa Antas 4", 
                order: 1, 
                content: "ang unang malaking bagay ay pag-aaral", 
                isGatekeeper: true,
                pool: [
                    "ang unang malaking bagay ay pag-aaral na gamitin muli ang iyong sariling boses.",
                    "isipin kung nasaan ka noong sinimulan mo ang paglalakbay na ito.",
                    "pag-aralan ang kanilang lugar kanan maliit na tunog ay maaaring muli pababa."
                ],
                learningGoal: "Pumasa sa Pagsusulit sa Antas 4", habitTip: "Manatiling kalmado at mag-type nang pantay", descriptionOverride: "Level test 4"
            )
        ]
        
        let modules = [
            Module(id: "4.1", name: "Maikling Salita", description: "Nangungunang 30 salita", stageId: 4, order: 1, lessons: lessons1),
            Module(id: "4.2", name: "Katamtamang Salita", description: "5+ letra", stageId: 4, order: 2, lessons: lessons2),
            Module(id: "4.3", name: "Word Sprints", description: "Bumuo ng bilis", stageId: 4, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 4, name: "Kadalubhasaan sa Salita", themeName: "Aklatan", description: "Dagdagan ang iyong bilis", iconName: "text.word.spacing", modules: modules)
    }

    // MARK: - Stage 5: Sentence Fluency (Tagalog)
    private func generateTagalogStage5() -> Stage {
        let lessons1 = [
            createLesson(id: "tl.5.1.1", moduleId: "5.1", name: "Mga Simpleng Pangungusap", order: 1, content: "Tumatahol ng malakas ang aso. Natutulog ang pusa.",
                         learningGoal: "Master ang Mga Simpleng Pangungusap", habitTip: "Basahin muna ang salita, pagkatapos i-type", descriptionOverride: "Mag-practice ng simpleng pangungusap"),
            createLesson(id: "tl.5.1.2", moduleId: "5.1", name: "Mga Tanong", order: 2, content: "Kamusta ka ngayon? Anong oras na?",
                         learningGoal: "Master ang Mga Tanong", habitTip: "Manatiling kalmado at mag-type nang pantay", descriptionOverride: "Practice questions"),
            createLesson(id: "tl.5.1.3", moduleId: "5.1", name: "Mga Utos", order: 3, content: "Pakisara ang pinto. Buksan ang ilaw.",
                         learningGoal: "Master ang Mga Utos", habitTip: "Manatiling kalmado at mag-type nang pantay", descriptionOverride: "Practice commands")
        ]
        let lessons2 = [
            createLesson(id: "tl.5.2.1", moduleId: "5.2", name: "Tambalang Pangungusap", order: 1, content: "Pumunta ako sa tindahan at bumili ng tinapay.",
                         learningGoal: "Master ang Tambalang Pangungusap", habitTip: "Manatiling kalmado at mag-type nang pantay", descriptionOverride: "Practice compound sentences"),
            createLesson(id: "tl.5.2.2", moduleId: "5.2", name: "Mga Komplikadong Ideya", order: 2, content: "Kahit umuulan, nagpasya kaming lumabas.",
                         learningGoal: "Master ang Mga Komplikadong Ideya", habitTip: "Basahin muna ang salita, pagkatapos i-type", descriptionOverride: "Mag-practice ng simpleng pangungusap")
        ]
        let lessons3 = [
            createLesson(
                id: "tl.5.4.1", 
                moduleId: "5.4", 
                name: "Pagsusulit sa Antas 5", 
                order: 1, 
                content: "Ang TypeQuest ay ang pinakamahusay na paraan.", 
                isGatekeeper: true,
                pool: [
                    "Ang TypeQuest ay ang pinakamahusay na paraan upang matutong mag-type. Sa araw-araw na pagsasanay gagaling ka.",
                    "Ang mabilis na sorong kayumanggi ay tumalon sa ibabaw ng asong tamad. Isang sikat na pangungusap.",
                    "Ang pagbabasa at pagsusulat ay mga pundasyon ng digital na komunikasyon. Kabisaduhin ang keyboard ngayon."
                ],
                learningGoal: "Pumasa sa Pagsusulit sa Antas 5", habitTip: "Manatiling kalmado at mag-type nang pantay", descriptionOverride: "Level test 5"
            )
        ]
        
        let modules = [
            Module(id: "5.1", name: "Simpleng Pangungusap", description: "Pangunahing daloy", stageId: 5, order: 1, lessons: lessons1),
            Module(id: "5.2", name: "Tambalang Pangungusap", description: "Konektadong ideya", stageId: 5, order: 2, lessons: lessons2),
            Module(id: "5.3", name: "Pagsasanay sa Talata", description: "Daloy ng maraming pangungusap", stageId: 5, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 5, name: "Kahusayan sa Pangungusap", themeName: "Karagatan", description: "Sumulat nang may ritmo", iconName: "text.alignleft", modules: modules)
    }

    // MARK: - Stage 6: Numbers & Symbols (Tagalog)
    private func generateTagalogStage6() -> Stage {
        let lessons1 = [
            createLesson(id: "tl.6.1.1", moduleId: "6.1", name: "Letrang 1 at 2", order: 1, content: "111 222 111 222 12 21 12 21",
                         learningGoal: "Master ang Letrang 1 at 2", habitTip: "Ilagay ang mga daliri sa home row", descriptionOverride: "Mag-practice ng Letrang 1 at 2"),
            createLesson(id: "tl.6.1.2", moduleId: "6.1", name: "Letrang 3 at 4", order: 2, content: "333 444 333 444 34 43 34 43",
                         learningGoal: "Master ang Letrang 3 at 4", habitTip: "Ilagay ang mga daliri sa home row", descriptionOverride: "Mag-practice ng Letrang 3 at 4"),
            createLesson(id: "tl.6.1.3", moduleId: "6.1", name: "Letrang 5 at 6", order: 3, content: "555 666 555 666 56 65 56 65",
                         learningGoal: "Master ang Letrang 5 at 6", habitTip: "Ilagay ang mga daliri sa home row", descriptionOverride: "Mag-practice ng Letrang 5 at 6"),
            createLesson(id: "tl.6.1.4", moduleId: "6.1", name: "Letrang 7 at 8", order: 4, content: "777 888 777 888 78 87 78 87",
                         learningGoal: "Master ang Letrang 7 at 8", habitTip: "Ilagay ang mga daliri sa home row", descriptionOverride: "Mag-practice ng Letrang 7 at 8"),
            createLesson(id: "tl.6.1.5", moduleId: "6.1", name: "Letrang 9 at 0", order: 5, content: "999 000 999 000 90 09 90 09",
                         learningGoal: "Master ang Letrang 9 at 0", habitTip: "Ilagay ang mga daliri sa home row", descriptionOverride: "Mag-practice ng Letrang 9 at 0")
        ]
        let lessons2 = [
            createLesson(id: "tl.6.2.1", moduleId: "6.2", name: "! @ # $", order: 1, content: "!!! @@@ ### $$$ !@#$",
                         learningGoal: "Master ang ! @ # $", habitTip: "I-hold ang Shift gamit ang pinky", descriptionOverride: "Mag-practice ng special characters"),
            createLesson(id: "tl.6.2.2", moduleId: "6.2", name: "% ^ & *", order: 2, content: "%%% ^^^ &&& *** %^&*",
                         learningGoal: "Master ang % ^ & *", habitTip: "I-hold ang Shift gamit ang pinky", descriptionOverride: "Mag-practice ng special characters"),
            createLesson(id: "tl.6.2.3", moduleId: "6.2", name: "( ) - =", order: 3, content: "((( ))) --- === ()-=",
                         learningGoal: "Master ang ( ) - =", habitTip: "I-hold ang Shift gamit ang pinky", descriptionOverride: "Mag-practice ng special characters")
        ]
        let lessons3 = [
            createLesson(
                id: "tl.6.4.1", 
                moduleId: "6.4", 
                name: "Huling Pagsusulit", 
                order: 1, 
                content: "Maligayang bati! Naabot mo na ang Stage 6.", 
                isGatekeeper: true,
                pool: [
                    "Maligayang bati! Naabot mo na ang Stage 6. I-verify natin ang lahat: 123 + 456 = 579. Tama? Oo!",
                    "Huling proyekto: (acc >= 98.0) && (wpm >= 50.0). Nakumpleto ang pagsusulit: [OK].",
                    "Mga espesyal na karakter: !@#$%^&*()_+. Nakumpleto mo na ang kurikulum ng TypeQuest. Mahusay!"
                ],
                learningGoal: "Pumasa sa Huling Pagsusulit", habitTip: "Malapit na – manatiling nakatutok!", descriptionOverride: "Final test ng buong keyboard"
            )
        ]
        
        let modules = [
            Module(id: "6.1", name: "Hanay ng Numero", description: "Letrang 0-9", stageId: 6, order: 1, lessons: lessons1),
            Module(id: "6.2", name: "Karaniwang Simbolo", description: "Espesyal na karakter", stageId: 6, order: 2, lessons: lessons2),
            Module(id: "6.3", name: "Magkahalong Pagsasanay", description: "Lahat pinagsama", stageId: 6, order: 3, lessons: lessons3)
        ]
        
        return Stage(id: 6, name: "Mga Numero at Simbolo", themeName: "Laboratoryo", description: "Kabisaduhin ang keyboard", iconName: "number.circle.fill", modules: modules)
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

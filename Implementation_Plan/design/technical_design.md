# TypeQuest - Technical Design Document

**Document Version**: 1.2.0  
**Status**: Draft / For Review  
**Date**: January 2026

---

## 1. Project Overview

### 1.1 Project Information

| Attribute | Value |
|-----------|-------|
| **Project Name** | TypeQuest |
| **Platform** | macOS 14+ (Primary) / iPadOS 17+ (Phase 2) |
| **Framework** | SwiftUI + Combine |
| **Minimum Deployment** | macOS 14 (Sonoma), iPadOS 17 |
| **Xcode Version** | 16+ |
| **Swift Version** | 6.0 |

### 1.2 Architecture Pattern

**MVVM (Model-View-ViewModel)** with observable state management:

```
┌─────────────────────────────────────────────────────────┐
│                      App Layer                          │
│  ┌─────────┐  ┌───────────┐  ┌─────────┐  ┌─────────┐  │
│  │  Views  │  │ ViewModels│  │  Models │  │Services │  │
│  └────┬────┘  └─────┬─────┘  └────┬────┘  └────┬────┘  │
│       │             │             │            │        │
│       └─────────────┼─────────────┼────────────┘        │
│                     │             │                     │
│              ┌──────┴──────┐      │                     │
│              │  Navigation │<─────┘                     │
│              │  Coordinator│                            │
│              └─────────────┘                            │
└─────────────────────────────────────────────────────────┘
```

---

## 2. Project Structure

### 2.1 Directory Structure

```
TypeQuest/
├── project.yml                    # XcodeGen configuration
├── setup.sh                       # Build setup script
│
├── TypeQuest/
│   ├── App/
│   │   ├── TypeQuestApp.swift
│   │   ├── AppDelegate.swift
│   │   └── ContentView.swift
│   │
│   ├── Models/
│   │   ├── User/
│   │   │   ├── UserProfile.swift
│   │   │   ├── UserSettings.swift
│   │   │   └── AgeGroup.swift
│   │   ├── Progress/
│   │   │   ├── SessionData.swift
│   │   │   ├── KeyPerformance.swift
│   │   │   └── LanguageProgress.swift
│   │   ├── Gamification/
│   │   │   ├── Achievement.swift
│   │   │   ├── Badge.swift
│   │   │   ├── StreakData.swift
│   │   │   └── Currency.swift
│   │   └── Curriculum/
│   │       ├── Lesson.swift
│   │       ├── Module.swift
│   │       └── Stage.swift
│   │
│   ├── ViewModels/
│   │   ├── Typing/
│   │   │   ├── TypingViewModel.swift
│   │   │   └── MetricsViewModel.swift
│   │   ├── Progress/
│   │   │   ├── ProgressViewModel.swift
│   │   │   └── StatisticsViewModel.swift
│   │   ├── Gamification/
│   │   │   ├── LevelViewModel.swift
│   │   │   └── StreakViewModel.swift
│   │   └── Curriculum/
│   │       ├── CurriculumViewModel.swift
│   │       └── SkillTreeViewModel.swift
│   │
│   ├── Views/
│   │   ├── Main/
│   │   │   ├── MainView.swift
│   │   │   └── SidebarView.swift
│   │   ├── Typing/
│   │   │   ├── TypingView.swift
│   │   │   ├── KeyboardView.swift
│   │   │   ├── KeyView.swift
│   │   │   └── MetricsDisplayView.swift
│   │   ├── Curriculum/
│   │   │   ├── SkillTreeView.swift
│   │   │   └── LessonPlayerView.swift
│   │   ├── Settings/
│   │   │   └── SettingsView.swift
│   │   └── Components/
│   │       ├── GlassCard.swift
│   │       ├── PrimaryButton.swift
│   │       └── XPProgressBar.swift
│   │
│   ├── Services/
│   │   ├── Keyboard/
│   │   │   ├── KeyboardManager.swift
│   │   │   └── KeyLayoutDetector.swift
│   │   ├── Persistence/
│   │   │   ├── DataManager.swift
│   │   │   └── UserDefaultsManager.swift
│   │   ├── Cloud/
│   │   │   └── CloudKitManager.swift
│   │   ├── Audio/
│   │   │   └── AudioManager.swift
│   │   ├── Animation/
│   │   │   └── AnimationManager.swift
│   │   └── Analytics/
│   │       └── MetricsCalculator.swift
│   │
│   ├── Utilities/
│   │   ├── Extensions/
│   │   │   ├── View+Extensions.swift
│   │   │   ├── Color+Extensions.swift
│   │   │   └── String+Extensions.swift
│   │   └── Constants/
│   │       ├── AppConstants.swift
│   │       └── Colors.swift
│   │
│   └── Resources/
│       ├── Assets.xcassets/
│       ├── Fonts/
│       ├── Sounds/
│       ├── Animations/
│       │   └── FingerPlacement/
│       │       ├── Kids/
│       │       │   ├── robot_hands.json
│       │       │   ├── wizard_hands.json
│       │       │   └── cat_paws.json
│       │       ├── Adult/
│       │       │   └── realistic_hands.usdz
│       │       └── Senior/
│       │           └── simple_hands.json
│       └── Localizations/
│
├── TypeQuestTests/
│   ├── UnitTests/
│   │   ├── MetricsCalculatorTests.swift
│   │   └── LessonTests.swift
│   └── UITests/
│       └── TypingUITests.swift
│
└── TypeQuestKit/                    # Shared framework
    ├── Models/
    └── Services/
```

### 2.2 XcodeGen Configuration (project.yml)

```yaml
name: TypeQuest
options:
  bundleIdPrefix: com.typequest
  deploymentTarget:
    macOS: "14.0"
    iOS: "17.0"
  xcodeVersion: "16.0"
  generateEmptyDirectories: true

settings:
  base:
    SWIFT_VERSION: "6.0"
    MARKETING_VERSION: "1.0.0"
    CURRENT_PROJECT_VERSION: "1"
    CODE_SIGN_STYLE: Automatic
    ENABLE_USER_SCRIPT_SANDBOXING: NO

targets:
  TypeQuest:
    type: application
    platform: [macOS, iOS]
    deploymentTarget: "14.0"
    sources:
      - path: TypeQuest
        excludes:
          - "**/*.md"
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: com.typequest.app
        INFOPLIST_FILE: TypeQuest/Info.plist
        ASSETCATALOG_COMPILER_APPICON_NAME: AppIcon
        LD_RUNPATH_SEARCH_PATHS: "$(inherited) @executable_path/../Frameworks"
        ENABLE_PREVIEWS: YES
    entitlements:
      path: TypeQuest/TypeQuest.entitlements
      properties:
        com.apple.developer.icloud-container-identifiers:
          - "iCloud.com.typequest.app"
        com.apple.developer.icloud-services:
          - "CloudKit"
    preBuildScripts:
      - name: "SwiftLint"
        script: |
          if which swiftlint > /dev/null; then
            swiftlint
          else
            echo "warning: SwiftLint not installed"
          fi
        basedOnDependencyAnalysis: false

  TypeQuestTests:
    type: bundle.unit-test
    platform: [macOS, iOS]
    sources:
      - path: TypeQuestTests
    dependencies:
      - target: TypeQuest
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: com.typequest.app.tests
        TEST_HOST: "$(BUILT_PRODUCTS_DIR)/TypeQuest.app/Contents/MacOS/TypeQuest"
        BUNDLE_LOADER: "$(TEST_HOST)"

schemes:
  TypeQuest:
    build:
      targets:
        TypeQuest: all
        TypeQuestTests: [test]
    run:
      config: Debug
    test:
      config: Debug
      targets:
        - TypeQuestTests
    archive:
      config: Release
```

---

## 3. Data Models

### 3.1 User Profile Models

```swift
import Foundation
import SwiftData

// MARK: - UserProfile

@Model
final class UserProfile {
    @Attribute(.unique) var id: UUID
    var username: String
    var ageGroup: AgeGroup
    var primaryLanguage: String
    var avatarId: UUID
    var currentLevel: Int
    var totalXP: Int
    var inkCurrency: Int
    var currentStreak: Int
    var longestStreak: Int
    var createdDate: Date
    var lastPracticeDate: Date
    
    @Relationship(deleteRule: .cascade)
    var settings: UserSettings?
    
    @Relationship(deleteRule: .cascade, inverse: \LanguageProgress.userProfile)
    var progress: [LanguageProgress]?
    
    init(
        id: UUID = UUID(),
        username: String,
        ageGroup: AgeGroup = .adult,
        primaryLanguage: String = "en"
    ) {
        self.id = id
        self.username = username
        self.ageGroup = ageGroup
        self.primaryLanguage = primaryLanguage
        self.avatarId = UUID()
        self.currentLevel = 1
        self.totalXP = 0
        self.inkCurrency = 0
        self.currentStreak = 0
        self.longestStreak = 0
        self.createdDate = Date()
        self.lastPracticeDate = Date()
    }
}

// MARK: - AgeGroup

enum AgeGroup: String, Codable, CaseIterable {
    case child = "child"
    case teen = "teen"
    case adult = "adult"
    case senior = "senior"
    
    var displayName: String {
        switch self {
        case .child: return "Children (5-12)"
        case .teen: return "Teens (13-17)"
        case .adult: return "Adults (18-59)"
        case .senior: return "Seniors (60+)"
        }
    }
}

// MARK: - UserSettings

@Model
final class UserSettings {
    var id: UUID
    var soundEnabled: Bool
    var musicEnabled: Bool
    var keystrokeSoundEnabled: Bool
    var soundVolume: Double
    var musicVolume: Double
    var theme: ThemeStyle
    var highContrastMode: Bool
    var reduceMotion: Bool
    var keyboardLayout: KeyboardLayoutType
    
    init(
        id: UUID = UUID(),
        soundEnabled: Bool = true,
        musicEnabled: Bool = true,
        keystrokeSoundEnabled: Bool = true,
        soundVolume: Double = 0.7,
        musicVolume: Double = 0.5,
        theme: ThemeStyle = .system,
        highContrastMode: Bool = false,
        reduceMotion: Bool = false,
        keyboardLayout: KeyboardLayoutType = .qwerty
    ) {
        self.id = id
        self.soundEnabled = soundEnabled
        self.musicEnabled = musicEnabled
        self.keystrokeSoundEnabled = keystrokeSoundEnabled
        self.soundVolume = soundVolume
        self.musicVolume = musicVolume
        self.theme = theme
        self.highContrastMode = highContrastMode
        self.reduceMotion = reduceMotion
        self.keyboardLayout = keyboardLayout
    }
}

// MARK: - ThemeStyle

enum ThemeStyle: String, Codable, CaseIterable {
    case system, light, dark, vibrant, professional, highContrast, eInk
}

// MARK: - KeyboardLayoutType

enum KeyboardLayoutType: String, Codable, CaseIterable {
    case qwerty = "QWERTY"
    case azerty = "AZERTY"
    case qwertz = "QWERTZ"
    case dvorak = "Dvorak"
    case colemak = "Colemak"
}
```

### 3.2 Session and Progress Models

```swift
import Foundation
import SwiftData

// MARK: - SessionData

@Model
final class SessionData {
    @Attribute(.unique) var id: UUID
    var timestamp: Date
    var duration: TimeInterval
    var wpm: Double
    var accuracy: Double
    var rawAccuracy: Double
    var correctedAccuracy: Double
    var totalCharacters: Int
    var uncorrectedErrors: Int
    var backspaceCount: Int
    var language: String
    var lessonId: String?
    
    @Relationship(deleteRule: .cascade)
    var keyData: [KeyPerformance]?
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        duration: TimeInterval = 0,
        wpm: Double = 0,
        accuracy: Double = 100,
        rawAccuracy: Double = 100,
        correctedAccuracy: Double = 100,
        totalCharacters: Int = 0,
        uncorrectedErrors: Int = 0,
        backspaceCount: Int = 0,
        language: String = "en",
        lessonId: String? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.duration = duration
        self.wpm = wpm
        self.accuracy = accuracy
        self.rawAccuracy = rawAccuracy
        self.correctedAccuracy = correctedAccuracy
        self.totalCharacters = totalCharacters
        self.uncorrectedErrors = uncorrectedErrors
        self.backspaceCount = backspaceCount
        self.language = language
        self.lessonId = lessonId
    }
}

// MARK: - KeyPerformance

@Model
final class KeyPerformance {
    @Attribute(.unique) var id: UUID
    var key: String
    var pressCount: Int
    var errorCount: Int
    var avgLatency: Double
    var struggleScore: Double
    var sessionId: UUID
    
    init(
        id: UUID = UUID(),
        key: String,
        pressCount: Int = 0,
        errorCount: Int = 0,
        avgLatency: Double = 0,
        struggleScore: Double = 0,
        sessionId: UUID
    ) {
        self.id = id
        self.key = key
        self.pressCount = pressCount
        self.errorCount = errorCount
        self.avgLatency = avgLatency
        self.struggleScore = struggleScore
        self.sessionId = sessionId
    }
}

// MARK: - LanguageProgress

@Model
final class LanguageProgress {
    @Attribute(.unique) var id: UUID
    var language: String
    var unlockedStages: [Int]
    var completedLessons: [String]
    var bestWPM: Double
    var bestAccuracy: Double
    var totalPracticeTime: TimeInterval
    
    var userProfile: UserProfile?
    
    init(
        id: UUID = UUID(),
        language: String,
        unlockedStages: [Int] = [1],
        completedLessons: [String] = [],
        bestWPM: Double = 0,
        bestAccuracy: Double = 0,
        totalPracticeTime: TimeInterval = 0
    ) {
        self.id = id
        self.language = language
        self.unlockedStages = unlockedStages
        self.completedLessons = completedLessons
        self.bestWPM = bestWPM
        self.bestAccuracy = bestAccuracy
        self.totalPracticeTime = totalPracticeTime
    }
}
```

### 3.3 Gamification Models

```swift
import Foundation

// MARK: - Achievement

struct Achievement: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let category: AchievementCategory
    let iconName: String
    let xpReward: Int
    let requirement: AchievementRequirement
    
    enum AchievementCategory: String, Codable {
        case milestone, skill, streak, special
    }
    
    struct AchievementRequirement: Codable, Hashable {
        let type: RequirementType
        let value: Double
        
        enum RequirementType: String, Codable {
            case totalPracticeHours, wpm, accuracy, streak, lessonsCompleted
        }
    }
}

// MARK: - Currency

struct Currency: Codable {
    var ink: Int
    var gold: Int
    
    static let zero = Currency(ink: 0, gold: 0)
    
    mutating func addInk(_ amount: Int) { ink += amount }
    mutating func spendInk(_ amount: Int) -> Bool {
        guard ink >= amount else { return false }
        ink -= amount
        return true
    }
}
```

### 3.4 Curriculum Models

```swift
import Foundation

// MARK: - Lesson

struct Lesson: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let stageId: String
    let moduleId: String
    let order: Int
    let difficulty: LessonDifficulty
    let content: LessonContent
    let passingRequirements: PassingRequirements
    
    enum LessonDifficulty: String, Codable, CaseIterable {
        case beginner, elementary, intermediate, advanced, expert
        
        var xpMultiplier: Double {
            switch self {
            case .beginner: return 1.0
            case .elementary: return 1.2
            case .intermediate: return 1.5
            case .advanced: return 2.0
            case .expert: return 2.5
            }
        }
    }
    
    struct LessonContent: Codable, Hashable {
        let type: ContentType
        let text: String
        
        enum ContentType: String, Codable {
            case keys, words, phrases, sentences, numbers, symbols, code
        }
    }
    
    struct PassingRequirements: Codable, Hashable {
        let minAccuracy: Double
        let minWPM: Double
    }
}

// MARK: - Stage

struct Stage: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let themeName: String
    let description: String
    let iconName: String
    let modules: [Module]
}

// MARK: - Module

struct Module: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let stageId: String
    let order: Int
    let lessons: [Lesson]
}
```

---

## 4. ViewModels

### 4.1 Typing ViewModel

```swift
import Foundation
import Combine
import SwiftUI

@MainActor
final class TypingViewModel: ObservableObject {
    
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
    @Published var currentLesson: Lesson?
    @Published var keyPerformance: [String: KeyPerformance] = [:]
    @Published var errorCount: Int = 0
    @Published var backspaceCount: Int = 0
    @Published var totalCharacters: Int = 0
    @Published var uncorrectedErrors: Int = 0
    
    // MARK: - Private Properties
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private let metricsCalculator: MetricsCalculator
    private let audioManager: AudioManager
    private let dataManager: DataManager
    
    // MARK: - Initialization
    
    init(
        metricsCalculator: MetricsCalculator = .shared,
        audioManager: AudioManager = .shared,
        dataManager: DataManager = .shared
    ) {
        self.metricsCalculator = metricsCalculator
        self.audioManager = audioManager
        self.dataManager = dataManager
        setupBindings()
    }
    
    // MARK: - Public Methods
    
    func startSession(with lesson: Lesson? = nil) {
        currentLesson = lesson
        currentText = lesson?.content.text ?? generatePracticeText()
        typedText = ""
        currentIndex = 0
        errorCount = 0
        backspaceCount = 0
        totalCharacters = 0
        uncorrectedErrors = 0
        keyPerformance = [:]
        sessionStartTime = Date()
        isSessionActive = true
        isPaused = false
        startTimer()
    }
    
    func pauseSession() {
        isPaused = true
        stopTimer()
    }
    
    func resumeSession() {
        isPaused = false
        startTimer()
    }
    
    func endSession() -> SessionData? {
        guard isSessionActive else { return nil }
        
        stopTimer()
        isSessionActive = false
        
        return SessionData(
            duration: elapsedTime,
            wpm: wpm,
            accuracy: accuracy,
            rawAccuracy: rawAccuracy,
            correctedAccuracy: correctedAccuracy,
            totalCharacters: totalCharacters,
            uncorrectedErrors: uncorrectedErrors,
            backspaceCount: backspaceCount,
            language: dataManager.currentUser?.primaryLanguage ?? "en",
            lessonId: currentLesson?.id
        )
    }
    
    func processKeyPress(_ key: String, isCorrect: Bool) {
        guard isSessionActive && !isPaused else { return }
        guard currentIndex < currentText.count else { return }
        
        let targetCharIndex = currentText.index(currentText.startIndex, offsetBy: currentIndex)
        let targetChar = currentText[targetCharIndex]
        
        updateKeyPerformance(for: key, isCorrect: isCorrect)
        
        if isCorrect {
            typedText.append(targetChar)
            currentIndex += 1
            totalCharacters += 1
            audioManager.playSound(.correctKey)
        } else {
            errorCount += 1
            uncorrectedErrors += 1
            totalCharacters += 1
            audioManager.playSound(.errorKey)
        }
        
        updateMetrics()
        
        if currentIndex >= currentText.count {
            completeSession()
        }
    }
    
    func processBackspace() {
        guard isSessionActive && !isPaused && currentIndex > 0 else { return }
        
        backspaceCount += 1
        currentIndex -= 1
        typedText.removeLast()
        audioManager.playSound(.backspace)
        updateMetrics()
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        $elapsedTime
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.updateWPM() }
            .store(in: &cancellables)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.elapsedTime += 0.1 }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateKeyPerformance(for key: String, isCorrect: Bool) {
        var performance = keyPerformance[key] ?? KeyPerformance(key: key, sessionId: UUID())
        performance.pressCount += 1
        if !isCorrect { performance.errorCount += 1 }
        performance.struggleScore = Double(performance.errorCount) / Double(performance.pressCount) * 100
        keyPerformance[key] = performance
    }
    
    private func updateMetrics() {
        let totalKeys = typedText.count + errorCount
        guard totalKeys > 0 else { return }
        rawAccuracy = Double(typedText.count) / Double(totalKeys) * 100
        let correctedErrors = errorCount - backspaceCount
        correctedAccuracy = Double(typedText.count) / Double(typedText.count + max(0, correctedErrors)) * 100
        accuracy = (rawAccuracy + correctedAccuracy) / 2
    }
    
    private func updateWPM() {
        wpm = metricsCalculator.calculateWPM(
            characters: totalCharacters,
            uncorrectedErrors: uncorrectedErrors,
            time: elapsedTime
        )
    }
    
    private func completeSession() {
        stopTimer()
        isSessionActive = false
        audioManager.playSound(.sessionComplete)
    }
    
    private func generatePracticeText() -> String {
        "The quick brown fox jumps over the lazy dog."
    }
}
```

### 4.2 Metrics Calculator

```swift
import Foundation

final class MetricsCalculator {
    static let shared = MetricsCalculator()
    
    private let standardWordLength = 5.0
    
    private init() {}
    
    /// WPM = ((Total Characters / 5) - Uncorrected Errors) / Time(min)
    func calculateWPM(characters: Int, uncorrectedErrors: Int, time: TimeInterval) -> Double {
        guard time > 0 else { return 0 }
        let netCharacters = Double(characters) - Double(uncorrectedErrors)
        let words = netCharacters / standardWordLength
        let minutes = time / 60
        return words / minutes
    }
    
    func calculateRawAccuracy(correct: Int, total: Int) -> Double {
        guard total > 0 else { return 100 }
        return Double(correct) / Double(total) * 100
    }
    
    func calculateXPForLesson(baseXP: Int, accuracy: Double, wpm: Double, lesson: Lesson) -> Int {
        var xp = baseXP
        
        // Accuracy bonus
        if accuracy >= 99 { xp += Int(Double(baseXP) * 0.3) }
        else if accuracy >= 95 { xp += Int(Double(baseXP) * 0.2) }
        else if accuracy >= 90 { xp += Int(Double(baseXP) * 0.1) }
        
        // Speed bonus
        if wpm >= lesson.passingRequirements.minWPM * 1.5 {
            xp += Int(Double(baseXP) * 0.2)
        }
        
        // Difficulty multiplier
        xp = Int(Double(xp) * lesson.difficulty.xpMultiplier)
        
        return xp
    }
}
```

### 4.3 Progress ViewModel

```swift
import Foundation
import Combine

@MainActor
final class ProgressViewModel: ObservableObject {
    
    @Published var currentLevel: Int = 1
    @Published var currentXP: Int = 0
    @Published var xpToNextLevel: Int = 1000
    @Published var xpProgress: Double = 0
    @Published var totalPracticeTime: TimeInterval = 0
    @Published var averageWPM: Double = 0
    @Published var bestWPM: Double = 0
    @Published var averageAccuracy: Double = 0
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var sessions: [SessionData] = []
    
    private let dataManager: DataManager
    
    static let levelThresholds: [Int: Int] = [
        1: 0, 2: 100, 3: 250, 4: 500, 5: 1000,
        6: 1500, 7: 2200, 8: 3000, 9: 4000, 10: 5000
    ]
    
    init(dataManager: DataManager = .shared) {
        self.dataManager = dataManager
        loadProgress()
    }
    
    func loadProgress() {
        Task {
            guard let user = dataManager.currentUser else { return }
            currentLevel = user.currentLevel
            currentXP = user.totalXP
            currentStreak = user.currentStreak
            longestStreak = user.longestStreak
            xpToNextLevel = Self.levelThresholds[currentLevel + 1] ?? (currentLevel * 1500)
        }
    }
    
    func addXP(_ xp: Int) {
        currentXP += xp
        checkLevelUp()
        dataManager.saveXP(currentXP, level: currentLevel)
    }
    
    private func checkLevelUp() {
        while currentXP >= xpToNextLevel {
            currentLevel += 1
            xpToNextLevel = Self.levelThresholds[currentLevel + 1] ?? (currentLevel * 1500)
            NotificationCenter.default.post(name: .didLevelUp, object: currentLevel)
        }
    }
}

extension Notification.Name {
    static let didLevelUp = Notification.Name("didLevelUp")
}
```

---

## 5. Services

### 5.1 Keyboard Manager (macOS)

```swift
import Foundation
import Cocoa

final class KeyboardManager: ObservableObject {
    static let shared = KeyboardManager()
    
    @Published var isExternalKeyboardConnected: Bool = false
    @Published var activeKeyboardLayout: KeyboardLayoutType = .qwerty
    @Published var keyStates: [UInt16: Bool] = [:]
    
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    
    private init() {
        detectInitialKeyboard()
    }
    
    deinit { stopMonitoring() }
    
    func startMonitoring() {
        guard eventTap == nil else { return }
        
        let eventMask = CGEventMask(1 << CGEventType.keyDown.rawValue | 1 << CGEventType.keyUp.rawValue)
        
        eventTap = CGEvent.tapCreate(
            tap: .cghidEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask,
            callback: { proxy, type, event, refcon in
                return Unmanaged.passUnretained(event)
            },
            userInfo: nil
        )
        
        guard let tap = eventTap else { return }
        
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
    }
    
    func stopMonitoring() {
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
            if let source = runLoopSource {
                CFRunLoopRemoveSource(CFRunLoopGetMain(), source, .commonModes)
            }
            eventTap = nil
            runLoopSource = nil
        }
    }
    
    private func detectInitialKeyboard() {
        isExternalKeyboardConnected = true // Simplified for macOS
    }
}

extension Notification.Name {
    static let keyDidPress = Notification.Name("keyDidPress")
    static let keyDidRelease = Notification.Name("keyDidRelease")
}
```

### 5.2 Data Manager (SwiftData)

```swift
import Foundation
import SwiftData

@MainActor
final class DataManager {
    static let shared = DataManager()
    
    private var modelContainer: ModelContainer?
    private var modelContext: ModelContext?
    
    @Published var currentUser: UserProfile?
    @Published var isSyncing: Bool = false
    
    private let userDefaults = UserDefaultsManager.shared
    
    private init() { setupSwiftData() }
    
    private func setupSwiftData() {
        do {
            let schema = Schema([
                UserProfile.self,
                UserSettings.self,
                SessionData.self,
                KeyPerformance.self,
                LanguageProgress.self
            ])
            
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .private("iCloud.com.typequest.app")
            )
            
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContext = modelContainer?.mainContext
            
            loadCurrentUser()
        } catch {
            print("Failed to setup SwiftData: \(error)")
        }
    }
    
    func createUser(username: String, ageGroup: AgeGroup, language: String) -> UserProfile {
        let user = UserProfile(username: username, ageGroup: ageGroup, primaryLanguage: language)
        modelContext?.insert(user)
        try? modelContext?.save()
        currentUser = user
        userDefaults.setUsername(username)
        return user
    }
    
    func loadCurrentUser() {
        guard let username = userDefaults.username else { return }
        let descriptor = FetchDescriptor<UserProfile>(predicate: #Predicate { $0.username == username })
        do {
            let users = try modelContext?.fetch(descriptor) ?? []
            currentUser = users.first
        } catch {
            print("Failed to fetch user: \(error)")
        }
    }
    
    func saveSession(_ session: SessionData) {
        modelContext?.insert(session)
        try? modelContext?.save()
    }
    
    func fetchSessions(limit: Int = 50) -> [SessionData] {
        let descriptor = FetchDescriptor<SessionData>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)],
            fetchLimit: limit
        )
        return (try? modelContext?.fetch(descriptor)) ?? []
    }
    
    func saveXP(_ xp: Int, level: Int) {
        guard let user = currentUser else { return }
        user.totalXP = xp
        user.currentLevel = level
        try? modelContext?.save()
    }
    
    func saveStreak(_ current: Int, longest: Int) {
        guard let user = currentUser else { return }
        user.currentStreak = current
        user.longestStreak = longest
        user.lastPracticeDate = Date()
        try? modelContext?.save()
    }
    
    var lastPracticeDate: Date? { currentUser?.lastPracticeDate }
}

// MARK: - UserDefaults Manager

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let username = "username"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
    
    private init() {}
    
    var username: String? {
        get { defaults.string(forKey: Keys.username) }
    }
    
    func setUsername(_ username: String) {
        defaults.set(username, forKey: Keys.username)
    }
    
    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: Keys.hasCompletedOnboarding) }
        set { defaults.set(newValue, forKey: Keys.hasCompletedOnboarding) }
    }
}
```

### 5.3 Audio Manager

```swift
import Foundation
import AVFoundation

final class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    @Published var soundEnabled: Bool = true
    @Published var musicEnabled: Bool = true
    @Published var soundVolume: Double = 0.7
    @Published var musicVolume: Double = 0.5
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private var backgroundMusicPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playSound(_ soundType: SoundType) {
        guard soundEnabled else { return }
        
        let soundName = soundType.rawValue
        guard let player = getPlayer(for: soundName) else { return }
        
        player.volume = Float(soundVolume)
        player.currentTime = 0
        player.play()
    }
    
    private func getPlayer(for soundName: String) -> AVAudioPlayer? {
        if let existing = audioPlayers[soundName] { return existing }
        
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3", subdirectory: "Sounds") else {
            return nil
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            audioPlayers[soundName] = player
            return player
        } catch {
            print("Failed to load sound \(soundName): \(error)")
            return nil
        }
    }
    
    func playMusic(_ track: MusicTrack) {
        guard musicEnabled else { return }
        stopMusic()
        
        guard let url = Bundle.main.url(forResource: track.rawValue, withExtension: "mp3", subdirectory: "Music") else { return }
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.volume = Float(musicVolume)
            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.play()
        } catch {
            print("Failed to play music: \(error)")
        }
    }
    
    func stopMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
    }
}

enum SoundType: String, CaseIterable {
    case correctKey = "correct_key"
    case errorKey = "error_key"
    case backspace = "backspace"
    case wordComplete = "word_complete"
    case sessionComplete = "session_complete"
    case levelUp = "level_up"
    case achievement = "achievement"
}

enum MusicTrack: String, CaseIterable {
    case focus, energetic, zen, victory
}
```

### 5.4 Animation Manager

```swift
import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

final class AnimationManager: ObservableObject {
    static let shared = AnimationManager()
    
    @Published var showHandGuide: Bool = false
    
    private init() {}
    
    /// Returns the appropriate finger placement animation based on user's age group
    func getFingerPlacementAnimation(for ageGroup: AgeGroup) -> String {
        switch ageGroup {
        case .child:
            // Return random character animation for kids
            return ["robot_hands", "wizard_hands", "cat_paws"].randomElement() ?? "robot_hands"
        case .teen, .adult:
            return "realistic_hands"
        case .senior:
            return "simple_hands"
        }
    }
    
    /// Returns the animation file path for finger placement
    func getAnimationPath(for ageGroup: AgeGroup) -> URL? {
        let animationName = getFingerPlacementAnimation(for: ageGroup)
        let subdirectory = "Animations/FingerPlacement/\(ageGroup == .child ? "Kids" : ageGroup == .senior ? "Senior" : "Adult")"
        
        // Check for 3D model first (Adults)
        if ageGroup == .adult || ageGroup == .teen {
            if let url = Bundle.main.url(forResource: animationName, withExtension: "usdz", subdirectory: subdirectory) {
                return url
            }
        }
        
        // Fall back to Lottie JSON
        return Bundle.main.url(forResource: animationName, withExtension: "json", subdirectory: subdirectory)
    }
    
    /// Toggle the hand guide overlay
    func toggleHandGuide() {
        showHandGuide.toggle()
    }
}
```

### 5.5 Color Constants (Deep Ocean Palette)

```swift
import SwiftUI

extension Color {
    // MARK: - Deep Ocean Brand Colors
    
    static let indigoPrimary = Color(hex: "6366F1")
    static let indigoHover = Color(hex: "4F46E5")
    static let indigoPressed = Color(hex: "4338CA")
    
    static let cyanAccent = Color(hex: "06B6D4")
    static let cyanHover = Color(hex: "0891B2")
    
    // MARK: - Backgrounds
    
    static let canvasLight = Color(hex: "F8FAFC") // Slate 50
    static let canvasDark = Color(hex: "0F172A")  // Slate 900
    
    static let surfaceLight = Color(hex: "FFFFFF")
    static let surfaceDark = Color(hex: "1E293B") // Slate 800
    
    // MARK: - Semantic Colors
    
    static let success = Color(hex: "10B981") // Emerald 500
    static let error = Color(hex: "EF4444")   // Red 500
    static let warning = Color(hex: "F59E0B")  // Amber 500
    static let focus = Color(hex: "06B6D4")    // Cyan
    
    // MARK: - Text Colors
    
    static let textPrimaryLight = Color(hex: "0F172A") // Slate 900
    static let textSecondaryLight = Color(hex: "475569") // Slate 600
    static let textTertiaryLight = Color(hex: "94A3B8")  // Slate 400
    
    static let textPrimaryDark = Color(hex: "F1F5F9")  // Slate 100
    static let textSecondaryDark = Color(hex: "CBD5E1") // Slate 300
    static let textTertiaryDark = Color(hex: "94A3B8")  // Slate 400
    
    // MARK: - Helper for Hex Colors
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
```
```

---

## 6. Build Configuration

### 6.1 Info.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
    <key>CFBundleShortVersionString</key>
    <string>$(MARKETING_VERSION)</string>
    <key>CFBundleVersion</key>
    <string>$(CURRENT_PROJECT_VERSION)</string>
    <key>LSMinimumSystemVersion</key>
    <string>$(MACOSX_DEPLOYMENT_TARGET)</string>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2026. All rights reserved.</string>
    <key>NSRequiresAquaSystemAppearance</key>
    <false/>
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLName</key>
            <string>com.typequest.app</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>typequest</string>
            </array>
        </dict>
    </array>
    <key>ITSAppUsesNonExemptEncryption</key>
    <false/>
</dict>
</plist>
```

### 6.2 Entitlements

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.icloud-container-identifiers</key>
    <array>
        <string>iCloud.com.typequest.app</string>
    </array>
    <key>com.apple.developer.icloud-services</key>
    <array>
        <string>CloudKit</string>
    </array>
    <key>com.apple.developer.ubiquity-kvstore-identifier</key>
    <string>$(TeamIdentifierPrefix)com.typequest.app</string>
    <key>com.apple.security.app-sandbox</key>
    <true/>
    <key>com.apple.security.files.user-selected.read-only</key>
    <true/>
    <key>com.apple.security.network.client</key>
    <true/>
</dict>
</plist>
```

---

## 7. Testing Strategy

### 7.1 Unit Tests

```swift
import XCTest
@testable import TypeQuest

final class MetricsCalculatorTests: XCTestCase {
    
    var calculator: MetricsCalculator!
    
    override func setUp() {
        super.setUp()
        calculator = MetricsCalculator.shared
    }
    
    func testWPMCalculation_StandardInput() {
        let wpm = calculator.calculateWPM(
            characters: 1000,
            uncorrectedErrors: 10,
            time: 60
        )
        XCTAssertEqual(wpm, 198, accuracy: 1.0)
    }
    
    func testWPMCalculation_ZeroTime() {
        let wpm = calculator.calculateWPM(characters: 1000, uncorrectedErrors: 0, time: 0)
        XCTAssertEqual(wpm, 0)
    }
    
    func testRawAccuracy_Calculation() {
        let accuracy = calculator.calculateRawAccuracy(correct: 95, total: 100)
        XCTAssertEqual(accuracy, 95.0)
    }
    
    func testRawAccuracy_ZeroTotal() {
        let accuracy = calculator.calculateRawAccuracy(correct: 0, total: 0)
        XCTAssertEqual(accuracy, 100.0)
    }
}
```

### 7.2 UI Tests

```swift
import XCTest

final class TypingUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
    }
    
    func testTypingView_AppearsOnLaunch() throws {
        app.launch()
        let typingView = app.otherElements["TypingView"]
        XCTAssertTrue(typingView.waitForExistence(timeout: 5))
    }
    
    func testKeyboardInteraction_RecordsInput() throws {
        app.launch()
        let startButton = app.buttons["StartSessionButton"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 5))
        startButton.click()
        
        let key = app.keys["a"]
        key.click()
        
        let typedText = app.staticTexts["TypedTextDisplay"]
        XCTAssertTrue(typedText.waitForExistence(timeout: 2))
    }
}
```

---

## 8. Code Quality

### 8.1 SwiftLint Configuration

```yaml
# .swiftlint.yml

excluded:
  - ${PWD}/TypeQuest/Resources
  - ${PWD}/TypeQuestTests

disabled_rules:
  - trailing_whitespace
  - line_length
  - file_length

opt_in_rules:
  - empty_count
  - closure_spacing
  - force_unwrapping
  - implicitly_unwrapped_optional
  - modifier_order
  - multiline_arguments
  - operator_usage_whitespace
  - overridden_super_call
  - sorted_first_last

identifier_name:
  min_length:
    warning: 1
    error: 1
  max_length:
    warning: 60
    error: 80
  excluded:
    - id
    - x
    - y
    - i
```

---

## 9. Document Version

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | January 2026 | Initial technical design document |
| 1.1.0 | January 2026 | Added complete model definitions, full ViewModel implementations, DataManager, SwiftLint config |
| 1.2.0 | January 2026 | Updated to Deep Ocean color palette, added AnimationManager service, finger placement animation system, Colors.swift constants |

---

*This technical design document provides the detailed implementation blueprint for TypeQuest.*

# TypeQuest - Technical Design Document (Improved)

**Document Version**: 2.0.0  
**Status**: Draft / For Review  
**Date**: January 2025

---

## 1. Project Overview

### 1.1 Project Information

| Attribute | Value |
|-----------|-------|
| **Project Name** | TypeQuest |
| **Platform** | macOS 14+ / iPadOS 17+ |
| **Framework** | SwiftUI + Combine |
| **Minimum Deployment** | macOS 14 (Sonoma), iPadOS 17 |
| **Xcode Version** | 15+ |
| **Swift Version** | 5.9+ |

### 1.2 Architecture Pattern

**MVVM + Coordinator + Clean Architecture** with reactive state management:

```
┌─────────────────────────────────────────────────────────┐
│                    App Layer                            │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐    │
│  │  Views  │  │ViewModels│  │ Services│  │ Coords  │    │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘    │
│       │              │               │          │       │
│       └──────────────┼───────────────┼──────────┘       │
│                      │               │                  │
│              ┌───────┴───────┐       │                  │
│              │   Navigation  │<──────┘                  │
│              │   Coordinator │                           │
│              └───────────────┘                           │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │                 Services Layer                   │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐       │   │
│  │  │Protocols │  │Impls     │  │ State    │       │   │
│  │  └──────────┘  └──────────┘  └──────────┘       │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │                 Data Layer                       │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐       │   │
│  │  │SwiftData │  │ CloudKit │  │ Cache    │       │   │
│  │  └──────────┘  └──────────┘  └──────────┘       │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## 2. Architecture Improvements

### 2.1 Coordinator Pattern

```swift
import Foundation

// MARK: - App Coordinator

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var selectedTab: AppTab = .typing
    @Published var navigationPath = NavigationPath()
    
    private let container: DIContainer
    
    init(container: DIContainer = .shared) {
        self.container = container
    }
    
    func navigate(to destination: AppDestination) {
        navigationPath.append(destination)
    }
    
    func navigateBack() {
        navigationPath.removeLast()
    }
    
    func resetNavigation() {
        navigationPath = NavigationPath()
    }
}

// MARK: - App Destination

enum AppDestination: Hashable {
    case typing(lessonId: String?)
    case progress
    case curriculum
    case skillTree
    case leaderboard
    case settings
    case lessonPlayer(lessonId: String)
    case achievementDetail(achievementId: String)
    case friendProfile(friendId: String)
}

// MARK: - Typing Coordinator

@MainActor
final class TypingCoordinator: ObservableObject {
    @Published private(set) var currentSession: SessionState?
    @Published private(set) var isSessionActive: Bool = false
    
    private let typingService: TypingServiceProtocol
    private let metricsService: MetricsServiceProtocol
    private let analyticsService: AnalyticsServiceProtocol
    
    init(
        typingService: TypingServiceProtocol,
        metricsService: MetricsServiceProtocol,
        analyticsService: AnalyticsServiceProtocol
    ) {
        self.typingService = typingService
        self.metricsService = metricsService
        self.analyticsService = analyticsService
    }
    
    // MARK: - Session Management
    
    func startSession(lesson: Lesson?) async throws {
        isSessionActive = true
        currentSession = SessionState(
            lesson: lesson,
            startTime: Date(),
            metrics: SessionMetrics()
        )
        
        try await typingService.startSession(lesson: lesson)
        analyticsService.trackSessionStart(lessonId: lesson?.id)
    }
    
    func pauseSession() {
        guard var session = currentSession else { return }
        session.isPaused = true
        currentSession = session
        typingService.pauseSession()
    }
    
    func resumeSession() {
        guard var session = currentSession else { return }
        session.isPaused = false
        currentSession = session
        typingService.resumeSession()
    }
    
    func endSession() async -> SessionResult? {
        guard let session = currentSession else { return nil }
        
        isSessionActive = false
        let result = await typingService.endSession()
        
        let finalMetrics = await metricsService.calculateFinalMetrics(for: result)
        analyticsService.trackSessionEnd(result, metrics: finalMetrics)
        
        currentSession = nil
        return SessionResult(
            session: result,
            metrics: finalMetrics,
            xpEarned: calculateXP(from: finalMetrics)
        )
    }
    
    // MARK: - Key Processing
    
    func processKeyPress(_ key: String, expected: Character) async throws -> KeyPressResult {
        let result = try await typingService.processKeyPress(key, expected: expected)
        
        // Update metrics in real-time
        await metricsService.recordKeyPress(result)
        
        return result
    }
    
    // MARK: - Private Methods
    
    private func calculateXP(from metrics: SessionMetrics) -> Int {
        let baseXP = 100
        var xp = baseXP
        
        // Accuracy bonus
        if metrics.accuracy >= 99 {
            xp += Int(Double(baseXP) * 0.3)
        } else if metrics.accuracy >= 95 {
            xp += Int(Double(baseXP) * 0.2)
        }
        
        // Speed bonus
        if metrics.wpm >= 50 {
            xp += Int(Double(baseXP) * 0.2)
        }
        
        return xp
    }
}

// MARK: - Session State

struct SessionState {
    var lesson: Lesson?
    var currentText: String = ""
    var typedText: String = ""
    var currentIndex: Int = 0
    var metrics: SessionMetrics
    var startTime: Date
    var isPaused: Bool = false
    var uncorrectedErrors: Int = 0
    var backspaceCount: Int = 0
}

// MARK: - Session Result

struct SessionResult {
    let session: SessionData
    let metrics: SessionMetrics
    let xpEarned: Int
}

// MARK: - App Tab

enum AppTab: String, CaseIterable {
    case typing = "Practice"
    case curriculum = "Learn"
    case progress = "Progress"
    case social = "Community"
    case settings = "Settings"
    
    var iconName: String {
        switch self {
        case .typing: return "keyboard"
        case .curriculum: return "book"
        case .progress: return "chart.bar"
        case .social: return "person.3"
        case .settings: return "gearshape"
        }
    }
}
```

### 2.2 Dependency Injection Container

```swift
import Foundation

// MARK: - DI Container

final class DIContainer {
    static let shared = DIContainer()
    
    // Services
    private var typingService: TypingServiceProtocol?
    private var metricsService: MetricsServiceProtocol?
    private var keyboardService: KeyboardServiceProtocol?
    private var audioService: AudioServiceProtocol?
    private var analyticsService: AnalyticsServiceProtocol?
    private var persistenceService: PersistenceServiceProtocol?
    
    // ViewModels
    private var typingViewModel: TypingViewModel?
    private var progressViewModel: ProgressViewModel?
    
    private init() {
        registerServices()
    }
    
    // MARK: - Service Registration
    
    private func registerServices() {
        // Core Services
        typingService = TypingService(
            keyboardService: keyboardService,
            metricsService: metricsService
        )
        
        metricsService = MetricsService()
        
        keyboardService = KeyboardManager.shared
        
        audioService = AudioManager.shared
        
        analyticsService = AnalyticsService(
            persistenceService: persistenceService
        )
        
        persistenceService = PersistenceManager.shared
    }
    
    // MARK: - Service Access
    
    func resolve<T>() -> T? {
        switch T.self {
        case is TypingServiceProtocol.Type:
            return typingService as? T
        case is MetricsServiceProtocol.Type:
            return metricsService as? T
        case is KeyboardServiceProtocol.Type:
            return keyboardService as? T
        case is AudioServiceProtocol.Type:
            return audioService as? T
        case is AnalyticsServiceProtocol.Type:
            return analyticsService as? T
        case is PersistenceServiceProtocol.Type:
            return persistenceService as? T
        default:
            return nil
        }
    }
    
    // MARK: - ViewModel Factory
    
    func makeTypingViewModel(coordinator: TypingCoordinator) -> TypingViewModel {
        if let vm = typingViewModel {
            return vm
        }
        
        vm = TypingViewModel(
            service: typingService!,
            coordinator: coordinator
        )
        return vm
    }
    
    func makeProgressViewModel() -> ProgressViewModel {
        if let vm = progressViewModel {
            return vm
        }
        
        vm = ProgressViewModel(
            metricsService: metricsService!,
            persistenceService: persistenceService!
        )
        return vm
    }
}
```

---

## 3. Service Layer with Protocols

### 3.1 Typing Service Protocol

```swift
import Foundation

// MARK: - Typing Service Protocol

protocol TypingServiceProtocol {
    func startSession(lesson: Lesson?) async throws
    func processKeyPress(_ key: String, expected: Character) async throws -> KeyPressResult
    func processBackspace() async throws
    func pauseSession()
    func resumeSession()
    func endSession() async -> SessionData
}

// MARK: - Key Press Result

struct KeyPressResult {
    let isCorrect: Bool
    let currentIndex: Int
    let typedCharacter: Character?
    let expectedCharacter: Character
    let timestamp: Date
    let latency: TimeInterval
}

// MARK: - Typing Service Implementation

final class TypingService: TypingServiceProtocol {
    private let keyboardService: KeyboardServiceProtocol
    private let metricsService: MetricsServiceProtocol
    
    private var currentState: TypingServiceState = .idle
    private var cancellables = Set<AnyCancellable>()
    
    private let sessionState = CurrentValueSubject<TypingServiceState, Never>(.idle)
    
    init(
        keyboardService: KeyboardServiceProtocol,
        metricsService: MetricsServiceProtocol
    ) {
        self.keyboardService = keyboardService
        self.metricsService = metricsService
    }
    
    // MARK: - Service Protocol
    
    func startSession(lesson: Lesson?) async throws {
        currentState = .active(TypingActiveState(
            lesson: lesson,
            text: lesson?.content.text ?? generatePracticeText(),
            currentIndex: 0,
            startTime: Date()
        ))
        
        sessionState.send(currentState)
        
        // Subscribe to keyboard events
        keyboardService.startMonitoring()
    }
    
    func processKeyPress(_ key: String, expected: Character) async throws -> KeyPressResult {
        guard case .active(var state) = currentState else {
            throw TypingServiceError.noActiveSession
        }
        
        let isCorrect = key == String(expected)
        let timestamp = Date()
        let latency = timestamp.timeIntervalSince(state.lastKeyTime)
        
        let result = KeyPressResult(
            isCorrect: isCorrect,
            currentIndex: state.currentIndex,
            typedCharacter: Character(key),
            expectedCharacter: expected,
            timestamp: timestamp,
            latency: latency
        )
        
        // Update state
        state.currentIndex += 1
        state.lastKeyTime = timestamp
        
        if isCorrect {
            state.correctKeyCount += 1
        } else {
            state.errorCount += 1
        }
        
        currentState = .active(state)
        sessionState.send(currentState)
        
        // Record in metrics
        await metricsService.recordKeyPress(result)
        
        return result
    }
    
    func processBackspace() async throws {
        guard case .active(var state) = currentState else {
            throw TypingServiceError.noActiveSession
        }
        
        if state.currentIndex > 0 {
            state.currentIndex -= 1
            state.backspaceCount += 1
        }
        
        currentState = .active(state)
        sessionState.send(currentState)
    }
    
    func pauseSession() {
        guard case .active(var state) = currentState else { return }
        state.isPaused = true
        currentState = .active(state)
        sessionState.send(currentState)
    }
    
    func resumeSession() {
        guard case .active(var state) = currentState else { return }
        state.isPaused = false
        currentState = .active(state)
        sessionState.send(currentState)
    }
    
    func endSession() async -> SessionData {
        guard case .active(let state) = currentState else {
            return SessionData()
        }
        
        keyboardService.stopMonitoring()
        
        currentState = .idle
        sessionState.send(.idle)
        
        // Calculate final metrics
        let metrics = await metricsService.calculateFinalMetrics(
            correctKeys: state.correctKeyCount,
            errors: state.errorCount,
            backspaces: state.backspaceCount,
            characters: state.currentIndex,
            duration: Date().timeIntervalSince(state.startTime)
        )
        
        return SessionData(
            duration: Date().timeIntervalSince(state.startTime),
            wpm: metrics.wpm,
            accuracy: metrics.accuracy,
            rawAccuracy: metrics.rawAccuracy,
            correctedAccuracy: metrics.correctedAccuracy,
            totalCharacters: state.correctKeyCount + state.errorCount,
            uncorrectedErrors: state.errorCount,
            backspaceCount: state.backspaceCount,
            language: "en",
            lessonId: state.lesson?.id
        )
    }
    
    // MARK: - Private Methods
    
    private func generatePracticeText() -> String {
        "The quick brown fox jumps over the lazy dog."
    }
}

// MARK: - Typing Service State

enum TypingServiceState {
    case idle
    case active(TypingActiveState)
    
    var isActive: Bool {
        if case .active = self { return true }
        return false
    }
}

struct TypingActiveState {
    var lesson: Lesson?
    var text: String
    var currentIndex: Int
    var startTime: Date
    var lastKeyTime: Date = Date()
    var correctKeyCount: Int = 0
    var errorCount: Int = 0
    var backspaceCount: Int = 0
    var isPaused: Bool = false
}

// MARK: - Typing Service Error

enum TypingServiceError: LocalizedError {
    case noActiveSession
    case invalidKeyInput
    case sessionNotStarted
    
    var errorDescription: String? {
        switch self {
        case .noActiveSession:
            return "No active typing session"
        case .invalidKeyInput:
            return "Invalid key input"
        case .sessionNotStarted:
            return "Session has not been started"
        }
    }
}
```

### 3.2 Metrics Service (Actor-Based)

```swift
import Foundation

// MARK: - Metrics Service Protocol

protocol MetricsServiceProtocol {
    func recordKeyPress(_ result: KeyPressResult) async
    func calculateRealTimeMetrics(correctKeys: Int, errors: Int, duration: TimeInterval) async -> SessionMetrics
    func calculateFinalMetrics(correctKeys: Int, errors: Int, backspaces: Int, characters: Int, duration: TimeInterval) async -> SessionMetrics
}

// MARK: - Metrics Service Implementation (Actor for Thread Safety)

actor MetricsService: MetricsServiceProtocol {
    static let shared = MetricsService()
    
    private var keyPerformance: [String: KeyPressStats] = [:]
    private var recentKeyPresses: [KeyPressResult] = []
    private let maxRecentHistory = 100
    
    private let standardWordLength = 5.0
    
    private init() {}
    
    // MARK: - Service Protocol
    
    func recordKeyPress(_ result: KeyPressResult) {
        // Update key performance stats
        var stats = keyPerformance[result.typedCharacter?.description ?? "unknown"] ?? KeyPressStats()
        stats.totalPresses += 1
        if result.isCorrect {
            stats.correctPresses += 1
        } else {
            stats.errorPresses += 1
        }
        stats.avgLatency = (stats.avgLatency * Double(stats.totalPresses - 1) + result.latency) / Double(stats.totalPresses)
        keyPerformance[result.typedCharacter?.description ?? "unknown"] = stats
        
        // Add to recent history
        recentKeyPresses.append(result)
        if recentKeyPresses.count > maxRecentHistory {
            recentKeyPresses.removeFirst()
        }
    }
    
    func calculateRealTimeMetrics(correctKeys: Int, errors: Int, duration: TimeInterval) async -> SessionMetrics {
        let totalKeys = correctKeys + errors
        let rawAccuracy = totalKeys > 0 ? Double(correctKeys) / Double(totalKeys) * 100 : 100
        let wpm = calculateWPM(characters: totalKeys, time: duration)
        
        return SessionMetrics(
            wpm: wpm,
            accuracy: rawAccuracy,
            rawAccuracy: rawAccuracy,
            correctedAccuracy: rawAccuracy,
            correctKeys: correctKeys,
            errors: errors,
            duration: duration
        )
    }
    
    func calculateFinalMetrics(
        correctKeys: Int,
        errors: Int,
        backspaces: Int,
        characters: Int,
        duration: TimeInterval
    ) async -> SessionMetrics {
        let totalKeys = correctKeys + errors
        let rawAccuracy = totalKeys > 0 ? Double(correctKeys) / Double(totalKeys) * 100 : 100
        
        let adjustedCorrect = correctKeys
        let adjustedTotal = characters
        let correctedAccuracy = adjustedTotal > 0 ? Double(adjustedCorrect) / Double(adjustedTotal) * 100 : 100
        
        let wpm = calculateWPM(characters: characters, time: duration)
        let accuracy = (rawAccuracy + correctedAccuracy) / 2
        
        // Calculate struggle keys
        let struggleKeys = identifyStruggleKeys(userAvgLatency: calculateAverageLatency())
        
        return SessionMetrics(
            wpm: wpm,
            accuracy: accuracy,
            rawAccuracy: rawAccuracy,
            correctedAccuracy: correctedAccuracy,
            correctKeys: correctKeys,
            errors: errors,
            backspaces: backspaces,
            duration: duration,
            struggleKeys: struggleKeys
        )
    }
    
    // MARK: - Private Methods
    
    private func calculateWPM(characters: Int, time: TimeInterval) -> Double {
        guard time > 0 else { return 0 }
        let words = Double(characters) / standardWordLength
        let minutes = time / 60
        return words / minutes
    }
    
    private func calculateAverageLatency() -> Double {
        guard !recentKeyPresses.isEmpty else { return 0 }
        let total = recentKeyPresses.reduce(0.0) { $0 + $1.latency }
        return total / Double(recentKeyPresses.count)
    }
    
    private func identifyStruggleKeys(userAvgLatency: Double) -> [StruggleKey] {
        let threshold = userAvgLatency * 1.3 // 30% above average
        
        return keyPerformance
            .filter { $0.value.avgLatency > threshold }
            .map { StruggleKey(key: $0.key, latency: $0.value.avgLatency, errorRate: Double($0.value.errorPresses) / Double($0.value.totalPresses)) }
            .sorted { $0.latency > $1.latency }
    }
    
    // MARK: - Reset
    
    func resetSession() {
        keyPerformance.removeAll()
        recentKeyPresses.removeAll()
    }
}

// MARK: - Supporting Types

struct KeyPressStats {
    var totalPresses: Int = 0
    var correctPresses: Int = 0
    var errorPresses: Int = 0
    var avgLatency: Double = 0
}

struct SessionMetrics {
    var wpm: Double = 0
    var accuracy: Double = 100
    var rawAccuracy: Double = 100
    var correctedAccuracy: Double = 100
    var correctKeys: Int = 0
    var errors: Int = 0
    var backspaces: Int = 0
    var duration: TimeInterval = 0
    var struggleKeys: [StruggleKey] = []
}

struct StruggleKey: Identifiable {
    let id = UUID()
    let key: String
    let latency: Double
    let errorRate: Double
}
```

### 3.3 Cross-Platform Keyboard Service

```swift
import Foundation
import Combine

// MARK: - Keyboard Service Protocol

protocol KeyboardServiceProtocol {
    func startMonitoring()
    func stopMonitoring()
    var keyEvents: AnyPublisher<KeyboardEvent, Never> { get }
    var isMonitoring: Bool { get }
    func getKeyPosition(for key: String) -> KeyPosition
    func getHandForKey(_ key: String) -> Hand
}

// MARK: - Keyboard Event

struct KeyboardEvent {
    let key: String
    let keyCode: Int
    let type: EventType
    let modifiers: Set<ModifierKey>
    let timestamp: Date
    
    enum EventType {
        case down, up
    }
    
    enum ModifierKey: String, CaseIterable {
        case shift = "Shift"
        case control = "Control"
        case option = "Option"
        case command = "Command"
        case capsLock = "CapsLock"
        
        init?(from flags: NSEvent.ModifierFlags) {
            if flags.contains(.shift) { self = .shift }
            else if flags.contains(.control) { self = .control }
            else if flags.contains(.option) { self = .option }
            else if flags.contains(.command) { self = .command }
            else if flags.contains(.capsLock) { self = .capsLock }
            else { return nil }
        }
        
        var flags: NSEvent.ModifierFlags {
            switch self {
            case .shift: return .shift
            case .control: return .control
            case .option: return .option
            case .command: return .command
            case .capsLock: return .capsLock
            }
        }
    }
}

#if os(macOS)

// MARK: - macOS Keyboard Manager

final class KeyboardManager: NSObject, ObservableObject, KeyboardServiceProtocol {
    static let shared = KeyboardManager()
    
    @Published private(set) var isMonitoring: Bool = false
    
    private var eventMonitor: Any?
    private let keyEventSubject = PassthroughSubject<KeyboardEvent, Never>()
    
    var keyEvents: AnyPublisher<KeyboardEvent, Never> {
        keyEventSubject.eraseToAnyPublisher()
    }
    
    private override init() {
        super.init()
    }
    
    // MARK: - Service Protocol
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .keyUp]) { [weak self] event in
            self?.handleKeyEvent(event)
            return event
        }
        
        isMonitoring = true
    }
    
    func stopMonitoring() {
        guard let monitor = eventMonitor else { return }
        
        NSEvent.removeMonitor(monitor)
        eventMonitor = nil
        isMonitoring = false
    }
    
    func getKeyPosition(for key: String) -> KeyPosition {
        KeyPosition.standardPositions[key.lowercased()] ?? .unknown
    }
    
    func getHandForKey(_ key: String) -> Hand {
        let leftKeys = Set("qwertasdfgzxcvpyhjkluvbnm")
        return leftKeys.contains(key.lowercased()) ? .left : .right
    }
    
    // MARK: - Private Methods
    
    private func handleKeyEvent(_ event: NSEvent) {
        let key = event.characters ?? ""
        let keyCode = Int(event.keyCode)
        let type: KeyboardEvent.EventType = event.type == .keyDown ? .down : .up
        let modifiers = Set(NSEvent.ModifierFlags.array(from: event.modifierFlags).compactMap { KeyboardEvent.ModifierKey(from: $0) })
        
        let keyboardEvent = KeyboardEvent(
            key: key,
            keyCode: keyCode,
            type: type,
            modifiers: modifiers,
            timestamp: Date()
        )
        
        keyEventSubject.send(keyboardEvent)
    }
}

#elseif os(iOS)

// MARK: - iOS Keyboard Manager

final class KeyboardManager: NSObject, ObservableObject, KeyboardServiceProtocol, UIKeyInput {
    static let shared = KeyboardManager()
    
    @Published private(set) var isMonitoring: Bool = false
    
    private let keyEventSubject = PassthroughSubject<KeyboardEvent, Never>()
    private var hiddenTextField: UITextField?
    
    var keyEvents: AnyPublisher<KeyboardEvent, Never> {
        keyEventSubject.eraseToAnyPublisher()
    }
    
    private override init() {
        super.init()
    }
    
    // MARK: - UIKeyInput
    
    var hasText: Bool { true }
    
    func insertText(_ text: String) {
        let keyboardEvent = KeyboardEvent(
            key: text,
            keyCode: 0,
            type: .down,
            modifiers: [],
            timestamp: Date()
        )
        keyEventSubject.send(keyboardEvent)
    }
    
    func deleteBackward() {
        let keyboardEvent = KeyboardEvent(
            key: "",
            keyCode: 0,
            type: .down,
            modifiers: [],
            timestamp: Date()
        )
        keyEventSubject.send(keyboardEvent)
    }
    
    // MARK: - Service Protocol
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        let textField = UITextField()
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .asciiCapable
        textField.inputAccessoryView = UIView()
        
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            window.addSubview(textField)
            textField.frame = CGRect(x: -1000, y: -1000, width: 100, height: 44)
            textField.becomeFirstResponder()
        }
        
        hiddenTextField = textField
        isMonitoring = true
    }
    
    func stopMonitoring() {
        hiddenTextField?.removeFromSuperview()
        hiddenTextField = nil
        isMonitoring = false
    }
    
    func getKeyPosition(for key: String) -> KeyPosition {
        // Simplified for on-screen keyboard
        return .homeRow
    }
    
    func getHandForKey(_ key: String) -> Hand {
        let leftKeys = Set("qwertasdfgzxcvpy")
        return leftKeys.contains(key.lowercased()) ? .left : .right
    }
}

// MARK: - UITextFieldDelegate

extension KeyboardManager: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
}

#endif

// MARK: - Supporting Types

enum KeyPosition: String, Codable {
    case homeRow = "home"
    case topRow = "top"
    case bottomRow = "bottom"
    case numberRow = "number"
    case leftHand = "left"
    case rightHand = "right"
    case unknown = "unknown"
    
    static let standardPositions: [String: KeyPosition] = [
        // Home row
        "a": .homeRow, "s": .homeRow, "d": .homeRow, "f": .homeRow,
        "j": .homeRow, "k": .homeRow, "l": .homeRow, ";": .homeRow,
        // Top row
        "q": .topRow, "w": .topRow, "e": .topRow, "r": .topRow, "t": .topRow,
        "y": .topRow, "u": .topRow, "i": .topRow, "o": .topRow, "p": .topRow,
        // Bottom row
        "z": .bottomRow, "x": .bottomRow, "c": .bottomRow, "v": .bottomRow, "b": .bottomRow,
        "n": .bottomRow, "m": .bottomRow, ",": .bottomRow, ".": .bottomRow, "/": .bottomRow,
    ]
}

enum Hand: String, Codable {
    case left = "left"
    case right = "right"
}
```

---

## 4. ViewModels (Improved)

```swift
import Foundation
import Combine
import SwiftUI

// MARK: - Typing ViewModel

@MainActor
final class TypingViewModel: ObservableObject {
    
    // MARK: - Published State
    
    @Published private(set) var state: TypingViewState = .idle
    @Published private(set) var currentText: String = ""
    @Published private(set) var typedText: String = ""
    @Published private(set) var currentIndex: Int = 0
    @Published private(set) var metrics: SessionMetrics = SessionMetrics()
    @Published private(set) var struggleKeys: [StruggleKey] = []
    @Published var selectedLesson: Lesson?
    
    // MARK: - Dependencies
    
    private let service: TypingServiceProtocol
    private let coordinator: TypingCoordinator
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(service: TypingServiceProtocol, coordinator: TypingCoordinator) {
        self.service = service
        self.coordinator = coordinator
        setupBindings()
    }
    
    // MARK: - Public Methods
    
    func startSession(lesson: Lesson? = nil) async {
        state = .loading
        
        do {
            try await coordinator.startSession(lesson: lesson)
            selectedLesson = lesson
            state = .active
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func processKeyPress(_ key: String) async {
        guard case .active = state else { return }
        
        let expectedCharacter = currentText[currentIndex]
        
        do {
            let result = try await coordinator.processKeyPress(key, expected: expectedCharacter)
            
            // Update UI state
            typedText.append(result.typedCharacter ?? Character(""))
            currentIndex = result.currentIndex
            
            // Update metrics
            metrics = await service.calculateRealTimeMetrics(
                correctKeys: metrics.correctKeys + (result.isCorrect ? 1 : 0),
                errors: metrics.errors + (result.isCorrect ? 0 : 1),
                duration: Date().timeIntervalSince(metrics.startTime)
            )
            
            // Update struggle keys
            let avgLatency = metrics.struggleKeys.isEmpty ? result.latency : metrics.struggleKeys.map(\.latency).average
            struggleKeys = metrics.struggleKeys.filter { $0.latency > avgLatency * 1.3 }
            
            // Check completion
            if currentIndex >= currentText.count {
                await completeSession()
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func processBackspace() async {
        guard case .active = state, currentIndex > 0 else { return }
        
        do {
            try await service.processBackspace()
            typedText.removeLast()
            currentIndex -= 1
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func pauseSession() {
        coordinator.pauseSession()
        state = .paused
    }
    
    func resumeSession() {
        coordinator.resumeSession()
        state = .active
    }
    
    func endSession() async -> SessionResult? {
        let result = await coordinator.endSession()
        state = .completed(result)
        return result
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        // Subscribe to typing state changes
        coordinator.$currentSession
            .receive(on: DispatchQueue.main)
            .sink { [weak self] session in
                guard let session = session else { return }
                self?.currentText = session.lesson?.content.text ?? ""
                self?.metrics.startTime = session.startTime
            }
            .store(in: &cancellables)
    }
    
    private func completeSession() async {
        let result = await coordinator.endSession()
        state = .completed(result)
    }
}

// MARK: - Typing View State

enum TypingViewState {
    case idle
    case loading
    case active
    case paused
    case completed(SessionResult?)
    case error(String)
}

// MARK: - Array Extension for Average

extension Array where Element == Double {
    var average: Double {
        guard !isEmpty else { return 0 }
        return reduce(0, +) / Double(count)
    }
}
```

---

## 5. Data Models (Improved)

```swift
import Foundation
import SwiftData

// MARK: - User Profile (Improved)

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
    var goldCurrency: Int
    var currentStreak: Int
    var longestStreak: Int
    var createdDate: Date
    var lastPracticeDate: Date
    
    // One-to-one relationship (cascade delete)
    @Relationship(deleteRule: .cascade)
    var settings: UserSettings?
    
    // One-to-many relationships (cascade delete)
    @Relationship(deleteRule: .cascade)
    var languageProgress: [LanguageProgress] = []
    
    @Relationship(deleteRule: .cascade)
    var sessions: [SessionData] = []
    
    @Relationship(deleteRule: .cascade)
    var achievements: [AchievementProgress] = []
    
    // Computed properties
    var bestWPM: Double {
        sessions.map(\.wpm).max() ?? 0
    }
    
    var averageAccuracy: Double {
        guard !sessions.isEmpty else { return 0 }
        return sessions.map(\.accuracy).reduce(0, +) / Double(sessions.count)
    }
    
    var totalPracticeTime: TimeInterval {
        sessions.reduce(0) { $0 + $1.duration }
    }
    
    init(
        id: UUID = UUID(),
        username: String,
        ageGroup: AgeGroup = .adult,
        primaryLanguage: String = "en",
        avatarId: UUID = UUID(),
        currentLevel: Int = 1,
        totalXP: Int = 0,
        inkCurrency: Int = 0,
        goldCurrency: Int = 0,
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        createdDate: Date = Date(),
        lastPracticeDate: Date = Date()
    ) {
        self.id = id
        self.username = username
        self.ageGroup = ageGroup
        self.primaryLanguage = primaryLanguage
        self.avatarId = avatarId
        self.currentLevel = currentLevel
        self.totalXP = totalXP
        self.inkCurrency = inkCurrency
        self.goldCurrency = goldCurrency
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.createdDate = createdDate
        self.lastPracticeDate = lastPracticeDate
    }
}

// MARK: - Language Progress (Improved)

@Model
final class LanguageProgress {
    @Attribute(.unique) var id: UUID
    var languageCode: String
    var xp: Int
    var bestWPM: Double
    var bestAccuracy: Double
    var totalPracticeTime: TimeInterval
    var lastAssessmentDate: Date
    
    // Many-to-one relationship (optional inverse)
    var user: UserProfile?
    
    // One-to-many relationship
    @Relationship(deleteRule: .cascade, inverse: \LessonProgress.languageProgress)
    var lessonProgress: [LessonProgress] = []
    
    init(
        id: UUID = UUID(),
        languageCode: String,
        user: UserProfile? = nil,
        xp: Int = 0,
        bestWPM: Double = 0,
        bestAccuracy: Double = 0,
        totalPracticeTime: TimeInterval = 0,
        lastAssessmentDate: Date = Date()
    ) {
        self.id = id
        self.languageCode = languageCode
        self.user = user
        self.xp = xp
        self.bestWPM = bestWPM
        self.bestAccuracy = bestAccuracy
        self.totalPracticeTime = totalPracticeTime
        self.lastAssessmentDate = lastAssessmentDate
    }
}

// MARK: - Lesson Progress

@Model
final class LessonProgress {
    @Attribute(.unique) var id: UUID
    var lessonId: String
    var isCompleted: Bool
    var completionDate: Date?
    var bestWPM: Double
    var bestAccuracy: Double
    var attemptCount: Int
    
    var languageProgress: LanguageProgress?
    
    init(
        id: UUID = UUID(),
        lessonId: String,
        languageProgress: LanguageProgress? = nil,
        isCompleted: Bool = false,
        completionDate: Date? = nil,
        bestWPM: Double = 0,
        bestAccuracy: Double = 0,
        attemptCount: Int = 0
    ) {
        self.id = id
        self.lessonId = lessonId
        self.languageProgress = languageProgress
        self.isCompleted = isCompleted
        self.completionDate = completionDate
        self.bestWPM = bestWPM
        self.bestAccuracy = bestAccuracy
        self.attemptCount = attemptCount
    }
}

// MARK: - Session Data

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
    var stageId: String?
    var moduleId: String?
    
    var user: UserProfile?
    
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
        lessonId: String? = nil,
        stageId: String? = nil,
        moduleId: String? = nil
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
        self.stageId = stageId
        self.moduleId = moduleId
    }
}
```

---

## 6. Project Structure (Updated)

```
TypeQuest/
├── project.yml
│
├── TypeQuest/
│   ├── App/
│   │   ├── TypeQuestApp.swift
│   │   ├── AppDelegate.swift
│   │   └── ContentView.swift
│   │
│   ├── Core/                      # NEW: Core protocols and types
│   │   ├── Protocols/
│   │   │   ├── TypingServiceProtocol.swift
│   │   │   ├── MetricsServiceProtocol.swift
│   │   │   ├── KeyboardServiceProtocol.swift
│   │   │   ├── AudioServiceProtocol.swift
│   │   │   └── PersistenceServiceProtocol.swift
│   │   │
│   │   ├── Types/
│   │   │   ├── KeyboardEvent.swift
│   │   │   ├── KeyPressResult.swift
│   │   │   ├── SessionMetrics.swift
│   │   │   └── SessionState.swift
│   │   │
│   │   └── Errors/
│   │       └── AppErrors.swift
│   │
│   ├── Models/                    # SwiftData models
│   │   ├── User/
│   │   ├── Progress/
│   │   ├── Gamification/
│   │   └── Curriculum/
│   │
│   ├── ViewModels/                # Light ViewModels
│   │   ├── TypingViewModel.swift
│   │   ├── ProgressViewModel.swift
│   │   └── SettingsViewModel.swift
│   │
│   ├── Views/                     # SwiftUI Views
│   │   ├── Main/
│   │   ├── Typing/
│   │   ├── Progress/
│   │   ├── Curriculum/
│   │   ├── Settings/
│   │   ├── Onboarding/
│   │   ├── Social/
│   │   └── Components/
│   │
│   ├── Services/                  # Service implementations
│   │   ├── TypingService.swift
│   │   ├── MetricsService.swift
│   │   ├── KeyboardManager.swift
│   │   ├── AudioManager.swift
│   │   ├── AnalyticsService.swift
│   │   └── PersistenceManager.swift
│   │
│   ├── Coordinators/              # NEW: Coordinator layer
│   │   ├── AppCoordinator.swift
│   │   └── TypingCoordinator.swift
│   │
│   ├── DI/                        # NEW: Dependency Injection
│   │   └── DIContainer.swift
│   │
│   ├── Utilities/
│   │   ├── Extensions/
│   │   ├── Constants/
│   │   └── Helpers/
│   │
│   └── Resources/
│       ├── Assets.xcassets/
│       ├── Sounds/
│       └── Localizations/
│
├── TypeQuestTests/
│   ├── UnitTests/
│   └── UITests/
│
└── TypeQuestKit/                  # Shared framework (optional)
```

---

## 7. Document Version

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | January 2025 | Initial technical design |
| 2.0.0 | January 2025 | Major improvements: Coordinator pattern, Actor-based services, Cross-platform keyboard, Better SwiftData relationships |

---

*This improved technical design document addresses the critical issues identified and provides a more robust, maintainable architecture for TypeQuest development.*

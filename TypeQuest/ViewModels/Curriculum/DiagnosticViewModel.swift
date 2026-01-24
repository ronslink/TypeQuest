import Foundation
import Combine
import SwiftUI

@MainActor
final class DiagnosticViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var currentPhase: DiagnosticPhase = .intro
    @Published var currentText: String = ""
    @Published var typedText: String = ""
    @Published var currentIndex: Int = 0
    @Published var isComplete: Bool = false
    @Published var elapsedTime: TimeInterval = 0
    @Published var recommendedStage: Int = 1
    @Published var resultsMessage: String = ""
    
    // Metrics per phase
    @Published var phaseResults: [DiagnosticPhase: PhaseResult] = [:]
    
    private var sessionStartTime: Date?
    private var timer: Timer?
    
    private let keyboardManager = KeyboardManager.shared
    
    // MARK: - Phases
    enum DiagnosticPhase: Int, CaseIterable {
        case intro = 0
        case homeRow = 1
        case commonWords = 2
        case sentences = 3
        case results = 4
        
        var title: String {
            switch self {
            case .intro: return "Welcome"
            case .homeRow: return "Home Row"
            case .commonWords: return "Common Words"
            case .sentences: return "Sentences"
            case .results: return "Your Results"
            }
        }
        
        var testContent: String {
            switch self {
            case .intro, .results: return ""
            case .homeRow: return "asdf jkl; asdf jkl; fjfj dkdk slsl a;a;"
            case .commonWords: return "the and for are but not you all can had"
            case .sentences: return "The quick brown fox jumps over the lazy dog."
            }
        }
    }
    
    struct PhaseResult {
        var wpm: Double
        var accuracy: Double
        var errors: Int
    }
    
    // MARK: - Init
    init() {
        setupKeyboardHandling()
    }
    
    // MARK: - Public Methods
    func startDiagnostic() {
        currentPhase = .homeRow
        loadPhaseContent()
    }
    
    func skipDiagnostic() {
        // Skip to results with default recommendation
        recommendedStage = 1
        resultsMessage = "Starting from the beginning. You can always revisit lessons later!"
        currentPhase = .results
    }
    
    private func loadPhaseContent() {
        currentText = currentPhase.testContent
        typedText = ""
        currentIndex = 0
        elapsedTime = 0
        sessionStartTime = Date()
        startTimer()
        keyboardManager.startMonitoring()
    }
    
    func processKeyPress(_ key: String) {
        guard currentPhase != .intro && currentPhase != .results else { return }
        guard currentIndex < currentText.count else { return }
        
        let targetIndex = currentText.index(currentText.startIndex, offsetBy: currentIndex)
        let targetChar = String(currentText[targetIndex])
        
        if key == targetChar {
            typedText.append(currentText[targetIndex])
            currentIndex += 1
        }
        // We ignore errors for now (simple pass-through)
        
        if currentIndex >= currentText.count {
            completePhase()
        }
    }
    
    func processBackspace() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        if !typedText.isEmpty {
            typedText.removeLast()
        }
    }
    
    private func completePhase() {
        stopTimer()
        keyboardManager.stopMonitoring()
        
        // Calculate metrics
        let wpm = MetricsCalculator.shared.calculateWPM(
            characters: typedText.count,
            uncorrectedErrors: 0,
            time: elapsedTime
        )
        let accuracy = Double(typedText.count) / Double(currentText.count) * 100
        
        phaseResults[currentPhase] = PhaseResult(wpm: wpm, accuracy: accuracy, errors: 0)
        
        // Move to next phase
        if let nextPhase = DiagnosticPhase(rawValue: currentPhase.rawValue + 1),
           nextPhase != .results {
            currentPhase = nextPhase
            loadPhaseContent()
        } else {
            calculateResults()
        }
    }
    
    private func calculateResults() {
        currentPhase = .results
        isComplete = true
        
        // Average WPM across all phases
        let avgWPM = phaseResults.values.map { $0.wpm }.reduce(0, +) / Double(phaseResults.count)
        let avgAccuracy = phaseResults.values.map { $0.accuracy }.reduce(0, +) / Double(phaseResults.count)
        
        // Determine starting stage based on performance
        if avgWPM < 15 || avgAccuracy < 80 {
            recommendedStage = 1
            resultsMessage = "Let's start with the fundamentals! Building strong foundations leads to faster progress."
        } else if avgWPM < 30 || avgAccuracy < 90 {
            recommendedStage = 2
            resultsMessage = "Great start! You have the basics down. Let's expand your skills."
        } else if avgWPM < 45 {
            recommendedStage = 3
            resultsMessage = "Solid typing skills! Time to master n-grams and flow patterns."
        } else if avgWPM < 60 {
            recommendedStage = 4
            resultsMessage = "Impressive! You're ready for word mastery and speed drills."
        } else {
            recommendedStage = 5
            resultsMessage = "Expert level typing detected! Let's refine your fluency."
        }
    }
    
    func applyRecommendation() {
        // Update user profile to unlock stages up to recommendedStage
        // This would be wired to DataManager/CurriculumViewModel
        // For now, just mark as complete for Onboarding to proceed
    }
    
    // MARK: - Timer
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.elapsedTime += 0.1
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Keyboard
    private func setupKeyboardHandling() {
        keyboardManager.onKeyDown = { [weak self] characters, keyCode in
            Task { @MainActor in
                guard let self = self else { return }
                if keyCode == 51 {
                    self.processBackspace()
                } else if !characters.isEmpty && characters != "\r" && characters != "\t" {
                    self.processKeyPress(characters)
                }
            }
        }
    }
}

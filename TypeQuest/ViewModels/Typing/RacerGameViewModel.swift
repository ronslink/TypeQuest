import Foundation
import SwiftUI
import Combine

struct Opponent: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let icon: String // SF Symbol, e.g. "car.fill", "bolt.fill"
    var progress: Double // 0.0 to 1.0
    var speed: Double // WPM equivalent (approx units per second)
    var finishTime: TimeInterval?
}

@MainActor
class RacerGameViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var racerText: String = ""
    @Published var typedText: String = "" // What user has typed so far
    @Published var userProgress: Double = 0.0
    
    @Published var opponents: [Opponent] = []
    
    @Published var isRaceActive: Bool = false
    @Published var isRaceFinished: Bool = false
    @Published var countdown: Int = 3
    
    @Published var userWPM: Double = 0
    @Published var userRank: Int? = nil
    
    private var countDownTask: Task<Void, Never>?
    
    // MARK: - Private Properties
    private var raceTimer: Timer?
    private var startTime: Date?
    private var cancellables = Set<AnyCancellable>()
    
    // Config
    private let trackLengthChars: Int = 100 // Estimate
    
    // MARK: - Initialization
    init() {
        setupKeyboardHandling()
    }
    
    // MARK: - Game Control
    
    func startRaceSequence() {
        resetRace()
        
        // Start Countdown Task
        countdown = 3
        countDownTask?.cancel()
        countDownTask = Task { @MainActor in
            while countdown > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if Task.isCancelled { return }
                countdown -= 1
            }
            startRace()
        }
    }
    
    private func startRace() {
        countdown = 0
        isRaceActive = true
        startTime = Date()
        
        // Start Game Loop for AI
        raceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.updateRaceLoop()
            }
        }
    }
    
    func stopRace() {
        isRaceActive = false
        raceTimer?.invalidate()
        raceTimer = nil
        countDownTask?.cancel()
        countDownTask = nil
        cancellables.removeAll()
    }
    
    private func resetRace() {
        // Load Text for current language
        let language = DataManager.shared.currentUser?.primaryLanguage ?? "en"
        let sentences = PracticeTextProvider.shared.sentences(for: language)
        racerText = sentences.randomElement() ?? "Ready set go!"
        // Make it longer for a race?
        if racerText.count < 50 {
             racerText += " " + (sentences.randomElement() ?? "")
        }
        
        typedText = ""
        userProgress = 0.0
        isRaceFinished = false
        userRank = nil
        userWPM = 0
        
        // Setup AI
        opponents = [
            Opponent(name: "Speedy", color: .red, icon: "car.fill", progress: 0.0, speed: Double.random(in: 40...60), finishTime: nil),
            Opponent(name: "Turbo", color: .yellow, icon: "bolt.car.fill", progress: 0.0, speed: Double.random(in: 60...80), finishTime: nil),
            Opponent(name: "Slowpoke", color: .green, icon: "tortoise.fill", progress: 0.0, speed: Double.random(in: 20...40), finishTime: nil)
        ]
        
        setupKeyboardHandling() // Ensure monitoring
    }
    
    // MARK: - Loop
    
    private func updateRaceLoop() {
        guard isRaceActive else { return }
        
        let now = Date()
        let elapsed = now.timeIntervalSince(startTime ?? now)
        if elapsed <= 0 { return }
        
        // Update AI Progress
        // Speed WPM -> Chars per second approx = WPM * 5 / 60
        // Progress increment = CharsPerSec * 0.1s / TotalChars
        
        let totalChars = Double(racerText.count)
        
        for i in opponents.indices {
            if opponents[i].finishTime == nil {
                let wpm = opponents[i].speed
                let cps = (wpm * 5) / 60.0
                let progressInc = (cps * 0.1) / totalChars
                
                opponents[i].progress += progressInc
                
                if opponents[i].progress >= 1.0 {
                    opponents[i].progress = 1.0
                    opponents[i].finishTime = elapsed
                }
            }
        }
        
        // Update User WPM live
        let userCharsTyped = Double(typedText.count)
        userWPM = (userCharsTyped / 5.0) / (elapsed / 60.0)
    }
    
    // MARK: - Input Handling
    
    private func setupKeyboardHandling() {
         KeyboardManager.shared.startMonitoring()
         
         NotificationCenter.default.publisher(for: .keyDidPress)
             .compactMap { $0.userInfo?["characters"] as? String }
             .receive(on: RunLoop.main)
             .sink { [weak self] key in
                 self?.processInput(key)
             }
             .store(in: &cancellables)
    }
    
    func processInput(_ key: String) {
        guard isRaceActive, !isRaceFinished else { return }
        
        // Check next expected character
        let nextIndex = typedText.count
        guard nextIndex < racerText.count else { return }
        
        let nextCharIndex = racerText.index(racerText.startIndex, offsetBy: nextIndex)
        let expectedChar = String(racerText[nextCharIndex])
        
        // Simple exact match logic
        // Ignore returns/tabs
        if key == "\r" || key == "\t" { return }
        
        if key == expectedChar {
            typedText.append(racerText[nextCharIndex])
            
            // Update Progress
            userProgress = Double(typedText.count) / Double(racerText.count)
            
            // Check Finish
            if typedText.count == racerText.count {
                finishRace()
            }
        } else {
            // OPTIONAL: Penalty or slowdown?
            // For now, simple block (must type correct key to proceed)
        }
    }
    
    private func finishRace() {
        isRaceActive = false
        isRaceFinished = true
        raceTimer?.invalidate()
        
        let endTime = Date().timeIntervalSince(startTime ?? Date())
        
        // Calculate Rank
        let finishedOpponents = opponents.filter { $0.finishTime != nil }
        // If opponent finish time < my finish time, they beat me
        let betterOpponents = finishedOpponents.filter { $0.finishTime! < endTime }
        userRank = betterOpponents.count + 1
    }
}

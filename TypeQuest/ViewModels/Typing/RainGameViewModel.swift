import Foundation
import SwiftUI
import Combine

struct FallingItem: Identifiable {
    let id = UUID()
    let text: String
    var xPosition: CGFloat // Normalized 0.0 to 1.0 or absolute points? Normalized is safer for resize.
    var yPosition: CGFloat // 0.0 (top) to 1.0 (bottom)
    let speed: CGFloat // Units per second
    let color: Color
}

@MainActor
class RainGameViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var fallingItems: [FallingItem] = []
    @Published var score: Int = 0
    @Published var lives: Int = 5
    @Published var isGameActive: Bool = false
    @Published var isGameOver: Bool = false
    @Published var level: Int = 1
    
    // MARK: - Private Properties
    private var timer: Timer?
    private var spawnTimer: Timer?
    private var lastUpdateTime: Date = Date()
    private var cancellables = Set<AnyCancellable>()
    
    // Game Configuration
    private var spawnRate: TimeInterval = 2.0 // Seconds between spawns
    private var baseSpeed: CGFloat = 0.1 // Screens per second
    private let maxSpeed: CGFloat = 0.6 // Cap spread to remain playable
    private let minSpawnRate: TimeInterval = 0.4 // Cap spawn rate
    
    private var possibleCharacters: String {
        let language = DataManager.shared.currentUser?.primaryLanguage ?? "en"
        let sentences = PracticeTextProvider.shared.sentences(for: language)
        let allChars = sentences.joined().lowercased()
        let uniqueChars = Set(allChars.filter { $0.isLetter || $0.isNumber })
        // If empty (shouldn't happen), fallback to en
        if uniqueChars.isEmpty { return "abcdefghijklmnopqrstuvwxyz" }
        return String(uniqueChars)
    }
    
    // MARK: - Integration
    
    private func setupKeyboardHandling() {
        // Ensure we are monitoring
        KeyboardManager.shared.startMonitoring()
        
        // Listen for notifications to avoid conflict with TypingViewModel's callback
        NotificationCenter.default.publisher(for: .keyDidPress)
            .compactMap { $0.userInfo?["characters"] as? String }
            .receive(on: RunLoop.main)
            .sink { [weak self] key in
                self?.processInput(key)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Game Control
    
    func startGame() {
        setupKeyboardHandling()
        resetGame()
        isGameActive = true
        isGameOver = false
        lastUpdateTime = Date()
        
        // Game Loop Timer (Update positions)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.updateGameLoop()
            }
        }
        
        // Spawn Timer
        startSpawnTimer()
    }
    
    func stopGame() {
        isGameActive = false
        timer?.invalidate()
        timer = nil
        spawnTimer?.invalidate()
        spawnTimer = nil
        // We don't stop KeyboardManager monitoring here because other views might need it,
        // or we rely on them to start it when they appear. 
        // But to be safe and clean:
        // KeyboardManager.shared.stopMonitoring() 
        // BETTER: Cancelling our subscription is enough.
        cancellables.removeAll()
    }
    
    func restartGame() {
        stopGame()
        startGame()
    }
    
    private func resetGame() {
        score = 0
        lives = 5
        level = 1
        fallingItems.removeAll()
        spawnRate = 2.0
        baseSpeed = 0.1
    }
    
    // MARK: - Game Loop
    
    private func startSpawnTimer() {
        spawnTimer?.invalidate()
        spawnTimer = Timer.scheduledTimer(withTimeInterval: spawnRate, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.spawnItem()
            }
        }
    }
    
    private func updateGameLoop() {
        guard isGameActive else { return }
        
        let now = Date()
        let deltaTime = now.timeIntervalSince(lastUpdateTime)
        lastUpdateTime = now
        
        // Update positions
        for i in fallingItems.indices {
            fallingItems[i].yPosition += fallingItems[i].speed * CGFloat(deltaTime)
        }
        
        // Check for misses (bottom of screen)
        // Assuming y=1.2 is well off screen
        if let missedIndex = fallingItems.firstIndex(where: { $0.yPosition > 1.1 }) {
            handleMiss(at: missedIndex)
        }
    }
    
    private func spawnItem() {
        let char = String(possibleCharacters.randomElement()!)
        let xPos = CGFloat.random(in: 0.1...0.9)
        let speed = baseSpeed * CGFloat.random(in: 0.8...1.2) * (1.0 + (CGFloat(level) * 0.1))
        
        // Random bright colors
        let colors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .yellow]
        let color = colors.randomElement() ?? .white
        
        let newItem = FallingItem(text: char, xPosition: xPos, yPosition: -0.1, speed: speed, color: color)
        fallingItems.append(newItem)
        
        // Increase difficulty slightly
        if score > 0 && score % 10 == 0 {
            increaseDifficulty()
        }
    }
    
    private func increaseDifficulty() {
        level += 1
        
        // Increase speed (logarithmic-ish decay towards max)
        if baseSpeed < maxSpeed {
            baseSpeed = min(maxSpeed, baseSpeed * 1.05)
        }
        
        // Decrease spawn rate
        if spawnRate > minSpawnRate {
            spawnRate = max(minSpawnRate, spawnRate * 0.95)
        }
        
        startSpawnTimer() // Restart with new rate
    }
    
    private func handleMiss(at index: Int) {
        fallingItems.remove(at: index)
        lives -= 1
        
        if lives <= 0 {
            gameOver()
        }
    }
    
    private func gameOver() {
        isGameActive = false
        isGameOver = true
        stopGame()
    }
    
    // MARK: - User Input
    
    func processInput(_ input: String) {
        guard isGameActive else { return }
        
        // Find the lowest falling item that matches the input
        // We sort by yPosition descending (highest Y = lowest on screen) to find the one closest to bottom
        let sortedIndices = fallingItems.indices.sorted { fallingItems[$0].yPosition > fallingItems[$1].yPosition }
        
        for index in sortedIndices {
            let item = fallingItems[index]
            if item.text.lowercased() == input.lowercased() {
                // Hit!
                fallingItems.remove(at: index)
                score += 1
                return // Only hit one per keypress
            }
        }
        
        // Optional: Penalty for wrong key?
    }
}

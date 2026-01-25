import Foundation
import SwiftUI
import Combine

enum SpellType: String, CaseIterable {
    case fire = "Fire Attack"
    case ice = "Ice Freeze"
    case heal = "Holy Light"
    case shield = "Arcane Shield"
}

struct Spell: Identifiable {
    let id = UUID()
    let type: SpellType
    let word: String
    let damage: Int
    let cost: Int // Maybe cooldown or mana? For now, just typing effort.
    let color: Color
}

@MainActor
class RPGGameViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var playerHP: Int = 100
    @Published var playerMaxHP: Int = 100
    @Published var enemyHP: Int = 200
    @Published var enemyMaxHP: Int = 200
    
    @Published var availableSpells: [Spell] = []
    @Published var activeSpell: Spell?
    @Published var typedSpellText: String = ""
    
    @Published var combatLog: [String] = []
    
    @Published var isBattleActive: Bool = false
    @Published var battleResult: Bool? = nil // True = Win, False = Loss
    
    // Visual effects
    @Published var playerDamageAnim: Bool = false
    @Published var enemyDamageAnim: Bool = false
    
    // MARK: - Private Properties
    private var enemyAttackTimer: Timer?
    private var spellWords: [String] = []
    private var cancellables = Set<AnyCancellable>()
    
    // Config
    private let enemyAttackInterval: TimeInterval = 3.5
    private let enemyDamage: Int = 10
    
    // MARK: - Initialization
    init() {
        setupKeyboardHandling()
        loadSpellWords()
    }
    
    // MARK: - Setup
    
    private func loadSpellWords() {
        let language = DataManager.shared.currentUser?.primaryLanguage ?? "en"
        let sentences = PracticeTextProvider.shared.sentences(for: language)
        // Extract unique words > 3 chars
        let words = sentences.flatMap { $0.components(separatedBy: .punctuationCharacters).joined().components(separatedBy: .whitespaces) }
            .filter { $0.count >= 4 }
            .map { $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) }
        
        self.spellWords = Array(Set(words)).shuffled()
        if self.spellWords.isEmpty { self.spellWords = ["fire", "water", "earth", "wind", "light", "shadow"] }
    }
    
    private func generateSpells() {
        availableSpells = SpellType.allCases.map { type in
            let word = spellWords.randomElement() ?? "magic"
            var damage = 20
            var color: Color = .red
            
            switch type {
            case .fire: 
                damage = 25
                color = .orange
            case .ice:
                damage = 15 // maybe freezes?
                color = .cyan
            case .heal:
                damage = -20 // Heals
                color = .green
            case .shield:
                damage = 0 // Blocks next attack? Simplified: Small heal + damage
                color = .blue
            }
            
            return Spell(type: type, word: word, damage: damage, cost: 0, color: color)
        }
    }
    
    // MARK: - Game Control
    
    func startBattle() {
        resetBattle()
        isBattleActive = true
        activeSpell = nil
        generateSpells()
        log("A wild Syntax Error appeared!")
        
        // Start Enemy AI
        startEnemyAI()
    }
    
    func stopBattle() {
        isBattleActive = false
        enemyAttackTimer?.invalidate()
        enemyAttackTimer = nil
        cancellables.removeAll()
    }
    
    private func resetBattle() {
        playerHP = 100
        enemyHP = 200
        currentEnemyMaxHP = 200 // Could scale with level
        battleResult = nil
        combatLog.removeAll()
        setupKeyboardHandling()
        loadSpellWords() // Reload words based on current language
    }
    
    private var currentEnemyMaxHP: Int = 200
    
    // MARK: - Combat Logic
    
    func selectSpell(_ spell: Spell) {
        guard isBattleActive, activeSpell == nil else { return }
        activeSpell = spell
        typedSpellText = ""
        log("Casting \(spell.type.rawValue)...")
    }
    
    private func castActiveSpell() {
        guard let spell = activeSpell else { return }
        
        if spell.type == .heal {
            healPlayer(amount: abs(spell.damage))
            log("You healed for \(abs(spell.damage)) HP!")
        } else {
            damageEnemy(amount: spell.damage)
            log("You hit Enemy for \(spell.damage) damage!")
        }
        
        // Reset turn
        activeSpell = nil
        typedSpellText = ""
        generateSpells() // Refresh words
    }
    
    private func damageEnemy(amount: Int) {
        enemyHP = max(0, enemyHP - amount)
        withAnimation { enemyDamageAnim = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { self.enemyDamageAnim = false }
        
        if enemyHP <= 0 {
            winBattle()
        }
    }
    
    private func healPlayer(amount: Int) {
        playerHP = min(playerMaxHP, playerHP + amount)
    }
    
    private func damagePlayer(amount: Int) {
        playerHP = max(0, playerHP - amount)
        withAnimation { playerDamageAnim = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { self.playerDamageAnim = false }
        
        log("Enemy attacks! -\(amount) HP")
        
        if playerHP <= 0 {
            loseBattle()
        }
    }
    
    private func startEnemyAI() {
        enemyAttackTimer = Timer.scheduledTimer(withTimeInterval: enemyAttackInterval, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self, self.isBattleActive else { return }
                self.damagePlayer(amount: self.enemyDamage)
            }
        }
    }
    
    private func winBattle() {
        isBattleActive = false
        battleResult = true
        log("You defeated the Syntax Error!")
        stopBattle()
    }
    
    private func loseBattle() {
        isBattleActive = false
        battleResult = false
        log("You were defeated...")
        stopBattle()
    }
    
    private func log(_ message: String) {
        combatLog.append(message)
        if combatLog.count > 4 {
            combatLog.removeFirst()
        }
    }
    
    // MARK: - Input
    
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
        guard isBattleActive, let spell = activeSpell else { return }
        
        let targetWord = spell.word
        let nextIndex = typedSpellText.count
        
        guard nextIndex < targetWord.count else { return }
        
        let targetCharIndex = targetWord.index(targetWord.startIndex, offsetBy: nextIndex)
        let expectedChar = String(targetWord[targetCharIndex])
        
        if key.lowercased() == expectedChar.lowercased() {
             typedSpellText.append(targetWord[targetCharIndex])
             
            if typedSpellText.count == targetWord.count {
                castActiveSpell()
            }
        }
    }
}

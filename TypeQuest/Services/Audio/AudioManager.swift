import Foundation
import AVFoundation
import AudioToolbox

@MainActor
final class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    // MARK: - UserDefaults Keys
    private enum Keys {
        static let soundEnabled = "audio_soundEnabled"
        static let musicEnabled = "audio_musicEnabled"
        static let soundVolume = "audio_soundVolume"
        static let musicVolume = "audio_musicVolume"
    }
    
    // MARK: - Published Properties (with persistence)
    @Published var soundEnabled: Bool {
        didSet { UserDefaults.standard.set(soundEnabled, forKey: Keys.soundEnabled) }
    }
    @Published var musicEnabled: Bool {
        didSet { UserDefaults.standard.set(musicEnabled, forKey: Keys.musicEnabled) }
    }
    @Published var soundVolume: Double {
        didSet { UserDefaults.standard.set(soundVolume, forKey: Keys.soundVolume) }
    }
    @Published var musicVolume: Double {
        didSet { UserDefaults.standard.set(musicVolume, forKey: Keys.musicVolume) }
    }
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private var backgroundMusicPlayer: AVAudioPlayer?
    
    // MARK: - Initialization
    
    private init() {
        // Load persisted settings or use defaults
        let defaults = UserDefaults.standard
        
        // Register defaults
        defaults.register(defaults: [
            Keys.soundEnabled: true,
            Keys.musicEnabled: true,
            Keys.soundVolume: 0.7,
            Keys.musicVolume: 0.5
        ])
        
        // Load saved values
        self.soundEnabled = defaults.bool(forKey: Keys.soundEnabled)
        self.musicEnabled = defaults.bool(forKey: Keys.musicEnabled)
        self.soundVolume = defaults.double(forKey: Keys.soundVolume)
        self.musicVolume = defaults.double(forKey: Keys.musicVolume)
    }
    
    // MARK: - Sound Playback
    
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
            // Sound file not found - Fallback to System Sounds
            playSystemSoundFallback(for: soundName)
            return nil
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            audioPlayers[soundName] = player
            return player
        } catch {
            print("Failed to load sound \(soundName): \(error)")
            // Fallback
            playSystemSoundFallback(for: soundName)
            return nil
        }
    }
    
    private func playSystemSoundFallback(for soundName: String) {
        var soundID: SystemSoundID = 0
        
        switch soundName {
        case "correct_key": soundID = 1104
        case "error_key": soundID = 1053
        case "backspace": soundID = 1105
        case "session_complete": soundID = 1016
        case "level_up": soundID = 1024
        case "race_start": soundID = 1000
        case "spell_cast": soundID = 1007
        case "enemy_hit": soundID = 1013
        case "player_hit": soundID = 1003
        default: return
        }
        
        AudioServicesPlaySystemSound(soundID)
    }
    
    // MARK: - Music Playback
    
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
    
    // MARK: - Reset
    
    func resetToDefaults() {
        soundEnabled = true
        musicEnabled = true
        soundVolume = 0.7
        musicVolume = 0.5
    }
}

// MARK: - Sound Types

enum SoundType: String, CaseIterable {
    case correctKey = "correct_key"
    case errorKey = "error_key"
    case backspace = "backspace"
    case wordComplete = "word_complete"
    case sessionComplete = "session_complete"
    case levelUp = "level_up"
    case achievement = "achievement"
    case raceStart = "race_start"
    case spellCast = "spell_cast"
    case enemyHit = "enemy_hit"
    case playerHit = "player_hit"
}

enum MusicTrack: String, CaseIterable {
    case focus, energetic, zen, victory
}

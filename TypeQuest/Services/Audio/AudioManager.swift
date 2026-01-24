import Foundation
import AVFoundation
import AudioToolbox

@MainActor
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
        // Fallback IDs for macOS System Sounds
        // Note: Actual IDs vary by OS version, using standard alert sounds
        var soundID: SystemSoundID = 0
        
        // Map sound names to system sounds
        // correct_key -> Tock (1104)
        // error_key -> Sosumi/Basso (1053)
        // session_complete -> Hero (1051)
        
        switch soundName {
        case "correct_key": soundID = 1104
        case "error_key": soundID = 1053
        case "backspace": soundID = 1105 // Tink
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
    case raceStart = "race_start"
    case spellCast = "spell_cast"
    case enemyHit = "enemy_hit"
    case playerHit = "player_hit"
}

enum MusicTrack: String, CaseIterable {
    case focus, energetic, zen, victory
}

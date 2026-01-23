import Foundation
import SwiftData

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

enum ThemeStyle: String, Codable, CaseIterable {
    case system, light, dark, vibrant, professional, highContrast, eInk
}

enum KeyboardLayoutType: String, Codable, CaseIterable {
    case qwerty = "QWERTY"
    case azerty = "AZERTY"
    case qwertz = "QWERTZ"
    case dvorak = "Dvorak"
    case colemak = "Colemak"
}

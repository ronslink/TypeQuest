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
    var layout: KeyboardLayout
    var hasCompletedOnboarding: Bool
    
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
        layout: KeyboardLayout = .qwerty,
        hasCompletedOnboarding: Bool = false
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
        self.layout = layout
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }
}

enum ThemeStyle: String, Codable, CaseIterable {
    case system, light, dark, vibrant, professional, highContrast, eInk
}

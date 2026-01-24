import SwiftUI
import Combine

@MainActor
final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppThemePreset {
        didSet {
            saveTheme()
            applyTheme()
        }
    }
    
    // MARK: - Theme Presets
    enum AppThemePreset: String, CaseIterable, Codable {
        case midnight = "Midnight"
        case ocean = "Ocean"
        case forest = "Forest"
        case sunset = "Sunset"
        case lavender = "Lavender"
        
        var displayName: String { rawValue }
        
        var colors: ThemeColors {
            switch self {
            case .midnight:
                return ThemeColors(
                    primary: Color(red: 0.4, green: 0.3, blue: 0.9),
                    secondary: Color(red: 0.3, green: 0.6, blue: 0.9),
                    accent: Color(red: 0.0, green: 0.8, blue: 0.8),
                    canvas: Color(red: 0.06, green: 0.06, blue: 0.12),
                    surface: Color(red: 0.1, green: 0.1, blue: 0.18),
                    textPrimary: .white,
                    textSecondary: Color(white: 0.7),
                    success: Color(red: 0.2, green: 0.8, blue: 0.4),
                    error: Color(red: 0.9, green: 0.3, blue: 0.3)
                )
            case .ocean:
                return ThemeColors(
                    primary: Color(red: 0.1, green: 0.5, blue: 0.8),
                    secondary: Color(red: 0.0, green: 0.7, blue: 0.7),
                    accent: Color(red: 0.4, green: 0.9, blue: 0.9),
                    canvas: Color(red: 0.02, green: 0.08, blue: 0.15),
                    surface: Color(red: 0.04, green: 0.12, blue: 0.22),
                    textPrimary: .white,
                    textSecondary: Color(red: 0.6, green: 0.8, blue: 0.9),
                    success: Color(red: 0.2, green: 0.9, blue: 0.6),
                    error: Color(red: 1.0, green: 0.4, blue: 0.4)
                )
            case .forest:
                return ThemeColors(
                    primary: Color(red: 0.2, green: 0.6, blue: 0.4),
                    secondary: Color(red: 0.4, green: 0.7, blue: 0.3),
                    accent: Color(red: 0.8, green: 0.9, blue: 0.3),
                    canvas: Color(red: 0.05, green: 0.1, blue: 0.08),
                    surface: Color(red: 0.08, green: 0.15, blue: 0.12),
                    textPrimary: .white,
                    textSecondary: Color(red: 0.7, green: 0.85, blue: 0.75),
                    success: Color(red: 0.4, green: 0.9, blue: 0.5),
                    error: Color(red: 0.9, green: 0.4, blue: 0.3)
                )
            case .sunset:
                return ThemeColors(
                    primary: Color(red: 0.9, green: 0.4, blue: 0.2),
                    secondary: Color(red: 0.95, green: 0.6, blue: 0.3),
                    accent: Color(red: 1.0, green: 0.8, blue: 0.4),
                    canvas: Color(red: 0.12, green: 0.06, blue: 0.06),
                    surface: Color(red: 0.18, green: 0.1, blue: 0.1),
                    textPrimary: .white,
                    textSecondary: Color(red: 0.9, green: 0.8, blue: 0.7),
                    success: Color(red: 0.5, green: 0.9, blue: 0.5),
                    error: Color(red: 1.0, green: 0.3, blue: 0.3)
                )
            case .lavender:
                return ThemeColors(
                    primary: Color(red: 0.6, green: 0.4, blue: 0.8),
                    secondary: Color(red: 0.8, green: 0.5, blue: 0.9),
                    accent: Color(red: 0.9, green: 0.7, blue: 1.0),
                    canvas: Color(red: 0.08, green: 0.06, blue: 0.12),
                    surface: Color(red: 0.12, green: 0.1, blue: 0.18),
                    textPrimary: .white,
                    textSecondary: Color(red: 0.85, green: 0.8, blue: 0.9),
                    success: Color(red: 0.4, green: 0.9, blue: 0.6),
                    error: Color(red: 0.95, green: 0.4, blue: 0.5)
                )
            }
        }
        
        var iconName: String {
            switch self {
            case .midnight: return "moon.stars.fill"
            case .ocean: return "water.waves"
            case .forest: return "leaf.fill"
            case .sunset: return "sun.horizon.fill"
            case .lavender: return "sparkles"
            }
        }
        
        var isPro: Bool {
            switch self {
            case .midnight: return false
            default: return true
            }
        }
    }
    
    // MARK: - Theme Colors
    struct ThemeColors {
        let primary: Color
        let secondary: Color
        let accent: Color
        let canvas: Color
        let surface: Color
        let textPrimary: Color
        let textSecondary: Color
        let success: Color
        let error: Color
    }
    
    // Current colors (reactive)
    var colors: ThemeColors {
        currentTheme.colors
    }
    
    // MARK: - Init
    private init() {
        // Load saved theme
        if let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme"),
           let theme = AppThemePreset(rawValue: savedTheme) {
            self.currentTheme = theme
        } else {
            self.currentTheme = .midnight
        }
    }
    
    private func saveTheme() {
        UserDefaults.standard.set(currentTheme.rawValue, forKey: "selectedTheme")
    }
    
    private func applyTheme() {
        // Post notification for views that need manual refresh
        NotificationCenter.default.post(name: .themeDidChange, object: nil)
    }
    
    // Convenience accessors
    var primary: Color { colors.primary }
    var secondary: Color { colors.secondary }
    var accent: Color { colors.accent }
    var canvas: Color { colors.canvas }
    var surface: Color { colors.surface }
    var textPrimary: Color { colors.textPrimary }
    var textSecondary: Color { colors.textSecondary }
    var success: Color { colors.success }
    var error: Color { colors.error }
}

extension Notification.Name {
    static let themeDidChange = Notification.Name("themeDidChange")
}

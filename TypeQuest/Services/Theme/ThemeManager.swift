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
                    primary: Color(hex: "6366F1"),
                    secondary: Color(hex: "8B5CF6"),
                    accent: Color(hex: "06B6D4"),
                    canvas: Color(hex: "0A0F1C"),
                    surface: Color(hex: "141B2A"),
                    textPrimary: Color(hex: "F1F5F9"),
                    textSecondary: Color(hex: "CBD5E1"),
                    success: Color(hex: "22C55E"),
                    error: Color(hex: "EF4444")
                )
            case .ocean:
                return ThemeColors(
                    primary: Color(hex: "0EA5E9"),
                    secondary: Color(hex: "06B6D4"),
                    accent: Color(hex: "22D3EE"),
                    canvas: Color(hex: "020617"),
                    surface: Color(hex: "0B1221"),
                    textPrimary: Color(hex: "F0F9FF"),
                    textSecondary: Color(hex: "7DD3FC"),
                    success: Color(hex: "34D399"),
                    error: Color(hex: "FCA5A5")
                )
            case .forest:
                return ThemeColors(
                    primary: Color(hex: "22C55E"),
                    secondary: Color(hex: "84CC16"),
                    accent: Color(hex: "A3E635"),
                    canvas: Color(hex: "052E16"),
                    surface: Color(hex: "0A3D1E"),
                    textPrimary: Color(hex: "F0FDF4"),
                    textSecondary: Color(hex: "86EFAC"),
                    success: Color(hex: "4ADE80"),
                    error: Color(hex: "F87171")
                )
            case .sunset:
                return ThemeColors(
                    primary: Color(hex: "F97316"),
                    secondary: Color(hex: "FB923C"),
                    accent: Color(hex: "FBBF24"),
                    canvas: Color(hex: "2A0A0A"),
                    surface: Color(hex: "3D1212"),
                    textPrimary: Color(hex: "FFF7ED"),
                    textSecondary: Color(hex: "FED7AA"),
                    success: Color(hex: "86EFAC"),
                    error: Color(hex: "FCA5A5")
                )
            case .lavender:
                return ThemeColors(
                    primary: Color(hex: "A855F7"),
                    secondary: Color(hex: "C084FC"),
                    accent: Color(hex: "E9D5FF"),
                    canvas: Color(hex: "1A0B2E"),
                    surface: Color(hex: "261241"),
                    textPrimary: Color(hex: "FAF5FF"),
                    textSecondary: Color(hex: "D8B4FE"),
                    success: Color(hex: "6EE7B7"),
                    error: Color(hex: "FDA4AF")
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

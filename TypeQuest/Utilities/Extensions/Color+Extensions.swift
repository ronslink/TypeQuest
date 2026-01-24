import SwiftUI

extension Color {
    // MARK: - Deep Ocean Brand Colors
    
    static let indigoPrimary = Color(hex: "6366F1")
    static let indigoHover = Color(hex: "4F46E5")
    static let indigoPressed = Color(hex: "4338CA")
    
    static let cyanAccent = Color(hex: "06B6D4")
    static let cyanHover = Color(hex: "0891B2")
    
    // MARK: - Backgrounds
    
    static let canvasLight = Color(hex: "F8FAFC") // Slate 50
    static let canvasDark = Color(hex: "0F172A")  // Slate 900
    
    static let surfaceLight = Color(hex: "FFFFFF")
    static let surfaceDark = Color(hex: "1E293B") // Slate 800
    
    // MARK: - Semantic Colors
    
    static let success = Color(hex: "10B981") // Emerald 500
    static let error = Color(hex: "EF4444")   // Red 500
    static let warning = Color(hex: "F59E0B")  // Amber 500
    static let focus = Color(hex: "06B6D4")    // Cyan
    
    // MARK: - Text Colors
    
    static let textPrimaryLight = Color(hex: "0F172A") // Slate 900
    static let textSecondaryLight = Color(hex: "475569") // Slate 600
    static let textTertiaryLight = Color(hex: "94A3B8")  // Slate 400
    
    static let textPrimaryDark = Color(hex: "F1F5F9")  // Slate 100
    static let textSecondaryDark = Color(hex: "CBD5E1") // Slate 300
    static let textTertiaryDark = Color(hex: "94A3B8")  // Slate 400
    
    // MARK: - Helper for Hex Colors
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

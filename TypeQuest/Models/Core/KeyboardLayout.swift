import Foundation

public enum KeyboardLayout: String, Codable, CaseIterable, Sendable {
    case qwerty
    case azerty
    case qwertz
    case dvorak
    case colemak
    case nordic
    case greek
    case hindiInScript
    
    /// Returns the default layout for a given language code (ISO 639-1)
    public static func defaultFor(language: String) -> KeyboardLayout {
        switch language.lowercased() {
        case "de": return .qwertz
        case "fr": return .azerty
        case "el": return .greek
        case "hi": return .hindiInScript
        case "da", "nb", "sv", "fi": return .nordic
        default: return .qwerty
        }
    }
    
    /// Returns available layouts for a given language code
    public static func availableLayouts(for language: String) -> [KeyboardLayout] {
        switch language.lowercased() {
        case "de": 
            return [.qwertz, .qwerty, .azerty, .dvorak, .colemak]
        case "fr":
            return [.azerty, .qwerty, .qwertz, .dvorak, .colemak]
        case "el":
             return [.greek]
        case "hi":
             return [.hindiInScript]
        default:
            return KeyboardLayout.allCases.filter { $0 != .greek && $0 != .hindiInScript }
        }
    }
}

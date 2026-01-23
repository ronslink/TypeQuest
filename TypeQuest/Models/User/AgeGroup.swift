import Foundation

enum AgeGroup: String, Codable, CaseIterable {
    case child = "child"
    case teen = "teen"
    case adult = "adult"
    case senior = "senior"
    
    var displayName: String {
        switch self {
        case .child: return "Children (5-12)"
        case .teen: return "Teens (13-17)"
        case .adult: return "Adults (18-59)"
        case .senior: return "Seniors (60+)"
        }
    }
}

import Foundation
import CoreGraphics

enum PostureIssue: String, Codable, CaseIterable {
    case likelyLookingDown = "Looking at Keyboard"
    case possiblePecking = "Pecking (Hunting)"
    case wristStrain = "Wrist Strain"
    
    var advice: String {
        switch self {
        case .likelyLookingDown:
            return "Try to keep your eyes on the screen. Use the bumps on F and J to find your way."
        case .possiblePecking:
            return "Keep your fingers closer to the home row and use all fingers."
        case .wristStrain:
            return "Take a moment to stretch. Ensure your wrists are floating and not resting on the edge."
        }
    }
}


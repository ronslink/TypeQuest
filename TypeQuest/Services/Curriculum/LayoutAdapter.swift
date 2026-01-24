import Foundation
import CoreGraphics

final class LayoutAdapter: Sendable {
    static let shared = LayoutAdapter()
    
    private init() {}
    
    func characters(for abstractKey: AbstractKey, layout: KeyboardLayout) -> String {
        switch layout {
        case .qwerty:
            return qwertyMapping(for: abstractKey)
        case .azerty:
            return azertyMapping(for: abstractKey)
        case .qwertz:
            return qwertzMapping(for: abstractKey)
        case .dvorak:
            return dvorakMapping(for: abstractKey)
        case .colemak:
            return colemakMapping(for: abstractKey)
        case .nordic:
            return nordicMapping(for: abstractKey)
        case .greek:
            return greekMapping(for: abstractKey)
        case .hindiInScript:
            return hindiMapping(for: abstractKey)
        }
    }
    
    // MARK: - Mappings
    
    private func qwertyMapping(for key: AbstractKey) -> String {
        switch key {
        // Home Row
        case .homeLeftPinky: return "a"
        case .homeLeftRing: return "s"
        case .homeLeftMiddle: return "d"
        case .homeLeftIndex: return "f"
        case .homeRightIndex: return "j"
        case .homeRightMiddle: return "k"
        case .homeRightRing: return "l"
        case .homeRightPinky: return ";"
            
        // Top Row
        case .topLeftPinky: return "q"
        case .topLeftRing: return "w"
        case .topLeftMiddle: return "e"
        case .topLeftIndex: return "r"
        case .topRightIndex: return "u"
        case .topRightMiddle: return "i"
        case .topRightRing: return "o"
        case .topRightPinky: return "p"
            
        // Bottom Row
        case .bottomLeftPinky: return "z"
        case .bottomLeftRing: return "x"
        case .bottomLeftMiddle: return "c"
        case .bottomLeftIndex: return "v"
        case .bottomRightIndex: return "m"
        case .bottomRightMiddle: return ","
        case .bottomRightRing: return "."
        case .bottomRightPinky: return "/"
            
        // Number Row (Defaults)
        default: return "?" // MVP fallback for nums
        }
    }
    
    private func azertyMapping(for key: AbstractKey) -> String {
        switch key {
        // Home Row
        case .homeLeftPinky: return "q"
        case .homeLeftRing: return "s"
        case .homeLeftMiddle: return "d"
        case .homeLeftIndex: return "f"
        case .homeRightIndex: return "j"
        case .homeRightMiddle: return "k"
        case .homeRightRing: return "l"
        case .homeRightPinky: return "m"
            
        // Top Row
        case .topLeftPinky: return "a"
        case .topLeftRing: return "z"
        case .topLeftMiddle: return "e"
        case .topLeftIndex: return "r"
        case .topRightIndex: return "u"
        case .topRightMiddle: return "i"
        case .topRightRing: return "o"
        case .topRightPinky: return "p"
            
        // Bottom Row
        case .bottomLeftPinky: return "w"
        case .bottomLeftRing: return "x"
        case .bottomLeftMiddle: return "c"
        case .bottomLeftIndex: return "v"
        case .bottomRightIndex: return ","
        case .bottomRightMiddle: return ";"
        case .bottomRightRing: return ":"
        case .bottomRightPinky: return "!"
            
         // Number Row (Defaults)
        default: return "?"
        }
    }
    
    private func dvorakMapping(for key: AbstractKey) -> String {
        switch key {
        // Home Row
        case .homeLeftPinky: return "a"
        case .homeLeftRing: return "o"
        case .homeLeftMiddle: return "e"
        case .homeLeftIndex: return "u"
        case .homeRightIndex: return "h"
        case .homeRightMiddle: return "t"
        case .homeRightRing: return "n"
        case .homeRightPinky: return "s"
        
        // Top Row
        case .topLeftPinky: return "'"
        case .topLeftRing: return ","
        case .topLeftMiddle: return "."
        case .topLeftIndex: return "p"
        case .topRightIndex: return "y"
        case .topRightMiddle: return "f"
        case .topRightRing: return "g"
        case .topRightPinky: return "c"
        case .topRightPinky2: return "r" // Dvorak shifted right
        case .topRightPinky3: return "l"
        
        // Bottom Row
        case .bottomLeftPinky: return ";"
        case .bottomLeftRing: return "q"
        case .bottomLeftMiddle: return "j"
        case .bottomLeftIndex: return "k"
        case .bottomRightIndex: return "x"
        case .bottomRightMiddle: return "b"
        case .bottomRightRing: return "m"
        case .bottomRightPinky: return "w"
        case .bottomRightPinky2: return "v"
        case .bottomRightPinky3: return "z"
            
        default: return qwertyMapping(for: key) // Fallback for special keys
        }
    }
    
    private func colemakMapping(for key: AbstractKey) -> String {
        switch key {
        // Home Row
        case .homeLeftPinky: return "a"
        case .homeLeftRing: return "r"
        case .homeLeftMiddle: return "s"
        case .homeLeftIndex: return "t"
        case .homeRightIndex: return "n"
        case .homeRightMiddle: return "e"
        case .homeRightRing: return "i"
        case .homeRightPinky: return "o"
            
        // Top Row
        case .topLeftPinky: return "q"
        case .topLeftRing: return "w"
        case .topLeftMiddle: return "f"
        case .topLeftIndex: return "p"
        case .topRightIndex: return "g"
        case .topRightMiddle: return "j"
        case .topRightRing: return "l"
        case .topRightPinky: return "u"
        case .topRightPinky2: return "y"
        
        // Bottom Row
        case .bottomLeftPinky: return "z"
        case .bottomLeftRing: return "x"
        case .bottomLeftMiddle: return "c"
        case .bottomLeftIndex: return "v"
        case .bottomRightIndex: return "b" // Only meaningful change on bottom is K
        case .bottomRightMiddle: return "k"
        case .bottomRightRing: return "m"
        // Colemak keeps most punctuation in place or similar
        case .bottomRightPinky: return ","
        case .bottomRightPinky2: return "."
        
        default: return qwertyMapping(for: key)
        }
    }
    
    private func qwertzMapping(for key: AbstractKey) -> String {
        switch key {
        // SWAP Y and Z from QWERTY
        case .topLeftRing: return "w"
        case .topRightIndex: return "z" // Z is here in QWERTZ
        case .bottomLeftPinky: return "y" // Y is here in QWERTZ
        default: return qwertyMapping(for: key)
        }
    }
    
    private func nordicMapping(for key: AbstractKey) -> String {
        switch key {
        case .homeRightPinky: return "ö" // or ø
        case .topRightPinky: return "p"
        case .topRightPinky2: return "å"
        case .topRightPinky3: return "ä" // or æ
        default: return qwertyMapping(for: key)
        }
    }
    
    private func greekMapping(for key: AbstractKey) -> String {
        switch key {
        case .homeLeftPinky: return "α"
        case .homeLeftRing: return "σ"
        case .homeLeftMiddle: return "δ"
        case .homeLeftIndex: return "φ"
        case .homeRightIndex: return "ξ"
        case .homeRightMiddle: return "κ"
        case .homeRightRing: return "λ"
        case .homeRightPinky: return "´" // Dead key often here
        
        case .topLeftPinky: return ";"
        case .topLeftRing: return "ς"
        case .topLeftMiddle: return "ε"
        case .topLeftIndex: return "ρ"
        case .topRightIndex: return "υ"
        case .topRightMiddle: return "θ"
        case .topRightRing: return "ι"
        case .topRightPinky: return "ο"
        case .topRightPinky2: return "π"
        
        case .bottomLeftPinky: return "ζ"
        case .bottomLeftRing: return "χ"
        case .bottomLeftMiddle: return "ψ"
        case .bottomLeftIndex: return "ω"
        case .bottomRightIndex: return "β"
        case .bottomRightMiddle: return "ν"
        case .bottomRightRing: return "μ"
        case .bottomRightPinky: return ","
        
        default: return qwertyMapping(for: key)
        }
    }
    
    private func hindiMapping(for key: AbstractKey) -> String {
        // InScript Standard
        switch key {
        case .homeLeftPinky: return "ो"
        case .homeLeftRing: return "े"
        case .homeLeftMiddle: return "ा"
        case .homeLeftIndex: return "ि"
        case .homeRightIndex: return "र"
        case .homeRightMiddle: return "क"
        case .homeRightRing: return "त"
        case .homeRightPinky: return "च"
        case .homeRightPinky2: return "ट"
        
        case .topLeftPinky: return "ौ"
        case .topLeftRing: return "ै"
        case .topLeftMiddle: return "ा"
        case .topLeftIndex: return "ी"
        case .topRightIndex: return "ब"
        case .topRightMiddle: return "ह"
        case .topRightRing: return "ग"
        case .topRightPinky: return "द"
        case .topRightPinky2: return "ज"
        case .topRightPinky3: return "ड"
        
        case .bottomLeftPinky: return "ॆ"
        case .bottomLeftRing: return "ं"
        case .bottomLeftMiddle: return "म"
        case .bottomLeftIndex: return "न"
        case .bottomRightIndex: return "व"
        case .bottomRightMiddle: return "ल"
        case .bottomRightRing: return "स"
        case .bottomRightPinky: return ","
        
        default: return qwertyMapping(for: key)
        }
    }

    func logicalPosition(for char: String, layout: KeyboardLayout) -> CGPoint {
        // Reverse lookup: Find abstract key for character, then get physical position
        // This is robust because it relies on the Single Source of Truth: the Key Mapping function
        
        // MVP: Naive Scan of all AbstractKeys. Optimized approach would use a reverse map.
        // Since AbstractKey is small (~50 cases), this is negligible impact.
        
        for key in AbstractKey.allCases {
            if characters(for: key, layout: layout) == char {
                return physicalPosition(for: key)
            }
        }
        
        // Fallback or Uppercase check
        for key in AbstractKey.allCases {
            if characters(for: key, layout: layout) == char.lowercased() {
                 return physicalPosition(for: key)
            }
        }
        
        return .zero
    }
    
    private func physicalPosition(for key: AbstractKey) -> CGPoint {
        // Returns logic grid coordinates (Col, Row) scaled by key size
        let kW: CGFloat = 50
        let kH: CGFloat = 50
        
        switch key {
        // Row 0 (Top)
        case .topLeftPinky: return CGPoint(x: 1 * kW, y: 1 * kH)
        case .topLeftRing: return CGPoint(x: 2 * kW, y: 1 * kH)
        case .topLeftMiddle: return CGPoint(x: 3 * kW, y: 1 * kH)
        case .topLeftIndex: return CGPoint(x: 4 * kW, y: 1 * kH)
        case .topRightIndex: return CGPoint(x: 5 * kW, y: 1 * kH)
        case .topRightMiddle: return CGPoint(x: 6 * kW, y: 1 * kH)
        case .topRightRing: return CGPoint(x: 7 * kW, y: 1 * kH)
        case .topRightPinky: return CGPoint(x: 8 * kW, y: 1 * kH)
        case .topRightPinky2: return CGPoint(x: 9 * kW, y: 1 * kH)
        case .topRightPinky3: return CGPoint(x: 10 * kW, y: 1 * kH)
            
        // Row 1 (Home)
        case .homeLeftPinky: return CGPoint(x: 1.2 * kW, y: 2 * kH) // Slight stagger
        case .homeLeftRing: return CGPoint(x: 2.2 * kW, y: 2 * kH)
        case .homeLeftMiddle: return CGPoint(x: 3.2 * kW, y: 2 * kH)
        case .homeLeftIndex: return CGPoint(x: 4.2 * kW, y: 2 * kH)
        case .homeRightIndex: return CGPoint(x: 5.2 * kW, y: 2 * kH)
        case .homeRightMiddle: return CGPoint(x: 6.2 * kW, y: 2 * kH)
        case .homeRightRing: return CGPoint(x: 7.2 * kW, y: 2 * kH)
        case .homeRightPinky: return CGPoint(x: 8.2 * kW, y: 2 * kH)
        case .homeRightPinky2: return CGPoint(x: 9.2 * kW, y: 2 * kH)
            
        // Row 2 (Bottom)
        case .bottomLeftPinky: return CGPoint(x: 1.5 * kW, y: 3 * kH)
        case .bottomLeftRing: return CGPoint(x: 2.5 * kW, y: 3 * kH)
        case .bottomLeftMiddle: return CGPoint(x: 3.5 * kW, y: 3 * kH)
        case .bottomLeftIndex: return CGPoint(x: 4.5 * kW, y: 3 * kH)
        case .bottomRightIndex: return CGPoint(x: 5.5 * kW, y: 3 * kH)
        case .bottomRightMiddle: return CGPoint(x: 6.5 * kW, y: 3 * kH)
        case .bottomRightRing: return CGPoint(x: 7.5 * kW, y: 3 * kH)
        case .bottomRightPinky: return CGPoint(x: 8.5 * kW, y: 3 * kH)
        case .bottomRightPinky2: return CGPoint(x: 9.5 * kW, y: 3 * kH)
        case .bottomRightPinky3: return CGPoint(x: 10.5 * kW, y: 3 * kH)
            
        default: return .zero
        }
    }

    func rows(for layout: KeyboardLayout) -> [[String]] {
        switch layout {
        case .azerty:
            return [
                ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "⌫"],
                ["⇥", "a", "z", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]", "\\"],
                ["⇪", "q", "s", "d", "f", "g", "h", "j", "k", "l", "m", "'", "↩"],
                ["⇧", "w", "x", "c", "v", "b", "n", ",", ";", ":", "!", "⇧"],
                ["fn", "⌃", "⌥", "⌘", " ", "⌘", "⌥", "←", "↓", "↑", "→"]
            ]
        case .qwertz:
             return [
                ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "⌫"],
                ["⇥", "q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ü", "+", "#"],
                ["⇪", "a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä", "↩"],
                ["⇧", "y", "x", "c", "v", "b", "n", "m", ",", ".", "-", "⇧"],
                ["fn", "⌃", "⌥", "⌘", " ", "⌘", "⌥", "←", "↓", "↑", "→"]
            ]
        case .greek:
            return [
                ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "⌫"],
                ["⇥", ";", "ς", "ε", "ρ", "τ", "υ", "θ", "ι", "ο", "π", "[", "]", "\\"],
                ["⇪", "α", "σ", "δ", "φ", "γ", "η", "ξ", "κ", "λ", "´", "'", "↩"],
                ["⇧", "ζ", "χ", "ψ", "ω", "β", "ν", "μ", ",", ".", "/", "⇧"],
                ["fn", "⌃", "⌥", "⌘", " ", "⌘", "⌥", "←", "↓", "↑", "→"]
            ]
        case .hindiInScript:
             return [
                ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "⌫"],
                ["⇥", "ौ", "ै", "ा", "ी", "ू", "ब", "ह", "ग", "द", "ज", "ड", "़", "\\"],
                ["⇪", "ो", "े", "ा", "ि", "ु", "प", "र", "क", "त", "च", "ट", "↩"],
                ["⇧", " ", "ं", "म", "न", "व", "ल", "स", ",", ".", "य", "⇧"],
                ["fn", "⌃", "⌥", "⌘", " ", "⌘", "⌥", "←", "↓", "↑", "→"]
            ]
        case .nordic:
            return [
                ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "⌫"],
                ["⇥", "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "å", "¨", "'"],
                ["⇪", "a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä", "↩"],
                ["⇧", "z", "x", "c", "v", "b", "n", "m", ",", ".", "-", "⇧"],
                ["fn", "⌃", "⌥", "⌘", " ", "⌘", "⌥", "←", "↓", "↑", "→"]
            ]
        case .dvorak:
             return [
                ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "[", "]", "⌫"],
                ["⇥", "'", ",", ".", "p", "y", "f", "g", "c", "r", "l", "/", "=", "\\"],
                ["⇪", "a", "o", "e", "u", "i", "d", "h", "t", "n", "s", "-", "↩"],
                ["⇧", ";", "q", "j", "k", "x", "b", "m", "w", "v", "z", "⇧"],
                ["fn", "⌃", "⌥", "⌘", " ", "⌘", "⌥", "←", "↓", "↑", "→"]
            ]
        default: 
            return [
                ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "⌫"],
                ["⇥", "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]", "\\"],
                ["⇪", "a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "'", "↩"],
                ["⇧", "z", "x", "c", "v", "b", "n", "m", ",", ".", "/", "⇧"],
                ["fn", "⌃", "⌥", "⌘", " ", "⌘", "⌥", "←", "↓", "↑", "→"]
            ]
        }
    }
}

enum KeyColumn: String, CaseIterable, Codable {
    case leftPinky, leftRing, leftMiddle, leftIndex
    case rightIndex, rightMiddle, rightRing, rightPinky
    
    var keys: [Character] {
        switch self {
        case .leftPinky: return ["q", "a", "z", "1"]
        case .leftRing: return ["w", "s", "x", "2"]
        case .leftMiddle: return ["e", "d", "c", "3"]
        case .leftIndex: return ["r", "f", "v", "t", "g", "b", "4", "5"]
        case .rightIndex: return ["y", "h", "n", "u", "j", "m", "6", "7"]
        case .rightMiddle: return ["i", "k", ",", "8"]
        case .rightRing: return ["o", "l", ".", "9"]
        case .rightPinky: return ["p", ";", "/", "0"]
        }
    }
}


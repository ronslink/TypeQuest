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
        case .dvorak:
            return dvorakMapping(for: abstractKey)
        case .colemak:
            return colemakMapping(for: abstractKey)
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
    
    func logicalPosition(for char: String, layout: KeyboardLayout) -> CGPoint {
        let lowerChar = char.lowercased()
        
        switch layout {
        case .qwerty:
             let qwertyKeys = [
                ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
                ["a", "s", "d", "f", "g", "h", "j", "k", "l", ";"],
                ["z", "x", "c", "v", "b", "n", "m", ",", ".", "/"]
            ]
            return findInGrid(lowerChar, grid: qwertyKeys)
            
        case .azerty:
             let azertyKeys = [
                ["a", "z", "e", "r", "t", "y", "u", "i", "o", "p"],
                ["q", "s", "d", "f", "g", "h", "j", "k", "l", "m"],
                ["w", "x", "c", "v", "b", "n", ",", ";", ":", "!"]
            ]
            return findInGrid(lowerChar, grid: azertyKeys)
            
        case .dvorak:
            let dvorakKeys = [
                 ["'", ",", ".", "p", "y", "f", "g", "c", "r", "l"],
                 ["a", "o", "e", "u", "i", "d", "h", "t", "n", "s"],
                 [";", "q", "j", "k", "x", "b", "m", "w", "v", "z"]
            ]
            return findInGrid(lowerChar, grid: dvorakKeys)
            
        case .colemak:
            let colemakKeys = [
                 ["q", "w", "f", "p", "g", "j", "l", "u", "y", ";"], // Top loop simplification
                 ["a", "r", "s", "t", "d", "h", "n", "e", "i", "o"],
                 ["z", "x", "c", "v", "b", "k", "m", ",", ".", "/"]
            ]
             return findInGrid(lowerChar, grid: colemakKeys)
        }
    }
    
    private func findInGrid(_ char: String, grid: [[String]]) -> CGPoint {
        for (rIndex, row) in grid.enumerated() {
            if let cIndex = row.firstIndex(of: char) {
                return CGPoint(x: CGFloat(cIndex * 50), y: CGFloat(rIndex * 50))
            }
        }
        return .zero
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


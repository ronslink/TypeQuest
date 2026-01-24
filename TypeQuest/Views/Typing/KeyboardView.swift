import SwiftUI

struct KeyboardView: View {
    var highlightedKeys: Set<String> = []
    @StateObject private var keyboardManager = KeyboardManager.shared
    
    private var rows: [[String]] {
        let layout = DataManager.shared.currentUser?.layout ?? .qwerty
        return LayoutAdapter.shared.rows(for: layout)
    }
    
    var body: some View {
        VStack(spacing: 6) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 6) {
                    ForEach(row, id: \.self) { key in
                        KeyView(
                            key: key,
                            isPressed: isKeyPressed(key),
                            isNext: isNextKey(key)
                        )
                    }
                }
            }
        }
        .padding()
        .background(Color.surfaceDark.opacity(0.3)) // Glass effect base
        .cornerRadius(16)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: rows)
    }
    
    private func isKeyPressed(_ key: String) -> Bool {
        // Check real-time hardware key state
        if let pressed = keyboardManager.lastKeyPressed {
            // Simple mapping for demo; ideally match key codes
            return pressed.lowercased() == key.lowercased()
        }
        return false
    }
    
    private func isNextKey(_ key: String) -> Bool {
        if highlightedKeys.contains(key.lowercased()) { return true }
        if key == " " && highlightedKeys.contains(" ") { return true }
        return false
    }
}

struct KeyView: View {
    let key: String
    let isPressed: Bool
    let isNext: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(backgroundColor)
                .shadow(color: shadowColor, radius: isPressed ? 0 : 2, x: 0, y: isPressed ? 0 : 2)
            
            Text(key.uppercased())
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .foregroundColor(foregroundColor)
        }
        .frame(width: keyWidth(for: key), height: 44)
        .offset(y: isPressed ? 2 : 0)
        .animation(.spring(response: 0.1, dampingFraction: 0.6), value: isPressed)
        .accessibilityLabel(key)
        .accessibilityValue(isNext ? "Next character to type" : "")
        .accessibilityAddTraits(isPressed ? [.isSelected] : [])
    }
    
    private var backgroundColor: Color {
        if isPressed { return Color.indigoPressed }
        if isNext { return Color.indigoPrimary }
        return Color.surfaceLight
    }
    
    private var shadowColor: Color {
        if isPressed { return .clear }
        return Color.black.opacity(0.2)
    }
    
    private var foregroundColor: Color {
        if isPressed || isNext { return .white }
        return Color.textPrimaryLight
    }
    
    private func keyWidth(for key: String) -> CGFloat {
        switch key {
        case " ": return 200
        case "⌫", "↩", "⇪", "⇧": return 60
        case "⇥": return 50
        case "fn", "⌃", "⌥", "⌘": return 40
        default: return 40
        }
    }
}

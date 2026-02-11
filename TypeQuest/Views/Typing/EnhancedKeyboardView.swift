import SwiftUI

// MARK: - Enhanced Keyboard View with Hand Visualization
struct EnhancedKeyboardView: View {
    let activeKeys: [AbstractKey]
    let isHomeRowMode: Bool
    let accentColor: Color
    @State private var showHandOverlay = true
    @State private var pressedKey: String?
    
    private var rows: [[String]] {
        let layout = DataManager.shared.currentUser?.layout ?? .qwerty
        return LayoutAdapter.shared.rows(for: layout)
    }
    
    var body: some View {
        ZStack {
            // Layer 1: Main Keyboard
            VStack(spacing: 6) {
                ForEach(rows, id: \.self) { row in
                    HStack(spacing: 6) {
                        ForEach(row, id: \.self) { key in
                            EnhancedLessonKeyView(
                                key: key,
                                isHighlighted: isKeyHighlighted(key),
                                isAnchorKey: isAnchorKey(key),
                                fingerColor: fingerColor(for: key),
                                accentColor: accentColor,
                                showGhostTrail: isHomeRowMode && !isKeyHighlighted(key)
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                                    pressedKey = key
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    pressedKey = nil
                                }
                            }
                        }
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    )
            )
            
            // Layer 2: Hand Overlay (toggleable)
            if showHandOverlay {
                HandOverlayView(
                    activeKeys: activeKeys,
                    accentColor: accentColor
                )
                .transition(.opacity)
            }
        }
        .onTapGesture {
            withAnimation(.spring()) {
                showHandOverlay.toggle()
            }
        }
    }
    
    private func isKeyHighlighted(_ key: String) -> Bool {
        let layout = DataManager.shared.currentUser?.layout ?? .qwerty
        return activeKeys.contains { abstractKey in
            LayoutAdapter.shared.characters(for: abstractKey, layout: layout).lowercased() == key.lowercased()
        }
    }
    
    private func isAnchorKey(_ key: String) -> Bool {
        let k = key.lowercased()
        return k == "f" || k == "j"
    }
    
    private func fingerColor(for key: String) -> Color {
        let layout = DataManager.shared.currentUser?.layout ?? .qwerty
        let k = key.lowercased()
        
        if isHomeRowMode && !isKeyHighlighted(key) {
            return .gray.opacity(0.2)
        }
        
        for abstractKey in AbstractKey.allCases {
            let mapped = LayoutAdapter.shared.characters(for: abstractKey, layout: layout)
            if mapped == k {
                switch abstractKey {
                case .homeLeftPinky, .topLeftPinky, .bottomLeftPinky: return .pink
                case .homeLeftRing, .topLeftRing, .bottomLeftRing: return .orange
                case .homeLeftMiddle, .topLeftMiddle, .bottomLeftMiddle: return .yellow
                case .homeLeftIndex, .topLeftIndex, .bottomLeftIndex: return .green
                case .homeRightIndex, .topRightIndex, .bottomRightIndex: return .cyan
                case .homeRightMiddle, .topRightMiddle, .bottomRightMiddle: return .blue
                case .homeRightRing, .topRightRing, .bottomRightRing: return .purple
                case .homeRightPinky, .topRightPinky, .bottomRightPinky: return .red
                case .homeLeftThumb, .homeRightThumb, .space: return .indigo
                default: break
                }
            }
        }
        return k == " " ? .indigo : .gray.opacity(0.3)
    }
}

// MARK: - Hand Overlay View
struct HandOverlayView: View {
    let activeKeys: [AbstractKey]
    let accentColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            let centerX = geometry.size.width / 2
            let centerY = geometry.size.height / 2
            
            ZStack {
                // Left Hand
                HandShapeView(
                    isLeft: true,
                    fingerStates: leftFingerStates,
                    centerX: centerX - 120,
                    centerY: centerY
                )
                
                // Right Hand
                HandShapeView(
                    isLeft: false,
                    fingerStates: rightFingerStates,
                    centerX: centerX + 120,
                    centerY: centerY
                )
            }
        }
        .opacity(0.85)
    }
    
    private var leftFingerStates: [FingerState] {
        [
            isFingerActive(.homeLeftPinky) ? .active : .rest,
            isFingerActive(.homeLeftRing) ? .active : .rest,
            isFingerActive(.homeLeftMiddle) ? .active : .rest,
            isFingerActive(.homeLeftIndex) ? .active : .rest,
            isFingerActive(.homeLeftThumb) ? .active : .rest
        ]
    }
    
    private var rightFingerStates: [FingerState] {
        [
            isFingerActive(.homeRightThumb) ? .active : .rest,
            isFingerActive(.homeRightIndex) ? .active : .rest,
            isFingerActive(.homeRightMiddle) ? .active : .rest,
            isFingerActive(.homeRightRing) ? .active : .rest,
            isFingerActive(.homeRightPinky) ? .active : .rest
        ]
    }
    
    private func isFingerActive(_ key: AbstractKey) -> Bool {
        activeKeys.contains(key)
    }
}

enum FingerState {
    case rest
    case active
    case reaching
}

// MARK: - Hand Shape View
struct HandShapeView: View {
    let isLeft: Bool
    let fingerStates: [FingerState]
    let centerX: CGFloat
    let centerY: CGFloat
    
    private let fingerColors: [Color] = [.pink, .orange, .yellow, .green, .indigo]
    private let fingerWidth: CGFloat = 22
    private let fingerHeights: [CGFloat] = [55, 75, 85, 75, 50]
    
    var body: some View {
        ZStack {
            // Palm
            Ellipse()
                .fill(.ultraThinMaterial)
                .frame(width: 100, height: 90)
                .position(x: centerX, y: centerY + 40)
            
            // Fingers
            HStack(spacing: 6) {
                if isLeft {
                    fingerView(index: 0) // Pinky
                    fingerView(index: 1) // Ring
                    fingerView(index: 2) // Middle
                    fingerView(index: 3) // Index
                    thumbView // Thumb
                } else {
                    thumbView // Thumb
                    fingerView(index: 3) // Index
                    fingerView(index: 2) // Middle
                    fingerView(index: 1) // Ring
                    fingerView(index: 0) // Pinky
                }
            }
            .position(x: centerX, y: centerY - 20)
        }
    }
    
    private func fingerView(index: Int) -> some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 11)
                .fill(fingerColor(for: index))
                .frame(width: fingerWidth, height: fingerHeights[index])
                .shadow(color: fingerStates[index] == .active ? fingerColor(for: index).opacity(0.6) : .clear, radius: 8)
                .scaleEffect(fingerStates[index] == .active ? 1.1 : 1.0)
                .animation(.spring(response: 0.2, dampingFraction: 0.6), value: fingerStates[index])
            
            // Finger joint detail
            Circle()
                .fill(.white.opacity(0.3))
                .frame(width: 8, height: 8)
                .offset(y: -fingerHeights[index] / 2 + 8)
        }
    }
    
    private var thumbView: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.indigo)
            .frame(width: 20, height: 45)
            .rotationEffect(.degrees(isLeft ? 25 : -25))
            .offset(x: isLeft ? 8 : -8, y: 15)
            .shadow(color: fingerStates[4] == .active ? .indigo.opacity(0.6) : .clear, radius: 8)
    }
    
    private func fingerColor(for index: Int) -> Color {
        guard index < fingerColors.count else { return .gray }
        return fingerColors[index]
    }
}

// MARK: - Enhanced Key View with Anchor Bumps and Ghost Trails
struct EnhancedLessonKeyView: View {
    let key: String
    let isHighlighted: Bool
    let isAnchorKey: Bool
    let fingerColor: Color
    let accentColor: Color
    let showGhostTrail: Bool
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            // Ghost trail effect (when in home row mode)
            if showGhostTrail {
                RoundedRectangle(cornerRadius: 6)
                    .fill(fingerColor.opacity(0.15))
                    .frame(width: keyWidth(for: key), height: 36)
                    .blur(radius: 4)
            }
            
            // Main key shape
            RoundedRectangle(cornerRadius: 6)
                .fill(keyGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(borderColor, lineWidth: isHighlighted ? 2 : 1)
                )
                .shadow(color: shadowColor, radius: isHighlighted ? 12 : 0)
                .overlay(alignment: .bottom) {
                    // Anchor bump for F and J keys
                    if isAnchorKey {
                        AnchorBumpView()
                            .offset(y: 16)
                    }
                }
            
            // Key content
            Text(key.uppercased())
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(textColor)
        }
        .frame(width: keyWidth(for: key), height: 36)
        .scaleEffect(isPressed ? 0.95 : (isHighlighted ? 1.1 : 1.0))
        .animation(.spring(response: 0.15, dampingFraction: 0.7), value: isHighlighted)
        .animation(.spring(response: 0.1, dampingFraction: 0.5), value: isPressed)
        .onTapGesture {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
    }
    
    private var keyGradient: LinearGradient {
        if isHighlighted {
            return LinearGradient(
                colors: [fingerColor, fingerColor.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [.white.opacity(0.12), .white.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var borderColor: Color {
        isHighlighted ? .white.opacity(0.9) : fingerColor.opacity(0.4)
    }
    
    private var shadowColor: Color {
        isHighlighted ? fingerColor.opacity(0.7) : .clear
    }
    
    private var textColor: Color {
        isHighlighted ? .white : .primary.opacity(0.8)
    }
    
    private func keyWidth(for key: String) -> CGFloat {
        switch key {
        case " ": return 180
        case "⌫", "↩", "⇪", "⇧": return 48
        case "⇥": return 40
        case "fn", "⌃", "⌥", "⌘": return 32
        default: return 32
        }
    }
}

// MARK: - Anchor Bump View (for F and J keys)
struct AnchorBumpView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(.white.opacity(0.6))
            .frame(width: 14, height: 3)
            .shadow(color: .black.opacity(0.2), radius: 1, y: 1)
    }
}

// MARK: - Finger-to-Key Color Mapping Guide
struct FingerColorGuideView: View {
    let accentColor: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Finger Color Guide")
                .font(.caption.bold())
                .foregroundColor(.secondary)
            
            HStack(spacing: 16) {
                FingerColorItem(color: .pink, label: "Pinky", keys: "A Q Z 1")
                FingerColorItem(color: .orange, label: "Ring", keys: "S W X 2")
                FingerColorItem(color: .yellow, label: "Middle", keys: "D E C 3")
                FingerColorItem(color: .green, label: "Index", keys: "F G R T V B")
                FingerColorItem(color: .indigo, label: "Thumb", keys: "Space")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct FingerColorItem: View {
    let color: Color
    let label: String
    let keys: String
    
    var body: some View {
        VStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
                .shadow(color: color.opacity(0.5), radius: 4)
            
            Text(label)
                .font(.caption2.bold())
                .foregroundColor(.primary)
            
            Text(keys)
                .font(.system(size: 8, design: .monospaced))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 50)
    }
}

// MARK: - Keyboard with Integrated Hand Guide
struct KeyboardWithHandGuideView: View {
    let activeKeys: [AbstractKey]
    let isHomeRowMode: Bool
    let accentColor: Color
    
    var body: some View {
        VStack(spacing: 20) {
            // Finger color guide
            FingerColorGuideView(accentColor: accentColor)
            
            // Main keyboard with hand overlay
            EnhancedKeyboardView(
                activeKeys: activeKeys,
                isHomeRowMode: isHomeRowMode,
                accentColor: accentColor
            )
            
            // Instructional text
            Text("Tap the keyboard to toggle hand overlay")
                .font(.caption)
                .foregroundColor(.secondary.opacity(0.7))
        }
    }
}

#Preview {
    KeyboardWithHandGuideView(
        activeKeys: [.homeLeftPinky, .homeLeftRing, .homeLeftMiddle, .homeLeftIndex,
                     .homeRightIndex, .homeRightMiddle, .homeRightRing, .homeRightPinky],
        isHomeRowMode: true,
        accentColor: .green
    )
    .padding()
    .background(Color.black.opacity(0.3))
}

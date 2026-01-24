import SwiftUI

struct LessonIntroView: View {
    let lesson: Lesson
    let userProfile: UserProfile?
    @Binding var showIntro: Bool
    
    
    @State private var introStep: IntroStep = .homeRow
    @State private var animationPhase = false
    
    enum IntroStep {
        case homeRow
        case activeKeys
    }
    
    // Adapted Age Logic
    var currentAgeGroup: AgeGroup {
        userProfile?.ageGroup ?? .adult
    }
    
    var adaptedHabitTip: String {
        switch currentAgeGroup {
        case .child:
            return lesson.childNarrative ?? lesson.habitTip
        case .senior:
            return lesson.seniorFocus ?? lesson.habitTip
        default:
            return lesson.habitTip
        }
    }
    
    // Fallback to ensure visuals never break
    var effectiveLessonKeys: [AbstractKey] {
        if let keys = lesson.requiredKeys, !keys.isEmpty {
            return keys
        }
        // If data is missing, default to F & J (Home Anchors) or deduce
        return [.homeLeftIndex, .homeRightIndex] 
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // LAYER 1: Background
            stageGradient
                .ignoresSafeArea()
            
            // LAYER 2: Scrollable Content
            ScrollView {
                VStack(spacing: 30) {
                    // Animated Stage Icon
                    Image(systemName: "star.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.white, .yellow)
                        .scaleEffect(animationPhase ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(), value: animationPhase)
                        .shadow(radius: 10)
                        .padding(.top, 60) // Extra top padding
                    
                    // Stage & Lesson Number
                    Text("Stage \(lesson.stageId) • Lesson \(lesson.order)")
                        .font(.caption)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                    
                    // Learning Goal & Instruction
                    VStack(spacing: 12) {
                        Text(introStep == .homeRow ? "First Step" : "Today's Goal")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                            .textCase(.uppercase)
                            .tracking(1)
                        
                        Text(introStep == .homeRow ? "Home Row Position" : (lesson.learningGoal.isEmpty ? lesson.name : lesson.learningGoal))
                            .font(currentAgeGroup == .senior ? .largeTitle : .title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .foregroundStyle(.white)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                            .id(introStep) // Trigger transition
                        
                        if introStep == .activeKeys {
                            if !lesson.description.isEmpty && lesson.description != lesson.name {
                                Text(lesson.description)
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 4)
                                    .padding(.horizontal)
                                    .transition(.opacity)
                            }
                        } else {
                            Text("Place your fingers on A-S-D-F and J-K-L-;")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                                .padding(.horizontal)
                                .transition(.opacity)
                        }
                    }
                    
                    // Habit Tip Card (Only in Active State)
                    if introStep == .activeKeys {
                        HabitTipCard(
                            tip: adaptedHabitTip,
                            ageGroup: currentAgeGroup
                        )
                        .transition(.opacity)
                    }
                    
                    // Biomechanical Focus (Only in Active State)
                    if introStep == .activeKeys && !lesson.biomechanicalFocus.isEmpty {
                        BiomechanicalFocusView(focus: lesson.biomechanicalFocus)
                            .transition(.opacity)
                    }
                    
                    // Visuals Section
                    VStack(spacing: 20) {
                        Text(introStep == .homeRow ? "Rest Fingers Here" : "Active Fingers & Keys")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.6))
                        
                        // Keyboard Map
                        LessonKeyboardView(
                            activeKeys: introStep == .homeRow ? HomeRowKeys : effectiveLessonKeys,
                            isHomeRowMode: introStep == .homeRow
                        )
                        .scaleEffect(0.8)
                        .animation(.default, value: introStep)
                        
                        // Hands
                        HandPlacementView(
                            activeFingers: introStep == .homeRow ? HomeRowFingers : HandPlacementView.fingers(for: effectiveLessonKeys),
                            color: introStep == .homeRow ? .white : .cyanAccent
                        )
                        .scaleEffect(0.6)
                        .frame(height: 120)
                        .animation(.default, value: introStep)
                    }
                    
                    Spacer(minLength: 120) // Bottom Scroll Padding ensures content isn't hidden by button
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure scrollview fills screen
            
            // LAYER 3: Floating Action Button (Pinned Bottom)
            VStack {
                Button(action: {
                    if introStep == .homeRow {
                        withAnimation(.spring()) {
                            introStep = .activeKeys
                        }
                    } else {
                        withAnimation(.spring()) {
                            showIntro = false
                        }
                    }
                }) {
                    HStack {
                        Text(introStep == .homeRow ? "Next" : "Begin Lesson")
                            .font(.headline)
                            .fontWeight(.bold)
                        if introStep == .homeRow {
                            Image(systemName: "arrow.right")
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(.indigoPrimary)
                .shadow(radius: 5)
                .scaleEffect(animationPhase ? 1.05 : 1.0) // Pulse effect
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: animationPhase)
                .padding(.bottom, 100) // Lift way up from bottom edge to be safe
            }
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(colors: [.black.opacity(0), .black.opacity(0.4)], startPoint: .top, endPoint: .bottom)
                    .frame(height: 100)
                    .allowsHitTesting(false)
            )
            .zIndex(10) // Force Layout Priority
        }
        .onAppear {
            animationPhase = true
            // Optional: Auto-advance after 5 seconds if child
            if currentAgeGroup == .child {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    if introStep == .homeRow {
                        withAnimation {
                            introStep = .activeKeys
                        }
                    }
                }
            }
        }
    }
    
    // Hardcoded Home Row Helpers
    private var HomeRowKeys: [AbstractKey] {
        return [.homeLeftPinky, .homeLeftRing, .homeLeftMiddle, .homeLeftIndex, .homeRightIndex, .homeRightMiddle, .homeRightRing, .homeRightPinky]
    }
    private var HomeRowFingers: Set<Int> {
        return [0, 1, 2, 3, 6, 7, 8, 9] // All except thumbs used for resting
    }
    
    var stageGradient: LinearGradient {
        let colors: [Color] = {
            switch lesson.stageId {
            case 1: return [.green, .teal]
            case 2: return [.blue, .cyan]
            case 3: return [.indigo, .purple]
            case 4: return [.orange, .pink]
            case 5: return [.red, .orange]
            case 6: return [.gray, .black]
            default: return [.blue, .purple]
            }
        }()
        
        return LinearGradient(
            colors: colors.map { $0.opacity(0.8) },
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct HabitTipCard: View {
    let tip: String
    let ageGroup: AgeGroup
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: iconName)
            .font(.system(size: iconSize))
            .foregroundColor(.yellow)
            
            Text(tip)
            .font(textFont)
            .foregroundColor(.white)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
            .overlay(
            RoundedRectangle(cornerRadius: 15)
            .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
        )
        .padding(.horizontal, 10)
    }
    
    var iconName: String {
        switch ageGroup {
            case .child: return "star.fill"
            case .senior: return "lightbulb.fill"
            default: return "info.circle.fill"
        }
    }
    
    var iconSize: CGFloat {
        ageGroup == .senior ? 32 : 24
    }
    
    var textFont: Font {
        ageGroup == .senior ? .title3 : .body
    }
}

struct BiomechanicalFocusView: View {
    let focus: String
    
    var body: some View {
        HStack {
            Image(systemName: "hand.raised.fill")
            .foregroundColor(.white.opacity(0.8))
            Text("Focus: \(focus)")
            .font(.subheadline)
            .foregroundColor(.white.opacity(0.8))
        }
        .padding(10)
        .background(Color.black.opacity(0.2))
        .cornerRadius(20)
    }
}

#Preview {
    LessonIntroView(lesson: Lesson(id: "1", name: "Test", description: "", stageId: 1, moduleId: "1", order: 1, difficulty: .beginner, contentPattern: "", passingRequirements: .init(minAccuracy: 0, minWPM: 0), requiredKeys: nil, learningGoal: "Master F and J", habitTip: "Feel the bumps!", biomechanicalFocus: "Curved fingers", recommendedDuration: 5), userProfile: nil, showIntro: .constant(true))
}

// MARK: - Hand Placement Visuals

struct HandPlacementView: View {
    let activeFingers: Set<Int> // 0-4 Left (Pinky->Thumb), 5-9 Right (Thumb->Pinky)
    let color: Color
    
    // Mapping keys to fingers (Simplified for MVP logic)
    // Left: Pinky=0, Ring=1, Middle=2, Index=3, Thumb=4
    // Right: Thumb=5, Index=6, Middle=7, Ring=8, Pinky=9
    
    var body: some View {
        HStack(spacing: 40) {
            // Left Hand
            HandShape(isLeft: true, activeFingers: activeFingers, color: color)
            .frame(width: 120, height: 160)
            
            // Right Hand
            HandShape(isLeft: false, activeFingers: activeFingers, color: color)
            .frame(width: 120, height: 160)
        }
    }
}

struct HandShape: View {
    let isLeft: Bool
    let activeFingers: Set<Int>
    let color: Color
    
    var body: some View {
        ZStack {
            // Palm
            RoundedRectangle(cornerRadius: 20)
            .fill(Color.white.opacity(0.1))
            .frame(width: 80, height: 90)
            .offset(y: 20)
            
            // Fingers
            HStack(alignment: .bottom, spacing: 4) {
                if isLeft {
                    Finger(isActive: activeFingers.contains(0), height: 50, color: color) // Pinky
                    Finger(isActive: activeFingers.contains(1), height: 70, color: color) // Ring
                    Finger(isActive: activeFingers.contains(2), height: 80, color: color) // Middle
                    Finger(isActive: activeFingers.contains(3), height: 70, color: color) // Index
                    Finger(isActive: activeFingers.contains(4), height: 40, color: color) // Thumb
                    .rotationEffect(.degrees(30))
                    .offset(x: 10, y: 15)
                } else {
                    Finger(isActive: activeFingers.contains(5), height: 40, color: color) // Thumb
                    .rotationEffect(.degrees(-30))
                    .offset(x: -10, y: 15)
                    Finger(isActive: activeFingers.contains(6), height: 70, color: color) // Index
                    Finger(isActive: activeFingers.contains(7), height: 80, color: color) // Middle
                    Finger(isActive: activeFingers.contains(8), height: 70, color: color) // Ring
                    Finger(isActive: activeFingers.contains(9), height: 50, color: color) // Pinky
                }
            }
        }
    }
}

struct Finger: View {
    let isActive: Bool
    let height: CGFloat
    let color: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
        .fill(isActive ? color : Color.white.opacity(0.1))
        .frame(width: 16, height: height)
        .shadow(color: isActive ? color.opacity(0.5) : .clear, radius: 5)
        .scaleEffect(isActive ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isActive)
    }
}

// Logic to map AbstractKeys to Fingers
extension HandPlacementView {
    static func fingers(for keys: [AbstractKey]?) -> Set<Int> {
        guard let keys = keys else { return [] }
        var fingers = Set<Int>()
        
        for key in keys {
            switch key {
                // Left Hand
                case .homeLeftPinky, .topLeftPinky, .bottomLeftPinky, .numLeftPinky: fingers.insert(0)
                case .homeLeftRing, .topLeftRing, .bottomLeftRing, .numLeftRing: fingers.insert(1)
                case .homeLeftMiddle, .topLeftMiddle, .bottomLeftMiddle, .numLeftMiddle: fingers.insert(2)
                case .homeLeftIndex, .topLeftIndex, .bottomLeftIndex, .numLeftIndex: fingers.insert(3)
                
                // Right Hand
                case .homeRightIndex, .topRightIndex, .bottomRightIndex, .numRightIndex: fingers.insert(6)
                case .homeRightMiddle, .topRightMiddle, .bottomRightMiddle, .numRightMiddle: fingers.insert(7)
                case .homeRightRing, .topRightRing, .bottomRightRing, .numRightRing: fingers.insert(8)
                case .homeRightPinky, .topRightPinky, .bottomRightPinky, .numRightPinky, .topRightPinky2, .topRightPinky3, .bottomRightPinky2, .bottomRightPinky3: fingers.insert(9)
                
                default: break
            }
        }
        
        // Always thumbs for space
        fingers.insert(4)
        fingers.insert(5)
        
        return fingers
    }
}

// MARK: - Keyboard Visuals

// MARK: - Keyboard Visuals

struct LessonKeyboardView: View {
    let activeKeys: [AbstractKey]
    var isHomeRowMode: Bool = false
    
    // Dynamic Layout Rows
    private var rows: [[String]] {
        let layout = DataManager.shared.currentUser?.layout ?? .qwerty
        return LayoutAdapter.shared.rows(for: layout)
    }
    
    var body: some View {
        VStack(spacing: 6) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 6) {
                    ForEach(row, id: \.self) { key in
                        LessonKeyView(
                            key: key,
                            isHighlighted: isKeyHighlighted(key),
                            fingerColor: fingerColor(for: key)
                        )
                    }
                }
            }
        }
        .padding()
        .background(Color.surfaceDark.opacity(0.5))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
            .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
    
    private func isKeyHighlighted(_ key: String) -> Bool {
        let layout = DataManager.shared.currentUser?.layout ?? .qwerty
        
        // Check if this physical key (represented by the char string) matches any active AbstractKey
        // Inverse check: Does this char map to an active AbstractKey?
        // Optimization: Pre-calculate the set of active CHARACTERS for this layout
        
        for abstractKey in activeKeys {
            let mappedChar = LayoutAdapter.shared.characters(for: abstractKey, layout: layout)
            if mappedChar.lowercased() == key.lowercased() {
                return true
            }
        }
        return false
    }
    
    private func fingerColor(for key: String) -> Color {
        // Use LayoutAdapter logic to find physical position, then map to finger Color
        // Or simpler: Reuse the logic from HandPlacementView?
        // Actually, we need to know "Which finger hits this key?"
        // We can use LayoutAdapter.logicalPosition(for: key) -> AbstractKey -> KeyColumn
        
        let layout = DataManager.shared.currentUser?.layout ?? .qwerty
        let k = key.lowercased()
        
        if isHomeRowMode, !isKeyHighlighted(key) {
            return .gray.opacity(0.2)
        }
        
        // Identify which AbstractKey this char belongs to
        // This is a reverse lookup. LayoutAdapter implies one-to-one for primary keys.
        // We can iterate all keys to find the match.
        
        // Fast path for common non-alpha keys not in AbstractKey map yet (Standard ISO)
        if ["⌫", "↩", "⇪", "⇧", "⇥", "fn", "⌃", "⌥", "⌘"].contains(key) { return .gray.opacity(0.3) }
        
        for abstractKey in AbstractKey.allCases {
            let mapped = LayoutAdapter.shared.characters(for: abstractKey, layout: layout)
            if mapped == k {
                // Found the abstract key, now map to finger color
                switch abstractKey {
                    case .homeLeftPinky, .topLeftPinky, .bottomLeftPinky, .numLeftPinky: return .pink
                    case .homeLeftRing, .topLeftRing, .bottomLeftRing, .numLeftRing: return .orange
                    case .homeLeftMiddle, .topLeftMiddle, .bottomLeftMiddle, .numLeftMiddle: return .yellow
                    case .homeLeftIndex, .topLeftIndex, .bottomLeftIndex, .numLeftIndex: return .green
                    
                    case .homeRightIndex, .topRightIndex, .bottomRightIndex, .numRightIndex: return .cyan
                    case .homeRightMiddle, .topRightMiddle, .bottomRightMiddle, .numRightMiddle: return .blue
                    case .homeRightRing, .topRightRing, .bottomRightRing, .numRightRing: return .purple
                    case .homeRightPinky, .topRightPinky, .bottomRightPinky, .numRightPinky,
                    .topRightPinky2, .topRightPinky3, .bottomRightPinky2, .bottomRightPinky3, .homeRightPinky2:
                    return .red
                }
            }
        }
        
        if k == " " { return .gray }
        
        return .gray.opacity(0.3)
    }
}

struct LessonKeyView: View {
    let key: String
    let isHighlighted: Bool
    let fingerColor: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
            .fill(isHighlighted ? fingerColor : Color.white.opacity(0.05))
            .overlay(
            RoundedRectangle(cornerRadius: 6)
            .stroke(isHighlighted ? Color.white : fingerColor.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: isHighlighted ? fingerColor.opacity(0.8) : .clear, radius: 8)
            
            Text(key.uppercased())
            .font(.system(size: 10, weight: .bold, design: .monospaced)) // Reduced size for fit
            .foregroundColor(isHighlighted ? .white : .white.opacity(0.5))
        }
        .frame(width: keyWidth(for: key), height: 32)
        .scaleEffect(isHighlighted ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isHighlighted)
    }
    
    private func keyWidth(for key: String) -> CGFloat {
        switch key {
            case " ": return 160
            case "⌫", "↩", "⇪", "⇧": return 44
            case "⇥": return 36
            case "fn", "⌃", "⌥", "⌘": return 28
            default: return 28
        }
    }
}

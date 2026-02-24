import SwiftUI
import Foundation

struct LessonIntroView: View {
    let lesson: Lesson
    let userProfile: UserProfile?
    @Binding var showIntro: Bool
    @State private var introStep: IntroStep = .homeRow
    @State private var animateEntry = false
    @State private var pulsePhase = false
    @Environment(\.colorScheme) var colorScheme
    
    enum IntroStep {
        case homeRow
        case activeKeys
    }
    
    var currentAgeGroup: AgeGroup {
        userProfile?.ageGroup ?? .adult
    }
    
    var adaptedHabitTip: String {
        switch currentAgeGroup {
        case .child: return lesson.childNarrative ?? lesson.habitTip
        case .senior: return lesson.seniorFocus ?? lesson.habitTip
        default: return lesson.habitTip
        }
    }
    
    var effectiveLessonKeys: [AbstractKey] {
        lesson.requiredKeys ?? [.homeLeftIndex, .homeRightIndex]
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // LAYER 1: Immersive Background
                immersiveBackground
                    .ignoresSafeArea()
                
                // LAYER 2: Floating Particles
                FloatingParticlesView(count: 15, geometry: geometry)
                    .opacity(0.6)
                
                // LAYER 3: Glass Overlay
                glassOverlay
                
                // LAYER 4: Main Content
                mainContent(geometry: geometry)
                
                // LAYER 5: Floating Action Button
                VStack {
                    Spacer()
                    actionButton
                        .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                animateEntry = true
            }
            startPulseAnimation()
        }
    }
    
    // MARK: - Immersive Background
    private var immersiveBackground: some View {
        ZStack {
            // Dynamic gradient based on stage
            stageGradient
            
            // Radial glow from center
            RadialGradient(
                gradient: Gradient(colors: [.white.opacity(0.15), .clear]),
                center: .center,
                startRadius: 0,
                endRadius: 500
            )
            .ignoresSafeArea()
            
            // Subtle grid pattern
            PatternGridView()
                .opacity(0.03)
        }
    }
    
    private var stageGradient: LinearGradient {
        let scheme = stageColorScheme
        return LinearGradient(
            colors: scheme.primaryGradient,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var stageColorScheme: (primaryGradient: [Color], accentColor: Color) {
        switch lesson.stageId {
        case 1: return ([Color.green.opacity(0.8), Color.teal.opacity(0.6)], .green)
        case 2: return ([Color.blue.opacity(0.8), Color.cyan.opacity(0.6)], .blue)
        case 3: return ([Color.indigo.opacity(0.8), Color.purple.opacity(0.6)], .indigo)
        case 4: return ([Color.orange.opacity(0.8), Color.pink.opacity(0.6)], .orange)
        case 5: return ([Color.red.opacity(0.7), Color.orange.opacity(0.5)], .red)
        case 6: return ([Color.gray.opacity(0.6), Color.black.opacity(0.8)], .gray)
        default: return ([Color.blue.opacity(0.6), Color.purple.opacity(0.4)], .blue)
        }
    }
    
    // MARK: - Glass Overlay
    private var glassOverlay: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .background(.regularMaterial)
            .opacity(0.1)
            .ignoresSafeArea()
    }
    
    // MARK: - Main Content
    @ViewBuilder
    private func mainContent(geometry: GeometryProxy) -> some View {
        ScrollView {
            VStack(spacing: 32) {
                // Animated Stage Icon with 3D effect
                stageIcon
                    .offset(y: animateEntry ? 0 : -50)
                    .opacity(animateEntry ? 1 : 0)
                
                // Glass card for lesson info
                lessonInfoCard
                    .scaleEffect(animateEntry ? 1 : 0.9)
                    .opacity(animateEntry ? 1 : 0)
                
                // Keyboard visualization
                keyboardVisualizer
                    .scaleEffect(animateEntry ? 1 : 0.95)
                    .opacity(animateEntry ? 1 : 0)
                
                // Hand placement
                HandPlacementView(
                    activeFingers: introStep == .homeRow ? HomeRowFingers : HandPlacementView.fingers(for: effectiveLessonKeys),
                    color: stageColorScheme.accentColor
                )
                .scaleEffect(animateEntry ? 1 : 0.9)
                .opacity(animateEntry ? 1 : 0)
                .padding(.top, 20)
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 40)
            .padding(.top, geometry.safeAreaInsets.top + 20)
        }
        .scrollDismissesKeyboard(.immediately)
    }
    
    // MARK: - Stage Icon
    private var stageIcon: some View {
        ZStack {
            // Outer glow ring
            Circle()
                .fill(stageColorScheme.accentColor.opacity(0.2))
                .frame(width: 140, height: 140)
                .blur(radius: 20)
            
            // Pulsing ring
            Circle()
                .stroke(stageColorScheme.accentColor.opacity(0.5), lineWidth: 2)
                .frame(width: 130 + (pulsePhase ? 20 : 0), height: 130 + (pulsePhase ? 20 : 0))
                .opacity(pulsePhase ? 0.3 : 0.8)
            
            // Main icon
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 120, height: 120)
                
                Image(systemName: stageIconName)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, stageColorScheme.accentColor.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: stageColorScheme.accentColor.opacity(0.5), radius: 10)
            }
        }
        .scaleEffect(pulsePhase ? 1.05 : 1.0)
    }
    
    private var stageIconName: String {
        switch lesson.stageId {
        case 1: return "hand.raised.fill"
        case 2: return "arrow.up.circle.fill"
        case 3: return "arrow.down.circle.fill"
        case 4: return "text.word.spacing"
        case 5: return "text.alignleft"
        case 6: return "number.circle.fill"
        default: return "star.fill"
        }
    }
    
    // MARK: - Lesson Info Card
    private var lessonInfoCard: some View {
        VStack(spacing: 20) {
            // Stage badge
            HStack(spacing: 12) {
                Label("\("stage_label".localized) \(lesson.stageId)", systemImage: "chevron.right")
                    .font(.caption.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                
                Text("\("lesson_label".localized) \(lesson.order)")
                    .font(.caption.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
            }
            
            // Title with animation
            VStack(spacing: 8) {
                Text(introStep == .homeRow ? "first_step".localized : "todays_goal".localized)
                    .font(.subheadline)
                    .textCase(.uppercase)
                    .foregroundColor(.secondary)
                    .tracking(2)
                
                Text(introStep == .homeRow ? "home_row_position".localized : (lesson.learningGoal.isEmpty ? lesson.name : lesson.learningGoal))
                    .font(currentAgeGroup == .senior ? .title : .title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .matchedGeometryEffect(id: "title", in: namespace)
                    .id(introStep)
            }
            
            // Description
            if introStep == .activeKeys && !lesson.description.isEmpty && lesson.description != lesson.name {
                Text(lesson.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            } else if introStep == .homeRow {
                Text("home_row_instruction".localized)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Habit tip card
            HabitTipCard(tip: adaptedHabitTip, ageGroup: currentAgeGroup, accentColor: stageColorScheme.accentColor)
                .padding(.top, 8)
            
            // Biomechanical focus if available
            if introStep == .activeKeys && !lesson.biomechanicalFocus.isEmpty {
                BiomechanicalFocusView(focus: lesson.biomechanicalFocus, accentColor: stageColorScheme.accentColor)
                    .padding(.top, 4)
            }
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
        )
    }
    
    @Namespace private var namespace
    
    // MARK: - Hand Placement View
    struct HandPlacementView: View {
        let activeFingers: Set<Int>
        let color: Color // Keep for backward compatibility or unused? actually used for non-active or fallback.
        // Actually, the requirement is to use specific colors.
        
        var body: some View {
            HStack(spacing: 40) {
                // Left Hand
                handView(isLeft: true)
                
                // Right Hand
                handView(isLeft: false)
            }
            .frame(height: 80)
        }
        
        private func handView(isLeft: Bool) -> some View {
            HStack(alignment: .bottom, spacing: 4) {
                let fingers = isLeft ? [0, 1, 2, 3, 4] : [5, 6, 7, 8, 9]
                ForEach(fingers, id: \.self) { finger in
                    // Skip thumbs for now or color them gray
                    if (finger == 4 || finger == 5) {
                        // Thumbs
                         Capsule()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 15, height: 40)
                            .rotationEffect(.degrees(isLeft ? 20 : -20))
                    } else {
                        // Fingers
                        let fColor = fingerColor(for: finger)
                        VStack {
                            Capsule()
                                .fill(activeFingers.contains(finger) ? fColor : Color.gray.opacity(0.2))
                                .frame(width: 12, height: height(for: finger))
                            
                            Circle()
                                .fill(activeFingers.contains(finger) ? fColor.opacity(0.5) : Color.gray.opacity(0.1))
                                .frame(width: 8, height: 8)
                        }
                    }
                }
            }
        }
        
        private func height(for finger: Int) -> CGFloat {
            switch finger % 5 {
            case 0: return 50 // Pinky
            case 1: return 65 // Ring
            case 2: return 75 // Middle
            case 3: return 60 // Index
            default: return 40 // Thumb
            }
        }
        
        private func fingerColor(for finger: Int) -> Color {
            switch finger {
            case 0: return .pink        // Left Pinky
            case 1: return .orange      // Left Ring
            case 2: return .yellow      // Left Middle
            case 3: return .green       // Left Index
            case 6: return .cyan        // Right Index
            case 7: return .blue        // Right Middle
            case 8: return .purple      // Right Ring
            case 9: return .red         // Right Pinky
            default: return .gray
            }
        }

        static func fingers(for keys: [AbstractKey]) -> Set<Int> {
            var fingers = Set<Int>()
            for key in keys {
                switch key {
                case .homeLeftPinky, .topLeftPinky, .bottomLeftPinky: fingers.insert(0)
                case .homeLeftRing, .topLeftRing, .bottomLeftRing: fingers.insert(1)
                case .homeLeftMiddle, .topLeftMiddle, .bottomLeftMiddle: fingers.insert(2)
                case .homeLeftIndex, .topLeftIndex, .bottomLeftIndex: fingers.insert(3)
                case .homeRightIndex, .topRightIndex, .bottomRightIndex: fingers.insert(6)
                case .homeRightMiddle, .topRightMiddle, .bottomRightMiddle: fingers.insert(7)
                case .homeRightRing, .topRightRing, .bottomRightRing: fingers.insert(8)
                case .homeRightPinky, .topRightPinky, .bottomRightPinky: fingers.insert(9)
                default: break
                }
            }
            return fingers
        }
    }

    // MARK: - Keyboard Visualizer (Enhanced with Hand Guide)
    private var keyboardVisualizer: some View {
        VStack(spacing: 8) {
            Text(introStep == .homeRow ? "rest_fingers_here".localized : "active_keys".localized)
                .font(.caption.bold())
                .foregroundColor(.secondary)
                .padding(.bottom, 4)
            
            KeyboardWithHandGuideView(
                activeKeys: introStep == .homeRow ? HomeRowKeys : effectiveLessonKeys,
                isHomeRowMode: introStep == .homeRow,
                accentColor: stageColorScheme.accentColor
            )
            .scaleEffect(0.85) // Resize to fit on screen without scrolling
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Action Button
    private var actionButton: some View {
        Button {
            triggerHaptic()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                if introStep == .homeRow {
                    introStep = .activeKeys
                } else {
                    showIntro = false
                }
            }
        } label: {
            HStack(spacing: 12) {
                Text(introStep == .homeRow ? "continue_btn".localized : "begin_lesson".localized)
                    .font(.headline)
                
                Image(systemName: introStep == .homeRow ? "arrow.right" : "play.fill")
            }
            .padding(.horizontal, 44)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [stageColorScheme.accentColor, stageColorScheme.accentColor.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .foregroundColor(.white)
            .shadow(color: stageColorScheme.accentColor.opacity(0.4), radius: 15, y: 8)
        }
        .scaleEffect(pulsePhase ? 1.05 : 1.0)
        .buttonStyle(.plain)
    }
    
    // MARK: - Helper Methods
    private var HomeRowKeys: [AbstractKey] {
        [.homeLeftPinky, .homeLeftRing, .homeLeftMiddle, .homeLeftIndex,
         .homeRightIndex, .homeRightMiddle, .homeRightRing, .homeRightPinky]
    }
    
    private var HomeRowFingers: Set<Int> {
        [0, 1, 2, 3, 6, 7, 8, 9]
    }
    
    private func startPulseAnimation() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            pulsePhase = true
        }
    }
    
    private func triggerHaptic() {
        #if os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .now)
        #endif
    }
}

// MARK: - Floating Particles
struct FloatingParticlesView: View {
    let count: Int
    let geometry: GeometryProxy
    @State private var particles: [Particle] = []
    
    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var opacity: Double
        var delay: Double
    }
    
    var body: some View {
        ForEach(particles) { particle in
            Circle()
                .fill(.white)
                .frame(width: particle.size, height: particle.size)
                .opacity(particle.opacity)
                .position(x: particle.x, y: particle.y)
        }
        .onAppear {
            generateParticles()
        }
    }
    
    private func generateParticles() {
        particles = (0..<count).map { _ in
            Particle(
                x: CGFloat.random(in: 0...geometry.size.width),
                y: CGFloat.random(in: 0...geometry.size.height),
                size: CGFloat.random(in: 4...12),
                opacity: Double.random(in: 0.1...0.4),
                delay: Double.random(in: 0...2)
            )
        }
    }
}

// MARK: - Pattern Grid
struct PatternGridView: View {
    var body: some View {
        Canvas { context, size in
            let gridSize: CGFloat = 40
            for x in stride(from: 0, through: size.width, by: gridSize) {
                for y in stride(from: 0, through: size.height, by: gridSize) {
                    let rect = CGRect(x: x, y: y, width: gridSize, height: gridSize)
                    context.stroke(
                        Path(rect.insetBy(dx: 1, dy: 1)),
                        with: .color(.white.opacity(0.1)),
                        lineWidth: 0.5
                    )
                }
            }
        }
    }
}

// MARK: - Glass Material Modifier
extension View {
    var glassMaterial: some View {
        self.background(.ultraThinMaterial)
    }
}

// MARK: - Enhanced Habit Tip Card
struct HabitTipCard: View {
    let tip: String
    let ageGroup: AgeGroup
    let accentColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(accentColor)
                .frame(width: 44, height: 44)
                .background(accentColor.opacity(0.15))
                .clipShape(Circle())
            
            Text(tip)
                .font(fontSize)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.thinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(accentColor.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private var iconName: String {
        switch ageGroup {
        case .child: return "star.fill"
        case .senior: return "lightbulb.fill"
        default: return "info.circle.fill"
        }
    }
    
    private var fontSize: Font {
        ageGroup == .senior ? .body : .subheadline
    }
}

// MARK: - Enhanced Biomechanical Focus
struct BiomechanicalFocusView: View {
    let focus: String
    let accentColor: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "hand.raised.fill")
                .foregroundColor(accentColor)
            Text("\("focus_label".localized): \(focus)")
                .font(.subheadline.weight(.medium))
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(
            Capsule()
                .fill(accentColor.opacity(0.1))
        )
    }
}

// MARK: - Biomechanical Focus
// MARK: - Preview
#Preview {
    LessonIntroView(
        lesson: Lesson(
            id: "1",
            name: "A & S Keys",
            description: "Master the A and S keys with your left hand",
            stageId: 1,
            moduleId: "1.1",
            order: 1,
            difficulty: .beginner,
            contentPattern: "aaa sss",
            passingRequirements: .init(minAccuracy: 90, minWPM: 15),
            requiredKeys: [.homeLeftPinky, .homeLeftRing],
            learningGoal: "Master A & S Keys",
            habitTip: "Keep your fingers curved like you're playing piano",
            biomechanicalFocus: "Relaxed, curved fingers",
            recommendedDuration: 5
        ),
        userProfile: nil,
        showIntro: .constant(true)
    )
}


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
                IntroHandOverlayView(
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
struct IntroHandOverlayView: View {
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
    
    // Removed fingerColors array to use consistent subtle styling
    private let fingerWidth: CGFloat = 22
    private let fingerHeights: [CGFloat] = [55, 75, 85, 75, 50]
    
    var body: some View {
        ZStack {
            // Palm - Translucent
            Ellipse()
                .fill(.ultraThinMaterial)
                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
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
        let isActive = fingerStates[index] == .active
        
        return VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 11)
                .fill(isActive ? Color.blue.opacity(0.15) : Color.gray.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 11)
                        .stroke(isActive ? Color.blue.opacity(0.4) : Color.gray.opacity(0.2), lineWidth: 1.5)
                )
                .frame(width: fingerWidth, height: fingerHeights[index])
                .shadow(color: isActive ? Color.blue.opacity(0.2) : .clear, radius: 4)
                .scaleEffect(isActive ? 1.05 : 1.0)
                .animation(.spring(response: 0.2, dampingFraction: 0.6), value: fingerStates[index])
            
            // Finger joint detail - subtle
            Circle()
                .fill(Color.secondary.opacity(0.1))
                .frame(width: 6, height: 6)
                .offset(y: -fingerHeights[index] / 2 + 8)
        }
    }
    
    private var thumbView: some View {
        let isActive = fingerStates[4] == .active
        return RoundedRectangle(cornerRadius: 10)
            .fill(isActive ? Color.blue.opacity(0.15) : Color.gray.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isActive ? Color.blue.opacity(0.4) : Color.gray.opacity(0.2), lineWidth: 1.5)
            )
            .frame(width: 20, height: 45)
            .rotationEffect(.degrees(isLeft ? 25 : -25))
            .offset(x: isLeft ? 8 : -8, y: 15)
            .shadow(color: isActive ? Color.blue.opacity(0.2) : .clear, radius: 4)
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
            Text("finger_color_guide".localized)
                .font(.caption.bold())
                .foregroundColor(.secondary)
            
            HStack(spacing: 16) {
                FingerColorItem(color: .pink, label: "pinky".localized, keys: "A Q Z 1")
                FingerColorItem(color: .orange, label: "ring".localized, keys: "S W X 2")
                FingerColorItem(color: .yellow, label: "middle".localized, keys: "D E C 3")
                FingerColorItem(color: .green, label: "index".localized, keys: "F G R T V B")
                FingerColorItem(color: .indigo, label: "thumb".localized, keys: "Space")
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
            Text("tap_to_toggle_hand".localized)
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

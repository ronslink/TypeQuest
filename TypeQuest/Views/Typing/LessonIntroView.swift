import SwiftUI

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
                Label("Stage \(lesson.stageId)", systemImage: "chevron.right")
                    .font(.caption.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                
                Text("Lesson \(lesson.order)")
                    .font(.caption.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
            }
            
            // Title with animation
            VStack(spacing: 8) {
                Text(introStep == .homeRow ? "First Step" : "Today's Goal")
                    .font(.subheadline.uppercase())
                    .foregroundColor(.secondary)
                    .tracking(2)
                
                Text(introStep == .homeRow ? "Home Row Position" : (lesson.learningGoal.isEmpty ? lesson.name : lesson.learningGoal))
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
                Text("Place your fingers on A-S-D-F and J-K-L-;")
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
                .fill(.glassMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
        )
    }
    
    @Namespace private var namespace
    
    // MARK: - Keyboard Visualizer
    private var keyboardVisualizer: some View {
        VStack(spacing: 8) {
            Text(introStep == .homeRow ? "Rest Fingers Here" : "Active Keys")
                .font(.caption.bold())
                .foregroundColor(.secondary)
                .padding(.bottom, 4)
            
            LessonKeyboardView(
                activeKeys: introStep == .homeRow ? HomeRowKeys : effectiveLessonKeys,
                isHomeRowMode: introStep == .homeRow,
                accentColor: stageColorScheme.accentColor
            )
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    )
            )
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
                Text(introStep == .homeRow ? "Continue" : "Begin Lesson")
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
            Text("Focus: \(focus)")
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

// MARK: - Enhanced Keyboard View
struct LessonKeyboardView: View {
    let activeKeys: [AbstractKey]
    var isHomeRowMode: Bool = false
    let accentColor: Color
    
    private var rows: [[String]] {
        let layout = DataManager.shared.currentUser?.layout ?? .qwerty
        return LayoutAdapter.shared.rows(for: layout)
    }
    
    var body: some View {
        VStack(spacing: 6) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 6) {
                    ForEach(row, id: \.self) { key in
                        EnhancedLessonKeyView(
                            key: key,
                            isHighlighted: isKeyHighlighted(key),
                            fingerColor: fingerColor(for: key),
                            accentColor: accentColor
                        )
                    }
                }
            }
        }
    }
    
    private func isKeyHighlighted(_ key: String) -> Bool {
        let layout = DataManager.shared.currentUser?.layout ?? .qwerty
        for abstractKey in activeKeys {
            if LayoutAdapter.shared.characters(for: abstractKey, layout: layout).lowercased() == key.lowercased() {
                return true
            }
        }
        return false
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
                default: break
                }
            }
        }
        return k == " " ? .gray : .gray.opacity(0.3)
    }
}

// MARK: - Enhanced Key View
struct EnhancedLessonKeyView: View {
    let key: String
    let isHighlighted: Bool
    let fingerColor: Color
    let accentColor: Color
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            // Glow effect for highlighted keys
            if isHighlighted {
                RoundedRectangle(cornerRadius: 6)
                    .fill(fingerColor.opacity(0.3))
                    .blur(radius: 8)
            }
            
            // Main key shape
            RoundedRectangle(cornerRadius: 6)
                .fill(isHighlighted ?
                      LinearGradient(colors: [fingerColor, fingerColor.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing) :
                      LinearGradient(colors: [.white.opacity(0.1), .white.opacity(0.05)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isHighlighted ? .white.opacity(0.8) : fingerColor.opacity(0.3), lineWidth: isHighlighted ? 2 : 1)
                )
                .shadow(color: isHighlighted ? fingerColor.opacity(0.6) : .clear, radius: 10)
            
            Text(key.uppercased())
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(isHighlighted ? .white : .primary.opacity(0.7))
        }
        .frame(width: keyWidth(for: key), height: 36)
        .scaleEffect(isHighlighted ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isHighlighted)
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

// EnhancedTypingView.swift
// TypeQuest - Improved typing interface with better feedback and engagement

import SwiftUI

/// Enhanced typing view with improved cursor, real-time feedback, and celebration system
struct EnhancedTypingView: View {
    @StateObject private var viewModel = TypingViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.colorScheme) var colorScheme
    
    var lesson: Lesson?
    @State private var showIntro: Bool = false
    @State private var showEncouragement = false
    @State private var encouragementText = ""
    
    init(lesson: Lesson? = nil) {
        self.lesson = lesson
        _showIntro = State(initialValue: lesson != nil)
    }
    
    var body: some View {
        ZStack {
            // Layer 1: Background
            Color.clear.appBackground()
            
            // Main content
            VStack(spacing: 0) {
                // Floating metrics bar
                FloatingMetricsBar(
                    wpm: viewModel.wpm,
                    accuracy: viewModel.accuracy,
                    time: viewModel.elapsedTime,
                    streak: viewModel.currentStreak
                )
                .padding(.top, 16)
                .padding(.horizontal, 40)
                
                // Exercise progress
                exerciseProgress
                    .padding(.horizontal, 60)
                    .padding(.top, 16)
                
                Spacer()
                
                // Main typing area
                EnhancedTextDisplay(
                    targetText: viewModel.currentText,
                    typedText: viewModel.typedText,
                    currentIndex: viewModel.currentIndex,
                    isCurrentError: viewModel.isCurrentError,
                    errorCount: viewModel.errorCount
                )
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Adaptive keyboard
                AdaptiveKeyboardView(
                    highlightedKeys: currentTargetKey,
                    activeFingers: currentRequiredFingers
                )
                .padding(.bottom, 30)
                
                // Controls
                controlButtons
                    .padding(.bottom, 24)
            }
            
            // Encouragement overlay
            if showEncouragement {
                EncouragementToast(text: encouragementText)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 100)
            }
            
            // Completion overlay
            if viewModel.isComplete {
                EnhancedLessonCompletionView(
                    result: .init(
                        wpm: viewModel.wpm,
                        accuracy: viewModel.accuracy,
                        isPassed: viewModel.isLessonPassed,
                        requirements: lesson?.passingRequirements
                    ),
                    onRetry: {
                        viewModel.resetSession()
                        viewModel.startSession(lesson: lesson)
                    },
                    onRemedial: {
                        viewModel.resetSession()
                        viewModel.startRemedialSession()
                        showIntro = true
                    },
                    onNext: {
                        navigationManager.navigate(to: .curriculum)
                    }
                )
                .transition(.opacity)
                .zIndex(10)
            }
            
            // Level up celebration
            if viewModel.showLevelUp {
                LevelUpCelebration(newLevel: viewModel.newLevel) {
                    viewModel.showLevelUp = false
                }
                .zIndex(20)
            }
            
            // Lesson intro
            if showIntro, let lesson = lesson {
                LessonIntroOverlay(
                    lesson: lesson,
                    onBegin: {
                        withAnimation(AppAnimation.page) {
                            showIntro = false
                        }
                    }
                )
                .transition(.move(edge: .bottom))
                .zIndex(30)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                CompactToolbarMetrics(
                    wpm: viewModel.wpm,
                    accuracy: viewModel.accuracy,
                    time: viewModel.elapsedTime
                )
            }
        }
        .onAppear {
            if !viewModel.isSessionActive && !showIntro {
                viewModel.startSession(lesson: lesson)
            }
            AudioManager.shared.playMusic(.focus)
        }
        .onDisappear {
            AudioManager.shared.stopMusic()
        }
        .onChange(of: viewModel.currentStreak) { newStreak in
            if newStreak > 0 && newStreak % 10 == 0 {
                showEncouragement("🔥 \(newStreak) streak! Keep going!")
            }
        }
        .onChange(of: viewModel.wpm) { newWPM in
            if newWPM > 60 && viewModel.currentStreak == 1 {
                showEncouragement("⚡ Speed demon! Great pace!")
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var exerciseProgress: some View {
        Group {
            if viewModel.totalExercisesInLesson > 1 {
                VStack(spacing: 8) {
                    HStack {
                        Text("Exercise \(viewModel.currentExerciseIndex + 1) of \(viewModel.totalExercisesInLesson)")
                            .font(AppTypography.caption)
                            .fontWeight(.bold)
                            .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
                        
                        Spacer()
                        
                        Text("\(Int(Double(viewModel.currentExerciseIndex) / Double(viewModel.totalExercisesInLesson) * 100))%")
                            .font(AppTypography.caption)
                            .fontWeight(.bold)
                            .foregroundColor(ThemeManager.shared.currentTheme.colors.primary)
                    }
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            // Background track
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.08))
                                .frame(height: 6)
                            
                            // Progress fill with gradient
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            ThemeManager.shared.currentTheme.colors.primary,
                                            ThemeManager.shared.currentTheme.colors.accent
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: geo.size.width * CGFloat(Double(viewModel.currentExerciseIndex) / Double(viewModel.totalExercisesInLesson)),
                                    height: 6
                                )
                                .animation(AppAnimation.component, value: viewModel.currentExerciseIndex)
                                .shadow(
                                    color: ThemeManager.shared.currentTheme.colors.primary.opacity(0.5),
                                    radius: 4,
                                    x: 0,
                                    y: 0
                                )
                        }
                    }
                    .frame(height: 6)
                }
            }
        }
    }
    
    private var controlButtons: some View {
        HStack(spacing: 16) {
            if !viewModel.isSessionActive || viewModel.isComplete {
                Button(action: { viewModel.startSession(lesson: lesson) }) {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                        Text("Start Session")
                    }
                    .font(AppTypography.h5)
                }
                .buttonStyle(PrimaryButtonStyle())
            } else {
                Button(action: { viewModel.resetSession() }) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset")
                    }
                    .font(AppTypography.h5)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.error)
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            
            if viewModel.isSessionActive && !viewModel.isComplete {
                Button(action: { viewModel.isPaused.toggle() }) {
                    HStack(spacing: 8) {
                        Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                        Text(viewModel.isPaused ? "Resume" : "Pause")
                    }
                    .font(AppTypography.body)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private var currentTargetKey: Set<String> {
        guard !viewModel.isComplete,
              viewModel.currentIndex < viewModel.currentText.count else { return [] }
        
        let index = viewModel.currentText.index(viewModel.currentText.startIndex, offsetBy: viewModel.currentIndex)
        let char = String(viewModel.currentText[index]).lowercased()
        return [char]
    }
    
    private var currentRequiredFingers: Set<Int> {
        guard !viewModel.isComplete,
              viewModel.currentIndex < viewModel.currentText.count else { return [] }
        
        let index = viewModel.currentText.index(viewModel.currentText.startIndex, offsetBy: viewModel.currentIndex)
        let char = String(viewModel.currentText[index])
        let layout = DataManager.shared.currentUser?.layout ?? .qwerty
        
        return HandOverlayView.fingers(for: char, layout: layout)
    }
    
    private func showEncouragement(_ text: String) {
        encouragementText = text
        withAnimation(AppAnimation.component) {
            showEncouragement = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(AppAnimation.component) {
                showEncouragement = false
            }
        }
    }
}

// MARK: - Floating Metrics Bar

struct FloatingMetricsBar: View {
    let wpm: Double
    let accuracy: Double
    let time: Double
    let streak: Int
    
    var body: some View {
        HStack(spacing: 32) {
            MetricPill(
                icon: "speedometer",
                value: String(format: "%.0f", wpm),
                label: "WPM",
                color: ThemeManager.shared.currentTheme.colors.primary
            )
            
            MetricPill(
                icon: "target",
                value: String(format: "%.0f%%", accuracy),
                label: "Accuracy",
                color: ThemeManager.shared.currentTheme.colors.success
            )
            
            MetricPill(
                icon: "clock",
                value: String(format: "%.1f", time),
                label: "Seconds",
                color: ThemeManager.shared.currentTheme.colors.textSecondary
            )
            
            if streak > 5 {
                MetricPill(
                    icon: "flame.fill",
                    value: "\(streak)",
                    label: "Streak",
                    color: .orange
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .premiumGlassCard(cornerRadius: 16, intensity: 0.08, padding: 0)
    }
}

struct MetricPill: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(AppTypography.metricSmall)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                
                Text(label)
                    .font(AppTypography.caption)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
            }
        }
    }
}

// MARK: - Enhanced Text Display

struct EnhancedTextDisplay: View {
    let targetText: String
    let typedText: String
    let currentIndex: Int
    let isCurrentError: Bool
    let errorCount: Int
    
    @State private var cursorBlink = false
    
    var body: some View {
        ZStack {
            // Glass container
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.15),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.3), radius: 40, x: 0, y: 20)
            
            ScrollView {
                attributedText
                    .font(AppTypography.monoLarge)
                    .lineSpacing(16)
                    .padding(40)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Bottom fade for scroll indication
            VStack {
                Spacer()
                LinearGradient(
                    colors: [.clear, ThemeManager.shared.currentTheme.colors.canvas.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 60)
                .allowsHitTesting(false)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
        .frame(height: 280)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                cursorBlink.toggle()
            }
        }
    }
    
    private var attributedText: Text {
        var output = Text("")
        let chars = Array(targetText)
        let typed = Array(typedText)
        
        for (index, char) in chars.enumerated() {
            let s = String(char)
            if index < typed.count {
                // Typed correctly - with subtle success styling
                output = output + Text(s)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.success)
            } else if index == currentIndex {
                // Current character with enhanced cursor
                if isCurrentError {
                    output = output + Text(s)
                        .foregroundColor(ThemeManager.shared.currentTheme.colors.error)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(ThemeManager.shared.currentTheme.colors.error.opacity(0.2))
                        )
                } else {
                    output = output + Text(s)
                        .foregroundColor(ThemeManager.shared.currentTheme.colors.primary)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(ThemeManager.shared.currentTheme.colors.primary.opacity(cursorBlink ? 0.15 : 0.25))
                        )
                        .overlay(
                            Rectangle()
                                .fill(ThemeManager.shared.currentTheme.colors.primary)
                                .frame(width: 2, height: 32)
                                .offset(x: 0, y: 2),
                            alignment: .leading
                        )
                }
            } else {
                // Pending - dimmed
                output = output + Text(s)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary.opacity(0.5))
            }
        }
        
        return output
    }
}

// MARK: - Adaptive Keyboard View

struct AdaptiveKeyboardView: View {
    let highlightedKeys: Set<String>
    let activeFingers: Set<Int>
    
    var body: some View {
        ZStack(alignment: .bottom) {
            KeyboardView(highlightedKeys: highlightedKeys)
                .padding(.horizontal, 20)
            
            // Finger overlay
            if !activeFingers.isEmpty {
                HandOverlayView(
                    activeFingers: activeFingers,
                    color: ThemeManager.shared.currentTheme.colors.accent,
                    scale: 0.45
                )
                .offset(y: 20)
                .allowsHitTesting(false)
                .opacity(0.5)
                .transition(.opacity)
            }
        }
    }
}

// MARK: - Encouragement Toast

struct EncouragementToast: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Text(text)
                .font(AppTypography.h5)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(
                    LinearGradient(
                        colors: [
                            ThemeManager.shared.currentTheme.colors.primary,
                            ThemeManager.shared.currentTheme.colors.accent
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        )
        .shadow(
            color: ThemeManager.shared.currentTheme.colors.primary.opacity(0.5),
            radius: 20,
            x: 0,
            y: 10
        )
    }
}

// MARK: - Compact Toolbar Metrics

struct CompactToolbarMetrics: View {
    let wpm: Double
    let accuracy: Double
    let time: Double
    
    var body: some View {
        HStack(spacing: 24) {
            ToolbarMetric(label: "WPM", value: String(format: "%.0f", wpm), color: ThemeManager.shared.currentTheme.colors.primary)
            ToolbarMetric(label: "Accuracy", value: String(format: "%.0f%%", accuracy), color: ThemeManager.shared.currentTheme.colors.success)
            ToolbarMetric(label: "Time", value: String(format: "%.0fs", time), color: ThemeManager.shared.currentTheme.colors.textSecondary)
        }
    }
}

struct ToolbarMetric: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 1) {
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.secondary)
                .tracking(0.5)
        }
    }
}

// MARK: - Enhanced Lesson Completion View

struct EnhancedLessonCompletionView: View {
    let result: SessionResult
    let onRetry: () -> Void
    let onRemedial: () -> Void
    let onNext: () -> Void
    
    @State private var showContent = false
    @State private var showConfetti = false
    
    struct SessionResult {
        let wpm: Double
        let accuracy: Double
        let isPassed: Bool
        let requirements: Lesson.PassingRequirements?
    }
    
    var body: some View {
        ZStack {
            // Backdrop
            ThemeManager.shared.currentTheme.colors.canvas
                .opacity(0.95)
                .ignoresSafeArea()
            
            // Confetti for passed lessons
            if showConfetti && result.isPassed {
                ConfettiView()
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 32) {
                // Header with icon
                VStack(spacing: 16) {
                    ZStack {
                        // Glow effect
                        Circle()
                            .fill(
                                result.isPassed
                                ? ThemeManager.shared.currentTheme.colors.success.opacity(0.3)
                                : Color.gray.opacity(0.2)
                            )
                            .frame(width: 120, height: 120)
                            .blur(radius: 30)
                        
                        // Icon
                        Image(systemName: result.isPassed ? "trophy.fill" : "chart.line.uptrend.xyaxis")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                result.isPassed
                                ? ThemeManager.shared.currentTheme.colors.success
                                : Color.gray
                            )
                            .shadow(
                                color: result.isPassed
                                    ? ThemeManager.shared.currentTheme.colors.success.opacity(0.5)
                                    : .clear,
                                radius: 20,
                                x: 0,
                                y: 0
                            )
                    }
                    .scaleEffect(showContent ? 1 : 0.5)
                    .rotationEffect(.degrees(showContent ? 0 : -20))
                    
                    VStack(spacing: 8) {
                        Text(result.isPassed ? "Lesson Complete!" : "Keep Practicing")
                            .font(AppTypography.h1)
                            .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                        
                        if !result.isPassed {
                            Text("You're improving! Here are your results:")
                                .font(AppTypography.body)
                                .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
                        }
                    }
                }
                
                // Stats cards
                HStack(spacing: 20) {
                    EnhancedStatCard(
                        title: "WPM",
                        value: String(format: "%.0f", result.wpm),
                        target: result.requirements.map { String(format: "%.0f", $0.minWPM) },
                        color: ThemeManager.shared.currentTheme.colors.primary,
                        isMet: result.requirements == nil || result.requirements!.minWPM <= result.wpm
                    )
                    .coordinatedEntrance(delay: 0.1)
                    
                    EnhancedStatCard(
                        title: "Accuracy",
                        value: String(format: "%.0f%%", result.accuracy),
                        target: result.requirements.map { String(format: "%.0f%%", $0.minAccuracy) },
                        color: ThemeManager.shared.currentTheme.colors.success,
                        isMet: result.requirements == nil || result.requirements!.minAccuracy <= result.accuracy
                    )
                    .coordinatedEntrance(delay: 0.2)
                }
                
                // Action buttons
                VStack(spacing: 12) {
                    Button(action: onNext) {
                        HStack(spacing: 8) {
                            Text(result.isPassed ? "Continue" : "Back to Lessons")
                                .font(AppTypography.h5)
                            Image(systemName: result.isPassed ? "arrow.right" : "list.bullet")
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .coordinatedEntrance(delay: 0.3)
                    
                    HStack(spacing: 16) {
                        Button(action: onRetry) {
                            Label("Try Again", systemImage: "arrow.counterclockwise")
                                .font(AppTypography.body)
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        
                        if !result.isPassed {
                            Button(action: onRemedial) {
                                Label("Simplified", systemImage: "wand.and.stars")
                                    .font(AppTypography.body)
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        }
                    }
                    .coordinatedEntrance(delay: 0.4)
                }
            }
            .padding(40)
        }
        .onAppear {
            withAnimation(AppAnimation.celebration) {
                showContent = true
            }
            if result.isPassed {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showConfetti = true
                }
            }
        }
    }
}

struct EnhancedStatCard: View {
    let title: String
    let value: String
    var target: String? = nil
    let color: Color
    var isMet: Bool = true
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(AppTypography.caption)
                .fontWeight(.bold)
                .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
                .tracking(1)
            
            Text(value)
                .font(AppTypography.metric)
                .foregroundColor(isMet ? color : ThemeManager.shared.currentTheme.colors.textPrimary)
            
            if let target = target {
                HStack(spacing: 4) {
                    Image(systemName: isMet ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 10))
                    Text("Goal: \(target)")
                        .font(AppTypography.caption)
                }
                .foregroundColor(isMet ? ThemeManager.shared.currentTheme.colors.success : ThemeManager.shared.currentTheme.colors.error)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            isMet
                            ? ThemeManager.shared.currentTheme.colors.success.opacity(0.15)
                            : ThemeManager.shared.currentTheme.colors.error.opacity(0.15)
                        )
                )
            }
        }
        .frame(width: 150, height: 150)
        .premiumGlassCard(cornerRadius: 20, intensity: 0.08, padding: 0)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    isMet ? color.opacity(0.3) : ThemeManager.shared.currentTheme.colors.error.opacity(0.5),
                    lineWidth: isMet ? 1 : 2
                )
        )
    }
}

// MARK: - Level Up Celebration

struct LevelUpCelebration: View {
    let newLevel: Int
    let onDismiss: () -> Void
    
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var showConfetti = false
    
    var body: some View {
        ZStack {
            ThemeManager.shared.currentTheme.colors.canvas
                .opacity(0.9)
                .ignoresSafeArea()
            
            if showConfetti {
                ConfettiView()
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 24) {
                // Star with glow
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.yellow.opacity(0.4), .clear],
                                center: .center,
                                startRadius: 10,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .orange, radius: 20)
                }
                
                VStack(spacing: 8) {
                    Text("LEVEL UP!")
                        .font(AppTypography.displaySmall)
                        .fontWeight(.black)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    Text("Level \(newLevel)")
                        .font(AppTypography.metricLarge)
                        .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                }
                
                Button("Continue", action: onDismiss)
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.top, 16)
            }
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(AppAnimation.celebration) {
                scale = 1
                opacity = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showConfetti = true
            }
        }
    }
}

// MARK: - Lesson Intro Overlay

struct LessonIntroOverlay: View {
    let lesson: Lesson
    let onBegin: () -> Void
    
    var body: some View {
        ZStack {
            ThemeManager.shared.currentTheme.colors.canvas
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 50))
                        .foregroundColor(ThemeManager.shared.currentTheme.colors.primary)
                    
                    Text(lesson.name)
                        .font(AppTypography.h1)
                        .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                    
                    Text(lesson.description)
                        .font(AppTypography.body)
                        .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                
                // Focus areas
                if let requiredKeys = lesson.requiredKeys, !requiredKeys.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Focus Keys")
                            .font(AppTypography.h4)
                            .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                        
                        HStack(spacing: 8) {
                            ForEach(requiredKeys.prefix(8), id: \.self) { key in
                                Text(keyDisplayName(for: key))
                                    .font(AppTypography.monoSmall)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(ThemeManager.shared.currentTheme.colors.primary.opacity(0.15))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(ThemeManager.shared.currentTheme.colors.primary.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding()
                    .premiumGlassCard(cornerRadius: 16, intensity: 0.08)
                }
                
                // Requirements
                if lesson.passingRequirements.minWPM > 0 || lesson.passingRequirements.minAccuracy > 0 {
                    VStack(spacing: 12) {
                        Text("Requirements to Pass")
                            .font(AppTypography.h4)
                            .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                        
                        HStack(spacing: 20) {
                            if lesson.passingRequirements.minWPM > 0 {
                                RequirementBadge(
                                    icon: "speedometer",
                                    text: "\(Int(lesson.passingRequirements.minWPM)) WPM"
                                )
                            }
                            if lesson.passingRequirements.minAccuracy > 0 {
                                RequirementBadge(
                                    icon: "target",
                                    text: "\(Int(lesson.passingRequirements.minAccuracy))% Accuracy"
                                )
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button(action: onBegin) {
                    HStack(spacing: 8) {
                        Text("Begin Lesson")
                            .font(AppTypography.h5)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(40)
            .frame(maxWidth: 600)
        }
    }
    
    private func keyDisplayName(for key: AbstractKey) -> String {
        // Simplified mapping for display
        switch key {
        case .homeLeftPinky: return "A"
        case .homeLeftRing: return "S"
        case .homeLeftMiddle: return "D"
        case .homeLeftIndex: return "F"
        case .homeRightIndex: return "J"
        case .homeRightMiddle: return "K"
        case .homeRightRing: return "L"
        case .homeRightPinky: return ";"
        default: return "?"
        }
    }
}

struct RequirementBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
            Text(text)
                .font(AppTypography.bodySmall)
        }
        .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.05))
        )
    }
}

// MARK: - Confetti View

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for particle in particles {
                    var path = Path()
                    path.addRect(CGRect(x: -4, y: -4, width: 8, height: 8))
                    
                    var contextCopy = context
                    contextCopy.translateBy(x: particle.x, y: particle.y)
                    contextCopy.rotate(by: .degrees(particle.rotation))
                    contextCopy.fill(path, with: .color(particle.color))
                }
            }
        }
        .onAppear {
            createParticles()
        }
        .onChange(of: particles) { _ in
            updateParticles()
        }
    }
    
    private func createParticles() {
        let colors: [Color] = [
            ThemeManager.shared.currentTheme.colors.primary,
            ThemeManager.shared.currentTheme.colors.accent,
            ThemeManager.shared.currentTheme.colors.secondary,
            .yellow,
            .green,
            .orange
        ]
        
        particles = (0..<50).map { _ in
            ConfettiParticle(
                x: CGFloat.random(in: 0...1200),
                y: -20,
                rotation: Double.random(in: 0...360),
                color: colors.randomElement()!,
                velocity: CGFloat.random(in: 2...6),
                drift: CGFloat.random(in: -1...1)
            )
        }
    }
    
    private func updateParticles() {
        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { timer in
            for index in particles.indices {
                particles[index].y += particles[index].velocity
                particles[index].x += particles[index].drift
                particles[index].rotation += 5
                
                if particles[index].y > 1000 {
                    particles[index].y = -20
                    particles[index].x = CGFloat.random(in: 0...1200)
                }
            }
            
            if particles.allSatisfy({ $0.y > 900 }) {
                timer.invalidate()
            }
        }
    }
}

struct ConfettiParticle {
    var x: CGFloat
    var y: CGFloat
    var rotation: Double
    var color: Color
    var velocity: CGFloat
    var drift: CGFloat
}

// MARK: - Preview

#Preview("Enhanced Typing View") {
    EnhancedTypingView()
        .environmentObject(NavigationManager())
}

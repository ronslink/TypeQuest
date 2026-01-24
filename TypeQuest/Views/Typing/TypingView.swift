import SwiftUI

struct TypingView: View {
    @StateObject private var viewModel = TypingViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.colorScheme) var colorScheme
    
    var lesson: Lesson?
    @State private var showIntro: Bool = false
    
    init(lesson: Lesson? = nil) {
        self.lesson = lesson
        // Show intro only if we have a lesson (not practice mode)
        _showIntro = State(initialValue: lesson != nil)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
            // Metrics HUD
            HStack(spacing: 40) {
                MetricItem(label: "WPM", value: String(format: "%.0f", viewModel.wpm), color: .indigoPrimary)
                MetricItem(label: "Accuracy", value: String(format: "%.0f%%", viewModel.accuracy), color: .success)
                MetricItem(label: "Time", value: String(format: "%.1fs", viewModel.elapsedTime), color: .textSecondaryLight)
            }
            .padding(.top, 20)
            
            // Exercise Progress
            if viewModel.totalExercisesInLesson > 1 {
                VStack(spacing: 8) {
                    Text("Exercise \(viewModel.currentExerciseIndex + 1) of \(viewModel.totalExercisesInLesson)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.textTertiaryLight)
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.surfaceDark.opacity(0.1))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.indigoPrimary)
                                .frame(width: geo.size.width * CGFloat(Double(viewModel.currentExerciseIndex) / Double(viewModel.totalExercisesInLesson)), height: 8)
                                .animation(.spring(), value: viewModel.currentExerciseIndex)
                        }
                    }
                    .frame(height: 8)
                    .padding(.horizontal, 80)
                }
            }
            
            Spacer()
            
            // Text Display
            ZStack {
               RoundedRectangle(cornerRadius: 16)
                    .fill(Material.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                    .shadow(radius: 4)
                
                ScrollView {
                    textBuilder
                        .font(.system(size: viewModel.isLargeTextMode ? 48 : 32, weight: .medium, design: .monospaced))
                        .lineSpacing(viewModel.isLargeTextMode ? 14 : 10)
                        .padding(40)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(height: 300)
            .padding(.horizontal, 40)
            
            // Keyboard Visualizer
            if !showIntro {
                KeyboardView(viewModel: viewModel)
                    .padding(.bottom, 20)
            }
            
            // Controls
            HStack {
                if !viewModel.isSessionActive || viewModel.isComplete {
                    Button(action: { viewModel.startSession(lesson: lesson) }) {
                        Label("Start Session", systemImage: "play.fill")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.indigoPrimary)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                } else {
                    Button(action: { viewModel.resetSession() }) {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.surfaceDark.opacity(0.1))
                            .foregroundColor(.error)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.bottom, 30)
            

        }
        .overlay(alignment: .topTrailing) {
            Text(viewModel.debugStatus)
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.gray)
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(4)
                .padding()
        }
        .background(colorScheme == .dark ? Color.canvasDark : Color.canvasLight)
        .onAppear {
            // Auto-start session when view appears for immediate typing, unless intro is showing
            if !viewModel.isSessionActive && !showIntro {
                viewModel.startSession(lesson: lesson)
            }
            // Trigger background music (requires MP3 in Resources/Music)
            AudioManager.shared.playMusic(.focus)
        }
        .onReceive(navigationManager.restartSessionPublisher) { _ in
            viewModel.resetSession()
            viewModel.startSession(lesson: lesson)
        }
        .onReceive(navigationManager.togglePausePublisher) { _ in
            // Implement pause logic in ViewModel if not exists, or just ignore for now
             viewModel.isPaused.toggle()
        }
        .onDisappear {
            AudioManager.shared.stopMusic()
        }
        .onChange(of: showIntro) { newValue in
            if !newValue {
                // Start once intro closes
                viewModel.startSession(lesson: lesson)
            }
        }
        .onTapGesture {
            // Ensure focus / restart if tapped
            if !viewModel.isSessionActive || viewModel.isComplete {
                viewModel.startSession(lesson: lesson)
            }
        }
        
        if showIntro, let lesson = lesson {
            LessonIntroView(
                lesson: lesson,
                userProfile: DataManager.shared.currentUser,
                showIntro: $showIntro
            )
            .transition(AnyTransition.move(edge: .bottom))
            .zIndex(2) // Ensure it sits on top
            .background(Color.canvasDark) // Ensure opacity
        }
        }
        .overlay(alignment: .bottomTrailing) {
            if !viewModel.currentPostureIssues.isEmpty {
                PostureAlertOverlay(issues: viewModel.currentPostureIssues)
                    .padding(.bottom, 100)
            }
        }
        .overlay {
            if viewModel.isComplete {

                LessonCompletionView(
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
                        showIntro = true // Re-trigger intro for "Begin" confirmation
                    },
                    onNext: {
                        navigationManager.navigate(to: .curriculum)
                    }
                )
                .transition(.opacity)
                .zIndex(10)
            }
        }
    }
    
    // Builds the attributed text using SwiftUI Text concatenation
    private var textBuilder: Text {
        var output = Text("")
        let chars = Array(viewModel.currentText)
        let typed = Array(viewModel.typedText)
        
        for (index, char) in chars.enumerated() {
            let s = String(char)
            if index < typed.count {
                // Typed correctly
                output = output + Text(s).foregroundColor(.success)
            } else if index == viewModel.currentIndex && viewModel.isCurrentError {
                 // Error state: Attempted wrong key on current character
                output = output + Text(s)
                    .foregroundColor(.error)
                    .underline(true, color: .error)
            } else if index == viewModel.currentIndex {
                // Cursor position
                 output = output + Text(s)
                    .foregroundColor(.indigoPrimary)
                    .underline(true, color: .indigoPrimary)
            } else {
                // Pending
                output = output + Text(s).foregroundColor(.textTertiaryLight)
            }
        }
        
        return output
    }
}

struct PostureAlertOverlay: View {
    let issues: [PostureIssue]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(issues, id: \.self) { issue in
                HStack(spacing: 15) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    VStack(alignment: .leading) {
                        Text(issue.rawValue)
                            .font(.headline)
                        Text(issue.advice)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
                .shadow(radius: 5)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding()
    }
}

struct MetricItem: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.textTertiaryLight)
            Text(value)
                .font(.title)
                .fontDesign(.monospaced)
                .foregroundColor(color)
        }
    }
}

#Preview {
    TypingView()
}

struct LessonCompletionView: View {
    let result: SessionResult
    let onRetry: () -> Void
    let onRemedial: () -> Void
    let onNext: () -> Void
    
    @State private var showContent = false
    
    struct SessionResult {
        let wpm: Double
        let accuracy: Double
        let isPassed: Bool
        let requirements: Lesson.PassingRequirements?
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.85).ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: result.isPassed ? "crown.fill" : "chart.line.uptrend.xyaxis")
                        .font(.system(size: 60))
                        .foregroundStyle(result.isPassed ? .yellow : .gray, result.isPassed ? .orange : .white)
                        .shadow(color: (result.isPassed ? Color.orange : Color.white).opacity(0.3), radius: 20)
                        .scaleEffect(showContent ? 1.0 : 0.5)
                        .rotationEffect(.degrees(showContent ? 0 : -20))
                    
                    Text(result.isPassed ? "Lesson Complete!" : "Keep Practicing")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    if !result.isPassed {
                        Text("You're getting there! Here is what you need to hit:")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                // Stats Cards with Targets
                HStack(spacing: 20) {
                    StatCard(
                        title: "WPM",
                        value: String(format: "%.0f", result.wpm),
                        target: result.requirements.map { String(format: "%.0f", $0.minWPM) },
                        color: .indigoPrimary,
                        isMet: result.requirements == nil || result.requirements!.minWPM <= result.wpm
                    )
                    
                    StatCard(
                        title: "Accuracy",
                        value: String(format: "%.0f%%", result.accuracy),
                        target: result.requirements.map { String(format: "%.0f%%", $0.minAccuracy) },
                        color: .success,
                        isMet: result.requirements == nil || result.requirements!.minAccuracy <= result.accuracy
                    )
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                
                // Action Buttons
                VStack(spacing: 16) {
                    Button(action: onNext) {
                        HStack {
                            Text("Back to Menu")
                                .fontWeight(.bold)
                            Image(systemName: "list.bullet")
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                        .background(Color.indigoPrimary)
                        .cornerRadius(30)
                        .shadow(radius: 5)
                    }
                    
                    if result.isPassed {
                        Button(action: onRetry) {
                            Text("Try Again")
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    } else {
                        Button(action: onRemedial) {
                            HStack {
                                Text("Try Simplified Version")
                                    .fontWeight(.bold)
                                Image(systemName: "wand.and.stars")
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.1))
                            .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white.opacity(0.3), lineWidth: 1))
                            .cornerRadius(30)
                        }
                    }
                }
                .opacity(showContent ? 1 : 0)
                .padding(.top, 20)
            }
            .padding()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showContent = true
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    var target: String? = nil
    let color: Color
    var isMet: Bool = true
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.6))
            
            Text(value)
                .font(.system(size: 40, weight: .bold, design: .monospaced))
                .foregroundColor(isMet ? color : .white)
            
            if let target = target {
                Text("Goal: \(target)")
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(isMet ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .foregroundColor(isMet ? .green : .red)
                    .cornerRadius(4)
            }
        }
        .frame(width: 140, height: 140)
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isMet ? Color.white.opacity(0.1) : Color.red.opacity(0.5), lineWidth: isMet ? 1 : 2)
        )
    }
}


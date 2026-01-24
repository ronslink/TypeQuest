import SwiftUI

struct SkillTreeView: View {
    @StateObject private var viewModel = CurriculumViewModel()
    @State private var selectedLesson: Lesson?
    @State private var showPractice: Bool = false
    @State private var animateConnections: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // Adaptive Recommendation Section
                if let adaptiveLesson = viewModel.adaptiveLesson {
                    AdaptiveLessonCard(lesson: adaptiveLesson) {
                        selectedLesson = adaptiveLesson
                        showPractice = true
                    }
                    .padding()
                }
                
                // Stage Map
                ForEach(Array(viewModel.stages.enumerated()), id: \.element.id) { index, stage in
                    EnhancedStageView(
                        stage: stage,
                        stageIndex: index,
                        viewModel: viewModel,
                        animateConnections: animateConnections
                    ) { lesson in
                        if viewModel.isLessonUnlocked(lesson) {
                            selectedLesson = lesson
                            showPractice = true
                        }
                    }
                }
            }
            .padding(.bottom, 40)
        }
        .background(
            LinearGradient(
                colors: [Color.canvasDark, Color(red: 0.05, green: 0.08, blue: 0.15)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .navigationDestination(isPresented: $showPractice) {
            if let lesson = selectedLesson {
                TypingView(lesson: lesson)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).delay(0.3)) {
                animateConnections = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .lessonCompleted)) { notification in
            if let lessonId = notification.userInfo?["lessonId"] as? String {
                viewModel.markLessonComplete(lessonId)
            }
            viewModel.checkForAdaptiveLesson()
        }
    }
}

// MARK: - Stage Themes
struct StageTheme {
    let primaryColor: Color
    let secondaryColor: Color
    let iconName: String
    let backgroundIcon: String
    
    static let themes: [StageTheme] = [
        StageTheme(primaryColor: Color(red: 0.2, green: 0.7, blue: 0.4), secondaryColor: Color(red: 0.15, green: 0.5, blue: 0.3), iconName: "leaf.fill", backgroundIcon: "tree"),
        StageTheme(primaryColor: Color(red: 0.3, green: 0.5, blue: 0.9), secondaryColor: Color(red: 0.2, green: 0.4, blue: 0.7), iconName: "water.waves", backgroundIcon: "drop.fill"),
        StageTheme(primaryColor: Color(red: 0.6, green: 0.4, blue: 0.2), secondaryColor: Color(red: 0.5, green: 0.3, blue: 0.15), iconName: "mountain.2.fill", backgroundIcon: "triangle.fill"),
        StageTheme(primaryColor: Color(red: 0.8, green: 0.4, blue: 0.1), secondaryColor: Color(red: 0.6, green: 0.3, blue: 0.1), iconName: "flame.fill", backgroundIcon: "sun.max.fill"),
        StageTheme(primaryColor: Color(red: 0.5, green: 0.2, blue: 0.7), secondaryColor: Color(red: 0.4, green: 0.15, blue: 0.5), iconName: "sparkles", backgroundIcon: "star.fill"),
        StageTheme(primaryColor: Color(red: 0.9, green: 0.7, blue: 0.2), secondaryColor: Color(red: 0.7, green: 0.5, blue: 0.1), iconName: "crown.fill", backgroundIcon: "trophy.fill")
    ]
    
    static func theme(for index: Int) -> StageTheme {
        themes[index % themes.count]
    }
}

// MARK: - Enhanced Stage View
struct EnhancedStageView: View {
    let stage: Stage
    let stageIndex: Int
    @ObservedObject var viewModel: CurriculumViewModel
    let animateConnections: Bool
    let onSelectLesson: (Lesson) -> Void
    
    private var theme: StageTheme {
        StageTheme.theme(for: stageIndex)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Stage Header with Theme
            stageHeader
                .padding(.top, stageIndex == 0 ? 20 : 40)
            
            // Modules with Connected Nodes
            ForEach(stage.modules) { module in
                EnhancedModuleView(
                    module: module,
                    theme: theme,
                    viewModel: viewModel,
                    animateConnections: animateConnections,
                    onSelectLesson: onSelectLesson
                )
            }
        }
    }
    
    private var stageHeader: some View {
        HStack(spacing: 16) {
            // Themed Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [theme.primaryColor, theme.secondaryColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: theme.primaryColor.opacity(0.5), radius: 10)
                
                Image(systemName: theme.iconName)
                    .font(.title)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("STAGE \(stageIndex + 1)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(theme.primaryColor)
                    .tracking(2)
                
                Text(stage.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(stage.description)
                    .font(.caption)
                    .foregroundColor(.textSecondaryDark)
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
}

// MARK: - Enhanced Module View
struct EnhancedModuleView: View {
    let module: Module
    let theme: StageTheme
    @ObservedObject var viewModel: CurriculumViewModel
    let animateConnections: Bool
    let onSelectLesson: (Lesson) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Module Name
            Text(module.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal, 24)
                .padding(.top, 16)
            
            // Lesson Node Path
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(module.lessons.enumerated()), id: \.element.id) { index, lesson in
                        HStack(spacing: 0) {
                            // Connection Line (before node, except first)
                            if index > 0 {
                                ConnectionLine(
                                    theme: theme,
                                    isCompleted: viewModel.completedLessons.contains(module.lessons[index - 1].id),
                                    animate: animateConnections
                                )
                            }
                            
                            // Lesson Node
                            EnhancedLessonNode(
                                lesson: lesson,
                                theme: theme,
                                isUnlocked: viewModel.isLessonUnlocked(lesson),
                                isCompleted: viewModel.completedLessons.contains(lesson.id)
                            )
                            .onTapGesture {
                                onSelectLesson(lesson)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
            }
        }
    }
}

// MARK: - Connection Line
struct ConnectionLine: View {
    let theme: StageTheme
    let isCompleted: Bool
    let animate: Bool
    
    @State private var progress: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Background track
            Rectangle()
                .fill(Color.surfaceDark)
                .frame(width: 40, height: 4)
            
            // Animated fill
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [theme.primaryColor, theme.secondaryColor],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 40 * (isCompleted ? 1 : progress), height: 4)
                .frame(width: 40, alignment: .leading)
        }
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .onAppear {
            if animate && !isCompleted {
                withAnimation(.easeInOut(duration: 0.8)) {
                    progress = 0.3
                }
            } else if isCompleted {
                progress = 1
            }
        }
    }
}

// MARK: - Enhanced Lesson Node
struct EnhancedLessonNode: View {
    let lesson: Lesson
    let theme: StageTheme
    let isUnlocked: Bool
    let isCompleted: Bool
    
    @State private var isHovered: Bool = false
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                // Outer glow ring for unlocked
                if isUnlocked && !isCompleted {
                    Circle()
                        .stroke(theme.primaryColor.opacity(0.3), lineWidth: 3)
                        .frame(width: 76, height: 76)
                        .scaleEffect(pulseScale)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                pulseScale = 1.1
                            }
                        }
                }
                
                // Main node circle
                Circle()
                    .fill(nodeBackground)
                    .frame(width: 70, height: 70)
                    .shadow(color: nodeShadowColor, radius: isHovered ? 12 : 6, x: 0, y: 4)
                
                // Inner content
                Group {
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                    } else if !isUnlocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.4))
                    } else {
                        Text("\(lesson.order)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
            }
            .scaleEffect(isHovered ? 1.1 : 1.0)
            .animation(.spring(response: 0.3), value: isHovered)
            .onHover { hovering in
                isHovered = hovering && isUnlocked
            }
            
            // Lesson name
            Text(lesson.name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isUnlocked ? .white : .gray)
                .frame(width: 90)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .opacity(isUnlocked ? 1 : 0.5)
    }
    
    private var nodeBackground: some ShapeStyle {
        if isCompleted {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color.success, Color.success.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        } else if isUnlocked {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [theme.primaryColor, theme.secondaryColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        } else {
            return AnyShapeStyle(Color.surfaceDark)
        }
    }
    
    private var nodeShadowColor: Color {
        if isCompleted { return .success.opacity(0.5) }
        if isUnlocked { return theme.primaryColor.opacity(0.5) }
        return .black.opacity(0.3)
    }
}

// MARK: - Adaptive Lesson Card
struct AdaptiveLessonCard: View {
    let lesson: Lesson
    let onSelect: () -> Void
    
    @State private var shimmer: CGFloat = -1
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                // Animated Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.indigoPrimary, .cyanAccent],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: "dumbbell.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .shadow(color: .indigoPrimary.opacity(0.5), radius: 8)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("RECOMMENDED")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.cyanAccent)
                        .tracking(1.5)
                    
                    Text(lesson.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(lesson.description)
                        .font(.caption)
                        .foregroundColor(.textSecondaryDark)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(.indigoPrimary)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.surfaceDark)
                    .overlay(
                        // Shimmer effect
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [.clear, .white.opacity(0.1), .clear],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: shimmer * 400)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [.indigoPrimary.opacity(0.5), .cyanAccent.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                shimmer = 1
            }
        }
    }
}

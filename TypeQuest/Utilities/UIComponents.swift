// UIComponents.swift
// TypeQuest - Additional UI Components for Complete Design System

import SwiftUI

// MARK: - Loading States

/// Animated loading spinner with theme colors
struct LoadingSpinner: View {
    var size: CGFloat = 40
    var lineWidth: CGFloat = 4
    
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                AngularGradient(
                    colors: [
                        ThemeManager.shared.currentTheme.colors.primary,
                        ThemeManager.shared.currentTheme.colors.accent,
                        ThemeManager.shared.currentTheme.colors.primary
                    ],
                    center: .center
                ),
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
            )
            .frame(width: size, height: size)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .animation(
                .linear(duration: 1)
                .repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

/// Loading overlay with spinner and text
struct LoadingOverlay: View {
    let message: String
    
    var body: some View {
        ZStack {
            ThemeManager.shared.currentTheme.colors.canvas
                .opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                LoadingSpinner(size: 50, lineWidth: 5)
                
                Text(message)
                    .font(AppTypography.body)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
            }
            .padding(40)
            .premiumGlassCard()
        }
    }
}

/// Skeleton loading placeholder
struct SkeletonLoading: View {
    var lines: Int = 3
    var lineHeight: CGFloat = 12
    var spacing: CGFloat = 8
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(0..<lines, id: \.self) { index in
                RoundedRectangle(cornerRadius: lineHeight / 2)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.05),
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: lineHeight)
                    .frame(maxWidth: index == lines - 1 ? 0.7 : 1.0, alignment: .leading)
            }
        }
        .mask(
            GeometryReader { geometry in
                LinearGradient(
                    colors: [.clear, .white, .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
            }
        )
        .animation(
            .linear(duration: 1.5)
            .repeatForever(autoreverses: false),
            value: isAnimating
        )
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Empty States

/// Empty state view with icon, title, and action
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                ThemeManager.shared.currentTheme.colors.primary.opacity(0.2),
                                ThemeManager.shared.currentTheme.colors.accent.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)
                
                Image(systemName: icon)
                    .font(.system(size: 48))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                ThemeManager.shared.currentTheme.colors.primary,
                                ThemeManager.shared.currentTheme.colors.accent
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(AppTypography.h3)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                
                Text(message)
                    .font(AppTypography.body)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 300)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(AppTypography.h5)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.top, 8)
            }
        }
        .padding(40)
        .coordinatedEntrance(delay: 0)
    }
}

// MARK: - Error States

/// Error state view with retry action
struct ErrorStateView: View {
    let title: String
    let message: String
    var retryAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.15))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.red)
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(AppTypography.h3)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                
                Text(message)
                    .font(AppTypography.body)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 300)
            }
            
            if let retryAction = retryAction {
                Button(action: retryAction) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                        Text("Try Again")
                    }
                    .font(AppTypography.h5)
                }
                .buttonStyle(SecondaryButtonStyle())
                .padding(.top, 8)
            }
        }
        .padding(40)
        .coordinatedEntrance(delay: 0)
    }
}

// MARK: - Toast Notification System

/// Global toast manager
@MainActor
class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var toasts: [ToastItem] = []
    
    private init() {}
    
    func show(
        title: String,
        message: String? = nil,
        icon: String? = nil,
        style: ToastStyle = .info,
        duration: Double = 3.0
    ) {
        let toast = ToastItem(
            id: UUID(),
            title: title,
            message: message,
            icon: icon,
            style: style
        )
        
        toasts.append(toast)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.dismiss(toast.id)
        }
    }
    
    func dismiss(_ id: UUID) {
        withAnimation(AppAnimation.component) {
            toasts.removeAll { $0.id == id }
        }
    }
}

struct ToastItem: Identifiable {
    let id: UUID
    let title: String
    let message: String?
    let icon: String?
    let style: ToastStyle
}

enum ToastStyle {
    case success
    case error
    case warning
    case info
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .success: return ThemeManager.shared.currentTheme.colors.success
        case .error: return ThemeManager.shared.currentTheme.colors.error
        case .warning: return .orange
        case .info: return ThemeManager.shared.currentTheme.colors.primary
        }
    }
}

/// Toast notification view
struct ToastView: View {
    let toast: ToastItem
    let onDismiss: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: toast.icon ?? toast.style.icon)
                .font(.system(size: 22))
                .foregroundColor(toast.style.color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(toast.title)
                    .font(AppTypography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                
                if let message = toast.message {
                    Text(message)
                        .font(AppTypography.bodySmall)
                        .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
                }
            }
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.surfaceDark)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(toast.style.color.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.3), radius: 16, x: 0, y: 8)
        .frame(maxWidth: 400)
    }
}

/// Toast container for presenting toasts
struct ToastContainer<Content: View>: View {
    @StateObject private var manager = ToastManager.shared
    @ViewBuilder let content: Content
    
    var body: some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                VStack(spacing: 8) {
                    ForEach(manager.toasts) { toast in
                        ToastView(toast: toast) {
                            manager.dismiss(toast.id)
                        }
                        .transition(
                            .move(edge: .bottom)
                            .combined(with: .opacity)
                        )
                    }
                }
                .padding(.bottom, 24)
            }
        }
    }
}

// MARK: - Badge Components

/// Status badge for labels
struct StatusBadge: View {
    let text: String
    let style: BadgeStyle
    
    enum BadgeStyle {
        case success
        case error
        case warning
        case info
        case neutral
        
        var color: Color {
            switch self {
            case .success:
                return ThemeManager.shared.currentTheme.colors.success
            case .error:
                return ThemeManager.shared.currentTheme.colors.error
            case .warning:
                return .orange
            case .info:
                return ThemeManager.shared.currentTheme.colors.primary
            case .neutral:
                return ThemeManager.shared.currentTheme.colors.textSecondary
            }
        }
    }
    
    var body: some View {
        Text(text)
            .font(AppTypography.caption)
            .fontWeight(.bold)
            .tracking(0.5)
            .foregroundColor(style.color)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(style.color.opacity(0.12))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(style.color.opacity(0.25), lineWidth: 1)
            )
    }
}

/// Notification badge with count
struct NotificationBadge: View {
    let count: Int
    
    var body: some View {
        ZStack {
            Circle()
                .fill(ThemeManager.shared.currentTheme.colors.error)
                .frame(width: 20, height: 20)
            
            Text("\(min(count, 99))")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
        }
        .scaleEffect(count > 0 ? 1 : 0)
        .animation(AppAnimation.component, value: count)
    }
}

// MARK: - Section Headers

/// Consistent section header with optional action
struct SectionHeader: View {
    let title: String
    var subtitle: String?
    var actionTitle: String?
    var action: (() -> Void)?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title.uppercased())
                    .font(AppTypography.caption)
                    .fontWeight(.bold)
                    .tracking(1.5)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary.opacity(0.7))
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(AppTypography.bodySmall)
                        .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
                }
            }
            
            Spacer()
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(AppTypography.bodySmall)
                        .fontWeight(.medium)
                        .foregroundColor(ThemeManager.shared.currentTheme.colors.primary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Divider with Text

/// Divider with centered text
struct LabeledDivider: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .frame(height: 1)
            
            Text(text)
                .font(AppTypography.caption)
                .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary.opacity(0.7))
            
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .frame(height: 1)
        }
    }
}

// MARK: - Preview

#Preview("UI Components") {
    ScrollView {
        VStack(spacing: 32) {
            // Loading
            Group {
                Text("Loading States").font(AppTypography.h3)
                LoadingSpinner()
                SkeletonLoading(lines: 3)
                    .frame(width: 200)
            }
            
            Divider()
            
            // Empty State
            Group {
                Text("Empty State").font(AppTypography.h3)
                EmptyStateView(
                    icon: "doc.text",
                    title: "No Documents",
                    message: "Create your first document to get started",
                    actionTitle: "Create Document",
                    action: {}
                )
            }
            
            Divider()
            
            // Error State
            Group {
                Text("Error State").font(AppTypography.h3)
                ErrorStateView(
                    title: "Something Went Wrong",
                    message: "We couldn't load your data. Please try again.",
                    retryAction: {}
                )
            }
            
            Divider()
            
            // Badges
            Group {
                Text("Badges").font(AppTypography.h3)
                HStack(spacing: 8) {
                    StatusBadge(text: "Success", style: .success)
                    StatusBadge(text: "Error", style: .error)
                    StatusBadge(text: "Warning", style: .warning)
                    StatusBadge(text: "Info", style: .info)
                }
            }
            
            Divider()
            
            // Section Header
            Group {
                Text("Section Header").font(AppTypography.h3)
                SectionHeader(
                    title: "Settings",
                    subtitle: "Customize your experience",
                    actionTitle: "Reset All",
                    action: {}
                )
            }
            
            Divider()
            
            // Labeled Divider
            Group {
                Text("Labeled Divider").font(AppTypography.h3)
                LabeledDivider(text: "OR")
            }
        }
        .padding()
        .appBackground()
    }
    .frame(width: 500, height: 1200)
}

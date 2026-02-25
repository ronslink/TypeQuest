// DesignSystem.swift
// TypeQuest - Unified Design System (2025)
// This file contains all design tokens, modifiers, and components for consistent UI

import SwiftUI

// MARK: - Animation Presets

enum AppAnimation {
    /// Micro-interactions: button presses, toggles
    static let micro = Animation.spring(response: 0.2, dampingFraction: 0.7)
    
    /// Component transitions: cards, modals
    static let component = Animation.spring(response: 0.35, dampingFraction: 0.8)
    
    /// Page transitions: view changes
    static let page = Animation.spring(response: 0.5, dampingFraction: 0.85)
    
    /// Celebration/achievement animations
    static let celebration = Animation.spring(response: 0.6, dampingFraction: 0.6)
    
    /// Staggered list entrance
    static func staggered(index: Int, baseDelay: Double = 0) -> Animation {
        .spring(response: 0.4, dampingFraction: 0.8)
        .delay(baseDelay + Double(index) * 0.05)
    }
}

// MARK: - Typography System

enum AppTypography {
    // Display - Hero sections, large numbers
    static let display = Font.system(size: 48, weight: .bold, design: .rounded)
    static let displaySmall = Font.system(size: 36, weight: .bold, design: .rounded)
    
    // Headers - Clear hierarchy
    static let h1 = Font.system(size: 32, weight: .bold)
    static let h2 = Font.system(size: 24, weight: .semibold)
    static let h3 = Font.system(size: 20, weight: .semibold)
    static let h4 = Font.system(size: 17, weight: .semibold)
    static let h5 = Font.system(size: 15, weight: .semibold)
    
    // Body - Readable prose
    static let bodyLarge = Font.system(size: 16, weight: .regular)
    static let body = Font.system(size: 14, weight: .regular)
    static let bodySmall = Font.system(size: 12, weight: .regular)
    static let caption = Font.system(size: 11, weight: .regular)
    
    // Monospace - Typing area, metrics
    static let monoDisplay = Font.system(size: 48, weight: .medium, design: .monospaced)
    static let monoLarge = Font.system(size: 32, weight: .medium, design: .monospaced)
    static let mono = Font.system(size: 24, weight: .medium, design: .monospaced)
    static let monoSmall = Font.system(size: 16, weight: .medium, design: .monospaced)
    
    // Metrics - Data display
    static let metricXL = Font.system(size: 72, weight: .bold, design: .rounded)
    static let metricLarge = Font.system(size: 56, weight: .bold, design: .rounded)
    static let metric = Font.system(size: 36, weight: .bold, design: .rounded)
    static let metricSmall = Font.system(size: 24, weight: .bold, design: .rounded)
}

// MARK: - Enhanced View Modifiers

/// Premium glass card with improved depth and styling
struct PremiumGlassCard: ViewModifier {
    var cornerRadius: CGFloat = 20
    var intensity: Double = 0.15
    var padding: CGFloat = 24
    
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                ZStack {
                    // Base material
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)
                    
                    // Tint overlay for theme consistency
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(ThemeManager.shared.currentTheme.colors.surface.opacity(intensity))
                        .blur(radius: 20)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.25),
                                .white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: .black.opacity(0.4),
                radius: 32,
                x: 0,
                y: 16
            )
    }
}

/// Unified app background with subtle mesh gradient
struct AppBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(
                ThemeManager.shared.currentTheme.colors.canvas
                    .overlay(
                        MeshGradientBackground()
                            .opacity(0.2)
                    )
                    .ignoresSafeArea()
            )
    }
}

/// Coordinated entrance animation
struct CoordinatedEntrance: ViewModifier {
    let delay: Double
    @State private var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 24)
            .scaleEffect(isVisible ? 1 : 0.96)
            .onAppear {
                withAnimation(AppAnimation.component.delay(delay)) {
                    isVisible = true
                }
            }
    }
}

/// Pressable button with satisfying feedback
struct PressableModifier: ViewModifier {
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .brightness(isPressed ? -0.08 : 0)
            .animation(AppAnimation.micro, value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

/// Accessible card with reduced motion support
struct AccessibleCardModifier: ViewModifier {
    let backgroundColor: Color
    let cornerRadius: CGFloat
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @Environment(\.accessibilityHighContrast) var highContrast
    
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(highContrast ? Color.black : backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        highContrast ? Color.white : Color.clear,
                        lineWidth: highContrast ? 2 : 0
                    )
            )
    }
}

// MARK: - View Extensions

extension View {
    /// Premium glass card effect
    func premiumGlassCard(
        cornerRadius: CGFloat = 20,
        intensity: Double = 0.15,
        padding: CGFloat = 24
    ) -> some View {
        modifier(PremiumGlassCard(
            cornerRadius: cornerRadius,
            intensity: intensity,
            padding: padding
        ))
    }
    
    /// Unified app background
    func appBackground() -> some View {
        modifier(AppBackgroundModifier())
    }
    
    /// Coordinated entrance animation
    func coordinatedEntrance(delay: Double = 0) -> some View {
        modifier(CoordinatedEntrance(delay: delay))
    }
    
    /// Pressable feedback
    func pressable() -> some View {
        modifier(PressableModifier())
    }
    
    /// Accessible card wrapper
    func accessibleCard(
        backgroundColor: Color = Color.surfaceDark,
        cornerRadius: CGFloat = 16
    ) -> some View {
        modifier(AccessibleCardModifier(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius
        ))
    }
}

// MARK: - Supporting Views

/// Subtle mesh gradient background
struct MeshGradientBackground: View {
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Animated gradient orbs
                Circle()
                    .fill(ThemeManager.shared.currentTheme.colors.primary.opacity(0.15))
                    .frame(width: 400, height: 400)
                    .blur(radius: 80)
                    .offset(
                        x: animate ? 50 : -50,
                        y: animate ? -30 : 30
                    )
                
                Circle()
                    .fill(ThemeManager.shared.currentTheme.colors.secondary.opacity(0.1))
                    .frame(width: 300, height: 300)
                    .blur(radius: 60)
                    .offset(
                        x: animate ? -40 : 40,
                        y: animate ? 40 : -40
                    )
                    .position(x: geo.size.width * 0.8, y: geo.size.height * 0.6)
                
                Circle()
                    .fill(ThemeManager.shared.currentTheme.colors.accent.opacity(0.08))
                    .frame(width: 350, height: 350)
                    .blur(radius: 70)
                    .offset(
                        x: animate ? 30 : -30,
                        y: animate ? 50 : -50
                    )
                    .position(x: geo.size.width * 0.3, y: geo.size.height * 0.8)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                    animate.toggle()
                }
            }
        }
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.h5)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isEnabled
                            ? ThemeManager.shared.currentTheme.colors.primary
                            : Color.gray.opacity(0.5)
                    )
                    .shadow(
                        color: ThemeManager.shared.currentTheme.colors.primary.opacity(0.4),
                        radius: configuration.isPressed ? 4 : 12,
                        x: 0,
                        y: configuration.isPressed ? 2 : 4
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(AppAnimation.micro, value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.h5)
            .foregroundColor(ThemeManager.shared.currentTheme.colors.primary)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ThemeManager.shared.currentTheme.colors.primary.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(ThemeManager.shared.currentTheme.colors.primary.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(AppAnimation.micro, value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview("Design System Components") {
    ScrollView {
        VStack(spacing: 32) {
            Text("Typography")
                .font(AppTypography.h2)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Display 48pt").font(AppTypography.display)
                Text("H1 32pt").font(AppTypography.h1)
                Text("H2 24pt").font(AppTypography.h2)
                Text("H3 20pt").font(AppTypography.h3)
                Text("Body 14pt").font(AppTypography.body)
                Text("Mono 24pt").font(AppTypography.mono)
                Text("Metric 36pt").font(AppTypography.metric)
            }
            
            Divider()
            
            Text("Cards")
                .font(AppTypography.h2)
            
            Text("Premium Glass Card")
                .premiumGlassCard()
            
            Text("Accessible Card")
                .accessibleCard()
            
            Divider()
            
            Text("Buttons")
                .font(AppTypography.h2)
            
            Button("Primary Button") {}
                .buttonStyle(PrimaryButtonStyle())
            
            Button("Secondary Button") {}
                .buttonStyle(SecondaryButtonStyle())
        }
        .padding()
        .appBackground()
    }
    .frame(width: 600, height: 800)
}

import SwiftUI

// MARK: - App Theme Utils

/// Centralized theme modifiers for the "Deep Ocean" aesthetic
struct AppTheme {
    
    struct Glassmorphic: ViewModifier {
        var cornerRadius: CGFloat
        var padding: CGFloat
        
        func body(content: Content) -> some View {
            content
                .padding(padding)
                .background(.ultraThinMaterial) // Native frosted glass
                .environment(\.colorScheme, .dark) // Force dark blur even in light mode if desired, or adaptive
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        }
    }
    
    struct BreathingAnimation: ViewModifier {
        @State private var isBreathing = false
        
        func body(content: Content) -> some View {
            content
                .opacity(isBreathing ? 0.4 : 1.0)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                        isBreathing = true
                    }
                }
        }
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 16, padding: CGFloat = 20) -> some View {
        modifier(AppTheme.Glassmorphic(cornerRadius: cornerRadius, padding: padding))
    }
    
    func breathing() -> some View {
        modifier(AppTheme.BreathingAnimation())
    }
}

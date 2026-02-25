# TypeQuest Design System - Quick Reference

## One-Page Cheat Sheet

---

## 🎨 Colors

```swift
// Theme-aware (automatically updates)
ThemeManager.shared.currentTheme.colors.primary
ThemeManager.shared.currentTheme.colors.accent
ThemeManager.shared.currentTheme.colors.canvas
ThemeManager.shared.currentTheme.colors.surface
ThemeManager.shared.currentTheme.colors.textPrimary
ThemeManager.shared.currentTheme.colors.textSecondary
ThemeManager.shared.currentTheme.colors.success
ThemeManager.shared.currentTheme.colors.error

// Static (always same)
Color.indigoPrimary
Color.cyanAccent
Color.canvasDark
Color.surfaceDark
```

---

## ✏️ Typography

```swift
// Display
AppTypography.display          // 48pt bold rounded
AppTypography.displaySmall     // 36pt bold rounded

// Headers
AppTypography.h1               // 32pt bold
AppTypography.h2               // 24pt semibold
AppTypography.h3               // 20pt semibold
AppTypography.h4               // 17pt semibold
AppTypography.h5               // 15pt semibold

// Body
AppTypography.bodyLarge        // 16pt regular
AppTypography.body             // 14pt regular
AppTypography.bodySmall        // 12pt regular
AppTypography.caption          // 11pt regular

// Monospace (typing)
AppTypography.monoDisplay      // 48pt medium
AppTypography.monoLarge        // 32pt medium
AppTypography.mono             // 24pt medium
AppTypography.monoSmall        // 16pt medium

// Metrics
AppTypography.metricXL         // 72pt bold rounded
AppTypography.metricLarge      // 56pt bold rounded
AppTypography.metric           // 36pt bold rounded
AppTypography.metricSmall      // 24pt bold rounded
```

---

## ✨ Animations

```swift
// Presets
AppAnimation.micro             // Buttons, toggles (0.2s)
AppAnimation.component         // Cards, modals (0.35s)
AppAnimation.page              // View transitions (0.5s)
AppAnimation.celebration       // Achievements (0.6s)
AppAnimation.staggered(index: 0)  // List items

// Usage
.animation(AppAnimation.component, value: state)

// Entrance
.coordinatedEntrance(delay: 0.1)

// Press feedback
.pressable()
```

---

## 🃏 Cards

```swift
// Premium glass card
.premiumGlassCard()

// With custom options
.premiumGlassCard(
    cornerRadius: 20,
    intensity: 0.15,
    padding: 24
)

// Accessible (respects high contrast)
.accessibleCard(
    backgroundColor: Color.surfaceDark,
    cornerRadius: 16
)
```

---

## 🖼 Backgrounds

```swift
// Unified app background
.appBackground()

// Legacy (still works)
.background(Color.canvasDark)
```

---

## 🔘 Buttons

```swift
// Primary (filled)
Button("Action") { }
    .buttonStyle(PrimaryButtonStyle())

// Secondary (outlined)
Button("Secondary") { }
    .buttonStyle(SecondaryButtonStyle())

// Custom with press effect
Button("Custom") { }
    .pressable()
```

---

## 📊 Progress

```swift
// Ring
ProgressRing(
    progress: 0.7,
    color: .orange,
    lineWidth: 6
)

// Linear
GeometryReader { geo in
    ZStack(alignment: .leading) {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.white.opacity(0.1))
        RoundedRectangle(cornerRadius: 4)
            .fill(ThemeManager.shared.currentTheme.colors.primary)
            .frame(width: geo.size.width * progress)
            .animation(AppAnimation.component, value: progress)
    }
}
```

---

## 🎉 Celebrations

```swift
// Confetti
ConfettiView()

// Encouragement
EncouragementToast(text: "🔥 Great job!")

// Level up
LevelUpCelebration(newLevel: 5) { }
```

---

## 📱 Common Patterns

### List with Staggered Animation
```swift
ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
    ItemRow(item: item)
        .coordinatedEntrance(delay: Double(index) * 0.05)
}
```

### Glass Header
```swift
HStack {
    Text("Title")
        .font(AppTypography.h2)
    Spacer()
}
.premiumGlassCard(cornerRadius: 16, intensity: 0.1)
```

### Themed Button
```swift
Button(action: action) {
    HStack {
        Image(systemName: "star")
        Text("Favorite")
    }
    .font(AppTypography.h5)
}
.buttonStyle(PrimaryButtonStyle())
```

### Card with Hover
```swift
MyCard()
    .scaleEffect(isHovered ? 1.02 : 1.0)
    .animation(AppAnimation.component, value: isHovered)
    .onHover { isHovered = $0 }
```

---

## 🎯 View Modifiers (Full List)

| Modifier | Purpose |
|----------|---------|
| `.premiumGlassCard()` | Glass morphism card |
| `.appBackground()` | Unified background |
| `.coordinatedEntrance()` | Entrance animation |
| `.pressable()` | Press feedback |
| `.accessibleCard()` | Accessibility card |

---

## 🧪 Testing Checklist

When creating new views:

- [ ] Use `AppTypography` for all text
- [ ] Use `AppAnimation` for state changes
- [ ] Add `.appBackground()` to root
- [ ] Use `.premiumGlassCard()` for cards
- [ ] Add `.coordinatedEntrance()` for dynamic content
- [ ] Test with Reduce Motion enabled
- [ ] Test with High Contrast enabled
- [ ] Verify at minimum window size

---

## 🚨 Common Mistakes

❌ **Don't:**
```swift
.font(.system(size: 18))                    // Hardcoded size
.animation(.default, value: state)          // Unnamed animation
.background(Color(hex: "#FF0000"))          // Raw hex
.glassCard()                                 // Old modifier
```

✅ **Do:**
```swift
.font(AppTypography.h3)                     // Typography scale
.animation(AppAnimation.component, value: state)  // Named animation
.background(Color.error)                     // Semantic color
.premiumGlassCard()                          // New modifier
```

---

## 🔗 Related Files

- `TypeQuest/Utilities/DesignSystem.swift` - Full implementation
- `TypeQuest/Utilities/Extensions/Color+Extensions.swift` - Colors
- `TypeQuest/Services/Theme/ThemeManager.swift` - Themes

---

*Keep this handy while developing!*

# TypeQuest Developer Migration Guide

## Migrating to the New Design System (2025)

This guide helps developers transition existing views to the new design system.

---

## Quick Migration Checklist

For each view you're updating:

- [ ] Replace `.background(Color.canvasDark)` with `.appBackground()`
- [ ] Replace `.glassCard()` with `.premiumGlassCard()`
- [ ] Replace hardcoded fonts with `AppTypography` presets
- [ ] Replace hardcoded animations with `AppAnimation` presets
- [ ] Add `.coordinatedEntrance()` for dynamic content
- [ ] Test with Reduce Motion enabled
- [ ] Test with High Contrast enabled

---

## Step-by-Step Migration

### Step 1: Update Background

**Before:**
```swift
var body: some View {
    VStack {
        // Content
    }
    .background(Color.canvasDark)
}
```

**After:**
```swift
var body: some View {
    VStack {
        // Content
    }
    .appBackground()  // Unified background with mesh gradient
}
```

---

### Step 2: Update Cards

**Before:**
```swift
VStack {
    Text("Content")
}
.padding(20)
.background(Color.surfaceDark)
.cornerRadius(16)
.glassCard()
```

**After:**
```swift
VStack {
    Text("Content")
}
.premiumGlassCard(
    cornerRadius: 20,      // Optional: default is 20
    intensity: 0.15,       // Optional: default is 0.15
    padding: 24            // Optional: default is 24
)
```

---

### Step 3: Update Typography

**Before:**
```swift
Text("Title")
    .font(.system(size: 24, weight: .bold))

Text("Body text")
    .font(.system(size: 14))

Text("Metric")
    .font(.system(size: 36, weight: .bold, design: .rounded))
```

**After:**
```swift
Text("Title")
    .font(AppTypography.h2)           // 24pt semibold

Text("Body text")
    .font(AppTypography.body)         // 14pt regular

Text("Metric")
    .font(AppTypography.metric)       // 36pt bold rounded
```

**Typography Mapping:**

| Old Style | New Style |
|-----------|-----------|
| `.largeTitle` | `AppTypography.h1` or `AppTypography.display` |
| `.title` | `AppTypography.h2` |
| `.title2` | `AppTypography.h3` |
| `.title3` | `AppTypography.h4` |
| `.headline` | `AppTypography.h5` |
| `.body` | `AppTypography.body` |
| `.caption` | `AppTypography.caption` |
| Monospace 32pt | `AppTypography.monoLarge` |

---

### Step 4: Update Animations

**Before:**
```swift
.animation(.spring(response: 0.35, dampingFraction: 0.7), value: isExpanded)
.animation(.easeInOut(duration: 0.2), value: isPressed)
```

**After:**
```swift
.animation(AppAnimation.component, value: isExpanded)  // Cards, modals
.animation(AppAnimation.micro, value: isPressed)        // Buttons, toggles
```

**Animation Guidelines:**

| Use Case | Animation |
|----------|-----------|
| Button press | `AppAnimation.micro` |
| Card expand | `AppAnimation.component` |
| View transition | `AppAnimation.page` |
| Achievement | `AppAnimation.celebration` |
| List item entrance | `AppAnimation.staggered(index:)` |

---

### Step 5: Add Entrance Animations

**Before:**
```swift
ForEach(items) { item in
    ItemRow(item: item)
}
```

**After:**
```swift
ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
    ItemRow(item: item)
        .coordinatedEntrance(delay: Double(index) * 0.05)
}
```

---

### Step 6: Update Buttons

**Before:**
```swift
Button(action: action) {
    Text("Submit")
        .padding()
        .background(Color.indigoPrimary)
        .foregroundColor(.white)
        .cornerRadius(8)
}
```

**After:**
```swift
Button(action: action) {
    Text("Submit")
        .font(AppTypography.h5)
}
.buttonStyle(PrimaryButtonStyle())
```

**Button Style Options:**
- `PrimaryButtonStyle()` - Filled, for main actions
- `SecondaryButtonStyle()` - Outlined, for secondary actions

---

## Common Patterns

### Pattern 1: Settings Section

**Before:**
```swift
VStack(alignment: .leading, spacing: 8) {
    Text("APPEARANCE")
        .font(.caption)
        .fontWeight(.bold)
        .foregroundColor(.secondary)
    
    VStack {
        Toggle("Dark Mode", isOn: $isDarkMode)
    }
    .padding()
    .background(Color.surfaceDark)
    .cornerRadius(12)
}
```

**After:**
```swift
VStack(alignment: .leading, spacing: 12) {
    SectionHeader(title: "Appearance")
    
    VStack {
        Toggle("Dark Mode", isOn: $isDarkMode)
    }
    .premiumGlassCard(cornerRadius: 16, intensity: 0.1)
}
.coordinatedEntrance(delay: 0.1)
```

---

### Pattern 2: List with Cards

**Before:**
```swift
List(items) { item in
    HStack {
        Text(item.name)
        Spacer()
        Text(item.value)
    }
    .padding()
    .background(Color.surfaceDark)
}
```

**After:**
```swift
List(Array(items.enumerated()), id: \.element.id) { index, item in
    HStack {
        Text(item.name)
            .font(AppTypography.body)
        Spacer()
        Text(item.value)
            .font(AppTypography.body)
            .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
    }
    .padding()
    .accessibleCard()
    .coordinatedEntrance(delay: Double(index) * 0.03)
}
```

---

### Pattern 3: Metric Display

**Before:**
```swift
VStack {
    Text("45")
        .font(.system(size: 48, weight: .bold))
    Text("WPM")
        .font(.caption)
}
```

**After:**
```swift
VStack(spacing: 4) {
    Text("45")
        .font(AppTypography.metric)
        .foregroundColor(ThemeManager.shared.currentTheme.colors.primary)
    Text("WPM")
        .font(AppTypography.caption)
        .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
}
```

---

## Component Replacements

### Loading States

**Before:**
```swift
ProgressView()
    .progressViewStyle(.circular)
```

**After:**
```swift
LoadingSpinner(size: 40, lineWidth: 4)
```

Or for content loading:
```swift
SkeletonLoading(lines: 3)
```

---

### Empty States

**Before:**
```swift
VStack {
    Image(systemName: "doc")
    Text("No items")
}
```

**After:**
```swift
EmptyStateView(
    icon: "doc.text",
    title: "No Items",
    message: "Create your first item to get started",
    actionTitle: "Create",
    action: { /* action */ }
)
```

---

### Error States

**Before:**
```swift
VStack {
    Text("Error")
    Text("Something went wrong")
    Button("Retry", action: retry)
}
```

**After:**
```swift
ErrorStateView(
    title: "Something Went Wrong",
    message: "We couldn't load your data.",
    retryAction: retry
)
```

---

### Toast Notifications

**Before:**
```swift
// Manual implementation or none
```

**After:**
```swift
// Show toast
ToastManager.shared.show(
    title: "Success!",
    message: "Your changes have been saved",
    icon: "checkmark.circle",
    style: .success,
    duration: 3.0
)

// Wrap your view
ToastContainer {
    YourView()
}
```

---

## Color Migration

### Theme-Aware Colors

**Before:**
```swift
.foregroundColor(.indigoPrimary)
.background(Color.surfaceDark)
```

**After:**
```swift
.foregroundColor(ThemeManager.shared.currentTheme.colors.primary)
.background(ThemeManager.shared.currentTheme.colors.surface)
```

### Semantic Colors

| Old | New (Theme-Aware) |
|-----|-------------------|
| `.success` | `ThemeManager.shared.currentTheme.colors.success` |
| `.error` | `ThemeManager.shared.currentTheme.colors.error` |
| `.white` (text) | `ThemeManager.shared.currentTheme.colors.textPrimary` |
| `.gray` (text) | `ThemeManager.shared.currentTheme.colors.textSecondary` |

---

## Accessibility Considerations

### Always Include:

```swift
// Labels for screen readers
.accessibilityLabel("Start typing session")
.accessibilityHint("Double tap to begin")

// Reduce motion support
@Environment(\.accessibilityReduceMotion) var reduceMotion

.animation(reduceMotion ? nil : AppAnimation.component, value: state)
```

### Use Accessible Components:

```swift
// Instead of custom buttons
Button("Action") { }
    .buttonStyle(PrimaryButtonStyle())

// Use accessible cards
Content()
    .accessibleCard()  // Respects high contrast
```

---

## Testing Checklist

After migration, verify:

- [ ] View renders without errors
- [ ] Animations are smooth (60fps)
- [ ] Text is readable in all themes
- [ ] No layout breaks at minimum size
- [ ] Reduce Motion disables animations
- [ ] High Contrast shows borders
- [ ] Colors update when theme changes
- [ ] No console warnings

---

## Troubleshooting

### Issue: Animation not working

**Solution:** Ensure you're using `@State` or `@Published`:
```swift
@State private var isExpanded = false

// Then use
.animation(AppAnimation.component, value: isExpanded)
```

### Issue: Glass card looks wrong

**Solution:** Ensure parent has proper background:
```swift
// Wrap in ZStack with background
ZStack {
    Color.clear.appBackground()
    
    Content()
        .premiumGlassCard()
}
```

### Issue: Colors not updating with theme

**Solution:** Use theme-aware colors:
```swift
// Don't use static colors that won't update
.foregroundColor(.indigoPrimary)

// Use theme manager
.foregroundColor(ThemeManager.shared.currentTheme.colors.primary)
```

### Issue: Entrance animation not showing

**Solution:** Add `.coordinatedEntrance()` after view appears:
```swift
MyView()
    .onAppear {
        // Animation triggers on appear
    }
    .coordinatedEntrance(delay: 0)
```

---

## Before & After: Complete View Example

### Original View:
```swift
struct OldView: View {
    @State private var items = ["Item 1", "Item 2"]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Settings")
                .font(.largeTitle)
                .foregroundColor(.white)
            
            ForEach(items, id: \.self) { item in
                HStack {
                    Text(item)
                        .font(.body)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding()
                .background(Color.surfaceDark)
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.canvasDark)
    }
}
```

### Migrated View:
```swift
struct NewView: View {
    @State private var items = ["Item 1", "Item 2"]
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Settings")
                .font(AppTypography.h1)
                .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                .coordinatedEntrance(delay: 0)
            
            ForEach(Array(items.enumerated()), id: \.element) { index, item in
                HStack {
                    Text(item)
                        .font(AppTypography.body)
                        .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
                }
                .padding()
                .premiumGlassCard(cornerRadius: 16, intensity: 0.1)
                .coordinatedEntrance(delay: 0.1 + Double(index) * 0.05)
            }
        }
        .padding()
        .appBackground()
    }
}
```

---

## Migration Priority

**High Priority (do first):**
1. ContentView and main navigation
2. Settings view
3. Most frequently used views

**Medium Priority:**
1. Secondary views
2. Modal sheets
3. Alert dialogs

**Low Priority (can wait):**
1. Debug/developer views
2. Rarely used features
3. Views being redesigned anyway

---

## Getting Help

If you encounter issues:
1. Check this guide's troubleshooting section
2. Review `DesignSystem_QuickReference.md`
3. Look at existing migrated views as examples
4. Check the preview in `DesignSystem.swift`

---

**Happy Migrating!** 🚀

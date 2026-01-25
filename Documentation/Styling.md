# Styling & Design System

TypeQuest features a modern, high-contrast aesthetic called **"Deep Ocean"**, characterized by glassmorphism, vibrant accents on dark backgrounds, and smooth micro-animations.

## 🎨 Color Palette

We use a curated palette based on the Slate and Indigo scales.

### Brand Colors
| Tone | Hex | usage |
| :--- | :--- | :--- |
| **Indigo Primary** | `#6366F1` | Primary actions, buttons, active focus. |
| **Cyan Accent** | `#06B6D4` | Highlights, level progress, secondary accents. |

### Backgrounds & Surfaces
- **Canvas (Dark)**: `#0F172A` (Slate 900) - Main background.
- **Surface (Dark)**: `#1E293B` (Slate 800) - Cards, panels, overlays.
- **Glass**: `ultraThinMaterial` (System blur) with 10% white opacity stroke.

### Semantic Status
- **Success**: `#10B981` (Emerald 500) - Correct keys, lesson passed.
- **Error**: `#EF4444` (Red 500) - Typos, failed requirements.
- **Warning**: `#F59E0B` (Amber 500) - Posture alerts.

## 🖼 UI Components

### Glass Cards
Use the `.glassCard()` modifier to create consistent frosted-glass containers.
```swift
VStack { ... }
    .glassCard(cornerRadius: 16)
```

### Motion & Feedback
- **Breathing**: Elements that need subtle attention (like "Press any key") use the `.breathing()` modifier.
- **Transitions**: Screen transitions should use `.spring(response: 0.5, dampingFraction: 0.7)`.

## ✍️ Typography
We primarily use system fonts with specialized design traits:
- **Monospaced**: Used for the central typing area and metrics display to ensure character alignment.
- **Rounded**: Used for headers and primary buttons to provide a friendly, accessible feel.

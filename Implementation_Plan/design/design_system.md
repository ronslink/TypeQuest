# TypeQuest Design System: "Liquid Glass" (Light Edition)

**Version**: 1.0.0
**Platform**: macOS 14+ / iPadOS 18+
**Theme**: Light / Airy / Spatial

---

## 1. Design Philosophy: "Liquid Glass"

TypeQuest's interface is built on the metaphor of **"Intelligent Light"**.
*   **Materiality**: The UI feels like layers of high-quality optical glass floating above a warm, paper-like surface.
*   **Depth**: We use shadows and blur (not just borders) to define hierarchy. Deeper elements are "further away".
*   **Motion**: UI elements behave like physical objects with mass and friction.

---

## 2. Color Palette: "Deep Ocean"

**Philosophy**: Reduce cognitive load and eye strain with cooler tones proven to enhance concentration.

### 2.1 Primary Brand Colors
*   **Indigo Primary**: `#6366F1` - *Main actions, highlights, brand identity*
    *   *Hover*: `#4F46E5`
    *   *Pressed*: `#4338CA`
*   **Cyan Accent**: `#06B6D4` - *Progress indicators, success states, growth*
    *   *Hover*: `#0891B2`

### 2.2 Backgrounds
**Light Mode** (Default):
*   **Canvas Base**: `#F8FAFC` (Slate 50) - *Main App Background*
*   **Surface Glass**: `rgba(255, 255, 255, 0.95)` + Blur 30pt - *Cards, Sidebar*
*   **Surface Elevated**: `#FFFFFF` - *Modals, Popovers*

**Dark Mode**:
*   **Canvas Base**: `#0F172A` (Slate 900) - *Main App Background*
*   **Surface Dark**: `#1E293B` (Slate 800) - *Cards*
*   **Surface Glass**: `rgba(30, 41, 59, 0.8)` + Blur 40pt - *Floating elements*

### 2.3 Semantic Colors
*   **Success**: `#10B981` (Emerald 500) - *Correct keystrokes, achievements*
*   **Error**: `#EF4444` (Red 500) - *Typos, alerts*
*   **Warning**: `#F59E0B` (Amber 500) - *Caution states*
*   **Focus**: `#06B6D4` (Cyan) - *Active input, selection*

### 2.4 Text Colors
**Light Mode**:
*   **Primary**: `#0F172A` (Slate 900)
*   **Secondary**: `#475569` (Slate 600)
*   **Tertiary**: `#94A3B8` (Slate 400)

**Dark Mode**:
*   **Primary**: `#F1F5F9` (Slate 100)
*   **Secondary**: `#CBD5E1` (Slate 300)
*   **Tertiary**: `#94A3B8` (Slate 400)

### 2.5 Elevation System
*   **Level 0** (Flush): No shadow
*   **Level 1** (Raised): `0 1px 3px rgba(0,0,0,0.12)`
*   **Level 2** (Lifted): `0 4px 6px rgba(0,0,0,0.1)`
*   **Level 3** (Floating): `0 10px 20px rgba(0,0,0,0.15)`
*   **Level 4** (Modal): `0 20px 40px rgba(0,0,0,0.2)`

---

## 3. Typography (San Francisco / New York)

We use the system fonts to feel native but apply custom tracking for distinctiveness.

| Style | Font | Size | Weight | Tracking | Usage |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Hero Display** | SF Pro Rounded | 48pt | Heavy | -0.5 | Welcome, Level Up |
| **Title 1** | SF Pro Display | 32pt | Bold | 0 | Page Headers |
| **Title 2** | SF Pro Display | 24pt | Semibold | 0 | Section Headers |
| **Body** | SF Pro Text | 17pt | Regular | 0 | Main Content |
| **Mono** | SF Mono | 16pt | Medium | 0 | Code Practice, Keys |
| **Caption** | SF Pro Text | 13pt | Medium | 0.5 | Labels, Hints |

---

## 4. Components

### 4.1 Buttons
*   **Primary (Action Button)**:
    *   Background: Indigo Primary (`#6366F1`)
    *   Text: White (`#FFFFFF`)
    *   Shape: Pill (Corner Radius 28pt)
    *   Shadow: Level 2 (`0 4px 6px rgba(99, 102, 241, 0.2)`)
    *   Hover: Background becomes `#4F46E5`
*   **Secondary (Ghost Button)**:
    *   Background: Surface Glass
    *   Border: 1px solid `rgba(99, 102, 241, 0.2)`
    *   Text: Indigo Primary

### 4.2 Cards (The "Shards")
Cards represent content modules (Lessons, Stats).
*   **Material**: Surface Glass
*   **Corner Radius**: 24pt (Apple Standard)
*   **Border**: 1px solid `rgba(255,255,255, 0.8)` (Inner glow effect)
*   **Shadow**: Level 2 (`0 8px 24px rgba(0,0,0, 0.04)`)
*   **Hover**: Elevates to Level 3

### 4.3 Navigation
*   **Sidebar (macOS/iPad)**:
    *   Translucent "Frosted" strip on the left.
    *   Active State: Icon fills with Indigo Primary + Soft cyan background glow.
*   **Floating Tab Bar (Focus Mode)**:
    *   Pill shape floating at top/bottom.
    *   High Blur material with Indigo tint.

---

## 5. Spacing & Grid
*   **Base Unit**: 4pt
*   **Standard Padding**: 16pt (4 units)
*   **Card Padding**: 24pt (6 units)
*   **Section Gap**: 32pt (8 units)
*   **Layout**: Fluid grid that respects Safe Areas and Window Size classes.

---

## 6. Motion Guidelines
TypeQuest is alive.
*   **Springs**: Use `spring(response: 0.3, damping: 0.7)` for UI interactions (buttons).
*   **Transitions**:
    *   *Push/Pop*: Standard navigation.
    *   *Morph*: Shared Element transitions for Avatar -> Profile.
*   **Micro-interactions**:
    *   Typing a correct letter emits a subtle "ripple" or "particle" from the cursor (Cyan color).
    *   Typing an error shakes the active input field slightly with red glow.
    *   Progress fills animate with Indigo -> Cyan gradient sweep.

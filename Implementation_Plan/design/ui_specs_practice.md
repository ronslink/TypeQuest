# UI Specifications: Practice Session

**Theme**: Zen / High Focus / clean
**Context**: The core loop. Distractions are minimized.

## 1. Layout: "The Stage"
*   **Background**: Pure White (`#FFFFFF`) or very faint Grey.
*   **Chrome**: Hidden. The Sidebar fades away.
*   **HUD (Heads Up Display)**:
    *   *Top Center*: Progress Bar (Thin line, blue).
    *   *Top Right*: Live WPM (Small, monospace).
    *   *Top Left*: Exit/Pause Button (Subtle 'X').

## 2. Text Renderer (The "Stream")
*   **Position**: Vertically centered.
*   **Typography**: SF Mono, Large (24pt).
*   **States**:
    *   *Future Text*: Grey (`#CCCCCC`).
    *   *Current Character*: Black, with a blinking Gold cursor (Block or Bar).
    *   *Past Text (Correct)*: Green (`#2E8B57`).
    *   *Past Text (Error)*: Red (`#FF6B6B`) background highlight on the character.

## 3. Visual Feedback
*   **Particles**:
    *   Correct key press triggers tiny "confetti" or "sparks" matching the Cyan accent color.
    *   Streak > 10 triggers a faint glow around the text container.
*   **Keyboard Overlay (Ghost)**:
    *   Located at the bottom of the screen.
    *   Visualizes the user's hands (Semi-transparent 3D hands).
    *   The correct finger highlights in Cyan.

### 3.1 Adaptive Finger Placement Animation System
**Purpose**: Teach optimal hand positioning through animated tutorials.

**Animation Styles (Persona-Based)**:
1.  **Kids Mode (Ages 5-12)**:
    *   **Style**: Cartoon/Anime 2D character hands
    *   **Visuals**: Bright, colorful, exaggerated finger movement
    *   **Characters**: Robot "Bit" hands (mechanical), Wizard "Spell" hands (magical sparkles), Cat "Glitch" paws
    *   **Sound**: Playful "boop" sounds when finger lands on key
    *   **Tutorial**: "Watch Bit's fingers dance on the keys!"

2.  **Adult Mode (Ages 18-59)**:
    *   **Style**: Realistic 3D hands (SceneKit/RealityKit)
    *   **Visuals**: Natural skin tones, subtle finger movements
    *   **Overlay**: Semi-transparent glass effect matching UI theme
    *   **Sound**: Subtle mechanical keyboard "thock" sound
    *   **Tutorial**: "Position your fingers as shown"

3.  **Senior Mode (Ages 60+)**:
    *   **Style**: High-contrast, simplified 2D hands
    *   **Visuals**: Large finger indicators, slower movement speed
    *   **Colors**: Bold outlines (Indigo on White background)
    *   **Sound**: Clear audio cues with optional VoiceOver narration
    *   **Tutorial**: "Each finger has a home position. Let's practice."

**Implementation**:
*   Trigger: First-time lesson launch or manual "Show Hand Guide" toggle in Settings
*   Format: Lottie animations or USDZ 3D models
*   Location: Overlay above practice text OR small widget in bottom-right corner
*   Interaction: Can be dismissed with Esc or tap outside

## 4. Modes
### 4.1 Zen Mode
*   **HUD**: Completely hidden.
*   **Sound**: Ambient nature sounds fade in.
*   **End Condition**: User stops typing for 5s (Fade out).

### 4.2 Sprint Mode
*   **Timer**: Large countdown timer in the background (Watermark).
*   **Intensity**: Screen edges pulsate red when < 5s remain.

## 5. Paused State
*   **Blur**: The text blurs out.
*   **Menu Overlay**:
    *   "Resume" (Gold Pill)
    *   "Restart" (White Pill)
    *   "Settings" (Icon)
    *   "Quit" (Text Link)

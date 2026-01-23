# UX & Design Strategy: The "Liquid Glass" Era

## 1. Design Philosophy: "Liquid Glass"
Based on 2025 iPadOS trends and Apple Design Award winners, TypeQuest will adopt the **"Liquid Glass"** design language.
*   **Visuals**: High translucency, depth-based layering, and fluid animations.
*   **Materiality**: The UI feels like a physical, floating layer above the content.
*   **Spatial Readiness**: UI elements are designed with 3D depth in mind, ready for future visionOS adaptation.

## 2. Navigation Architecture
### 2.1 The Morphing Sidebar
We will utilize the **iPadOS 18 `UITabBar` integration**.
*   **State A (Expanded)**: A full Sidebar (Source List) on the left for Navigation (Learn, Practice, Stats, Shop).
*   **State B (Collapsed/Focus)**: The Sidebar morphs into a **Floating Tab Bar** at the top-center of the screen.
*   **Customization**: Users can drag their favorite specific lessons or modes from the Sidebar onto the Floating Tab Bar for quick access.

## 3. Interaction Design
### 3.1 "Desktop-Class" Touch
*   **Pointer Effects**: Buttons “snap” to the cursor (Magic Trackpad).
*   **Hover States**: Key caps on the virtual keyboard glow subtly when the cursor hovers over them.
*   **Context Menus**: Long-press on any Skill Tree node reveals rich actions (Practice specific keys, View Leaderboard).

### 3.2 Haptic & Audio Feedback Loop
*   **Texture**: Different textures for UI elements (e.g., "Glassy" feel for the HUD, "Matte" feel for the Settings).
*   **Impact**: `UIImpactFeedbackGenerator` provides varying intensities:
    *   *Light*: Key press (successful).
    *   *Rigid*: End of line/margin bump.
    *   *Heavy*: Level Up / Achievement Unlock.

## 4. Accessibility as a Feature
*   **Dynamic Type**: All text scales infinitely.
*   **VoiceControl**: The entire app is navigable by voice commands ("Click Next Lesson").
*   **High Contrast**: A dedicated "E-Ink" mode for users sensitive to motion or light.

## 5. Gamified UI Patterns
*   **3D Hero Elements**: The "Ink" currency and "Avatars" are rendered as 3D USDZ models using SceneKit/RealityKit, allowing them to spin and react to touch.
*   **Particle Effects**: Success is celebrated with confetti (using `SpriteKit` particles) that respects the gravity of the device orientation.

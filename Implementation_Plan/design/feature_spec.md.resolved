# Feature Specification: TypeQuest iOS (iPad Edition)

## 1. Executive Summary
TypeQuest is a gamified RPG-like typing tutor designed to transform touch-typing mastery into an engaging journey. Targeting students, professionals, and hobbyists, it leverages iPad hardware (Magic Keyboard) to increase WPM and accuracy through a "Skill Tree" curriculum and diverse practice modes.

## 2. Core Functionality

### 2.1 iPad-First Typing Engine
*   **Input Handling**:
    *   **Hardware Priority**: Full integration with `GCKeyboard` (Game Controller framework) for <8ms latency.
    *   **On-Screen**: "Float" and "Split" keyboard visualization.
*   **Metrics Calculation** (High-Frequency Polling: 500ms updates):
    *   **WPM Formula**: `((Total Characters / 5) - Uncorrected Errors) / Time(min)`.
    *   **Raw Accuracy**: `(Correct Keystrokes / Total Keystrokes) * 100`.
    *   **Corrected Accuracy**: Tracks "Backspace" usage to identify unstable typing patterns.
    *   **Struggle Map**: Heatmap identifying keys with latency >30% above user average.
*   **Real-time Feedback**:
    *   **Smart Text Renderer**: 120Hz ProMotion support for smooth cursor movement.
    *   **Peripheral Cues**: Screen edges glow red on error.

### 2.2 Multi-Language "Locale-Aware Engine"
*   **Corpus Dictionary**: Frequency-based dictionary (Top 1000 words) for realistic practice.
*   **Tiers**:
    *   **Tier 1 (Launch)**: English (US/UK), Spanish, French, German.
    *   **Tier 2**: Japanese (Romaji), Portuguese, Italian.
*   **Localization**: Native `.stringscatalog` for UI.
*   **Layout Detection**: Auto-detect QWERTY, AZERTY, QWERTZ and adjust visual guides.

### 2.3 Progressive "Skill Tree" System
*   **Structure**:
    *   **Stages**: Broad themes (e.g., "Home Row Forest", "Numeric Peaks").
    *   **Modules**: 5-10 lessons per stage.
    *   **Lessons**: 1-3 minute drills.
*   **Unlock Logic**:
    *   **Passing**: Accuracy ≥ 94%, WPM ≥ 20 (Early levels).
    *   **Gold Star**: Accuracy ≥ 98%, WPM ≥ 50.
    *   **Prerequisite**: Previous node complete.

### 2.4 Practice Modes
*   **Zen Mode**: Infinite scrolling text, no timer, hidden metrics. Focus on flow and rhythm.
*   **Custom Text**: "Paste & Type" with sanitizer (removes unsupported ASCII/Unicode).
*   **Daily Sprint**: Fixed 60-second global challenge with leaderboard.
*   **Dynamic Difficulty Adjustment (DDA)**:
    *   If Accuracy > 98% for 2 mins, introduce complex vocabulary (n-grams, scientific terms).

## 3. Technical Considerations (iPadOS)
*   **Stack**: Swift 6.0, SwiftUI, SwiftData, CloudKit.
*   **Input**: `GCController` / `GCKeyboard` for hardware capture.
*   **Haptics**: `UIImpactFeedbackGenerator` for "Perfect Word" streaks.
*   **Performance**:
    *   Input Latency: < 8ms.
    *   Frame Rate: Constant 120fps (ProMotion).

## 4. Success Metrics (KPIs)
*   **Retention**: Day 30 > 25%.
*   **Growth**: +15 WPM after 10 hours of practice.
*   **Engagement**: Avg session duration 12 minutes.


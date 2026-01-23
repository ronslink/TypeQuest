# Implementation Plan: Gamified Typing Tutor App (iPadOS Edition)

## Goal Description
Design and plan a comprehensive, gamified typing tutor application explicitly for **iPad**, targeting a wide demographic from children to seniors. The goal is to create a "Desktop-Class" experience that leverages hardware keyboards, multitasking, and the large canvas to provide a superior learning tool.

## Design Deliverables (Completed & Refined)
The following design documents have been updated for iPadOS:

1.  **[Market Analysis & Pricing](design/market_analysis.md)**
    *   *Highlights*: Gap for "Native Desktop-Class" iPad apps vs web ports.
2.  **[Feature Specification](design/feature_spec.md)**
    *   *Highlights*: Hardware Keyboard priority, Split View/Stage Manager support, `NavigationSplitView` architecture.
3.  **[Gamification Framework](design/gamification_framework.md)**
    *   *Highlights*: "Skill Tree" progression, "KeyCoins" soft economy, League-based social competition.
4.  **[User Journey Strategy](design/user_journey.md)**
    *   *Highlights*: Classroom use with rugged cases, Pro use with Magic Keyboard/Sidecar.
5.  **[Development Roadmap](design/roadmap.md)**
    *   *Highlights*: `GCController` integration, Keyboard Shortcuts, Widget support.
6.  **[Audio Strategy](design/audio_strategy.md)**
    *   *Highlights*: Mechanical Key Switch profiles (Blue/Brown/Red), Flow State music channels, and Accessibility voiceover.
7.  **[Technology Stack](design/tech_stack.md)**
    *   *Highlights*: Pure Swift 6, SwiftUI MVVM, SwiftData persistence, GCController for hardware input, Zero 3rd-party dependencies.
8.  **[UX Strategy](design/ux_strategy.md)**
    *   *Highlights*: "Liquid Glass" design language, Morphing Sidebar/TabBar, and Spatial-ready interactions.
9.  **[Technical Design Document](design/technical_design.md)**
    *   *Highlights*: MVVM architecture, SwiftData models, XcodeGen config, KeyboardManager, AudioManager, and Testing Strategy.

## Proposed Changes (Development Phase)
If you approve this design, the next phase (Execution) would involve setting up the project structure.

### Project Setup
#### [NEW] `TypingTutor.xcodeproj`
- Initialize new iOS project with **iPad-only** target (initially).
- Configure `NavigationSplitView` as root.
- Enable "Game Controller" capabilities for keyboard capture.

### Development Stages (Overview)
- **Stage 1**: Hardware Input Catching & Layout Engine.
- **Stage 2**: Responsive Lesson UI (Split View compatible).
- **Stage 3**: Persistence Layer (SwiftData).
- **Stage 4**: Gamification UI overlay.

## Verification Plan
### Manual Verification
- **Design Review**: User to review the updated iPad-specific documents.
- **Prototype Testing**: Verify `GCController` can capture keystrokes without an input field focus.

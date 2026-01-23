# Development Roadmap (iPadOS Edition)

## Phase 1: Foundation (Months 1-2)
*   **Goal**: Functional Typing Engine & Hardware Input.
*   **Milestones**:
    *   [ ] Implement `GCController` / `GameController` framework to intercept hardware key events (low latency).
    *   [ ] Build `NavigationSplitView` shell for Sidebar + Content layout.
    *   [ ] Create "Virtual Keyboard" HUD that lights up when hardware keys are pressed.
    *   [ ] Design `Lesson` data model.

## Phase 2: Core Loop & iPadOS Integration (Months 3-4)
*   **Goal**: Progression and Multitasking.
*   **Milestones**:
    *   [ ] Implement Split View and Slide Over support (Auto Layout constraints).
    *   [ ] Add Keyboard Shortcut support (`UIKeyCommand`).
    *   [ ] Connect CloudKit for "School to Home" sync.
    *   [ ] Create "Diagnostic Test" for onboarding.

## Phase 3: Gamification Layer (Months 5-6)
*   **Goal**: The Fun Factor.
*   **Milestones**:
    *   [ ] Build "Skill Tree" Map utilizing full screen real estate.
    *   [ ] Implement Game Center Leaderboards (visible in Sidebar).
    *   [ ] Create "Shop" UI.
    *   [ ] Add "Daily Streak" Widget for iPad Home Screen (Extra Large size).

## Phase 4: Polish & Expansion (Months 7-8)
*   **Goal**: Content Depth and Visuals.
*   **Milestones**:
    *   [ ] Create 100+ unique lessons (Zones 3-6).
    *   [ ] Implement "Adaptive Practice" algorithm (Problem Key generation).
    *   [ ] Add Localization: Spanish, French, German.
    *   [ ] Finalize UI theming engine and animations.
    *   [ ] Beta Testing via TestFlight (Closed Group).

## Phase 5: Launch Prep (Month 9)
*   **Goal**: Release Candidate.
*   **Milestones**:
    *   [ ] Integrate StoreKit 2 for Subscriptions/IAP.
    *   [ ] Finalize Paywall UI and onboarding flow.
    *   [ ] Comprehensive Accessibility Audit (VoiceOver, Dynamic Type).
    *   [ ] App Store Screenshots, Privacy Policy, and Marketing Copy.
    *   [ ] **Global Launch**.

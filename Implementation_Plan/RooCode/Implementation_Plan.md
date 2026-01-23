# TypeQuest - macOS/iPad Feature Specification Document

**Document Version**: 2.0.0  
**Status**: Draft / For Review  
**Role Context**: Product Management & Technical Architecture  
**Date**: January 2025

---

## 1. Executive Summary

### Strategic Pivot: macOS as Primary Platform

After extensive market research, we've identified that **macOS is the optimal launch platform** for TypeQuest. This strategic decision is driven by:

**Practical Necessity**:
- Typing apps require physical keyboards to be effective
- macOS guarantees physical keyboard availability on all Macs
- iOS/iPad version would be limited to iPad + Bluetooth keyboard users (niche market)
- No autocorrect interference on macOS for cleaner input handling

**Market Opportunity**:
- Less crowded market on macOS compared to web-based solutions
- Existing macOS typing apps have dated UI/UX - significant room for modern design
- More opportunity to stand out with superior gamification

**Business Model Advantages**:
- Higher willingness to pay on macOS ($15-30 vs $3.99-5.99 on iOS)
- Desktop users are more serious about productivity tools
- Easier to justify subscription pricing

**Technical Benefits**:
- Better keyboard event handling (no autocorrect interference)
- Larger screen = better UI for learning proper finger placement
- Can show hands/keyboard visualization more effectively

### Core Value Proposition

**TypeQuest** is a gamified macOS/iPad application designed to transform touch-typing mastery into an engaging RPG-like experience. The application targets students, professionals, and hobbyists looking to increase their Words Per Minute (WPM) and accuracy.

**Key Differentiators**:
- True gamification (not just lesson-based)
- Modern subscription models (not outdated one-time purchase)
- Social/competitive features (multiplayer, leaderboards are rare)
- Cross-platform sync (practice on Mac at home, iPad at school/work)
- "Liquid Glass" design language

### Platform Strategy

| Phase | Timeline | Platforms | Target Users |
|-------|----------|-----------|--------------|
| **Phase 1** | Launch | macOS only | Serious learners, schools, professionals |
| **Phase 2** | Q2 2025 | macOS + iPad | Schools with iPads, mobile professionals |
| **Phase 3** | Optional | iPhone | Thumb-typing market (different app concept) |

**Universal Purchase Model**: Buy once, works on Mac and iPad with iCloud sync of progress.

---

## 2. Competitive Analysis Update

### Market Gaps Identified

Based on current market research, most competitors have significant gaps:

| Gap | Market Reality | TypeQuest Advantage |
|-----|----------------|---------------------|
| **True Gamification** | Most are lesson-based, not game-based | RPG progression, skill trees, 3D elements |
| **Modern Subscriptions** | Many use outdated one-time purchase | Freemium + subscription + lifetime options |
| **Social Features** | Multiplayer and leaderboards are rare | Friend challenges, global leaderboards |
| **Cross-Platform Sync** | Only a few (like Typesy) offer this | CloudKit sync across Mac and iPad |

### Key Competitors

| Competitor | Strengths | Weaknesses | TypeQuest Advantage |
|------------|-----------|------------|---------------------|
| **Typing.com** | Curriculum depth, teacher tools | Desktop-focused, dated UI, limited gamification | Native macOS, modern UX, true RPG progression |
| **Typing Master** | Games, detailed metrics | Windows-only, dated design | macOS native, Liquid Glass design |
| **Keybr** | Minimalist, privacy-focused | No gamification, web-only | 3D hero elements, achievement system |
| **Typesy** | Cross-platform sync | Subscription model issues | Universal purchase, CloudKit sync |

### Differentiation Strategy

1. **True Gamification**: RPG-like experience with character progression, not just lesson completion
2. **Modern Pricing**: Freemium + subscription + lifetime options
3. **Social Features**: Friend challenges, team competitions, global leaderboards
4. **Cross-Platform**: Universal purchase with seamless CloudKit sync
5. **Liquid Glass Design**: Stunning visuals that compete with modern apps
6. **True Offline-First**: Full functionality without connectivity

---

## 3. Multi-Language Support Details

To ensure global scalability, TypeQuest employs a Locale-Aware Engine that adjusts not just the UI, but the underlying data structures for typing exercises.

### 3.1 Language Tiers

| Tier | Languages | Timeline |
|------|-----------|----------|
| **Tier 1 (Launch)** | English (US/UK), Spanish, French, German | Launch |
| **Tier 2 (Post-Launch)** | Japanese (Romaji), Portuguese, Italian | Q3 2025 |
| **Tier 3 (Future)** | Dutch, Polish, Russian (Cyrillic), Chinese (Pinyin) | 2026 |

### 3.2 Technical Implementation

**Corpus Dictionary System**:
- Frequency-based dictionary approach (Top 1000 words per language)
- N-gram sequences for realistic phrase generation
- Scientific and technical vocabulary for advanced levels
- Custom vocabulary import capability

**Keyboard Layout Detection**:
- Auto-detect active macOS Keyboard Layout (QWERTY, AZERTY, QWERTZ)
- Dynamic "Finger Placement" visual guide adjustment
- Support for regional variants (Swiss German, Canadian French)
- Physical keyboard layout mapping with proper macOS input handling

**Localization (L10n)**:
- Use .stringscatalog in Xcode for UI elements
- Full RTL support for future Arabic/Hebrew
- Date/number formatting per locale
- Accessible text scaling

**Special Character Handling**:
- Diacritics support (ñ, é, ö, ü, à, etc.)
- Composed vs. single-tap character differentiation
- Alt code and option key combinations
- Emoji and symbol training for social languages

---

## 4. Progressive Lesson System Structure

The curriculum is structured as a Skill Tree, where users earn "Experience Points" (XP) to unlock higher-tier nodes.

### 4.1 Hierarchy of Learning

```
STAGES (Broad Categories)
│
├── Stage 1: The Home Row Forest
│   ├── Module 1.1: Home Row Introduction
│   ├── Module 1.2: Left Hand Mastery
│   └── Module 1.3: Right Hand Mastery
│
├── Stage 2: The Numeric Peaks
│   ├── Module 2.1: Number Row
│   ├── Module 2.2: Symbol Valley
│   └── Module 2.3: Numpad Pro
│
├── Stage 3: The Speed Highway
│   ├── Module 3.1: Common Words
│   ├── Module 3.2: Phrase Flow
│   └── Module 3.3: Sentence Sprints
│
├── Stage 4: The Accuracy Citadel
│   ├── Module 4.1: Precision Drills
│   ├── Module 4.2: Weak Key Attack
│   └── Module 4.3: Error Recovery
│
└── Stage 5: The Expert Express
    ├── Module 5.1: Technical Terms
    ├── Module 5.2: Coding Syntax
    └── Module 5.3: Advanced Composition
```

**Time Structure**:
- **Stages**: Thematic groupings (5 stages in launch)
- **Modules**: 5-10 lessons per stage (3-5 minutes each)
- **Lessons**: Individual 1-3 minute typing drills

### 4.2 Unlocking Logic

| Requirement | Threshold (Passing) | Threshold (Gold Star) |
|-------------|---------------------|----------------------|
| Accuracy | ≥ 94% | ≥ 98% |
| WPM | ≥ 20 WPM (Level 1-5) | ≥ 50 WPM |
| Prerequisite | Previous Node Complete | Previous Node Gold Star |

**Bonus Conditions**:
- Streak bonus: +10% XP per consecutive day (max +50%)
- Accuracy bonus: +20% XP for 99%+ accuracy
- Speed bonus: +15% XP for exceeding WPM threshold by 10+

### 4.3 Gamification Mechanics

**Character Progression**:
- Avatar selection at onboarding (5 starter options)
- Visual evolution as user levels up
- Unlockable outfits and accessories via "Ink" currency
- Character class bonuses (speed-focused, accuracy-focused, balanced)

**Streak System**:
- Daily login streak tracker
- Lesson completion streak
- Streak recovery items (premium)
- Milestone celebrations (7, 30, 100, 365 days)

**Currency System**:
- **Ink (Primary Currency)**: Earned through practice and achievements
- **Gold (Premium Currency)**: Earned through achievements, purchasable
- **Gems (Rare Currency)**: Achievement milestones, special events

**Spending Options**:
- Custom keyboard skins (Mechanical Blue Switch, Silent Red, Retro Typewriter)
- Sound effect packs
- Avatar accessories
- Streak protection items
- Premium lesson content

---

## 5. Real-Time Metrics Logic

Precision in metrics is critical for user trust. TypeQuest uses a high-frequency polling system to calculate performance.

### 5.1 Words Per Minute (WPM) Calculation

**Standard Word Definition**: 5 characters = 1 word

**WPM Formula**:
```
WPM = ((Total Characters / 5) - Uncorrected Errors) / Time(min)
```

**Real-Time Display**:
- Sliding window average (500ms refresh)
- Smooth interpolation to prevent erratic movement
- Target zone indicator (color-coded)
- Personal best highlight

### 5.2 Accuracy Tracking

**Raw Accuracy**:
```
Raw Accuracy = (Correct Keystrokes / Total Keystrokes) * 100
```

**Corrected Accuracy**:
- Tracks Backspace usage frequency
- High backspace triggers "Stability" warning
- Penalty: -2% accuracy per 10 backspaces

### 5.3 Key Latency & Heatmapping

**Latency Measurement**:
```
Latency Delta = Time(UIKeyCommand registered) - Time(Prompt character shown)
```

**Performance Threshold**:
- Normal: < 20% above user average
- Warning: 20-30% above average
- Struggle: > 30% above average

**Struggle Map Visualization**:
- Per-key latency heatmap (green to red)
- Hand imbalance chart (left vs. right)
- Finger usage statistics
- Specific key recommendations

---

## 6. Practice Mode Specifics

Practice mode is a "sandbox" for users to refine skills outside the structured curriculum.

### 6.1 Mode Variations

**Zen Mode**:
- Infinite scrolling text
- No timer display
- Hidden metrics until manual end
- Focus on rhythm and relaxation
- Optional ambient soundscape

**Custom Text Mode**:
- Paste articles, code, or documents
- Parser sanitizes input
- Code syntax highlighting option
- Import from Files app

**Daily Sprint**:
- Fixed 60-second challenge
- Global leaderboard (opt-in)
- Daily reset at midnight
- Bonus XP for participation

### 6.2 Dynamic Difficulty Adjustment (DDA)

**Smart Engine Monitoring**:
- Tracks accuracy over rolling 2-minute window
- Detects user performance plateau
- Identifies when user is ready for challenge

**Adaptation Rules**:
- Maintain >98% accuracy for 2 minutes → Increase difficulty
- Drop below 90% accuracy → Decrease difficulty
- Consistent >50 WPM → Introduce technical vocabulary

---

## 7. User Experience Design

### 7.1 Age-Appropriate Experiences

**Children (Ages 5-12)**:
- Bright, cartoon RPG aesthetic
- Cute mascot companion
- Celebratory sounds and animated rewards
- COPPA compliant, no social features
- Parent Dashboard for progress tracking

**Teens (Ages 13-17)**:
- Modern, gaming-inspired design
- Stylized avatar with customization
- Achievement sharing and leaderboards
- Opt-in social features

**Adults (Ages 18-59)**:
- Clean, professional interface
- Subtle notifications, detailed reports
- Skill certifications, professional tracks
- Efficiency-optimized design

**Seniors (Ages 60+)**:
- High contrast, large text
- Extended audio/visual cues
- VoiceOver optimized, switch control
- Unlimited time options

### 7.2 Onboarding Flow

**Phase 1: Welcome & Setup** (3-4 minutes):
- App introduction with value proposition
- Age group selection
- Language selection
- Keyboard type detection

**Phase 2: Placement Assessment** (5-7 minutes):
- Key recognition warm-up
- 1-minute speed test
- 2-minute accuracy test
- Generate personalized learning path

**Phase 3: Tutorial Walkthrough** (3-4 minutes):
- Finger placement guide
- First practice lesson
- Metrics introduction
- Achievement system preview

**Phase 4: First Session** (5-10 minutes):
- Guided first module
- Real-time coaching
- Session completion celebration
- Progress dashboard introduction

---

## 8. UX & Design Strategy: The "Liquid Glass" Era

Based on 2025 macOS and iPadOS trends and Apple Design Award winners, TypeQuest will adopt the **"Liquid Glass"** design language.

### 8.1 Design Philosophy: "Liquid Glass"

**Core Visual Principles**:
- High translucency with background blurs and material effects
- Depth-based layering with Z-axis awareness
- Fluid animations with spring physics
- Materiality: UI feels like physical, floating glass layers
- Spatial readiness for future visionOS adaptation

### 8.2 Navigation Architecture

**Morphing Sidebar Implementation** (macOS + iPadOS):

```swift
struct MorphingSidebarView: View {
    @State private var isExpanded = true
    
    var body: some View {
        if isExpanded {
            ExpandedSidebar()
                .transition(.move(edge: .leading).combined(with: .opacity))
        } else {
            FloatingTabBar()
                .transition(.scale.combined(with: .opacity))
        }
    }
}
```

**State A - Expanded Sidebar**:
- Left-side navigation panel (Source List style)
- Primary sections: Learn, Practice, Stats, Shop, Settings
- Drag-to-resize capability
- Section icons with glass effect

**State B - Collapsed/Focus Mode**:
- Morphs into floating tab bar at top-center
- Minimal footprint for content-focused sessions
- Auto-collapse after 10 seconds of inactivity

### 8.3 Interaction Design

**Desktop-Class Touch**:
- Pointer effects with snap-to-cursor
- Hover states with scale and glow
- Context menus on long-press
- Keyboard shortcut support

**Haptic & Audio Feedback**:
- UIImpactFeedbackGenerator with varying intensities
- Synchronized audio-haptic feedback
- Spatial audio for achievements
- Mute options per feedback type

### 8.4 Accessibility as a Feature

**Accessibility Features**:
- Dynamic Type with infinite scaling
- VoiceControl navigation ("Click Next Lesson", "Go Back")
- High Contrast E-Ink mode
- Reduce motion option
- Color blind friendly palettes
- Screen reader optimized labels

### 8.5 Gamified UI Patterns

**3D Hero Elements**:
- Ink Currency as 3D USDZ coins using SceneKit
- Avatars as 3D character models
- Interactive badges with rotation
- Particle effects for celebrations (SpriteKit)

**Liquid Glass Animations**:
- Smooth interpolation between states
- Spring-based physics
- Parallax scrolling effects
- Blur transitions between screens

---

## 9. Technical Architecture Overview

### 9.1 Platform: macOS + iPadOS

**Universal App Strategy**:
- Single codebase using SwiftUI
- Universal purchase across Mac and iPad
- Native experience on each platform
- iCloud sync for progress and settings

**Framework Stack**:
- **UI Layer**: SwiftUI with custom components
- **Data Binding**: Combine framework for reactive updates
- **State Management**: SwiftUI @Observable, @State, @Environment
- **Navigation**: NavigationStack with deep link support

**macOS-Specific Optimizations**:
- NSEvent for keyboard event handling (no autocorrect interference)
- CGEvent for low-latency input monitoring
- NSStatusBar for menu bar quick access
- Focus management for keyboard shortcuts

**iPadOS-Specific Features**:
- External keyboard detection (GCKeyboard)
- Stage Manager support
- Split View compatibility
- Apple Pencil support (optional)

### 9.2 Backend & Data

**Local Persistence**:
- **Primary**: SwiftData (macOS 14+, iPadOS 17+) with Core Data fallback
- **UserDefaults**: Settings and quick-access data
- **FileManager**: Lesson content and user exports

**Cloud Sync**:
- **Primary**: CloudKit for seamless device transition
- **Conflict Resolution**: Last-write-wins with merge for stats
- **Privacy**: End-to-end encryption option
- **Offline-First**: Local storage primary, cloud sync secondary

### 9.3 Performance Requirements

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| Input Latency | < 8ms | NSEvent to visual update |
| Frame Rate | 60fps | Core Animation instruments |
| App Launch | < 2 seconds | XCTest metrics |
| Memory Usage | < 100MB typical | Memory Graph debugger |
| Battery Impact | < 5%/hour practice | Energy Log debug |

---

## 10. Audio & Sound Design

### 10.1 Sound Architecture Overview

**Core Audio Philosophy**:
- Sounds enhance user experience without being distracting
- Age-appropriate sound profiles
- All sounds optional and fully customizable
- Low battery impact design

### 10.2 Sound Categories

**Keystroke Sounds**:
- Tactile Click, Soft Tap, Mechanical Clack, Retro Click, Muted
- Dynamic feedback with pitch variation

**Achievement Sounds**:
- Badge Unlock, Level Up, Streak Milestone, Perfect Session
- Age-appropriate variations

**Ambient Music**:
- Focus Music (60-80 BPM)
- Energetic Music (100-120 BPM)
- Zen Mode ambient sounds

### 10.3 Audio Features

**Sound Packs**:
- Free: Classic Pack, Basic UI Pack, 2 Music Tracks
- Premium: Retro Pack, Sci-Fi Pack, Nature Pack, Kids Pack, ASMR Pack

---

## 11. Monetization Strategy

### 11.1 Recommended Pricing Model: Hybrid Approach

Based on market research and competitive analysis, we recommend the **Hybrid Model**:

**Free Tier**:
- 10 lessons (sufficient to demonstrate value)
- Basic stats (WPM, accuracy)
- Ad-supported
- Limited customization

**Subscription Options**:
- **Monthly**: $6.99/month
- **Yearly**: $39.99/year (47% discount)
- Universal purchase (works on Mac and iPad)

**One-Time Purchase Option**:
- **Lifetime**: $149.99 one-time
- All current and future features
- Universal purchase

**Family Plan**:
- **Family**: $59.99/year (up to 5 users)
- Individual progress per user
- Family leaderboard

### 11.2 Pricing Justification

| Tier | Price | Competitor Comparison | Value Proposition |
|------|-------|----------------------|-------------------|
| Free | $0 | Standard free tier | 10 lessons to demonstrate value |
| Monthly | $6.99 | $4.99-14.99 market range | Premium features, modern UX |
| Yearly | $39.99 | $29.99-99.99 market range | 47% savings vs monthly |
| Lifetime | $149.99 | $29.99 one-time competitors | Future-proof investment |
| Family | $59.99 | $99.99 competitors | Up to 5 users, significant savings |

**Rationale**:
- $6.99/month is competitive but reflects premium value
- Lifetime option at $49.99 converts annual subscribers
- Family plan at $59.99 is 20% below market leader pricing
- Universal purchase justifies higher price point

### 11.3 Revenue Projections

| Metric | Conservative | Moderate | Optimistic |
|--------|--------------|----------|------------|
| Year 1 Downloads | 20,000 | 50,000 | 100,000 |
| Conversion Rate | 5% | 8% | 12% |
| Annual Subscribers | 1,000 | 4,000 | 12,000 |
| Year 1 Revenue | $60,000 | $200,000 | $600,000 |

---

## 12. Success Metrics (KPIs)

### 12.1 User Engagement

| Metric | Target |
|--------|--------|
| Day 1 Retention | > 50% |
| Day 7 Retention | > 35% |
| Day 30 Retention | > 25% |
| Average Session Duration | 12 minutes |
| Sessions Per Week | 4+ |

### 12.2 Learning Outcomes

| Metric | Target |
|--------|--------|
| WPM Improvement | +15 WPM after 10 hours |
| Accuracy Improvement | +8% after 10 hours |
| Lesson Completion Rate | > 75% |
| Stage Progression | 50% reach Stage 3 in 90 days |

### 12.3 Business Metrics

| Metric | Target |
|--------|--------|
| Free to Premium Conversion | 5-8% |
| Customer Lifetime Value | $40-80 |
| Net Promoter Score | 50+ |
| App Store Rating | 4.5+ |

---

## 13. Development Roadmap

### Phase 1: macOS Launch (Sprints 1-16)

**Sprint 1-4: Foundation**
- Project setup with SwiftUI
- Core Data model design
- Basic navigation architecture
- Design system implementation

**Sprint 5-8: Core Engine**
- Typing input handling (NSEvent)
- WPM/accuracy calculation
- Session management
- Progress tracking

**Sprint 9-12: Content & Gamification**
- Lesson system (Stage 1-2)
- Achievement framework
- XP and leveling system
- Avatar system

**Sprint 13-16: Polish & Launch**
- Liquid Glass UI refinement
- Audio and haptics
- Testing and optimization
- App Store submission

**macOS Launch**: Month 4

### Phase 2: iPad Expansion (Sprints 17-24)

**Sprint 17-20: iPad Adaptation**
- Universal app setup
- External keyboard support (GCKeyboard)
- Split View compatibility
- iPad-specific UI adjustments

**Sprint 21-24: Sync & Social**
- CloudKit implementation
- Universal purchase setup
- Leaderboard system
- Friend challenges

**iPad Launch**: Month 6

### Phase 3: iPhone Pivot (Optional, Sprint 25+)

**Considerations**:
- Different app concept (thumb-typing vs touch-typing)
- Different target audience
- Minimal code reuse
- Separate marketing strategy

**Decision**: Evaluate after Phase 2 success

---

## 14. Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| macOS market smaller than expected | Medium | Medium | Target schools and professionals |
| Input latency > 8ms | Medium | High | Extensive profiling, NSEvent optimization |
| Low user retention | Medium | High | A/B test onboarding, improve engagement |
| CloudKit sync issues | Low | High | Offline-first design, conflict resolution |
| Universal purchase complexity | Low | Medium | Careful architecture planning |

---

## 15. Platform Advantages Summary

### Why macOS Makes Sense

1. **Physical Keyboard Guarantee**: Every Mac has a physical keyboard
2. **Less Crowded Market**: More opportunity to stand out
3. **Higher Willingness to Pay**: $15-30 vs $3.99-5.99 on iOS
4. **Better Keyboard Handling**: No autocorrect interference
5. **Larger Screen**: Better visualization of hand positions
6. **Professional Users**: More serious about productivity

### Cross-Platform Strategy Benefits

1. **Universal Purchase**: Buy once, works on Mac and iPad
2. **iCloud Sync**: Practice continues seamlessly across devices
3. **One Codebase**: SwiftUI enables universal apps
4. **Wider Audience**: Schools with iPads + keyboards, professionals at home

### Competitive Positioning

| Feature | Most Competitors | TypeQuest |
|---------|-----------------|-----------|
| Gamification | Lesson-based | True RPG experience |
| Pricing | One-time purchase | Modern subscription |
| Social Features | Minimal | Multiplayer, leaderboards |
| Cross-Platform | Rare | Universal purchase + CloudKit |
| Design | Dated UI | Liquid Glass modern design |
| Offline-First | Cloud-dependent | Full offline functionality |

---

## Appendix A: Technical Specifications

### A.1 Data Model Schema

```
UserProfile
├── id: UUID
├── username: String
├── ageGroup: Enum (CHILD, TEEN, ADULT, SENIOR)
├── primaryLanguage: String
├── avatarId: UUID
├── currentLevel: Int
├── totalXP: Int
├── inkCurrency: Int
├── goldCurrency: Int
├── currentStreak: Int
├── longestStreak: Int
├── createdDate: Date
├── lastPracticeDate: Date
├── settings: UserSettings
└── progress: [LanguageProgress]

SessionData
├── id: UUID
├── timestamp: Date
├── duration: TimeInterval
├── wpm: Double
├── accuracy: Double
├── rawAccuracy: Double
├── correctedAccuracy: Double
├── totalCharacters: Int
├── uncorrectedErrors: Int
├── backspaceCount: Int
├── keyData: [KeyPerformance]
└── language: String
```

### A.2 Platform-Specific Code

**macOS Keyboard Handling**:
```swift
import Cocoa

class KeyboardManager {
    func setupKeyboardObservers() {
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyDown(event)
        }
    }
    
    private func handleKeyDown(_ event: NSEvent) {
        // Process keyboard input without autocorrect interference
        let keyCode = event.keyCode
        let characters = event.characters ?? ""
        let isARepeat = event.isARepeat
    }
}
```

---

## Document Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | January 2025 | Initial iOS-focused document |
| 1.2.0 | January 2025 | Added Liquid Glass UX Design Strategy |
| 2.0.0 | January 2025 | **Complete strategic pivot to macOS primary platform** |

---

*This feature specification document provides the comprehensive blueprint for TypeQuest development. The strategic pivot to macOS as the primary platform reflects extensive market research and competitive analysis. All sections should be reviewed and refined during the design phase with stakeholder input.*

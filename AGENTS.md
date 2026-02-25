# TypeQuest - Agent Guide

TypeQuest is a **macOS typing tutor application** built with SwiftUI and Swift 6.0. It uses a gamified, curriculum-based approach to teach touch typing across multiple keyboard layouts and languages.

## Project Overview

- **Platform**: macOS 14.0+
- **Language**: Swift 6.0
- **UI Framework**: SwiftUI
- **Architecture**: MVVM-S (Model-View-ViewModel-Service)
- **Project Management**: XcodeGen (generates `.xcodeproj` from `project.yml`)

## Build System

### Project Generation
This project uses **XcodeGen** to generate the Xcode project file. Do NOT commit `.xcodeproj` to git.

```bash
# Generate project
xcodegen generate

# Open in Xcode
open TypeQuest.xcodeproj
```

### Build Requirements
- macOS 14.0 or newer
- Xcode 16.0 or newer
- Swift 6.0 compiler
- SwiftLint (optional but recommended): `brew install swiftlint`

### Build Commands
```bash
# Build from command line
xcodebuild -scheme TypeQuest -destination 'platform=macOS,arch=arm64' build

# Run tests
xcodebuild -scheme TypeQuest -destination 'platform=macOS,arch=arm64' test
```

## Architecture

### MVVM-S Layers

```
View (SwiftUI)
  ↕️ @StateObject / @ObservedObject
ViewModel (@MainActor)
  ↕️
Service Layer (Singletons)
  ↕️
Model Layer (Codable/Hashable)
```

### Key Services
| Service | Purpose | Location |
|---------|---------|----------|
| `CurriculumService` | Lesson tree, exercise generation | `Services/Curriculum/` |
| `KeyboardManager` | Hardware keystroke interception | `Services/Keyboard/` |
| `DataManager` | Persistence (UserDefaults, files) | `Services/Persistence/` |
| `AudioManager` | Audio/haptic feedback | `Services/Audio/` |
| `TypingSessionController` | Session state management | `Services/Typing/` |
| `GameCenterManager` | Leaderboards, achievements | `Services/GameCenter/` |

### Data Flow Pattern
1. **Input**: `KeyboardManager` captures keystrokes
2. **Processing**: `TypingViewModel` updates state
3. **Metrics**: `MetricsCalculator` computes WPM/Accuracy
4. **UI**: View updates via `@Published` properties
5. **Persistence**: `DataManager` saves on completion

## Code Style & Conventions

### Swift Style
- **SwiftLint**: Enforced via pre-build script
- **Naming**: Swift-standard camelCase, PascalCase for types
- **Access Control**: Explicit `public`/`internal`/`private`
- **Actors**: Services marked with `@MainActor` where UI-bound

### Example Patterns

**ViewModel Pattern:**
```swift
@MainActor
class TypingViewModel: ObservableObject {
    @Published var typedText: String = ""
    @Published var metrics: TypingMetrics = .zero
    
    private let keyboardManager = KeyboardManager.shared
    private let dataManager = DataManager.shared
    
    func startSession() { ... }
}
```

**Service Singleton:**
```swift
@MainActor
class AudioManager: ObservableObject {
    static let shared = AudioManager()
    private init() { ... }
}
```

**Model with Codable:**
```swift
public struct Lesson: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    // ...
}
```

## Design System

### Colors
| Token | Hex | Usage |
|-------|-----|-------|
| Indigo Primary | `#6366F1` | Primary actions, buttons |
| Cyan Accent | `#06B6D4` | Highlights, progress |
| Canvas (Dark) | `#0F172A` | Main background |
| Surface (Dark) | `#1E293B` | Cards, panels |
| Success | `#10B981` | Correct keys, passed |
| Error | `#EF4444` | Typos, failed |

### Custom Modifiers
```swift
// Glass card effect
.glassCard(cornerRadius: 16)

// Breathing animation
.breathing()

// Spring transitions
.spring(response: 0.5, dampingFraction: 0.7)
```

### Typography
- **Monospaced**: Typing area, metrics display
- **Rounded**: Headers, primary buttons

## Audio System

The app uses a comprehensive audio library generated via MiniMax Music 2.5.

### Audio Categories
| Category | Location | Purpose |
|----------|----------|---------|
| Flow State | `Resources/Audio/Music/flow_state/` | Background music (3 intensity levels) |
| Achievements | `Resources/Audio/Music/achievements/` | Success, level up, streaks |
| UI Sounds | `Resources/Audio/ui/sounds/` | Clicks, errors, ticks |

### Generation Scripts
Located in project root:
- `generate-music.js` - MiniMax Music API for background/achievement music
- `generate-tts.js` - Text-to-speech for instructional audio
- `generate-single.js` - Single audio file generation

Usage:
```bash
export MINIMAX_MUSIC_API_KEY="sk-api-..."
node generate-music.js --all
```

## Curriculum System

### 6-Stage Pedagogical Structure
1. **Foundation** - Home row, basic posture
2. **Expansion** - Top/bottom rows
3. **Words** - Common words, n-grams
4. **Sentences** - Punctuation, capitalization
5. **Mastery** - Numbers, symbols
6. **Specialization** - Advanced layouts, languages

### Key Models
- `Stage`: Container for modules
- `Module`: Thematic group of lessons
- `Lesson`: Individual exercise with requirements
- `Exercise`: Typed content with target metrics

### Progression Gates
Lessons can be `isGatekeeper: true` requiring:
- Minimum accuracy threshold
- Minimum WPM threshold
- Stage test completion

## Testing

### Test Structure
- **Unit Tests**: `TypeQuestTests/` directory
- **Focus Areas**: `MetricsCalculatorTests`, `CurriculumTests`

### Running Tests
```bash
# In Xcode
Cmd + U

# Command line
xcodebuild -scheme TypeQuest test
```

## Common Tasks

### Adding a New Language
1. Add keyboard layout in `Models/Core/KeyboardLayout.swift`
2. Create language model in `Services/Curriculum/LanguageModel.swift`
3. Add word frequency data
4. Generate TTS audio via `generate-tts.js`

### Adding a New View
1. Create View in `Views/[Category]/`
2. Create ViewModel in `ViewModels/[Category]/`
3. Add navigation case in `NavigationManager`
4. Update `ContentView` routing

### Adding Audio Assets
1. Run appropriate generation script
2. Output to correct `Resources/Audio/` subdirectory
3. Reference via `AudioManager` with `.playback` category

## File Organization

```
TypeQuest/
├── App/                    # App entry, lifecycle
├── Models/                 # Data structures
│   ├── Core/              # Keyboard layouts, fundamentals
│   ├── Curriculum/        # Lesson, Module, Stage
│   ├── Progress/          # Performance, Session data
│   ├── Shop/              # Shop items
│   ├── Typing/            # Typing models, posture
│   └── User/              # UserProfile, Settings
├── Services/              # Business logic
│   ├── Analytics/         # Metrics, tracking
│   ├── Audio/             # Audio playback
│   ├── Cloud/             # CloudKit sync
│   ├── Content/           # Text providers
│   ├── Curriculum/        # Lesson generation
│   ├── GameCenter/        # Leaderboards
│   ├── Gamification/      # XP, progress
│   ├── Keyboard/          # Input handling
│   ├── Navigation/        # Routing
│   ├── Persistence/       # Data storage
│   ├── Store/             # IAP
│   ├── Theme/             # Styling
│   └── Typing/            # Session control
├── ViewModels/            # View state
├── Views/                 # SwiftUI UI
├── Resources/             # Assets, audio
└── Utilities/             # Extensions, helpers
```

## Documentation

Additional documentation in `Documentation/`:
- `Architecture.md` - Detailed architecture
- `Curriculum.md` - Pedagogical structure
- `Gamification.md` - XP, currency, engagement
- `Audio.md` - Audio system details
- `Styling.md` - Design system
- `Accessibility.md` - Inclusive design
- `API.md` - Data models reference

## Git Workflow

1. Create feature branch from `master`
2. Ensure SwiftLint passes
3. Use descriptive commit messages
4. Verify build succeeds before pushing
5. Do NOT commit `.xcodeproj` (it is generated)

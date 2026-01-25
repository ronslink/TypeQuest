# Architecture Overview

TypeQuest is built using a modern **MVVM-S** architecture (Model-View-ViewModel-Service) to ensure separation of concerns and testability.

## 🧱 Layers

### 1. View Layer (SwiftUI)
- Uses declarative syntax for the UI.
- Observes ViewModels via `@StateObject` or `@ObservedObject`.
- Minimal logic; primarily handles event delegation to ViewModels.

### 2. ViewModel Layer (@MainActor)
- Orchestrates the state for specific screens.
- Communicates with Services to fetch data or perform actions.
- Handles user input logic (e.g., `TypingViewModel` processing keystrokes).

### 3. Service Layer (Singletons/Dependency Injection)
- **`CurriculumService`**: Manages the lesson tree and lesson generation.
- **`KeyboardManager`**: Intercepts hardware keystrokes and provides a unified event stream.
- **`DataManager`**: Handles persistence via UserDefaults and file storage.
- **`AudioManager`**: Manages haptic/audio feedback.

### 4. Model Layer (Codable/Hashable)
- Pure data structures.
- Logic is limited to self-contained transformations (e.g., `LessonDifficulty.xpMultiplier`).

## 📡 Data Flow

1. **User Input**: `KeyboardManager` captures a key.
2. **ViewModel**: `TypingViewModel` receives the key and updates `typedText`.
3. **Logic**: `MetricsCalculator` computes WPM/Accuracy updates.
4. **UI**: View updates instantly via `@Published` properties.
5. **Persistence**: Upon lesson completion, `DataManager` saves the performance record.

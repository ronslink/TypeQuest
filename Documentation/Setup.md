# Developer Setup

This guide will help you get TypeQuest running on your local machine for development and testing.

## 📋 Requirements
- **macOS**: 14.0 or newer.
- **Xcode**: 16.0 or newer.
- **Swift**: 6.0 compiler.

## 🚀 Getting Started

### 1. Project Generation
TypeQuest uses **XcodeGen** to manage project files and avoid `.xcodeproj` merge conflicts.

If you have XcodeGen installed:
```bash
xcodegen generate
```
*(Note: If the project files are already present and you don't have XcodeGen, you can proceed by opening `TypeQuest.xcodeproj` directly.)*

### 2. Dependencies
- **SwiftLint**: Used to enforce code style. If installed, it runs automatically during the build process.
  ```bash
  brew install swiftlint
  ```

### 3. Build & Run
1. Open `TypeQuest.xcodeproj`.
2. Select the `TypeQuest` scheme.
3. Choose **My Mac** or a macOS simulator as the destination.
4. Press `Cmd + R` to build and run.

## 🧪 Testing

### Unit Tests
Run the `TypeQuestTests` scheme (`Cmd + U`).
Focus areas:
- `MetricsCalculatorTests`: Validates WPM/Accuracy math.
- `CurriculumTests`: Validates lesson tree generation.

## 🤝 Contribution Workflow

1. **Branching**: Create a feature branch from `master`.
2. **Linting**: Ensure `SwiftLint` passes without errors.
3. **Commit**: Use descriptive commit messages.
4. **Push**: Ensure the build succeeds via `xcodebuild` before pushing.

```bash
xcodebuild -scheme TypeQuest -destination 'platform=macOS,arch=arm64' build
```

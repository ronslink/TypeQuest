# API & Data Models

This document outlines the core data structures used in TypeQuest for curriculum management and user persistence.

## 🎓 Lesson Model (`Lesson.swift`)

The `Lesson` struct is the fundamental unit of the curriculum.

### Schema
- **`id`**: Unique string identifier (e.g., `s1_m1_l1`).
- **`name`**: Display name of the lesson.
- **`difficulty`**: Enum (`beginner`, `elementary`, `intermediate`, `advanced`, `expert`).
- **`requiredKeys`**: Array of `AbstractKey` enums required for this lesson.
- **`passingRequirements`**:
  - `minAccuracy`: Minimum percentage (e.g., `95.0`).
  - `minWPM`: Minimum speed (e.g., `20.0`).

### AbstractKey Alignment
Keys are mapped via `LayoutAdapter` to physical positions. 
Examples: `.homeLeftPinky` -> `a`, `.homeRightIndex` -> `j`.

---

## 👤 User Profile (`UserProfile.swift`)

Stored using **SwiftData** for persistent user progress.

### Schema
- **`username`**: User's chosen display name.
- **`ageGroup`**: Enum (`child`, `adult`, `senior`) - Drives UI adaptation (e.g., text size, narrative).
- **`currentLevel`**: Calculated based on `totalXP`.
- **`inkCurrency`**: In-game currency for the Shop.
- **`currentStreak`**: Consecutive days practiced.
- **`layout`**: The active `KeyboardLayout` (e.g., `.qwerty`, `.dvorak`, `.azerty`).

---

## 📊 Key Performance (`KeyPerformance.swift`)

Used for adaptive training to track letter-specific metrics.

### Fields
- **`key`**: The specific character (e.g., "z").
- **`errorCount`**: Number of misses.
- **`avgLatency`**: Speed of the key press in seconds.
- **`struggleScore`**: Weighted score used by the `ExerciseGenerator` to prioritize remedial drills.

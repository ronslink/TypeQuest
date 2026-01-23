# UI Specifications: Onboarding & First Run

**Theme**: Light / Welcoming
**Goal**: Get the user typing in < 30 seconds.

## 1. Screen: The Welcome Portal
*   **Visual**:
    *   **Background**: Clean Cream (`#F9F9F7`) with a subtle, slow-moving golden "Aurora" mesh gradient in the background.
    *   **Hero**: Large 3D Glass Typography "TypeQuest" floating in center.
*   **Action**:
    *   **Primary Button**: "Begin Journey" (Pill, Quest Gold) pulses slowly.
    *   **Secondary**: "I have an account" (Text link).

## 2. Screen: Hardware Check (The "Handshake")
Before asking for names, we validate the hardware.
*   **Interaction**:
    *   Text appears: "Press [Space] to sync your neural link."
    *   User presses Space.
    *   **Feedback**: A generic mechanical switch sound plays (clack!), and screen ripples.
    *   *macOS*: Detects Keyboard ID.
    *   *iPad*: Detects Magic Keyboard / External / On-screen.
*   **Success**: "Hardware Detected: Magic Keyboard. Excellent."

## 3. Screen: Choose Your Hero (Persona Selection)
*   **Layout**: Horizontal carousel of 3 Cards (Glass Material).
*   **Cards**:
    1.  **Robot 'Bit'**: "I want precision & coding skills." (Icon: Pixelated Bot Face)
    2.  **Wizard 'Spell'**: "I want flow state & speed." (Icon: Wand with Sparkles)
    3.  **Cat 'Glitch'**: "I want to have fun!" (Icon: Paw Print)
*   **Selection**:
    *   Tapping a card expands it slightly.
    *   Background gradient shifts color faintly (Blue for Robot, Purple for Wizard, Orange for Cat).

## 4. Screen: The Calibration (Placement Test)
*   **Context**: "Let's see what you can do. Type this ghost sentence."
*   **UI**:
    *   Minimal interface. No chrome.
    *   Text: "The quick brown fox..." (Standard pangram).
    *   **Visuals**: Letters light up Green (Success) or fade Red (Error).
*   **Result**: Displays "Starting WPM". Suggests a difficulty level.

## 5. Screen: Account & Permissions
*   **Privacy First**:
    *   "Enable Notifications for Daily Quests?" (System Prompt)
    *   "Sync with iCloud?"
*   **Sign Up**: "Save your progress" (Apple Sign In).
*   **Transition**: Morph into **Dashboard**.

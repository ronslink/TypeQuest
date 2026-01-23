# Audio Strategy: Flow, Feedback & Immersion

## 1. Core Philosophy: The Audio Spectrum
The audio experience must balance **Information** (feedback on typing) with **Immersion** (flow state music). It is not "one size fits all"; it adapts to the Lesson Mode and User Persona.

### 1.1 The Two Channels
*   **Channel A: Tactile Feedback (The "Click")**: High-priority, zero-latency sounds that confirm input.
*   **Channel B: Environmental Ambience (The "Zone")**: Low-priority background music to induce flow state.

## 2. Mechanical Switch Simulation (The "Click")
Since iPad keyboards (Magic Keyboard, Smart Folio) have shallow travel and quiet membrane switches, the app will simulate the auditory satisfaction of high-end mechanical keyboards to improve rhythm and typing feel.

### Sound Profiles
*   **Blue Switch (Clicky)**: High-pitched, crisp click. Best for: *Gamers, Kids, High-Accuracy Drills*.
*   **Brown Switch (Tactile)**: Softer bump sound. Best for: *Office Mode, Longform Typing*.
*   **Red Switch (Linear)**: Smooth clack. Best for: *Speed Tests*.
*   **Typewriter**: Vintage bell and carriage return sounds. Best for: *Seniors, Nostalgia Mode*.
*   **Sci-Fi UI**: Blips and beeps. Best for: *Kids "Space" Theme*.

## 3. Persona-Based Soundscapes

### 3.1 Leo (The Student)
*   **Music**: Upbeat "Kart Racing" style tracks for games; "Spy Movie" tension for challenges.
*   **SFX**: Cartoonish "Boing" on errors (low stress), satisfying "Ding" on streaks.
*   **Voiceover**: Enthusiastic robot or pilot character giving encouragement ("Shields charging!").

### 3.2 Sarah (The Professional)
*   **Music**: Generative Lo-Fi Hip Hop / Ambient Electronica. Tempo syncs with typing speed (subtly increases as WPM rises).
*   **SFX**: Subtle "Thock" sounds (premium mechanical keyboard). Errors are a dull "Thud" rather than a jarring buzzer.
*   **Voiceover**: Minimal. Only for milestone announcements ("New High Score").

### 3.3 Arthur (The Senior)
*   **Music**: Classical Piano or Nature Sounds (Rain, Creek).
*   **SFX**: Clear, distinct typewriter sounds.
*   **Accessibility**:
    *   **Spoken Keys**: Option to read aloud every letter typed.
    *   **Spoken Words**: Read aloud completed words.
    *   **Audio Ducking**: Music volume lowers automatically when voiceover speaks.

## 4. Technical Implementation

### 4.1 Audio Engine
*   **Framework**: `AVAudioEngine` for real-time mixing.
*   **Latency**: Must use strictly low-latency buffers (aiming for <20ms) for key presses to feel responsive.
*   **Spatial Audio**: Use stereo panning for on-screen typing (keys on left sound slightly left).

### 4.2 Accessibility & Settings
*   **Granular Control**: Separate sliders for Music, SFX, and Voice.
*   **Haptics Sync**: Haptic engine on iPhone (and supported iPads) syncs with the audio "click" for physical sensation.

# TypeQuest Sound Library - Complete Guide

## Overview

This library contains all audio assets for TypeQuest, generated using **MiniMax Music 2.5** and TTS providers.

---

## Part 1: Generated Music (MiniMax Music 2.5)

### Flow State Music (3 Levels)

MiniMax 2.5 structural tags used: `[Intro]`, `[Verse]`, `[Pre-Chorus]`, `[Chorus]`, `[Bridge]`, `[Build-up]`, `[Break]`, `[Outro]`

| Level | BPM | Description | Structure |
|-------|-----|-------------|-----------|
| Flow 1 | 70 | Ambient piano + rainfall | [Inst] → [Break] → [Inst] → [Outro] |
| Flow 2 | 80 | Lo-fi beats + vinyl | [Intro] → [Verse] → [Pre-Chorus] → [Chorus] → [Break] → [Outro] |
| Flow 3 | 90 | Full orchestration | [Intro] → [Verse] → [Pre-Chorus] → [Chorus] → [Bridge] → [Build-up] → [Chorus] → [Outro] |

### Achievement Sounds (6 Sounds)

| Sound | Structure | Description |
|-------|-----------|-------------|
| success_chord | [Intro] → [Chorus] → [Outro] | Major key triumph |
| level_up | [Intro] → [Build-up] → [Chorus] → [Outro] | Ascending fanfare |
| streak_milestone | [Intro] → [Verse] → [Chorus] → [Break] → [Outro] | Building celebration |
| perfect_round | [Intro] → [Chorus] → [Outro] | Crystalline sparkle |
| legendary_achievement | [Intro] → [Verse] → [Chorus] → [Bridge] → [Chorus] → [Outro] | Epic fanfare |
| high_score | [Intro] → [Chorus] → [Outro] | Excited celebration |

### UI Sounds (6 Sounds)

| Sound | Structure | Description |
|-------|-----------|-------------|
| menu_hover | [Inst] | Soft tick, 0.3s |
| menu_select | [Inst] | Confirming click, 0.4s |
| error_muted | [Inst] | Low muted tone, 0.5s |
| countdown_tick | [Inst] | Sharp tick, 0.2s |
| lesson_complete | [Intro] → [Chorus] → [Outro] | Positive fanfare, 2s |
| wpm_target_reached | [Intro] → [Chorus] → [Outro] | Encouraging ping, 1.5s |

---

## Part 2: Mechanical Switch Sounds (Not Generated)

These need to be sourced or recorded:

| Switch Type | Characteristics | File |
|-------------|----------------|------|
| Cherry MX Blue | High-pitched, clicky, tactile | `keypress/blue.mp3` |
| Cherry MX Red | Soft, linear, quiet | `keypress/red.mp3` |
| Cherry MX Brown | Balanced bump, tactile | `keypress/brown.mp3` |
| IBM Model M | Heavy, metallic clack | `keypress/retro.mp3` |
| Correct Key | Crisp transient | `feedback/correct.mp3` |
| Error Key | Low, muted thud | `feedback/error.mp3` |

**Sources:**
- [Keyboard Shop Sounds](https://example.com) (free samples)
- [MK\_Cute Keycap Sounds](https://openclipart.org) (Creative Commons)
- Record with Zoom H1n recorder

---

## Part 3: Voice Announcements (TTS)

See `typequest-tts-prompts.md` for all 17 languages.

### English Voice Samples

| Sound | Text | Duration |
|-------|------|----------|
| welcome | "Welcome to TypeQuest!" | ~1.5s |
| countdown | "Three, two, one, GO!" | ~2s |
| encouragement | "Great job! Keep going!" | ~2s |
| streak5 | "You're on a roll!" | ~1.5s |
| streak10 | "Legendary skills!" | ~1.5s |
| highscore | "New high score!" | ~1.5s |
| lessonComplete | "Lesson complete!" | ~1.5s |
| perfect | "Perfect!" | ~0.8s |
| timeWarning | "Almost there!" | ~1s |
| chapterComplete | "Chapter complete!" | ~1.5s |

---

## Directory Structure

```
TypeQuest/TypeQuest/Resources/Audio/
├── Music/
│   ├── flow_state/
│   │   ├── flow_level_1.mp3
│   │   ├── flow_level_2.mp3
│   │   └── flow_level_3.mp3
│   └── achievements/
│       ├── success_chord.mp3
│       ├── level_up.mp3
│       ├── streak_milestone.mp3
│       ├── perfect_round.mp3
│       ├── legendary_achievement.mp3
│       └── high_score.mp3
├── Voice/
│   ├── en/ (10 sounds)
│   ├── es/ (10 sounds)
│   ├── fr/ (10 sounds)
│   └── ... (all 17 languages)
├── UI/
│   ├── keypress/
│   │   ├── blue.mp3
│   │   ├── red.mp3
│   │   ├── brown.mp3
│   │   └── retro.mp3
│   ├── feedback/
│   │   ├── correct.mp3
│   │   └── error.mp3
│   └── sounds/
│       ├── menu_hover.mp3
│       ├── menu_select.mp3
│       ├── error_muted.mp3
│       ├── countdown_tick.mp3
│       ├── lesson_complete.mp3
│       └── wpm_target_reached.mp3
```

---

## Generation Commands

### Music (MiniMax)

```bash
export MINIMAX_API_KEY="sk-..."
cd TypeQuest
node generate-music.js --all      # All categories
node generate-music.js flow       # Flow music only
node generate-music.js achievements  # Achievement sounds
node generate-music.js ui         # UI sounds only
```

### Voice (ElevenLabs)

```bash
export ELEVENLABS_API_KEY="your-key"
node generate-tts.js --all       # All languages
node generate-tts.js en          # English only
node generate-tts.js es          # Spanish only
```

---

## Swift Integration

```swift
import AVFoundation

enum AudioCategory {
    case flow(Int level)
    case achievement(AchievementType)
    case ui(UISound)
    case voice(String language, String sound)
    
    enum AchievementType {
        case success, levelUp, streak, perfect, legendary, highScore
    }
    
    enum UISound {
        case hover, select, error, countdown, lessonComplete, wpmTarget
    }
}

class AudioManager {
    static let shared = AudioManager()
    private var players: [String: AVAudioPlayer] = [:]
    
    func preload() {
        let categories = ["flow", "achievements", "ui", "voice/en"]
        for category in categories {
            let dir = Bundle.main.url(forResource: category, withExtension: nil)!
            if let files = try? FileManager.default.contentsOfDirectory(at: dir, 
                                                                        includingPropertiesForKeys: nil) {
                for file in files {
                    let name = file.deletingPathExtension().lastPathComponent
                    if let player = try? AVAudioPlayer(contentsOf: file) {
                        players[name] = player
                    }
                }
            }
        }
    }
    
    func play(category: AudioCategory) {
        let soundName: String
        switch category {
        case .flow(let level):
            soundName = "flow_level_\(min(level, 3))"
        case .achievement(let type):
            switch type {
            case .success: soundName = "success_chord"
            case .levelUp: soundName = "level_up"
            case .streak: soundName = "streak_milestone"
            case .perfect: soundName = "perfect_round"
            case .legendary: soundName = "legendary_achievement"
            case .highScore: soundName = "high_score"
            }
        case .ui(let type):
            switch type {
            case .hover: soundName = "menu_hover"
            case .select: soundName = "menu_select"
            case .error: soundName = "error_muted"
            case .countdown: soundName = "countdown_tick"
            case .lessonComplete: soundName = "lesson_complete"
            case .wpmTarget: soundName = "wpm_target_reached"
            }
        case .voice(let lang, let sound):
            soundName = "\(lang)/\(sound)"
        }
        
        players[soundName]?.play()
    }
}
```

---

## Audio Specifications

| Setting | Value |
|---------|-------|
| Format | MP3, 192kbps |
| Sample Rate | 44.1 kHz |
| Flow Music | 70-90 BPM |
| UI Sounds | 0.2-0.5s |
| Voice | Normalized -16 LUFS |

---

## Next Steps

- [ ] Generate music: `node generate-music.js --all`
- [ ] Add ElevenLabs API key for TTS
- [ ] Source mechanical switch sounds
- [ ] Integrate with Xcode project
- [ ] Test audio balance
- [ ] Optimize for performance

---

Generated: 2026-02-06
MiniMax Music 2.5: 14 structural tags, 100+ instruments

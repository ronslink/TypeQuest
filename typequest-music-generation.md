# TypeQuest Sound Library - Generated with MiniMax Music 2.5

## MiniMax Music 2.5 Features

**14 Structural Tags Used:**
- `[Intro]` - Opening section
- `[Verse]` - Main lyrical/content section
- `[Pre-Chorus]` - Build before chorus
- `[Chorus]` - Main hook section
- `[Bridge]` - Contrast section
- `[Build-up]` - Intensity increase
- `[Break]` - Dynamic drop
- `[Interlude]` - Transition section
- `[Hook]` - Catchy refrain
- `[Transition]` - Section bridge
- `[Solo]` - Instrumental spotlight
- `[Inst]` - Instrumental
- `[Outro]` - Closing section
- `[Post-Chorus]` - After chorus

**100+ Instruments:** Piano, synth, strings, brass, percussion, and more

**Auto-adaptive Mixing:** Lo-Fi, ambient, orchestral styles automatically mixed

## Generation Commands

```bash
# Set MiniMax API key
export MINIMAX_API_KEY="sk-..."

# Generate all music
cd TypeQuest
node generate-music.js --all

# Generate specific categories
node generate-music.js flow      # Flow state music
node generate-music.js achievements  # Achievement sounds
node generate-music.js ui         # UI sounds
```

## Generated Audio Files

### 1. Flow State Music (Lo-Fi)

| File | Description | Tags Used |
|------|-------------|-----------|
| `flow/level_1.mp3` | Level 1 - Basic ambient | [Inst], [Break], [Outro] |
| `flow/level_2.mp3` | Level 2 - Adds rhythm | [Intro], [Verse], [Pre-Chorus], [Chorus], [Break], [Outro] |
| `flow/level_3.mp3` | Level 3 - Full intensity | [Intro], [Verse], [Pre-Chorus], [Chorus], [Bridge], [Build-up], [Outro] |

**Music Prompts:**
- Level 1: Lo-fi ambient, 70 BPM, soft piano, rainfall
- Level 2: Lo-fi hip hop, 80 BPM, warm vinyl texture
- Level 3: Lo-fi pop, 90 BPM, rich orchestration

### 2. Achievement Sounds

| File | Description | Duration |
|------|-------------|----------|
| `achievements/success_chord.mp3` | Session success | ~2s |
| `achievements/level_up.mp3` | Level up fanfare | ~3s |
| `achievements/streak_milestone.mp3` | Streak celebration | ~4s |
| `achievements/perfect_round.mp3` | Perfect score | ~2s |
| `achievements/high_score.mp3` | High score | ~3s |

### 3. UI Sounds

| File | Description | Duration |
|------|-------------|----------|
| `ui/menu_hover.mp3` | Soft tick | 0.3s |
| `ui/error_muted.mp3` | Error tone | 0.5s |
| `ui/wpm_target_reached.mp3` | Target reached | 1.5s |

## Voice Announcements (TTS)

Voice announcements require ElevenLabs or Edge TTS (see `typequest-tts-prompts.md`)

### English Voice Prompts

| Sound | Text |
|-------|------|
| `Voice/en/welcome.mp3` | Welcome to TypeQuest! |
| `Voice/en/countdown.mp3` | Three, two, one, GO! |
| `Voice/en/encouragement.mp3` | Great job! Keep going! |
| `Voice/en/streak5.mp3` | You're on a roll! |
| `Voice/en/streak10.mp3` | Legendary skills! |
| `Voice/en/highscore.mp3` | New high score! |
| `Voice/en/lessonComplete.mp3` | Lesson complete! |
| `Voice/en/perfect.mp3` | Perfect! |
| `Voice/en/timeWarning.mp3` | Almost there! |
| `Voice/en/chapterComplete.mp3` | Chapter complete! |

## Mechanical Switch Sounds

These need to be sourced or recorded (not generated):

| File | Description |
|------|-------------|
| `ui/keypress/blue.mp3` | Cherry MX Blue - Clicky |
| `ui/keypress/red.mp3` | Cherry MX Red - Linear |
| `ui/keypress/brown.mp3` | Cherry MX Brown - Tactile |
| `ui/keypress/retro.mp3` | IBM Model M - Mechanical |
| `ui/feedback/correct.mp3` | Crisp key confirm |
| `ui/feedback/error.mp3` | Muted error tone |

## Directory Structure

```
TypeQuest/TypeQuest/Resources/Audio/
├── flow/
│   ├── level_1.mp3
│   ├── level_2.mp3
│   └── level_3.mp3
├── achievements/
│   ├── high_score.mp3
│   ├── level_up.mp3
│   ├── perfect_round.mp3
│   ├── streak_milestone.mp3
│   └── success_chord.mp3
├── ui/
│   ├── error_muted.mp3
│   ├── menu_hover.mp3
│   └── wpm_target_reached.mp3
```

## Integration

### Swift Integration

```swift
import AVFoundation

enum AudioCategory {
    case flow(Int streakLevel)
    case achievement(String type)
    case ui(String sound)
}

class AudioManager {
    static let shared = AudioManager()

    func play(category: AudioCategory) {
        switch category {
        case .flow(let level):
            let file = "level_\(min(level, 3))"
            playAudio(file)
        case .achievement(let type):
            playAudio(type)
        case .ui(let sound):
            playAudio(sound)
        }
    }

    private func playAudio(_ name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        let player = AVPlayer(url: url)
        player.play()
    }
}
```

## Next Steps

1. [ ] Generate music with MiniMax: `node generate-music.js --all`
2. [ ] Add ElevenLabs API key for TTS: `ELEVENLABS_API_KEY=... node generate-tts.js --all`
3. [ ] Source/record mechanical keyboard sounds
4. [ ] Integrate with Xcode project
5. [ ] Test audio levels and balance

---

Generated: 2026-02-06
Generated with: MiniMax Music 2.5

# TypeQuest Sound Library - Language Support

## Supported Languages (17)

| Language | Code | Region | TTS Voice |
|----------|------|-------|-----------|
| English | en | US/UK | en-US-* |
| Spanish | es | ES/MX | es-ES-* |
| French | fr | FR | fr-FR-* |
| German | de | DE | de-DE-* |
| Dutch | nl | NL | nl-NL-* |
| Italian | it | IT | it-IT-* |
| Polish | pl | PL | pl-PL-* |
| Czech | cs | CZ | cs-CZ-* |
| Hungarian | hu | HU | hu-HU-* |
| Swedish | sv | SE | sv-SE-* |
| Norwegian | no | NO | no-NO-* |
| Danish | da | DK | da-DK-* |
| Finnish | fi | FI | fi-FI-* |
| Greek | el | GR | el-GR-* |
| Hindi | hi | IN | hi-IN-* |
| Malay | ms | MY | ms-MY-* |
| Tagalog | tl | PH | tl-PH-* |

## Sound Categories by Language

### 1. Voice Announcements (TTS Required)

| Sound | Trigger | EN | ES | FR | DE | Other Languages |
|-------|---------|----|----|----|----|----------------|
| Welcome | App launch | "Welcome to TypeQuest" | "Bienvenido a TypeQuest" | "Bienvenue dans TypeQuest" | "Willkommen bei TypeQuest" | Translate each |
| Countdown | Lesson start | "3, 2, 1, GO!" | Same pattern | Same pattern | Same pattern | Same pattern |
| Encouragement | 50% progress | "Great job!" | "Buen trabajo" | "Bon travail" | "Toll gemacht" | Localized |
| Streak milestone | Every 5 lessons | "You're on a roll!" | Localized | Localized | Localized | Localized |
| High score | New record | "New high score!" | Localized | Localized | Localized | Localized |
| Lesson complete | Success | "Lesson complete!" | Localized | Localized | Localized | Localized |
| Chapter complete | Story mode | "Chapter complete" | Localized | Localized | Localized | Localized |
| Time warning | 10s remaining | "Almost there!" | Localized | Localized | Localized | Localized |
| Perfect round | 100% accuracy | "Perfect!" | "Perfecto" | "Parfait" | "Perfekt" | Localized |
| Legendary | Streak 10+ | "Legendary skills!" | Localized | Localized | Localized | Localized |

### 2. UI Sounds (Language-Independent)

These don't need translations:

| Sound | Description | Format |
|-------|-------------|--------|
| Key click (Blue) | Tactile MX Blue | MP3 |
| Key click (Red) | Linear MX Red | MP3 |
| Key click (Brown) | Tactile MX Brown | MP3 |
| Key click (Retro) | IBM Model M style | MP3 |
| Correct key | Crisp transient | MP3 |
| Error key | Muted low-freq | MP3 |
| Success chord | Harmonic progression | MP3 |
| Fail resolve | Dissonant, muted | MP3 |
| Posture alert | Subtle ping | MP3 |
| WPM target ping | Gentle notification | MP3 |
| Menu hover | Soft tick | MP3 |
| Menu select | Confirming click | MP3 |
| Achievement unlock | Celebratory chime | MP3 |
| Level up | Ascending notes | MP3 |
| Streak milestone | Building intensity | MP3 |

### 3. Story Mode Narration (Language-Dependent)

Story Mode needs full voice acting per language:

| Chapter | EN Voice | ES Voice | FR Voice | Other Voices |
|---------|----------|----------|----------|--------------|
| Chapter 1 | English narrator | Spanish narrator | French narrator | Localized |
| Chapter 2 | English narrator | Spanish narrator | French narrator | Localized |
| ... | ... | ... | ... | ... |

**Note:** Story narration is complex - consider:
- Professional voice actors per language
- Consistent character voices across chapters
- Emotional range (encouraging, celebratory, patient)

## Implementation Strategy

### Phase 1: Core Sounds (Language-Independent)
- [ ] Mechanical switch sounds (4 variants)
- [ ] UI feedback sounds (10+ sounds)
- [ ] Achievement sounds (5+ sounds)

### Phase 2: Priority Translations (TTS)
Start with top 5 languages by user base:
1. English (primary)
2. Spanish (2nd largest)
3. French
4. German
5. Dutch or Italian

### Phase 3: Extended Support
- Polish, Czech, Hungarian
- Nordic languages (Swedish, Norwegian, Danish, Finnish)
- Greek
- Hindi, Malay, Tagalog

## TTS Generation (MiniMax)

For generated voiceovers:

```bash
# English (default)
tts --voice "en-US" --text "Welcome to TypeQuest" --output welcome_en.mp3

# Spanish
tts --voice "es-ES" --text "Bienvenido a TypeQuest" --output welcome_es.mp3

# French
tts --voice "fr-FR" --text "Bienvenue dans TypeQuest" --output welcome_fr.mp3
```

### Recommended TTS Settings

| Parameter | Value | Notes |
|-----------|-------|-------|
| Voice | Native speaker | Natural accent |
| Speed | 1.0x | Normal pace |
| Pitch | Neutral | Not too high/low |
| Emotions | Encouraging | Warm, friendly tone |

## Directory Structure

```
TypeQuest/Resources/Audio/
├── UI/
│   ├── keypress/
│   │   ├── blue.mp3
│   │   ├── red.mp3
│   │   ├── brown.mp3
│   │   └── retro.mp3
│   ├── feedback/
│   │   ├── correct.mp3
│   │   ├── error.mp3
│   │   ├── success.mp3
│   │   └── fail.mp3
│   └── navigation/
│       ├── hover.mp3
│       └── select.mp3
├── Voice/
│   ├── en/
│   │   ├── welcome.mp3
│   │   ├── countdown.mp3
│   │   ├── encouragement.mp3
│   │   ├── streak_5.mp3
│   │   ├── streak_10.mp3
│   │   ├── highscore.mp3
│   │   ├── lesson_complete.mp3
│   │   ├── perfect.mp3
│   │   └── legendary.mp3
│   ├── es/
│   │   └── (same structure)
│   ├── fr/
│   │   └── (same structure)
│   └── ... (other languages)
└── Music/
    ├── flow_state/
    │   ├── level_1.mp3
    │   ├── level_2.mp3
    │   └── level_3.mp3
    └── achievements/
        ├── level_up.mp3
        └── streak_milestone.mp3
```

## Next Steps

1. **Audit current audio files** in `TypeQuest/Resources/Audio/`
2. **Create missing directories** for language structure
3. **Generate TTS placeholders** for priority languages (EN, ES, FR, DE)
4. **Source/produce mechanical switch sounds** (free assets or record)
5. **Contract voice actors** for story mode (Phase 3)

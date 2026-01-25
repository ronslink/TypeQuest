# Curriculum & Pedagogy

TypeQuest uses a systematic approach to touch typing mastery, moving from biomechanical fundamentals to fluid sentence production.

## 🎓 The 6 Stages

| Stage | Name | Focus |
| :--- | :--- | :--- |
| **1** | Home Row | Anchoring fingers on ASDF JKL;. |
| **2** | Column Mastery | Vertically moving fingers within dedicated columns. |
| **3** | N-Grams | Common letter combinations (th, he, ing). |
| **4** | Lexical | High-frequency words and basic vocabulary. |
| **5** | Sentential | Fluidity and rhythm in complete sentences. |
| **6** | Symbology | Numbers, symbols, and basic code patterns. |

## 🛠 Exercise Generation

Exercises are generated dynamically based on the lesson's `requiredKeys`:

1. **Anchor Exercises**: Repetitive patterns to build muscle memory for specific keys.
2. **Column Exercises**: Drills for vertical finger movement.
3. **Word Exercises**: Real-word practice using only known keys (filtered via `LanguageModel`).
4. **Sentence Exercises**: Contextual practice with varied sentence structures.

## ✅ Passing Requirements

Each lesson has a `PassingRequirements` object:
- `minWPM`: Minimum words per minute.
- `minAccuracy`: Minimum percentage (usually 95%+ for regular lessons, 98% for Masteries).

If a user fails, the system offers a **Remedial Lesson** which is a 50% shorter version of the content to help rebuild confidence.

## 🌐 Global Support

TypeQuest is globally distributed, supporting **17 languages** and their regional keyboard standards:
- **Major EU**: English, Spanish, French, German, Dutch, Italian.
- **Eastern Europe**: Polish, Czech, Hungarian (QWERTZ support).
- **Nordic**: Swedish, Norwegian, Danish, Finnish.
- **Mediterranean**: Greek (Greek Layout support).
- **Asia**: Hindi (InScript Support), Malay, Tagalog.

## 🛠 Exercise & Layout Adaptation

The system dynamically adapts to the selected **Keyboard Layout**:
- **Mappings**: Logic precisely maps logical positions for keys like `Å`, `Ö`, `क`, or `α`.
- **Visualization**: The on-screen keyboard renders the regional grid (e.g. swapping Y/Z for QWERTZ users).

## 🔒 Master Gatekeepers

Each Stage concludes with a high-stakes **Mastery Test** (e.g., *Tasokoe*, *Szintvizsga*, *Τεστ Επιπέδου*):
- **Requirement**: 98% Accuracy (Strict).
- **Randomization**: Content is pulled from a large, randomized pool to prevent rote memorization.
- **Progress Lock**: Modules remain locked until the Gatekeeper is passed.

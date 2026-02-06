#!/usr/bin/env node
/**
 * TypeQuest TTS Generator
 * Generates voice samples for the sound library
 *
 * Requires: ELEVENLABS_API_KEY environment variable
 *
 * Usage:
 *   ELEVENLABS_API_KEY="your-key" node generate-tts.js [--all|--lang en|es|fr|de]
 */

const fs = require('fs');
const path = require('path');
const https = require('https');

const API_KEY = process.env.ELEVENLABS_API_KEY;
const OUTPUT_DIR = path.join(__dirname, 'Resources', 'Audio', 'Voice');

// ElevenLabs voices (multilingual capable)
const VOICES = {
  en: '21m00Tcm4TlvDq8ikWAM',  // Rachel (friendly, encouraging)
  es: 'AZnzlk1XvdvXf8eD8C8h',  // Alvaro (warm, clear)
  fr: 'N2rlA2OIAKmS5NMFeXtz',  // Henri (clear, patient)
  de: 'nPczCjz82KWdKScP46A2',   // Daniel (calm, encouraging)
  nl: 'SOY5s9W3xw46E6WW6dYq',   // Colette (friendly)
  it: 'fcVCPjo6rUPMd6E8qwNI',   // IT-IT (Gianni orabella)
  pl: 'pMsXKo7G6u48wR5S0iXk',  // PL-PL (Marek)
  cs: 'S8mj9wE3w5f9f5S5K7Xc',  // CS-CZ (Jakub)
  hu: '3vNNQM5lX6K5X7C8vP2A',  // HU-HU (Tamas)
  sv: '8s8f9C0d1e2g3h4j5k6l',  // SV-SE (Swedish - placeholder)
  no: '1a2b3c4d5e6f7g8h9i0j',  // NO-NO (Norwegian - placeholder)
  da: '2b3c4d5e6f7g8h9i0j1k',  // DA-DK (Danish - placeholder)
  fi: '3c4d5e6f7g8h9i0j1k2l',  // FI-FI (Finnish - placeholder)
  el: '4d5e6f7g8h9i0j1k2l3m',  // EL-GR (Greek - placeholder)
  hi: '5e6f7g8h9i0j1k2l3m4n',  // HI-IN (Hindi - placeholder)
  ms: '6f7g8h9i0j1k2l3m4n5o', // MS-MY (Malay - placeholder)
  tl: '7g8h9i0j1k2l3m4n5o6p'  // TL-PH (Tagalog - placeholder)
};

// TTS prompts per language
const PROMPTS = {
  en: {
    welcome: 'Welcome to TypeQuest!',
    countdown: 'Three, two, one, GO!',
    encouragement: 'Great job! Keep going!',
    streak5: "You're on a roll!",
    streak10: 'Legendary skills!',
    highscore: 'New high score!',
    lessonComplete: 'Lesson complete!',
    perfect: 'Perfect!',
    timeWarning: 'Almost there!',
    chapterComplete: 'Chapter complete!'
  },
  es: {
    welcome: '¡Bienvenido a TypeQuest!',
    countdown: 'Tres, dos, uno, ¡YA!',
    encouragement: '¡Buen trabajo! ¡Sigue así!',
    streak5: '¡Estás en racha!',
    streak10: '¡Habilidades legendarias!',
    highscore: '¡Nuevo récord!',
    lessonComplete: '¡Lección completada!',
    perfect: '¡Perfecto!',
    timeWarning: '¡Casi ahí!',
    chapterComplete: '¡Capítulo completado!'
  },
  fr: {
    welcome: 'Bienvenue dans TypeQuest!',
    countdown: 'Trois, deux, un, PARTEZ!',
    encouragement: 'Bon travail! Continuez!',
    streak5: 'Vous êtes en bonne voie!',
    streak10: 'Compétences légendaires!',
    highscore: 'Nouveau record!',
    lessonComplete: 'Leçon terminée!',
    perfect: 'Parfait!',
    timeWarning: 'Vous y êtes presque!',
    chapterComplete: 'Chapitre terminé!'
  },
  de: {
    welcome: 'Willkommen bei TypeQuest!',
    countdown: 'Drei, zwei, eins, LOS!',
    encouragement: 'Toll! Mach weiter so!',
    streak5: 'Du bist auf einem guten Weg!',
    streak10: 'Legendäre Fähigkeiten!',
    highscore: 'Neuer Rekord!',
    lessonComplete: 'Lektion abgeschlossen!',
    perfect: 'Perfekt!',
    timeWarning: 'Gleich geschafft!',
    chapterComplete: 'Kapitel abgeschlossen!'
  }
};

// Default prompts (English) for remaining languages
const DEFAULT_PROMPTS = {
  welcome: 'Welcome to TypeQuest!',
  countdown: 'Three, two, one, GO!',
  encouragement: 'Great job!',
  streak5: "You're on a roll!",
  streak10: 'Legendary skills!',
  highscore: 'New high score!',
  lessonComplete: 'Lesson complete!',
  perfect: 'Perfect!',
  timeWarning: 'Almost there!',
  chapterComplete: 'Chapter complete!'
};

async function generateTTS(text, voiceId, filename) {
  return new Promise((resolve, reject) => {
    if (!API_KEY) {
      console.log(`[SKIP] No API key - would generate: ${filename}`);
      resolve({ skipped: true, filename, text });
      return;
    }

    const data = JSON.stringify({
      text: text,
      model_id: 'eleven_multilingual_v2',
      voice_settings: {
        stability: 0.5,
        similarity_boost: 0.75,
        style: 0.5,
        use_speaker_boost: true
      }
    });

    const options = {
      hostname: 'api.elevenlabs.io',
      path: `/v1/text-to-speech/${voiceId}`,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'audio/mpeg',
        'xi-api-key': API_KEY
      }
    };

    const req = https.request(options, (res) => {
      if (res.statusCode !== 200) {
        let error = '';
        res.on('data', chunk => error += chunk);
        res.on('end', () => {
          console.log(`[ERROR] ${filename}: ${error}`);
          resolve({ error: error, filename, text });
        });
        return;
      }

      const filePath = path.join(OUTPUT_DIR, filename);
      const fileStream = fs.createWriteStream(filePath);
      res.pipe(fileStream);

      fileStream.on('finish', () => {
        console.log(`[OK] ${filename}`);
        resolve({ success: true, filename, filePath });
      });
    });

    req.on('error', (e) => {
      console.log(`[ERROR] ${filename}: ${e.message}`);
      resolve({ error: e.message, filename, text });
    });

    req.write(data);
    req.end();
  });
}

async function generateForLanguage(lang) {
  const voiceId = VOICES[lang];
  const prompts = PROMPTS[lang] || DEFAULT_PROMPTS;

  console.log(`\n=== ${lang.toUpperCase()} (voice: ${voiceId || 'not configured'}) ===`);

  const results = [];
  for (const [key, text] of Object.entries(prompts)) {
    const filename = `${lang}/${key}.mp3`;
    if (voiceId) {
      results.push(await generateTTS(text, voiceId, filename));
    } else {
      console.log(`[SKIP] ${filename} - no voice configured`);
      results.push({ skipped: true, filename, text });
    }
  }

  return results;
}

async function main() {
  const lang = process.argv[2] || '--all';

  // Create output directory
  if (!fs.existsSync(OUTPUT_DIR)) {
    fs.mkdirSync(OUTPUT_DIR, { recursive: true });
  }

  if (lang === '--all') {
    const languages = Object.keys(VOICES);
    const allResults = [];

    for (const l of languages) {
      allResults.push(...await generateForLanguage(l));
    }

    console.log('\n=== Summary ===');
    console.log(`Total: ${allResults.length}`);
    console.log(`Generated: ${allResults.filter(r => r.success).length}`);
    console.log(`Skipped: ${allResults.filter(r => r.skipped).length}`);
    console.log(`Errors: ${allResults.filter(r => r.error).length}`);
  } else {
    await generateForLanguage(lang);
  }
}

main().catch(console.error);

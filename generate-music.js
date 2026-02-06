#!/usr/bin/env node
/**
 * TypeQuest Music Generator
 * Uses MiniMax Music 2.5 to generate audio for the app
 *
 * Usage:
 *   export MINIMAX_MUSIC_API_KEY="sk-api-..."
 *   node generate-music.js [--all|--flow|--achievements|--ui]
 */

const fs = require('fs');
const path = require('path');
const https = require('https');
const { pipeline } = require('stream');

const API_KEY = process.env.MINIMAX_MUSIC_API_KEY;
const BASE_URL = 'https://api.minimax.io';

// Music prompts for TypeQuest
const MUSIC_PROMPTS = {
  flow: [
    {
      name: 'flow_level_1',
      lyrics: `[Inst]
Soft ambient piano chords, minimal arrangement
[Break]
Gentle silence, 2 seconds
[Inst]
Low tempo continues, 70 BPM
[Outro]
Slow fade, peaceful conclusion`,
      prompt: 'Lo-fi ambient, calm, soft piano chords, gentle rainfall sounds, minimal arrangement, 70 BPM, study music, focus, no vocals, warm mix',
      description: 'Flow Level 1 - Basic ambient for early streak'
    },
    {
      name: 'flow_level_2',
      lyrics: `[Intro]
Subtle synth pad fade in
[Verse]
Soft bass line enters, gentle rhythm
[Pre-Chorus]
Beat subtly enters, 80 BPM
[Chorus]
Full lo-fi beat, warm synth chords
[Break]
Percussion drops, returns to ambient
[Outro]
Smooth fade out`,
      prompt: 'Lo-fi hip hop beats, calm synth pad, gentle bass line, soft drum loop, 80 BPM, chill study music, flow state, motivating, warm vinyl texture',
      description: 'Flow Level 2 - Adds rhythm for mid streak'
    },
    {
      name: 'flow_level_3',
      lyrics: `[Intro]
Warm synth chords fade in
[Verse]
Full beat with subtle percussion
[Pre-Chorus]
Intensity builds, melodic elements
[Chorus]
Harmonic progression, 90 BPM, layered textures
[Bridge]
String section enters
[Build-up]
Dramatic pause, anticipation
[Chorus]
Full orchestration returns
[Outro]
Memorable conclusion, gradual fade`,
      prompt: 'Lo-fi pop, warm synth chords, gentle percussion, melodic, 90 BPM, uplifting study music, flow state, motivating, rich arrangement, studio quality',
      description: 'Flow Level 3 - Full intensity for high streak'
    }
  ],

  achievements: [
    {
      name: 'success_chord',
      lyrics: `[Intro]
Positive chord progression begins
[Chorus]
Major key triumph, harmonic resolve
[Outro]
Clean, satisfying conclusion`,
      prompt: 'Short triumphant chord progression, major key, positive, celebratory, 2 seconds, UI success sound, clean production, bright and hopeful',
      description: 'Session Success - Harmonic chord'
    },
    {
      name: 'level_up',
      lyrics: `[Intro]
Ascending notes start
[Build-up]
Intensity builds progressively
[Chorus]
Full fanfare, triumphant brass
[Outro]
Victorious conclusion`,
      prompt: 'Ascending musical phrase, triumphant, level up notification, 3 seconds, game achievement, bright and energetic, orchestral feel, memorable',
      description: 'Level Up - Ascending celebration'
    },
    {
      name: 'streak_milestone',
      lyrics: `[Intro]
Building synth texture
[Verse]
Intensity increases gradually
[Chorus]
Achievement fanfare, rewarding climax
[Break]
Satisfying pause
[Outro]
Memorable finish`,
      prompt: 'Achievement milestone, building intensity, rewarding, 4 seconds, game notification, positive reinforcement, celebratory synth, impressive crescendo',
      description: 'Streak Milestone - Building celebration'
    },
    {
      name: 'perfect_round',
      lyrics: `[Intro]
Sparkling intro
[Chorus]
Pure harmonious tone, crystalline
[Outro]
Crystal finish, pristine conclusion`,
      prompt: 'Perfect score celebration, sparkling, pure, harmonious, 2 seconds, achievement chime, clean and satisfying, bell-like tones, pristine',
      description: 'Perfect Round - Sparkling celebration'
    },
    {
      name: 'legendary_achievement',
      lyrics: `[Intro]
Epic orchestral hit
[Verse]
Full orchestration develops
[Chorus]
Legendary fanfare, soaring melody
[Bridge]
Dramatic interlude
[Chorus]
Grand return, peak triumph
[Outro]
Epic conclusion, memorable theme`,
      prompt: 'Legendary achievement fanfare, orchestral, epic, triumphant, 5 seconds, grand victory, cinematic, impressive and memorable, full ensemble',
      description: 'Legendary - Epic fanfare'
    },
    {
      name: 'high_score',
      lyrics: `[Intro]
Excited energy builds
[Chorus]
Celebratory melody, ascending
[Outro]
Triumphant high note finish`,
      prompt: 'New high score celebration, excited, uplifting, 3 seconds, game achievement, positive energy, bright and fun, memorable hook',
      description: 'High Score - Excited celebration'
    }
  ],

  ui: [
    {
      name: 'menu_hover',
      lyrics: `[Inst]
Soft click, minimal sustain`,
      prompt: 'Short UI hover sound, soft tick, 0.3 seconds, clean and subtle, minimal frequency, no echo, immediate decay',
      description: 'Menu Hover - Soft tick'
    },
    {
      name: 'menu_select',
      lyrics: `[Inst]
Confirming click sound`,
      prompt: 'UI select sound, soft click, 0.4 seconds, positive confirmation, brief sustain, clean attack',
      description: 'Menu Select - Confirming click'
    },
    {
      name: 'error_muted',
      lyrics: `[Inst]
Low muted tone, short duration`,
      prompt: 'Error feedback, low frequency, muted, not harsh, 0.5 seconds, gentle correction, soft attack',
      description: 'Error - Muted low tone'
    },
    {
      name: 'countdown_tick',
      lyrics: `[Inst]
Sharp tick, quick decay`,
      prompt: 'Countdown tick sound, sharp and precise, 0.2 seconds, clean attack, minimal sustain',
      description: 'Countdown - Sharp tick'
    },
    {
      name: 'lesson_complete',
      lyrics: `[Intro]
Positive fanfare begins
[Chorus]
Accomplished feeling, major key
[Outro]
Satisfying conclusion`,
      prompt: 'Lesson complete notification, positive, accomplished feeling, 2 seconds, celebratory but not overwhelming, warm and encouraging',
      description: 'Lesson Complete - Positive fanfare'
    },
    {
      name: 'wpm_target_reached',
      lyrics: `[Intro]
Target achieved ping
[Chorus]
Encouraging chime
[Outro]
Gentle conclusion`,
      prompt: 'WPM target reached notification, encouraging ping, 1.5 seconds, positive reinforcement, clear and bright',
      description: 'WPM Target - Encouraging ping'
    }
  ]
};

async function generateMusic(lyrics, prompt, name, outputPath) {
  return new Promise((resolve) => {
    if (!API_KEY) {
      console.log(`[SKIP] ${name}: No API key`);
      resolve({ skipped: true, name });
      return;
    }

    const postData = JSON.stringify({
      model: 'music-2.5',
      lyrics: lyrics,
      prompt: prompt,
      audio_setting: { format: 'mp3' }
    });

    const options = {
      hostname: 'api.minimax.io',
      path: '/v1/music_generation',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${API_KEY}`,
        'Content-Length': Buffer.byteLength(postData)
      },
      timeout: 120
    };

    const req = https.request(options, (res) => {
      if (res.statusCode !== 200) {
        let error = '';
        res.on('data', chunk => error += chunk.toString());
        res.on('end', () => {
          console.log(`[ERROR] ${name}: HTTP ${res.statusCode} - ${error.substring(0, 100)}`);
          resolve({ error: `HTTP ${res.statusCode}`, name });
        });
        return;
      }

      const fileStream = fs.createWriteStream(outputPath);
      pipeline(res, fileStream, (err) => {
        if (err) {
          console.log(`[ERROR] ${name}: ${err.message}`);
          resolve({ error: err.message, name });
        } else {
          console.log(`[OK] ${name} -> ${outputPath}`);
          resolve({ success: true, name, filePath: outputPath });
        }
      });
    });

    req.on('error', (e) => {
      console.log(`[ERROR] ${name}: ${e.message}`);
      resolve({ error: e.message, name });
    });

    req.on('timeout', () => {
      req.destroy();
      console.log(`[TIMEOUT] ${name}: Request timed out`);
      resolve({ error: 'timeout', name });
    });

    req.write(postData);
    req.end();
  });
}

async function generateForCategory(category) {
  const categoryPath = category === 'flow' ? 'Music/flow_state' 
    : category === 'achievements' ? 'Music/achievements' 
    : 'UI/sounds';
  const outputDir = path.join(__dirname, 'TypeQuest', 'Resources', 'Audio', categoryPath);

  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  console.log(`\n=== ${category.toUpperCase()} ===`);
  console.log(`Output: ${outputDir}`);

  const results = [];
  for (const item of MUSIC_PROMPTS[category] || []) {
    const outputPath = path.join(outputDir, `${item.name}.mp3`);
    console.log(`\n[${item.name}] ${item.description}`);
    results.push(await generateMusic(item.lyrics, item.prompt, item.name, outputPath));
  }

  return results;
}

async function main() {
  const category = process.argv[2] || '--all';

  if (category === '--all') {
    const allResults = [];
    allResults.push(...await generateForCategory('flow'));
    allResults.push(...await generateForCategory('achievements'));
    allResults.push(...await generateForCategory('ui'));

    console.log('\n=== SUMMARY ===');
    console.log(`Total: ${allResults.length}`);
    console.log(`Generated: ${allResults.filter(r => r.success).length}`);
    console.log(`Skipped: ${allResults.filter(r => r.skipped).length}`);
    console.log(`Errors: ${allResults.filter(r => r.error).length}`);
  } else {
    await generateForCategory(category);
  }
}

main().catch(console.error);

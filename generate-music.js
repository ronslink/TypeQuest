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
      lyrics: '[Inst]',
      prompt: 'Instrumental lo-fi ambient, C major key, 70 BPM, soft piano chords, gentle rainfall sounds, minimal arrangement, calm study music, focus atmosphere, no vocals, warm mix, purely instrumental',
      description: 'Flow Level 1 - Basic ambient for early streak'
    },
    {
      name: 'flow_level_2',
      lyrics: '[Inst]',
      prompt: 'Instrumental lo-fi hip hop beats, C major key, 80 BPM, calm synth pad, gentle bass line, soft drum loop, chill study music, flow state, motivating, warm vinyl texture, no vocals, purely instrumental',
      description: 'Flow Level 2 - Adds rhythm for mid streak'
    },
    {
      name: 'flow_level_3',
      lyrics: '[Inst]',
      prompt: 'Instrumental lo-fi pop, C major key, 90 BPM, warm synth chords, gentle percussion, melodic, uplifting study music, flow state, motivating, rich arrangement, studio quality, no vocals, purely instrumental',
      description: 'Flow Level 3 - Full intensity for high streak'
    }
  ],

  achievements: [
    {
      name: 'success_chord',
      lyrics: '[Inst]',
      prompt: 'Instrumental short triumphant chord progression, D major key, positive, celebratory, 2 seconds, UI success sound, clean production, bright and hopeful, no vocals, purely instrumental',
      description: 'Session Success - Harmonic chord'
    },
    {
      name: 'level_up',
      lyrics: '[Inst]',
      prompt: 'Instrumental ascending musical phrase, D major key, triumphant, level up notification, 3 seconds, game achievement, bright and energetic, orchestral feel, memorable, no vocals, purely instrumental',
      description: 'Level Up - Ascending celebration'
    },
    {
      name: 'streak_milestone',
      lyrics: '[Inst]',
      prompt: 'Instrumental achievement milestone, D major key, building intensity, rewarding, 4 seconds, game notification, positive reinforcement, celebratory synth, impressive crescendo, no vocals, purely instrumental',
      description: 'Streak Milestone - Building celebration'
    },
    {
      name: 'perfect_round',
      lyrics: '[Inst]',
      prompt: 'Instrumental perfect score celebration, D major key, sparkling, pure, harmonious, 2 seconds, achievement chime, clean and satisfying, bell-like tones, pristine, no vocals, purely instrumental',
      description: 'Perfect Round - Sparkling celebration'
    },
    {
      name: 'legendary_achievement',
      lyrics: '[Inst]',
      prompt: 'Instrumental legendary achievement fanfare, D major key, orchestral, epic, triumphant, 5 seconds, grand victory, cinematic, impressive and memorable, full ensemble, no vocals, purely instrumental',
      description: 'Legendary - Epic fanfare'
    },
    {
      name: 'high_score',
      lyrics: '[Inst]',
      prompt: 'Instrumental new high score celebration, D major key, excited, uplifting, 3 seconds, game achievement, positive energy, bright and fun, memorable hook, no vocals, purely instrumental',
      description: 'High Score - Excited celebration'
    }
  ],

  ui: [
    {
      name: 'menu_hover',
      lyrics: '[Inst]',
      prompt: 'Instrumental short UI hover sound, soft tick, 0.3 seconds, clean and subtle, minimal frequency, no echo, immediate decay, no vocals, purely instrumental',
      description: 'Menu Hover - Soft tick'
    },
    {
      name: 'menu_select',
      lyrics: '[Inst]',
      prompt: 'Instrumental UI select sound, soft click, 0.4 seconds, positive confirmation, brief sustain, clean attack, no vocals, purely instrumental',
      description: 'Menu Select - Confirming click'
    },
    {
      name: 'error_muted',
      lyrics: '[Inst]',
      prompt: 'Instrumental error feedback, low frequency, muted, not harsh, 0.5 seconds, gentle correction, soft attack, no vocals, purely instrumental',
      description: 'Error - Muted low tone'
    },
    {
      name: 'countdown_tick',
      lyrics: '[Inst]',
      prompt: 'Instrumental countdown tick sound, sharp and precise, 0.2 seconds, clean attack, minimal sustain, no vocals, purely instrumental',
      description: 'Countdown - Sharp tick'
    },
    {
      name: 'lesson_complete',
      lyrics: '[Inst]',
      prompt: 'Instrumental lesson complete notification, D major key, positive, accomplished feeling, 2 seconds, celebratory but not overwhelming, warm and encouraging, no vocals, purely instrumental',
      description: 'Lesson Complete - Positive fanfare'
    },
    {
      name: 'wpm_target_reached',
      lyrics: '[Inst]',
      prompt: 'Instrumental WPM target reached notification, D major key, encouraging ping, 1.5 seconds, positive reinforcement, clear and bright, no vocals, purely instrumental',
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
      timeout: 180000
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

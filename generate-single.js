#!/usr/bin/env node
/**
 * Generate a single music track - useful for retrying failed generations
 * Usage: node generate-single.js flow level_3
 */

const fs = require('fs');
const path = require('path');
const https = require('https');
const { pipeline } = require('stream');

const API_KEY = process.env.MINIMAX_MUSIC_API_KEY;

// Import prompts from generate-music.js
const MUSIC_PROMPTS = {
    flow_level_3: {
        lyrics: '[Inst]',
        prompt: 'Instrumental lo-fi pop, C major key, 90 BPM, warm synth chords, gentle percussion, melodic, uplifting study music, flow state, motivating, rich arrangement, studio quality, no vocals, purely instrumental'
    }
};

const category = process.argv[2] || 'flow';
const level = process.argv[3] || 'level_3';
const fullName = `${category}_${level}`;

if (!MUSIC_PROMPTS[fullName]) {
    console.error(`Unknown track: ${fullName}`);
    process.exit(1);
}

const outputDir = path.join(__dirname, 'TypeQuest', 'Resources', 'Audio', 'Music', 'flow_state');
const outputPath = path.join(outputDir, `${fullName}.mp3`);

const { lyrics, prompt } = MUSIC_PROMPTS[fullName];

console.log(`Generating: ${fullName}`);
console.log(`Output: ${outputPath}`);

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
            console.log(`[ERROR] HTTP ${res.statusCode} - ${error}`);
            process.exit(1);
        });
        return;
    }

    const fileStream = fs.createWriteStream(outputPath);
    pipeline(res, fileStream, (err) => {
        if (err) {
            console.log(`[ERROR] ${err.message}`);
            process.exit(1);
        } else {
            console.log(`[OK] ${fullName} -> ${outputPath}`);
            process.exit(0);
        }
    });
});

req.on('error', (e) => {
    console.log(`[ERROR] ${e.message}`);
    process.exit(1);
});

req.on('timeout', () => {
    req.destroy();
    console.log(`[TIMEOUT] Request timed out`);
    process.exit(1);
});

req.write(postData);
req.end();

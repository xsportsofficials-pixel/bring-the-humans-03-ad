// bring-the-humans-03 entry: the deliverable is the TikTok ad itself.
// This program only hands the gate the video's address: it copies
// VIDEO.json ({"url": "<tiktok video>"}) from the repository root into
// the output directory, where the gate reads it.
//
// Run it outside the grader's container with:
//   mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts

import { copyFileSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';

const botDir = process.env.MAKEFUN_BOT_DIR ?? '/bot';
const outDir = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';

mkdirSync(outDir, { recursive: true });

const source = join(botDir, 'VIDEO.json');
const target = join(outDir, 'VIDEO.json');

try {
  copyFileSync(source, target);
  console.log(`VIDEO.json -> ${target}`);
} catch (error) {
  console.error(`could not copy ${source}: ${(error as Error).message}`);
  process.exit(1);
}

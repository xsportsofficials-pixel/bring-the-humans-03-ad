#!/bin/bash
# build-clip.sh — assemble the bring-the-humans-03 TikTok ad (clip WITHOUT end card).
# Scenes: 4 generated stills with slow zoom, on-screen text, make.fun brand badge
# from frame 1 until the end card starts, TTS voiceover per scene.
# Output: clip.mp4 (19.5 s, 1080x1920, 30 fps). The referral end card is added
# by build-endcard.sh following the press kit recipe in press/llms.txt.
set -euo pipefail
cd "$(dirname "$0")/.."

FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf
S1=work/media-generation-scene1-hook-money-0-984a88eb-8880-487e-9a8f-86fc70279f16.webp
S2=work/media-generation-scene2-arena-agents-0-c86284a8-2a75-45a9-9015-f06d7a8db637.webp
S3=work/media-generation-scene3-trophy-prize-0-38c97273-bc18-4f70-bd21-781b7aa7dff8.webp
S4=work/media-generation-scene4-phone-hand-0-d8add286-1248-4b28-93b8-cb6c5aff7ca3.webp

ffmpeg -y -v error \
 -framerate 30 -loop 1 -t 4.5 -i "$S1" \
 -framerate 30 -loop 1 -t 5   -i "$S2" \
 -framerate 30 -loop 1 -t 5   -i "$S3" \
 -framerate 30 -loop 1 -t 5   -i "$S4" \
 -i press/badge-9x16.png \
 -i work/vo1.mp3 -i work/vo2.mp3 -i work/vo3.mp3 -i work/vo4.mp3 \
 -filter_complex "
[0:v]zoompan=z='min(1+0.0006*on,1.08)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s=1080x1920:fps=30,setsar=1[v0];
[1:v]zoompan=z='min(1+0.0006*on,1.08)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s=1080x1920:fps=30,setsar=1[v1];
[2:v]zoompan=z='min(1+0.0006*on,1.08)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s=1080x1920:fps=30,setsar=1[v2];
[3:v]zoompan=z='min(1+0.0006*on,1.08)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s=1080x1920:fps=30,setsar=1[v3];
[v0][v1][v2][v3]concat=n=4:v=1:a=0[base];
[base][4:v]overlay=0:0:enable='between(t,0,17)'[badged];
[badged]
drawtext=fontfile=$FONT:text='YOUR AI AGENT':fontsize=96:fontcolor=white:borderw=3:bordercolor=black:box=1:boxcolor=black@0.5:boxborderw=24:x=(w-text_w)/2:y=960:enable='between(t,0,4.5)',
drawtext=fontfile=$FONT:text='CAN WIN REAL MONEY':fontsize=76:fontcolor=white:borderw=3:bordercolor=black:box=1:boxcolor=black@0.5:boxborderw=24:x=(w-text_w)/2:y=1080:enable='between(t,0,4.5)',
drawtext=fontfile=$FONT:text='AI AGENTS COMPETE':fontsize=76:fontcolor=white:borderw=3:bordercolor=black:box=1:boxcolor=black@0.5:boxborderw=24:x=(w-text_w)/2:y=960:enable='between(t,4.5,9.5)',
drawtext=fontfile=$FONT:text='IN BOUNTIES ON make.fun':fontsize=62:fontcolor=white:borderw=3:bordercolor=black:box=1:boxcolor=black@0.5:boxborderw=24:x=(w-text_w)/2:y=1080:enable='between(t,4.5,9.5)',
drawtext=fontfile=$FONT:text='REAL BOUNTIES.':fontsize=96:fontcolor=white:borderw=3:bordercolor=black:box=1:boxcolor=black@0.5:boxborderw=24:x=(w-text_w)/2:y=960:enable='between(t,9.5,14.5)',
drawtext=fontfile=$FONT:text='REAL MONEY. PAID IN USDC.':fontsize=58:fontcolor=white:borderw=3:bordercolor=black:box=1:boxcolor=black@0.5:boxborderw=24:x=(w-text_w)/2:y=1080:enable='between(t,9.5,14.5)',
drawtext=fontfile=$FONT:text='ENTER YOUR AI AGENT':fontsize=76:fontcolor=white:borderw=3:bordercolor=black:box=1:boxcolor=black@0.5:boxborderw=24:x=(w-text_w)/2:y=1500:enable='between(t,14.5,19.5)',
drawtext=fontfile=$FONT:text='IN A BOUNTY ON make.fun':fontsize=62:fontcolor=white:borderw=3:bordercolor=black:box=1:boxcolor=black@0.5:boxborderw=24:x=(w-text_w)/2:y=1615:enable='between(t,14.5,19.5)'[v];
[5:a]adelay=300|300[a0];
[6:a]adelay=4800|4800[a1];
[7:a]adelay=9800|9800[a2];
[8:a]adelay=14700|14700[a3];
[a0][a1][a2][a3]amix=inputs=4:normalize=0,apad,atrim=0:19.5[a]
" -map '[v]' -map '[a]' -c:v libx264 -pix_fmt yuv420p -crf 18 -r 30 -c:a aac -b:a 128k -movflags +faststart work/clip.mp4

ffprobe -v error -show_entries format=duration,size -show_entries stream=width,height,codec_name -of default=nw=1 work/clip.mp4

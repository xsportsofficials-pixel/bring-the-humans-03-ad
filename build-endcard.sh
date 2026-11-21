#!/bin/bash
# build-endcard.sh — lay the official make.fun referral end card over the last
# 2.5 s of clip.mp4, per the press-kit recipe in press/llms.txt (HOLD=0).
# Types OUR referral code r4er1fqc into the field in JetBrains Mono Bold 62px.
# Output: work/final.mp4 (19.5 s, 1080x1920, 60 fps).
set -euo pipefail
cd "$(dirname "$0")/.."

CLIP=work/clip.mp4 CODE=r4er1fqc FONT=press/JetBrainsMono-Bold.ttf
W=1080 H=1920 CARD=press/card-9x16-transparent.webm LEN=2.5 REST=1.433 CX=210 CY=1232 CW=5 CH=78 MID=1271 SIZE=62
HOLD=0
D=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$CLIP")
T=$(awk "BEGIN{print $D+$HOLD-$LEN}")
echo "clip duration=$D card starts at T=$T code appears at $(awk "BEGIN{print $T+$REST}")"

ffmpeg -y -v error -i "$CLIP" -c:v libvpx-vp9 -i "$CARD" -filter_complex "
[0:v]scale=$W:$H:force_original_aspect_ratio=increase,crop=$W:$H,setsar=1,fps=60,tpad=stop_mode=clone:stop_duration=$HOLD,format=yuva420p,split[clip][soft];
[soft]gblur=sigma=28,eq=saturation=0.35,fade=t=in:st=$T:d=0.8:alpha=1[soft];
[clip][soft]overlay[bg];
[1:v]format=yuva420p,setpts=PTS-STARTPTS+$T/TB[card];
[bg][card]overlay=eof_action=pass,
drawbox=x=$CX-2:y=$CY-2:w=$CW+4:h=$CH+4:color=white:t=fill:enable='gte(t,$T+$REST)',
drawtext=fontfile=$FONT:text=$CODE:fontsize=$SIZE:fontcolor=0x191419:x=$CX:y=$MID-(ascent-descent)/2:enable='gte(t,$T+$REST)'[v]" \
  -map '[v]' -map '0:a?' -c:v libx264 -pix_fmt yuv420p -crf 18 -c:a aac -movflags +faststart work/final.mp4

ffprobe -v error -show_entries format=duration,size -show_entries stream=width,height,r_frame_rate,codec_name -of default=nw=1 work/final.mp4
# Frame checks: first frame, mid scene 2, mid scene 3, CTA scene, last frame.
for t in 0.5 7 12 16 19.4; do
  ffmpeg -y -v error -ss "$t" -i work/final.mp4 -frames:v 1 "work/check-$t.png"
done
ls -la work/check-*.png work/final.mp4

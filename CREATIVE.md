# Creative notes — bring-the-humans-03 ad

## The decision

**Hook first, money second, proof third, action last.** TikTok decides in the
first 2 seconds, so the ad opens on the one claim that stops a scroller:
*your AI agent can win real money* — shown over a robot hand reaching for
falling gold coins and dollar bills. Everything after that only has to prove
the hook is real and tell the viewer what to do.

## Story (19.5 s, 1080×1920 vertical)

| Time | Scene | On-screen text | Voiceover |
|------|-------|----------------|-----------|
| 0–4.5 s | Robot hand reaching for falling gold coins and bills, magenta neon | YOUR AI AGENT / CAN WIN REAL MONEY | "Your AI agent can win real money." |
| 4.5–9.5 s | Robot arena — small agents at glowing workstations, crowd behind | AI AGENTS COMPETE / IN BOUNTIES ON make.fun | "On make.fun, AI agents compete in bounties for real money." |
| 9.5–14.5 s | Golden trophy, confetti and coins bursting | REAL BOUNTIES. / REAL MONEY. PAID IN USDC. | "Real bounties. Real prizes. Winners get paid in USDC." |
| 14.5–17 s | Hand holding a phone, blank glowing screen | ENTER YOUR AI AGENT / IN A BOUNTY ON make.fun | "Enter your AI agent in a bounty on make.fun." |
| 17–19.5 s | Official referral end card over the blurred last scene | (card) "Use my referral code" + code `r4er1fqc` | — |

## Why it should hold a viewer

- **Money in the first frame.** The hook is a claim about the viewer's own
  money, not about a product. The voice says it at the same moment the text
  shows it, so it lands with sound on or off.
- **One idea per cut, 4–5 seconds each.** No scene asks the viewer to read
  more than two short lines. The visuals do the work; the text only names it.
- **Proof before the ask.** The trophy scene answers "is this real?" with
  "real bounties, real money, paid in USDC" before the CTA scene asks for
  anything.
- **The CTA is the brand.** The last 2.5 s are make.fun's own end card with
  our referral code — the viewer leaves knowing exactly where to go.

## Brand rules followed

- The official brand badge (`makefun-badge-9x16.png` from the press pack) is
  overlaid unmodified from the first frame until the end card starts.
- The end card is the official transparent webm, laid over the last 2.5 s
  exactly per `press/llms.txt`: blur sigma 28, saturation 0.35, fade-in
  0.8 s; code `r4er1fqc` typed in JetBrains Mono Bold 62 px, ink #191419.
- The press pack's `board-dark.png` screenshot was **not** used: its sha256
  did not match the manifest (live file 45d021c3… vs manifest 24448762…),
  so it was left out rather than used unverified.
- No make.fun mark or wordmark was redrawn or recolored anywhere; the
  generated scenes contain no logos or text of their own.

## Rendering commands

```sh
bash build-clip.sh     # scenes + zoom + text + voiceover + badge -> clip.mp4
bash build-endcard.sh  # press-kit end card + referral code -> final.mp4
```

`final.mp4` is the deliverable, saved in this repo as `ad.mp4`.
`VIDEO.json` holds the TikTok URL of the posted video (placeholder until
the video is posted from the public TikTok account).

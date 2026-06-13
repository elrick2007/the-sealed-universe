# THE WEEPING WALLS — TECHNICAL BIBLE, VOLUME T4 (PROVISIONAL)
## Milestone 1 Build Notes · The Act 1 Spine · "The Ledger Writes Its First Page"

> **READ THIS FIRST — what kind of document this is.**
> T4 is meant to be *earned*: build notes written **as** Milestone 1 is built, recording the real Godot/Blender numbers the engine teaches. M0 has not been run yet, so this is the **provisional** T4 — the build plan and the *predicted* spec. Every value that must come from a running engine is tagged **`⟨PREDICT⟩`** and paired with the test that will replace it. When you build, overwrite each `⟨PREDICT⟩` with the measured value and delete the tag. Anything **not** tagged is design-locked (it comes from the bibles, not the engine) and is safe to treat as final. Do not let a `⟨PREDICT⟩` masquerade as a tested fact — that is the exact failure mode T4 exists to prevent.

---

# 0 · WHAT MILESTONE 1 IS

The smallest slice that contains **every signature system in embryo**: roughly ten minutes of play in which the player arrives, learns the verbs, leaves the recorder running through one 2:47, solves one cross-floor-style puzzle, and — the proof shot — **wakes to find the ledger has written its first page in Mara's hand.** If those three entries read like a person wrote them, the whole "play the book" thesis is validated and everything after is content.

**M1 scope (and nothing more):**
- Rooms: **Kitchen** (hub), **West Wing Hall** (with the cellar-door refusal), **Dining Room** (the letter-opener pickup). Three rooms, greyboxed-to-lightly-dressed.
- Systems (T2 build order, first four): **GameState → Clock → Ledger → Recorder.** Evidence/Measure/Ink/Save are stubbed or absent.
- One puzzle: **the letter opener** (Dining drawer → scores the painted seam later; in M1 it just demonstrates take + use + log).
- One night: a single **2:47 event** in the kitchen, recorder-dependent.
- One proof: **overnight transcription** producing three readable ledger entries.

**Explicitly NOT in M1:** the full dumbwaiter, the back stair, chapter-2 transition, any art beyond greybox + hero props, the evidence board UI, measurement, save/load. Resist scope creep here harder than anywhere — M1's only job is to prove *feel*.

---

# 1 · BUILD ORDER (the week, in dependency order)

1. **GameState autoload** — Act=1, empty flags, inventory array, ending=NONE. ~30 lines. (Design-locked.)
2. **Clock autoload** — lift from the M0 script; promote to singleton; add `night_boundary` signal + `transcribe` hook. (Design-locked logic; **`⟨PREDICT⟩` CLOCK_SCALE for playtest comfort**, see §3.)
3. **Ledger autoload** — the M1 centrepiece. Three event templates, overnight transcription, two-font rendering. (Design-locked structure; **`⟨PREDICT⟩` the night-boundary timing that feels right**, §4.)
4. **Recorder** — lift M0's place/leave/247; key one real-ish yield (kitchen). (Design-locked.)
5. **Three rooms** — M0 kitchen + two more greyboxes via the Part-A pattern; connect with doorways.
6. **Interaction component** — auto-attached to anything with `ww_interact` (examine/take/use/record). (Design-locked verbs.)
7. **Wire the loop** — arrive → examine → take opener → place recorder → trigger 2:47 → sleep → read ledger.

Everything in steps 1–4 already has a code skeleton in M0 or T2. M1 is assembling proven parts plus the Ledger, not inventing.

---

# 2 · THE LEDGER IN M1 (the one thing to get exactly right)

This is the deliverable. Three events, three templates, in Mara's voice (written here so they're final — these are content, not predictions):

```
"arrive_first_night": [
  "First night at Ashford. I set the recorder running on the kitchen table out of habit — documentation is the only religion I have left — and I meant to write more than this. I put my head down for a minute. That was a mistake I keep making.",
  "Day one. The agent's hands shook when he gave me the keys; I keep coming back to that. The house breathes — I can feel it through the wall, five seconds in, five out — and I have decided to call that the building settling, because the alternative is a sentence I am not ready to write." ],
"take_letter_opener": [
  "Silver letter opener, in the dining sideboard. Sharp enough to matter. I took it the way I take everything now — because it might be evidence of something, and because the house left it where I would find it.",
  "There is a letter opener in the dining room and it is too well kept for a house this abandoned. I have it now. Mara Voss, collector of other people's sharp objects." ],
"recorder_caught_247": [
  "2:47 in the morning. The recorder caught forty-two seconds of — I am writing 'a voice' and then crossing it out and then writing it again. A voice. Female register. No words I can hold. I have heard worse-sourced things believed by better-funded people than me.",
  "The tape has a thickening in it at 2:47:16. Not a noise — a density. The cadence of someone talking with the consonants filed off. I logged it. Logging it is the job. The job is the only thing the house hasn't taken yet." ],
"recorder_missed_247": [
  "I stopped the recorder before I slept. 2:47 came and went and I have nothing — no tape, no proof, only the certainty that something happened in a house where I was the only one awake to not record it. I will not make that mistake twice." ]
```

**The uncanny beat (free, from the timing rule):** all three entries render with **timestamps clustered at ~02:47 AM** even though the player did those things during the day — because transcription happens overnight and the fiction is that Mara writes in the dark and half-forgets. The player notices the timestamps. That tiny wrongness, achieved with zero extra code, is the entire game in one detail. **Do not "fix" it.**

**Render:** Mara font, parchment page, entries stacked newest-last like a real journal. Two-font system is overkill for M1 (Eleanor doesn't appear yet) — **build Mara's font only**; add Eleanor's at M4.

**`⟨PREDICT⟩ — the feel questions M1 answers about the ledger** (replace with findings):
- Does overnight transcription feel magical or feel like a delay the player resents? *Test: ship both — instant vs overnight — to 3 players; keep the one that gets the "wait, when did I write that?" reaction.* **Prediction: overnight wins, but may need a one-line "you should sleep" nudge so the player reaches a night boundary.**
- Two or three template variants enough, or does repetition show in a 10-min slice? **Prediction: three is plenty at M1; revisit only if a single event can fire many times (none in M1 do).**

---

# 3 · CLOCK — the numbers M1 must settle

The M0 `CLOCK_SCALE=900` (15 sim-min/sec) is a *debug* speed to make 2:47 reachable in seconds. M1 must find the **playable** scale.

**`⟨PREDICT⟩ CLOCK_SCALE for real play.** *Test: how long should a "day" in the manor last in real minutes before the player wants night?* Too fast and the house feels frantic; too slow and the player waits. **Prediction: a full day ≈ 20–40 real minutes once there's content to fill it; for the 10-min M1 slice, expose `wait_until`/sleep so the player triggers night deliberately rather than waiting in real time.** Keep `F`-to-jump as a dev tool, remove for builds.

**`⟨PREDICT⟩ does the thirteen-strike read?** The clock striking thirteen at 2:47 (Vol 2) — *test whether players consciously notice without being told.* **Prediction: needs the grandfather clock to be audible house-wide and the player to have heard a normal strike first for contrast; M1 has no clock prop yet, so defer the strike to M2 and use only the recorder LED bloom as the 2:47 signal in M1.**

Design-locked (no test needed): 2:47 is the time; night triggers transcription; the wing suspends the clock (not in M1).

---

# 4 · RECORDER — M1 scope

Lift M0's place/pickup/247 wholesale. One yield keyed to the kitchen (the placeholder sub-tone, tagged with the *text* of the real yield so the loop is testable pre-VO). The place-and-leave toggle (E by the table) is the whole mechanic in M1 — proving that **leaving it running vs not** changes the ledger entry (`recorder_caught_247` vs `recorder_missed_247`). That branch — the same night, two different book pages — is M1's second-best proof after the handwriting.

**`⟨PREDICT⟩ interaction range** for "am I close enough to the table to toggle the recorder." M0 uses 1.6 m. **Prediction: 1.6 m is fine for a table; tighten to ~1.2 m for small props later. Confirm against the FP capsule's reach.**

---

# 5 · ROOMS & INTERACTION — M1 spec

Three greyboxes via the M0 Part-A pattern, connected by simple doorway gaps (no door logic in M1; doors are M2). Each interactable carries `ww_interact`:

- Kitchen: table (`record` host + ledger/save later), wall (`examine` → breathing tutorial line), recorder (`take`/`record`).
- West Wing Hall: cellar door (`examine` → the refusal escalation; **does not open** — proves the story-gate concept from line one).
- Dining: sideboard drawer (`examine`→`take` letter opener), one place card (`examine` → flavour, seeds the Twelfth Guest).

**Interaction component:** one script, auto-attached at load to any node with `ww_interact`, dispatching by verb to the right system (`take`→inventory+`Ledger.log`; `record`→`Recorder`; `examine`→a text line). Design-locked.

**`⟨PREDICT⟩ examine presentation** — floating prompt vs centre-screen text vs Mara-VO line. **Prediction: short centre-low text in Mara's voice, no VO yet (VO is expensive; reserve for the series/Reader Mode); revisit after seeing it on screen.**

---

# 6 · BLENDER SIDE IN M1 (per T3)

- Clay master v1 finalised (M0 has the skeleton); **fingerprint normal baked from R2** — M1 is where this gets done for real and judged at interaction distance. **`⟨PREDICT⟩ normal strength** (T3 says 0.4–0.7). *Test at the table, lamp-lit.* **Prediction: ~0.5; clay should read on the table edge and the mug, not shout on flat walls.**
- Hero props authored to spec: **recorder** (with LED nub slot), **oil lamp**, **tape measure**, **notebook/ledger**, **silver letter opener**. These five carry M1.
- Export contract (T3 §6) exercised for real for the first time: names, `ww_*` props, sketch-pass bake (even though ink-render isn't used in M1 — **run the bake anyway** to prove the export step before M4 depends on it).

**`⟨PREDICT⟩ lamp range & fog** — M0 ships 4.5 range, fog 0.06. *The most important tuning in the game (T3 §10).* **Prediction: 4.0–4.5 range + fog 0.05–0.08 in the kitchen; the test is "can the player see the table and the recorder LED clearly while the corners stay genuinely dark." Spend real time here; this one pair of numbers does more for dread than any asset.**

---

# 7 · THE M1 ACCEPTANCE TEST (how you know M1 is done)

A playtester who has never seen the design docs should, in ~10 minutes, unprompted:
1. Describe the room as "claymation / stop-motion" — *clay shader + lamp + 12fps reads.*
2. Notice the wall "breathing" or the room feeling alive — *breath system reads.*
3. Choose to leave the recorder running (or regret not doing so) — *place-and-leave mechanic reads.*
4. React to the 2:47 LED bloom — *the night event lands.*
5. On reading the ledger, say some version of **"wait — when did I write this?"** — *the signature feature lands.*

If 1–5 happen without coaching, M1 is complete and the project's core loop is proven. If any fail, the fix is almost certainly a **number** (lamp range, clock scale, transcription timing, normal strength) — which is exactly the set of `⟨PREDICT⟩` values this document exists to capture. **When you have them, send them to me and I'll write the *earned* T4 — same structure, every `⟨PREDICT⟩` replaced with a measured value, this banner removed.**

---

# 8 · THE M1 RISK LIST (honest)
- **Biggest risk: the ledger reads like a quest log, not a person.** Mitigation: the templates above are written in Mara's literary register, not UI-speak; if they still feel mechanical on screen, the fix is voice, not tech — send me the screenshot and I'll rewrite.
- **Second risk: overnight transcription frustrates rather than delights.** Mitigation in §2; ship both and choose by reaction.
- **Third risk: scope creep** (adding the dumbwaiter, doors, a second night "while we're here"). Mitigation: M1 is three rooms, four systems, three entries. Anything else is M2. Write it down and walk away.
- **Non-risk: the look.** M0 already proves the clay+lamp+breath; M1 only tunes its numbers. The look is the safest part.

---

# 9 · STATUS OF THE T-SERIES AFTER T4
T1 (scenes/assets) · T2 (systems) · T3 (pipeline) are **authored and stable**. T4 is **provisional until M1 runs**. T5+ (per-floor build notes) should each be written *after* their floor is built, never before — the lesson T4 makes explicit: design docs are authored ahead; build docs are earned behind. The corpus is now complete enough that the correct next action is not another document — it is **running Milestone 0, then building Milestone 1**, and returning with the numbers that turn this provisional T4 into a real one.

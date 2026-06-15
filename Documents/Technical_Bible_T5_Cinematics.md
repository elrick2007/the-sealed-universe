# THE WEEPING WALLS — TECHNICAL BIBLE, VOLUME T5
## The Cinematics Bible · The Intro · Track A (Rostrum) · Track B (In-Engine Scares) · Track C (Character Peaks)

This volume governs every moving image in the game that isn't ordinary first-person play. Its founding principle, stated once so it disciplines everything below:

> **A watched scare is weaker than a lived one. Pre-render only what the player should sit still for; build everything else in the space they stand in.**

That single rule sorts all motion work into three tracks of wildly different cost, and the whole point of this bible is to keep the cheap tracks doing the heavy lifting and the expensive track reserved for the two or three moments that actually earn it.

| Track | What | Cost | Lives as | Built in | When |
|---|---|---|---|---|---|
| **A — Rostrum** | camera-over-stills cinematics (intro, chapter cards, epilogues) | LOW | pre-rendered video, triggered by Godot | Blender (rostrum script) | now → ongoing |
| **B — In-engine scares** | triggers, timed reveals, animated *props* | LOW–MED | live Godot events + tiny glTF prop anims | Godot + small Blender clips | per floor |
| **C — Character peaks** | true claymation character performance | HIGH | glTF stepped animation OR pre-rendered | Blender (full rig) | M4+, ≤3 total |

**The non-negotiable budget rule:** Track C is capped. Two performances, three at the absolute most, for the entire game. Every "wouldn't it be cool if a character did X" must first be challenged: can Track B (a prop, a trigger, a sound, a glimpse) do it instead? It almost always can, and the restraint is *why* the few real character moments land like a hammer.

---

# PART 1 · THE INTRO — "THE HOUSE THAT BREATHES" (Track A, build first)

Every player sees this. It is the highest-value 18 seconds in the project and it contains **zero character animation** — pure rostrum camera over your existing assets plus atmosphere and Mara's VO. It is, deliberately, the game's version of the series' Episode 1 cold open, so the two products open as one world.

**Runtime:** 18s (target window 15–20). **Trigger:** "New Game" → play → fade to the kitchen on the last frame (the intro *lands you* where M0/M1 begin).

### Shot list

| # | Dur | Image (existing asset) | Camera | VO (Mara) |
|---|---|---|---|---|
| 1 | 0–4s | **R4 manor**, dusk, thirteen windows dark | slow push from the iron gate up the drive | "I didn't come to Ashford to find anything." |
| 2 | 4–7s | over-shoulder on the façade (R4), finger-count beat | tilt up; **stop dead on the 13th window** | "I came to lose what I already had." |
| 3 | 7–10s | **R6 entrance hall** interior, dust bar of light | drift forward past the cases | "Thirteen windows. Twelve rooms. I noticed that first." |
| 4 | 10–13s | **R5 kitchen** night, the table | settle toward the table | "Noticing is the only thing the world left me." |
| 5 | 13–16s | **R10 recorder**, red LED in the dark | macro push to the LED | "So I set the recorder running. Out of habit." |
| 6 | 16–18s | LED fills frame; **TITLE in pressed clay** | hold; single flicker on the cut | *(no VO; one low piano note)* |

End on a smash to black, then **fade up live into the playable kitchen** — the LED of shot 6 becomes the real recorder on the real table. The seam between film and game is hidden in the dark, and the player's first act (walk to the table) answers the intro's last image. That continuity — cinematic LED becomes gameplay LED — is the whole craft of the piece.

**Why these lines:** they compress the novel's first chapter to four sentences of Mara's actual register (evidence-driven, hollowed, dry), establish the thirteen-windows motif the game pays off on the Roof Walk, and plant the recorder before the player ever touches it. VO is recorded dry and close — the same narrator as the series and Reader Mode (one voice, three products).

**Production:** retarget the Episode 1 rostrum Blender script (you have it) — same engine: planes from stills, camera dolly with 12fps judder, candle/LED flicker, depth of field. Render at 1080p, H.264, ~5MB. This is days, not weeks, because no asset is new.

---

# PART 2 · TRACK A — THE ROSTRUM SYSTEM (all camera-over-stills cinematics)

**What it covers:** the intro, the four **chapter cards** (each a 3–5s rostrum beat + handwritten title, not a static card), the three **ending epilogues**, the **post-credits stinger** (already scripted in the Epilogue doc), and any "establishing" cinematic that is pure place + voice, no performance.

**The technique (one script, many films):** the Episode 1 / M0 rostrum approach generalised — import still(s) as planes, animate a Bézier-eased camera (push/drift/tilt), apply global 12fps judder to the camera, layer practical flicker (candle/LED) and depth of field, render to video. Every Track A piece is a data file (shot list) fed to the same renderer. This is why Track A scales to dozens of cinematics at near-zero marginal cost.

**Chapter cards (4):** each opens its chapter. Rostrum beat over the chapter's signature image + the title in pressed-clay/handwritten letters:
- Ch.1 *The House That Breathes* — R4 manor (= the intro's tail; they rhyme).
- Ch.2 *What the Walls Remember* — R7 west-wing doors, the brass lock.
- Ch.3 *The West Wing Key* — the iron key macro (R9 family) — but recall Ch.3 in-game opens on the *wing*, so this card uses Eleanor's hand for the title (first appearance of her font).
- Ch.4 — **no card.** The Witnessing ends and the game cuts to the open cellar door. A door is the chapter heading. (Canon from Vol 5.)

**Ending epilogues (3):** serve / destroy / publish each get a rostrum epilogue (scripted in Vol 4 §9 and the Epilogue doc). Pure Track A — places, the ledger, VO/text. The publish epilogue carries the interactive email-send as its one live beat, then rostrums out through the network montage.

**Godot side:** Track A outputs are `.ogv`/`.webm` video files played by a `VideoStreamPlayer`, triggered by `GameState` events (new game, `act_changed`, `ending_chosen`). They fade to/from live scenes; the intro and each chapter card hand off to gameplay on their last frame.

**Rule:** Track A is for *establishing* and *transition* — places and voice. The moment a piece needs a character to *perform*, it is no longer Track A. Don't smuggle performance into a rostrum film; that's how Track A's budget quietly becomes Track C's.

---

# PART 3 · TRACK B — IN-ENGINE SCARES (the real horror engine)

**The thesis, restated as method:** the game's best frights already exist in the design bibles and need *no animation* — they need triggers, timing, and the atmosphere systems. They are scarier than any clip because they happen in the live world, react to the player, and are half-caught rather than presented. Track B is where most of the game's dread is actually manufactured, and it is cheap.

**The five Track-B mechanisms** (every scare in the bibles is one of these):

1. **The re-entry change.** An object is different when the player returns. *Rocking horse turned back to the wall (Nursery); the cheval mirror's reflected door open when the real one is shut (Master Bedroom); the bare bedroom furnishing itself across wing visits.* Build: two states, swap on `room_exited`/`room_entered`, never while observed (raycast gate). **No animation — a state swap the player didn't witness.**

2. **The timed reveal.** Something happens at a clock moment, usually 2:47. *The thirteenth window lights (Roof Walk); the blank bell rings; the recorder LED blooms; the mortar weeps in the archway.* Build: `Clock.struck_247` → a light, a sound, a decal. **No animation — a property changing on a signal.**

3. **The glimpse.** Something seen only in periphery or for a held second, never confirmed. *The dust sheet that keeps its shape then collapses (Long Attic); the hook-shadows that fill when you look away (Cold Store); the indentation on the unnumbered bed relaxing as you watch through the ceiling crack.* Build: a shader/visibility trick gated on gaze-direction or a one-shot timeline. **No animation — visibility and shadow tricks.**

4. **The audio scare.** Pure recorder yield / ambient — the scariest are often sound alone. *The 2:47 voice; the dictation from the void; the breathing that stops; the well's five languages.* Build: the Recorder yield table + Atmosphere hum. **No visuals at all** — the cheapest and frequently the most effective.

5. **The animated prop (the only Track-B work that touches Blender).** A single object genuinely moves, on its own, in view. *A door swinging shut and locking itself (the wing's first exit); the chandelier chain swaying; the music box lid opening; the contract page (borderline — see Track C).* Build: a tiny single-object glTF animation (T3 §4, 12fps stepped) played by Godot's `AnimationPlayer`, triggered by event. **Minutes of animation, not days — one object, a few keyframes, no rig, no lip-sync.**

**The discipline:** when a scare is proposed, classify it 1–5 *before* reaching for the animation tools. 1–4 need no Blender clip at all. 5 needs a tiny one. Only if none of the five can carry the moment does it escalate to Track C — and that should be rare.

**Track B catalogue (seed — expand per floor from the bibles):**

| Scare | Mechanism | Room | Cost |
|---|---|---|---|
| Rocking horse turned back | 1 re-entry | Nursery / wing nursery | none |
| Cheval mirror's open door | 1 re-entry | Master Bedroom | none |
| 13th window lights at 2:47 | 2 timed | Roof Walk | light+sound |
| Recorder LED bloom | 2 timed | any (recorder) | done in M0 |
| Blank bell rings 2:47 | 2 timed | Servants' Passage | sound |
| Mortar weeps | 2 timed | Bricked Archway | decal |
| Dust sheet holds shape | 3 glimpse | Long Attic | one-shot anim/visibility |
| Hook-shadows fill | 3 glimpse | Cold Store | shadow meshes |
| Bed indentation relaxes | 3 glimpse | view into Unnumbered | one-shot |
| 2:47 voice / void dictation | 4 audio | many | audio only |
| Breathing that stops | 4 audio | Master Bdrm / wing | audio only |
| Wing door swings + locks | 5 prop | Wing exit | tiny glTF anim |
| Music box opens | 5 prop | Nursery | tiny glTF anim |
| Chandelier sways | 5 prop | Gallery | tiny glTF anim |

---

# PART 4 · TRACK C — CHARACTER PEAKS (capped at 2–3, M4+)

**What it is:** true claymation character performance — a figure moving, possibly speaking, with full 12fps stepped animation. This is the most expensive work in the project (days per shot: rig, animate, the stepped pass, possibly lip-sync), and its power comes *entirely from scarcity*. If characters animate often, none of it lands; reserved for the emotional peaks, each becomes unforgettable.

**The sanctioned list (and nothing beyond it without a real reason):**

- **C1 — Eleanor in the Witnessing (Vol 5, Eleanor's Room).** The one essential character performance. She is present — knitting, or seated at the desk, or simply *there* — during the reading of the journal. Even here, restraint: she barely moves; the power is presence, not action (the novel's "professional courtesy between women with work to do"). This is the game's emotional summit and the single shot most worth animating fully. **Build as glTF stepped animation played in-engine** so she composites with live lamplight and the player's camera — far stronger than a video here, because the player is *in the room* with her.

- **C2 — Eleanor's appearance in the Study choice (Vol 5 / the Choice scene).** Optional sibling to C1; if budget is tight, C2 can be **audio-only** (her voice, no body — equally faithful to the novel, where she is often a voice from nowhere). Default to audio; animate only if C1 went smoothly and time remains.

- **C3 (conditional) — the contract page writing itself (Vol 5 Study).** Borderline Track B/C: it's a *prop* (Track B mechanism 5) but the self-writing-ink effect is a custom shader, not a keyframe anim, so it's cheaper than character work. **Build as a UV-scroll reveal shader** (text texture unmasked progressively) — Track B cost, Track C impact. Listed here only because it reads as "something is performing."

**Explicitly NOT Track C** (resist these — Track B covers them): Caldwell's December visit (he's a *talking-head* scene — can be staged with minimal motion + VO, like a fixed-camera conversation, closer to Track A with a puppet than full performance); Thomas (never appears live — he's diary, ledger, the dictating voice, the turned portrait; the villain is *felt*, never animated, which is scarier and free); any other ghost. The manor is haunted by *absence* — lean on it.

**The pre-render-vs-in-engine call for Track C:** default to **in-engine glTF stepped animation**, because Track C moments happen in rooms the player stands in (the wing), and live compositing (lamp, camera, the player's presence) beats a video that breaks the fourth wall. Pre-render only if a shot needs camera work or effects the engine can't afford in real time — and even then, prefer to keep the player *in* the moment.

---

# PART 5 · THE PIPELINE (all three tracks → Godot)

Per T3's export contract, three handoffs:

- **Track A** → render in Blender to **video** (`.ogv`/`.webm`, 1080p, H.264/VP9) → Godot `VideoStreamPlayer` → triggered by `GameState` signals (new game, act change, ending). Fades bridge film↔live.
- **Track B mech 5 / Track C** → export the animation in the **glTF** (T3 §6), stepped at 12fps (T3 §4) → Godot `AnimationPlayer`/`AnimationTree` → triggered by room/clock events. Composites with live lighting.
- **Track B mech 1–4** → pure Godot: state swaps, signal-driven properties, shaders, audio. No Blender at all.

**Audio across all three:** one narrator (Mara) for Track A VO and Reader Mode; Eleanor's testimony recorded once (serves C1, the wing yields, and the series); the hum/yield library (T2 §3) serves Track B. Record VO sessions once, key everywhere — the standing rule.

**Sync:** Track A is baked (audio in the video file). Track B/C sync in-engine via AnimationPlayer audio tracks or signal timing — the 12fps stepped anim and the audio share a timeline in Godot, no frame-matching headaches because the judder is baked into the curve, not the playback rate.

---

# PART 6 · BUILD ORDER & BUDGET REALITY

1. **Now:** the **intro** (Part 1) — retarget the Ep1 rostrum script; every player sees it; it proves the cinematic pipeline as M0 proves the gameplay one.
2. **Per milestone:** Track B scares as their rooms are built (they're part of room work, not separate — classify each 1–5 and most cost nothing).
3. **M4:** Track A chapter cards + the wing's **C1** (the one essential character performance).
4. **M5:** ending epilogues (Track A) + the stinger; C2 only if C1 went well.
5. **Throughout:** Track A scales freely (data files into one renderer); Track B is absorbed into room building; Track C stays capped.

**The honest budget truth:** Track A is days of work total and high-impact. Track B is mostly *free* (it's triggers and audio you're building anyway) with a handful of tiny prop clips. Track C is the only real animation cost, and capping it at 2–3 is what keeps "animated clips throughout the game" from becoming a year-long black hole. The game *feels* cinematic and full of scares because A and B do the volume cheaply; it feels *profound* in two or three places because C is rare. That ratio — abundant cheap dread, scarce expensive awe — is the whole strategy.

---

# PART 7 · THE PRINCIPLE
T2: push complexity into data. T3: push identity into conventions. T5: **push fear into the live world, and pre-render only voice and place.** The scariest house is the one that moves when you're not looking, speaks when you can't see, and shows you a person exactly twice. Build for that and the cinematics serve the dread instead of interrupting it.

Next deliverable on request: the **intro rostrum script** — the paste-and-run Blender Python that renders Part 1's 18-second intro from your existing R4/R5/R6/R10 stills, VO-ready, exactly as the Episode 1 pilot script rendered its scenes.

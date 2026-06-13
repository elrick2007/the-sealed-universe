# THE WEEPING WALLS — TECHNICAL BIBLE, VOLUME T2
## The Systems Bible · The Eight Engine-Level Systems Every Floor Shares

T1 covered scenes and assets. T2 covers the **systems** — the game-wide machinery that doesn't belong to any one room because it belongs to all of them. These are design-locked (the bibles already decided what they do), so this document specifies *how*, in Godot 4.x terms, at the level a programmer can build from. Each system is written as: **what it is · the data it owns · the API other code calls · build notes · the cheap-trick that makes it affordable.**

Engine split, restated: **Blender authors, Godot runs.** Every system here lives in Godot. Most are **autoload singletons** (Godot's global-script pattern) so any room can reach them without wiring. Recommended autoloads: `Clock`, `Ledger`, `Evidence`, `Recorder`, `Measure`, `GameState`, `Save`. Shaders (`InkRender`, `Breath`) live on materials. The result is that a room scene is almost pure content — it declares its interactables and trusts the singletons.

**The spine that connects all eight:** `GameState` holds the current **Act (1–4)** and a dictionary of **flags**. Every other system reads Act/flags to gate itself. Chapter transitions are just `GameState.set_act(n)` — which fires a signal everything else listens to. This is the whole "open chapters" structure in one variable.

---

# 1 · THE LEDGER — *the game writes the book* (signature system, build first)

**What it is.** Every meaningful player action is transcribed, overnight, into an in-game ledger written in **Mara's handwriting** — readable prose, not a quest log. By the end the player owns a unique, exportable, readable account of their own playthrough: their personal copy of Book One. In the sealed wing the author switches to **Eleanor's hand**; the endings merge or blank the hands accordingly. This is the cheapest spectacular feature in the game, because it is **string templates + fonts**, not AI generation.

**The data it owns.**
```
class LedgerEntry: { id:String, day:int, time_stamp:String, author:enum{MARA,ELEANOR,BOTH}, text:String, witnessed:bool }
var entries: Array[LedgerEntry]
var pending: Array[String]      # event ids logged today, transcribed at next "night"
```

**How prose gets written without AI — the template system.** Each loggable event registers a small set of **prose variants** keyed by event id. The Ledger picks one (seeded by playthrough so it's stable per save), fills slots, and stores it. Example resource (`ledger_templates.tres`, a Dictionary):
```
"dumbwaiter_solved": [
  "The dumbwaiter answers to weight, not to want. Two irons and it sat level with the hatch. Inside, a supper no one came back for.",
  "I balanced the dumbwaiter at last — two counterweights, not three. The car held a cold tray and a servant's note. A. again." ],
"window_count_13": [
  "Thirteen windows on the front. Twelve rooms behind them. I have counted both, twice. The house is one window richer than it has any right to be." ]
```
Slots (`{name}`, `{count}`, `{time}`) fill from event params. Two or three variants per event is plenty — the *illusion* of authored prose comes from voice consistency, not volume, and the voice is fixed because you wrote these lines, in Mara's register, once.

**The "overnight" rule (why entries feel uncanny).** Actions accumulate in `pending` during the day. They transcribe to `entries` only when the clock crosses a night boundary (or on sleep). Timestamps on the written entries cluster around **2:47 AM** — diegetically, Mara writes them in the dark and doesn't fully remember (the novel's exact device). The publish ending's keystone beat: one entry appears that the player's actions never queued — authored, `author = BOTH`, timestamp 02:47.

**API.**
```
Ledger.log(event_id:String, params:Dictionary={})     # queue today's event
Ledger.set_author(author)                              # wing switches to ELEANOR
Ledger.transcribe_night()                              # called by Clock at night boundary
Ledger.get_book() -> Array[LedgerEntry]                # the readable in-game book
Ledger.export_text() -> String                         # "export my playthrough" feature
signal entry_written(entry)
```

**Two-hand rendering.** Generate **two handwriting fonts** once (a "Mara" hand — fast, slanted, modern ballpoint feel; an "Eleanor" hand — careful Victorian copperplate that loosens). Ledger UI renders each entry in its author's font. `BOTH` overlays the two at low offset/opacity. That's the entire visual cost of the most-talked-about feature in the game.

**Build note.** Build this in Milestone 1 with exactly three events (arrive, letter-opener, dumbwaiter). If three entries in Mara's hand, written overnight, read like a person — the system is proven and the rest is just more templates.

---

# 2 · THE CLOCK & 2:47 SCHEDULER — time, the night event, the countdown

**What it is.** The house's clock. Drives day/night, schedules every 2:47 event, hosts the December-2nd countdown, and triggers `Ledger.transcribe_night()`. In the sealed wing it **suspends** (HUD shows "—"). The grandfather-clock pendulum (Vol 2) is what *unlocks player control* of time — before it, the clock runs free and 2:47 is stumbled into; after, the player can wait/sleep to a chosen hour.

**The data it owns.** `var seconds:float`, `var day:int`, `var time_controllable:bool=false`, `var suspended:bool=false`, `var countdown_active:bool=false`, `var deadline_day:int`.

**API.**
```
Clock.now() -> {h,m}            Clock.is_247() -> bool
Clock.wait_until(h,m)           # only if time_controllable
Clock.suspend(on:bool)          # wing entry/exit
Clock.start_countdown(days)     # black book names Mara's date (Vol 5)
signal struck_247               signal night_boundary      signal day_changed     signal deadline_reached
```

**The 2:47 event bus.** Rooms don't each watch the clock; they register. `Clock.struck_247` fires once per night; rooms subscribed via `Recorder` (system 3) resolve their own yield. The clock **strikes thirteen** at 2:47 (audio cue, house-wide) — the one moment the player learns to dread on sight of the time.

**Countdown.** Once `start_countdown` fires (Vol 5 study), the grandfather clock's brass calendar wheel shows days remaining; `deadline_reached` forces the question if the player dawdles past Act 4 entry (design: the house completes its record — soft-fail into an ending, never a game-over screen).

**Cheap-trick.** One scaled accumulator (the M0 script already has it). Everything else is signals. The "house-wide" feel of 2:47 is just a global signal plus per-room audio — no expensive simulation.

---

# 3 · THE RECORDER — place-and-leave audio capture (per-room yield)

**What it is.** Mara's signature tool. Placeable in any room and left running; returning and playing back yields **room×act-specific audio**. Several puzzles are audio-solved. Every yield in the design bibles is **one audio file keyed `room_id × act`** — the system is a lookup table, not logic.

**The data it owns.**
```
var placed_room:String          var running:bool
var captures: Dictionary         # {room_id: [act:audio_path]} resolved on capture
const YIELD_TABLE := preload("recorder_yields.tres")   # the ~45 files + lullaby/loop/hum
```

**API.**
```
Recorder.place(room_id)         Recorder.pickup()
Recorder.on_247(room_id, act)   # called by Clock bus if running in that room
Recorder.play(room_id)          # review a capture
Recorder.has_capture(room_id) -> bool
signal captured(room_id, act)
```

**The two-sources rule (design-locked, enforce in data).** Every audio-critical solution (the lullaby) has **two YIELD_TABLE rows** that satisfy it (e.g. Conservatory *and* Water Tank). The puzzle that consumes it accepts either. This keeps the recorder fair and is purely a data constraint — when authoring `recorder_yields.tres`, never let a required clue have only one source.

**Remote capture (Vol 2).** The dumbwaiter can carry the recorder between floors — `place()` simply sets `placed_room` to the destination. Bugging the kitchen from upstairs is the same call with a different room id.

**Build note.** The Conservatory is the proving ground (strongest yields); build the recorder against it. Until real audio exists, the table points at the M0 placeholder tone tagged with the *text* of the yield (printed to log) so puzzle logic can be tested before VO is recorded.

---

# 4 · THE EVIDENCE BOARD & METER — the publish gate, made diegetic

**What it is.** The kitchen table is the journal. Collected exhibits pin here; strings auto-draw between linked evidence; when enough keystones are present the strings **form a legible shape — the house's own floor plan in red thread** — and the publish ending unlocks. The board also classifies *witnessed-unprovable* items (photos that review as dark) at **half weight**, the game's kindest statement about testimony.

**The data it owns.**
```
class Exhibit: { id, title, weight:enum{FULL,HALF}, keystone:bool, linked_ids:Array }
var collected: Array[Exhibit]
var meter:float                  # sum of weights; FULL=1.0, HALF=0.5
const PUBLISH_THRESHOLD := ...   # keystones required + 60% of optional
```

**Keystones (locked from the audit):** journal · coroner's report · Whitmore's confession drafts · Eleanor's ordered drafts (seal-verified) · the 1887 ice ledger · the black book page 41 (Caldwell "Status: Living") · label backups. Publish requires **all keystones + 60% of optional exhibits**.

**API.**
```
Evidence.add(exhibit_id)        # auto-links via the exhibit's linked_ids
Evidence.verify(exhibit_id)     # Eleanor's seal (Vol 2) flips a draft to verified
Evidence.publish_ready() -> bool
signal exhibit_added(id)         signal threshold_reached
```

**The red-thread shape.** The "strings form the floor plan" is the meter's UI made literal: as `meter` rises, the board's connection lines lerp toward predefined anchor points that spell the manor's plan. At threshold, the shape completes. This is a Line2D/3D animation driven by one float — spectacular, nearly free.

**Build note.** Wire `Evidence` to the Ledger: adding an exhibit also `Ledger.log`s it, so the player's book and their board stay the same story told two ways.

---

# 5 · THE MEASUREMENT SYSTEM — tape measure + Caton overlay (the Compass Lie engine)

**What it is.** The tape measure (Study, Act 1) lets the player pace/measure any room. Most read true; the lying rooms don't. Caton's Field Book (attic, Act 3) **upgrades** the tool into a map overlay that shows submitted-vs-true figures, turning the Compass Lie from atmosphere into a readable system. The wing's corridor is the set piece: 42 interior / 28 exterior.

**The data it owns.** Per measurable space: `{interior_m:float, exterior_m:float, honest:bool}`. Most rooms have `interior==exterior`; the wing corridor, the unnumbered guest room, the void, and the Phantom Stair are the authored exceptions.

**API.**
```
Measure.read(space_id) -> {interior, exterior, delta}
Measure.has_field_book() -> bool     # gates the overlay
Measure.overlay_on_map(space_id)     # draws both figures on MapUI
signal lie_found(space_id, delta)    # pins an exhibit when a delta is first proven
```

**Build note.** Implement as trigger volumes the player paces between, not literal measurement — the "42 feet" is an authored value revealed by completing a pace, not a physics measurement. Honest and reproducible (players will check), but authored, so it never drifts.

---

# 6 · THE INK-RENDER SHADER — unwritten ink (the gating visual)

**What it is.** Gated/unvisited areas render as **pencil-sketch parchment**, not darkness, and bloom into full claymation material as Mara *looks at* them (gaze-driven, slow). Peering through the cellar keyhole in Act 1 shows sketch; the wing renders room-by-room as witnessed. Fuses the parchment maps, the claymation look, and the archive theme into one language.

**How it's built.** A material shader with two states — a sketch texture pass and the full PBR — lerped by a per-instance `witnessed` float (0→1). A gaze raycast from the camera raises `witnessed` on what it dwells on, slowly, like ink spreading. Per-room master `witnessed` for chapter-gated areas; per-surface for the wing's room-by-room reveal.

**API (shader uniform + a tiny manager).**
```
InkRender.set_room(room_id, value:float)      # 0=sketch, 1=full
InkRender.gaze_bloom(surface, delta)          # called by the camera's look-ray
```

**Build note.** This is the wing's showcase and can wait until Milestone 4 — but author **both texture states for every surface from the start** (the sketch pass is cheap: a posterize+edge-detect bake of the full texture, scriptable in Blender as part of T3's export). Cellar keyhole in M-early is the first proof.

---

# 7 · THE BREATHING & ATMOSPHERE SYSTEM — the house is alive (global)

**What it is.** Walls breathe (5s in / 5s out, ±2–3mm), slowing after publication. The room-tone hum is the audio twin, thickening at 2:47 and resolving — in the cellar — into many voices reading. The lamp is the only light the player carries; its radius is honest and **shrinks in the cellar** (the deficit rule).

**How it's built.** M0 already proves the wall pulse (vertex offset on a sine; consider migrating to a vertex shader in T3 for cost). One global `Breath.amplitude` and `Breath.period`; `Breath.slow()` post-publication. The hum is one looping `AudioStreamPlayer` with a low-pass that opens at 2:47. Lamp = an OmniLight on the camera with per-zone `range` (kitchen 4.5, cellar ~3.5 — the 22% deficit Caton's overlay reports).

**API.**
```
Breath.slow()                   # post-publication
Atmosphere.set_zone(zone_id)    # sets lamp range + hum profile per floor
Atmosphere.hum_thicken(on)      # 2:47 / cellar resolve
```

**Build note.** Tie `Breath.slow()` to the publish flag in `GameState`. The single most cost-effective dread in the game is the lamp deficit + fog density (both one number each); spend tuning time there before anywhere else.

---

# 8 · SAVE / LOAD & GAMESTATE — Act, flags, and the three endings (+ NG+)

**What it is.** The backbone. `GameState` holds Act, the flag dictionary, inventory, and the ending path; `Save` serialises all singletons. The **destroy ending IS New Game+**: it serialises a "reset house" variant where the south sick-room chart gains a third column and only the jar list crosses over.

**The data it owns.**
```
GameState: { act:int, flags:Dictionary, inventory:Array, ending:enum{NONE,SERVE,DESTROY,PUBLISH}, ng_plus:int }
```

**API.**
```
GameState.set_act(n)            # fires chapter transition; all systems re-gate
GameState.set_flag(id, val)     GameState.flag(id) -> Variant
GameState.choose_ending(e)      # Foundation Chamber resolves register + epilogue
Save.write(slot)  Save.read(slot)
signal act_changed(n)           signal ending_chosen(e)
```

**The three endings as data, not branches.** Each ending is a flag + an epilogue scene + a register-resolution string (serve→keeper line; destroy→"Filed."; publish→"Incomplete."). The Foundation Chamber's three affordances (pen/oil/send) each call `choose_ending`. The publish gate checks `Evidence.publish_ready()`. Keep endings out of gameplay branches — they're one enum read at the climax — so the 40 hours before don't fork.

**NG+ from destroy.** `Save.write` with `ng_plus+1` and a `reset_house` flag; rooms read that flag for their variant dressing. The Prague key + the unremembered ledger entry are publish-only epilogue items, set by `choose_ending(PUBLISH)`.

---

# 9 · SYSTEM DEPENDENCY MAP (build order within Milestone 1+)

```
GameState ── everything reads Act/flags
Clock ───── Ledger.transcribe_night, Recorder.on_247, countdown, night→Ledger
Ledger ──── reads events from all; Evidence.add also logs
Recorder ── reads Clock bus; YIELD_TABLE (two-sources rule)
Evidence ── reads collected exhibits; gates publish; feeds Ledger
Measure ─── gates on Field-Book flag; pins exhibits to Evidence
InkRender ─ reads room witnessed + GameState act-gates
Breath/Atmos ─ reads publish flag (slow) + zone
Save ────── serialises all of the above
```

**Recommended build sequence:** GameState → Clock → Ledger (the M1 proof) → Recorder → Evidence → Measure → InkRender → Breath/Atmos polish → Save. The first three are Milestone 1. Systems 4–5 are Milestone 2–3. InkRender headlines Milestone 4 (the wing). Save can be stubbed early and finished last.

---

# 10 · THE PRINCIPLE BEHIND ALL EIGHT
Every system is **content-driven, not code-branched**: yields are a table, prose is templates, exhibits are resources, endings are an enum, the Compass Lie is authored values in trigger volumes. This is deliberate and it is what makes a game of this scope buildable by a small team — the *systems* are small and stable; the *content* is large but cheap to add. When in doubt, push complexity into data (a `.tres` resource you can edit without touching code) rather than into logic. The design bibles already wrote most of that data; T2's job was only to say where it plugs in.

Next technical deliverable on request: **T3 — The Art & Shader Pipeline Bible** (the Blender side: clay master shader spec, 12fps-stepped claymation rig convention, the glTF export contract, sketch-pass baking for InkRender, and how the series renders convert to game textures).

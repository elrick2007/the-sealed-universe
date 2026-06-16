# THE WEEPING WALLS — BLENDER ENVIRONMENT CONSTRUCTION BIBLE (T6)
## Every room, every dimension · the modular kit · doors, walls, ceilings, mechanics anchors, UI layouts

This is the document a modeller opens Blender with. It converts the design bibles (Vol 1–5) and the Room Manifest into buildable geometry: a shared modular kit, then per-room dimensions for all ~45 locations, then the mechanics-anchor and UI specifications. It obeys the T3 export contract throughout (1 unit = 1 m, Y-up to Godot, `ww_*` tags, clay master shader).

**Reading order for a build session:** §1 global standards → §2 the kit → the floor section you're building (§4–§9) → §10 mechanics anchors → §11 UI. Build greybox to these numbers first; dress second.

---

# 1 · GLOBAL STANDARDS (never deviate without a note)

| Standard | Value | Why |
|---|---|---|
| Unit scale | **1 Blender unit = 1 metre** | T3 export contract; Godot parity |
| Grid / snap | **0.25 m** fine, **0.5 m** module base | rooms lay out on a half-metre grid |
| Interior wall thickness | **0.20 m** | reads solid at FP scale |
| Exterior/load wall thickness | **0.40 m** | and enables the Compass-Lie cavity (wing) |
| Floor slab thickness | **0.15 m** | |
| Ceiling slab thickness | **0.15 m** | |
| Door opening (standard) | **0.9 m W × 2.1 m H** | Victorian domestic |
| Door opening (grand/double) | **1.6 m W × 2.4 m H** | entrance, wing doors, dining |
| Door opening (servant/low) | **0.75 m W × 1.95 m H** | west wing, attic, cellar |
| Doorframe reveal | **0.05 m** trim proud of wall | |
| Skirting / baseboard | **0.15 m H × 0.02 m proud** | |
| Picture rail (family rooms) | **at 2.0 m** | |
| Window (sash, standard) | **0.9 m W × 1.6 m H, sill 0.9 m** | |
| Window (bay, 3-pane) | **2.4 m W × 1.7 m H, sill 0.45 m** | Maid IV, Morning Room |
| FP eye height | **1.6 m** | matches the M0 camera |
| Interaction reach | **1.6 m** table / **1.2 m** small prop | matches M0 |
| Lamp ranges | ground **4.5**, upper **4.2**, attic **3.8**, **cellar 3.5**, wing **4.0** | T3 §2 deficit rule |

**Ceiling heights by zone** (the single most identity-defining dimension — players read floor by headroom):
- **Ground floor (public):** 3.2 m — grand, cold, the house performing wealth.
- **Ground floor (service: kitchen, back stair):** 2.8 m — lower, working.
- **First floor west (servants):** 2.6 m — meanest headroom in the house.
- **First floor east (family):** 3.0 m — generous but domestic.
- **Attic:** 2.4 m ridge, sloping to **1.1 m** at eaves (mansard; the slope is the horror — you stoop).
- **Cellar:** 2.4 m, vaulted bays dropping to **2.1 m** at the springing — oppressive.
- **Sealed wing:** 3.0 m — matches family, but the corridor lies (see §9).

---

# 2 · THE MODULAR KIT (build once, reuse everywhere)

One library file, `WW_Kit.blend`, linked into every room. Pieces snap on the 0.5 m grid. This is what makes ~45 rooms buildable: you assemble from the shelf, you don't model each room from scratch.

**Wall modules** (height = zone ceiling height; author one set per ceiling height):
- `Wall_2m`, `Wall_1m`, `Wall_0.5m` — plain segments, thickness 0.20.
- `Wall_door_std` — 0.9×2.1 opening pre-cut, frame included.
- `Wall_door_double` — 1.6×2.4 opening.
- `Wall_window_sash`, `Wall_window_bay` — openings + reveal.
- `Wall_ext_0.4` — thick exterior variant (Compass-Lie cavity).
- All carry `ww_breathing=1` and inward-facing normals (T5 breath system).

**Floor / ceiling tiles** (1.0 × 1.0 base, also 0.5 fillers):
- `Floor_board` (family/ground), `Floor_stone` (kitchen/hall/cellar), `Floor_quarry` (service), `Floor_bare` (attic), `Ceiling_plain`, `Ceiling_beam` (attic/kitchen).

**Trim kit:** `Skirt`, `PictureRail`, `Cornice_plain`, `Cornice_ornate` (ground public only), `Doorframe`, `Architrave`.

**Door props** (separate from openings, animate via `AnimationPlayer`): `Door_panel_std`, `Door_panel_double`, `Door_iron_banded` (wing), `Door_handleless` (cellar — no handle mesh), `Door_painted_shut` (back stair — seam decal).

**Stair kit:** `Stair_run_straight` (12 steps, rise 0.18 / going 0.25), `Stair_winder`, `Stair_servant_narrow` (0.8 m wide).

**Naming:** every placed module keeps its kit name + a room prefix on export (`Kitchen_Wall_N`, etc.) so Godot finds walls by `Wall_*` (T3 §6).

---

# 3 · ROOM SPEC FORMAT
Each room below gives: **Footprint (W × D)** interior in metres · **Ceiling** (zone default unless noted) · **Doors** (count + type + which wall) · **Windows** · **Key fixed geometry** (built, not dressed) · **Lamp zone** · **Build milestone**. Dressing/props live in the design bibles; this is the shell + fixed mechanics geometry.

---

# 4 · GROUND FLOOR (ceiling 3.2 public / 2.8 service · lamp 4.5)

**Entrance Hall** — 6.0 × 7.0 · ceiling 3.2 (double-height stairwell void to 6.4 over the stair) · Doors: front double (1.6×2.4, S wall) + 4 std (to Library, Dining, Study, corridor) · Windows: 2 sash flanking door · Fixed: Grand Staircase (winder, rises into void; **blocked at half-landing by the fallen chandelier mesh** until winch), chandelier winch mount on ceiling, portrait niche (Eleanor). · M2.

**Dining Room** — 5.0 × 6.0 · 3.2 · Doors: 1 double (Hall) + 1 service (to kitchen passage) · Windows: 2 sash, W wall · Fixed: sideboard recess (letter-lock drawer geometry), 12 chair footprints around table, portrait rail. · M1 (letter opener).

**Library** — 5.0 × 5.0 · 3.2 · Doors: 1 std · Windows: 1 tall sash · Fixed: floor-to-ceiling shelving on 3 walls (the anonymous shelf = 1 bay, tagged no-photo), fireplace + **flue interior** (rope-retrieval cavity, 0.6×0.6 reachable). · M3.

**Study (public)** — 4.0 × 4.5 · 3.2 · Doors: 1 std · Windows: 1 sash · Fixed: desk footprint, 2 ledger shelves, map-roller mount, drawer (WOOL letter-lock). · M3.

**Kitchen (HUB)** — 6.0 × 5.0 · **2.8** · Doors: 1 std (passage) + 1 to West Wing Hall + dumbwaiter hatch (0.6×0.6 at 1.1 m) + pantry arch · Windows: 1 sash N (moonlight) · Fixed: the table (1.6×0.9, centre — board+ledger+dock anchor), range recess, dumbwaiter shaft (full height to first floor), breathing-wall tutorial panel (any wall). · **M0/M1.**

**West Wing Hall** — 2.2 × 8.0 (corridor) · 3.2 · Doors: kitchen, cellar (handleless), back-stair, sconce niches · Fixed: framed floor-plan mount (map UI), the cellar door (no handle mesh). This is the *honest* measurement control sample — interior = exterior here. · M1.

**Back Stair** — 0.9 × 3.0 run · 2.8 · `Stair_servant_narrow`, painted-shut door at top (seam decal). · M2.

**Master Bedroom** — 5.0 × 5.5 · 3.0 (sits over service, family-height) · Doors: 1 std + washroom · Windows: 2 sash · Fixed: cheval-mirror rig (reflects a door-mesh that can open independently), loose floorboard cavity, wardrobe (WOOL case interior). · M3.

**Washroom** — 2.5 × 3.0 · 3.0 · Doors: 1 · Windows: 1 small high · Fixed: mirror (steam-write shader plane), basin + trap. · M3.

**Nursery** — 4.0 × 4.5 · 3.0 · Doors: 1 · Windows: 1 sash (barred) · Fixed: rocking-horse anchor (re-entry state), cradle, music-box shelf (socket). · M3.

**Chapel Room** — 4.0 × 5.0 · 3.2 (taller, ecclesiastical) · Doors: 1 · Windows: 1 lancet (coloured) · Fixed: 5 candle spikes (death-date puzzle), grille niche, register stand. · M3.

**Conservatory** — 5.0 × 6.0 · glass roof, ridge 4.0 sloping to 2.5 eaves · Doors: 1 + garden door · Walls: 3 glazed (frost-etch pane = 1 panel, shader) · Fixed: planting benches, centre tub (lemon tree, `Emissive_Lemon`), the living lemon. · M3.

---

# 5 · FIRST FLOOR — WEST / SERVANTS (ceiling 2.6 · lamp 4.0)

**Servants' Passage** — 1.8 × 9.0 corridor · 2.6 · Doors: 4 maid rooms + housekeeper + box room + connecting door · Fixed: bell board (12+1 mounts), dumbwaiter upper hatch. · M3.

**Maid's Room I–IV** — each **3.0 × 3.5** · 2.6 · Doors: 1 servant-low each · Windows: 1 small each (IV = bay, scorch shadow on floor; III = blackable window plane). · Fixed: bed, wardrobe (II has pry-panel back). · M3.

**Housekeeper's Room** — 3.5 × 4.0 · 2.6 · Doors: 1 · Windows: 1 · Fixed: ledger desk, master bell legend, sewing-box rig (3-dial + mirror slot), pendulum mount. · M3.

**Box Room** — 4.0 × 4.0 · 2.6 (stacked cases reduce headroom feel) · Doors: 1 · Fixed: 14 case footprints on shelving, Whitmore's modern case. · M3.

**Connecting Door** — two-face mesh in the passage↔east wall: blank (W) / bolted (E). · M3.

---

# 6 · FIRST FLOOR — EAST / FAMILY (ceiling 3.0 · lamp 4.2)

**Gallery Landing** — 4.0 × 6.0 (overlooks Entrance Hall void) · 3.0 → open to stairwell · Doors: to guest rooms + morning room · Fixed: raised chandelier (close-up, handprint decal), winch beam, balustrade over the void. · M3.

**Guest Bedroom (UNNUMBERED)** — **interior 4.0 × 5.0, but window wall reads 3.0 m short from outside** (first measurable lie — build the exterior shell 1 m inboard of the interior). · 3.0 · Doors: 1 · Windows: 1 (impossible) · Fixed: bed (overnight-trade controller), guest book stand. · M4.

**Guest I + Bath (Whitmore)** — 4.0 × 4.5 (+2.0×2.5 bath) · 3.0 · Doors: 1 + bath · Fixed: doctor's-bag spot, mirrored cupboard (chatelaine/bottle). · M3.

**Guest Bedroom II (1924)** — 4.0 × 4.5 · 3.0 · Doors: 1 · Windows: 1 · Fixed: height-mark doorframe (decal), toy-theatre stand, trunk. · M3.

**Eleanor's Morning Room** — 4.5 × 5.0 · 3.0 · Doors: 1 · Windows: 1 bay · Fixed: embroidery frame, Thomas-portrait (turn-state), pigeen-hole desk (draft-order puzzle), window seat, blotter, **seal stand** (verify mechanic). · M3.

---

# 7 · ATTIC (ridge 2.4 → eaves 1.1, mansard · lamp 3.8)

Build the slope from `Wall_2m` + angled `Roof_slope` modules; the player stoops below the purlin line. Headroom IS the dread.

**Attic Stair + Door** — 0.8 × 3.0 narrow run + low chatelaine door (0.7×1.8). · M3.

**Long Attic** — 3.0 × 12.0 (spine; slope both sides) · ridge 2.4 · Fixed: bell-wire spline run, dust-sheet anchors, 2 crawl-space openings (sightline into Unnumbered Room below), chalk hopscotch decal on floor. · M4.

**Water Tank Room** — 3.5 × 4.0 · 2.2 (tank dominates) · Fixed: cistern (recorder-composite), 3-valve rig, trunk. · M4.

**Sick Room North** — 3.0 × 3.5 · 2.2 · Fixed: bed, washstand, fever-chart mount. (Mirror-link driver.) · M4.

**Sick Room South** — 3.0 × 3.5 (mirror of North) · 2.2 · Fixed: 2nd chart, mirror-chest (linked transform to North). · M4.

**The Void** — *no interior.* A clean exterior wall in the Long Attic with a wire-hole (0.05) and a recorder-post slot. Build as solid; it never opens. · M4.

**Roof Walk** — exterior parapet deck 1.5 × 8.0 · open sky · Fixed: 13 façade-window instances (count vs 12 rooms), the 13th window (lights at 2:47). · M4.

**Phantom Stair** — procedural: `Stair_run_straight` instanced N times from a property (28 down / 30 up / +1 per cycle); Act-4 variant terminates at `ArchwayInterior`. · M4/M5.

---

# 8 · CELLAR (ceiling 2.4 → 2.1 vault springing · lamp **3.5** deficit)

Vaulted brick bays; lamp range cut to 3.5 and fog up — the dark eats more here by design.

**Cellar Stairs** — 0.9 × 3.0, 12 steps (honest both ways) · door with inside handle only. · M5.

**Undercroft** — 6.0 × 8.0, brick pillars on a 2.0 grid · vault 2.4→2.1 · Fixed: 47 numbered hooks (wall), bootprint decals (from the archway wall). · M5.

**Caton Pillar** — one pillar in the Undercroft, 0.6×0.6, carved-initials decal sheet + blank palm-space + chisel spot. · M5.

**Wine Cellar** — 3.0 × 4.0 · 2.2 · Fixed: bottle racks, 3 standing-bottle anchors, label-roll rack. · M5.

**Coal Room** — 3.0 × 3.5 · 2.2 · Fixed: coal chute (light shaft), coal-face mesh (3 dig-states → breach to Foundation Chamber). · M5.

**Cold Store** — 3.0 × 3.5 · 2.2 · Fixed: shadow-only hook meshes (on a separate light layer), slate shelves (ice ledger), ice block. · M5.

**Well Room** — 3.5 × 3.5 · 2.4 · Fixed: well shaft (recorder-lower via flue rope), windlass rig, bucket+jar anchor. · M5.

**Bricked Archway** — an arch in the Undercroft wall: loose-brick mesh, weep-decal at 2:47, one-shot `ArchwayInterior` glimpse cavity behind. Never opens. · M5.

**Foundation Chamber** — 5.0 × 5.0, rough-hewn (behind the coal breach) · 2.4 · Fixed: the original-book stand, writing stand (pen), oil+matches spot. The three-ending staging. True-silence zone. · M5.

---

# 9 · SEALED WING (ceiling 3.0 · lamp 4.0 · the corridor lies)

**The Compass-Lie build (critical):** the corridor's **interior length = 14.0 m**, but its **exterior footprint = 9.3 m** (≈42 ft vs 28 ft). Build the interior corridor at 14.0 m; build the exterior wing shell at 9.3 m; the 4.7 m difference is absorbed in a non-Euclidean seam the player can only detect by measuring (Measure volumes `Measure_wing_int`=14.0, `Measure_wing_ext`=9.3). Doors open **outward** (hinge meshes on corridor side).

**Wing Doors** — double iron-banded (1.6×2.4), open outward, keyhole (sketch-render pre-key). · M4.

**The Corridor** — **2.2 × 14.0** interior · 3.0 · 4 doors left + 1 end · Fixed: measurement volumes, gaze-driven ink-render surfaces. · M4.

**First Door — Bare Bedroom** — 3.5 × 4.0 · 3.0 · 4 accumulation dressing-states. · M4.

**Second Door — Sewing Room** — 3.5 × 4.0 · 3.0 · Fixed: dress-form, work table, hem-stitch rig. · M4.

**Third Door — Second Nursery** — 3.5 × 4.0 · 3.0 · Fixed: wrapped cradle, rocking horse (stays-turned state). · M4.

**Fourth Door — Thomas's Study (rose room)** — 4.0 × 4.5 · 3.0 · Fixed: desk (diary), shelf (black-book relocation slot), contract-page plane (self-writing shader), rose vase (`Emissive`). Opens after journal pg1. · M4.

**The Room at the End — Eleanor's Room** — 4.5 × 5.0 · 3.0 · Fixed: bed (hospital corners), washstand, **writing desk** (journal + wet loose-page), wardrobe (black book), **window portal** (separate "always-September" world behind glass; does not exist from the garden exterior). The Witnessing staging. · M4.

---

# 10 · MECHANICS ANCHORS (where the systems attach in geometry)

Every system from T2 needs a physical anchor in the mesh. Author these as empties or tagged sub-meshes so Godot wires them on import:

- **Recorder dock** — kitchen table, empty `Dock_Recorder`. Place-and-leave spots in every room = empty `RecSpot_<room>` at table/shelf height (1.0 m).
- **Ledger / board** — kitchen table, empties `Anchor_Ledger`, `Anchor_Board` (the red-thread Line2D origin).
- **Measurement volumes** — box volumes `Measure_<space>` with `interior_m`/`exterior_m` custom props (every honest room: equal; the four liars: unequal — Unnumbered Room, wing corridor, the Void, Phantom Stair).
- **Clock/2:47** — `Anchor_Clock` (Entrance Hall grandfather clock; hosts countdown wheel post-Vol5).
- **Ink-render** — per-surface `witnessed` float; per-room master on gated areas (cellar keyhole, all wing surfaces).
- **Breathing** — every `Wall_*` already tagged; the kitchen tutorial panel = `Wall_Tutorial`.
- **Interactables** — every prop carries `ww_interact="<verb>"`; hero props carry `ww_prop="<id>"`.
- **Doors** — `Door_*` meshes with `AnimationPlayer` (swing/lock); the cellar `Door_handleless` has no handle sub-mesh by design; the wing doors swing **outward**.
- **Endings** — Foundation Chamber: empties `Affordance_Pen`, `Affordance_Oil`, `Affordance_Send`.

---

# 11 · UI LAYOUTS (Godot Control nodes, authored to these specs)

The UI is diegetic-first: most "menus" are objects (the ledger is a book, the map is parchment). Screen-space UI is minimal.

**HUD (in-play, sparse):**
- **Lamp/oil** — bottom-left, a small flame icon; dims as oil low. No bar unless critical.
- **Clock** — top-right, small; reads time, shows "—" in the wing, shows the **Dec-2 countdown wheel** once active. The only persistent numeric element.
- **Interaction prompt** — centre-low, short verb text in Mara's voice register (no floating icons over objects; a single contextual line).
- **No health, no minimap, no objective marker.** The house is not a game that nags.

**The Ledger (full-screen diegetic book):**
- Opens as a two-page parchment spread, entries in Mara's handwriting font (Eleanor's in the wing; `BOTH` overlaid post-publish).
- Newest entry bottom-right; page-turn interaction; an **Export** affordance (player's playthrough as text).
- Layout: 60% page / 20% margin / 20% facing notes. Timestamps clustered ~02:47 (the uncanny beat).

**The Evidence Board (the kitchen table, world-space UI):**
- Pinned exhibits as cards; `Line2D` red thread auto-links; the publish meter is the thread *forming the floor-plan shape* (no bar). Half-weight (witnessed-unprovable) exhibits render translucent/dashed.

**The Map (parchment, full-screen):**
- The four Caton survey maps + Eleanor's wing journal-page as literal textures; Caton overlay = a toggle layer drawing interior-vs-exterior figures (the Compass Lie made visible). No "you are here" dot until the Field Book upgrade.

**Chapter cards (between acts):**
- Full-screen, pressed-clay/handwritten title over a rostrum still (T5 Track A). Ch4 has none (the open cellar door is the heading).

**Main menu:**
- R4 manor rostrum loop background; title in pressed clay; entries: New Game · Continue · Reader Mode · Settings. Reader Mode greyed until first completion.

---

# 12 · BUILD ORDER (geometry, mirroring the milestones)
M0: Kitchen shell (this bible §4) — done/in progress. · M1: + West Wing Hall + Dining shells. · M2: Entrance Hall (incl. stairwell void + blocked chandelier), Back Stair. · M3: ground bedrooms/library/study/chapel/conservatory + first-floor west & east shells. · M4: attic + the sealed wing (incl. the Compass-Lie corridor build). · M5: cellar (deficit lighting) + Foundation Chamber. Dress each in design-bible order after its shell passes greybox.

**The principle:** every number here is a *starting* dimension chosen for FP comfort and Victorian proportion; the M0 look-test may tune a few (corridor widths especially), and when it does, overwrite the value and note it — same discipline as the provisional T4. Build the shell to these, prove it walks right, then dress.

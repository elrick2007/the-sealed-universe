# THE WEEPING WALLS — TECHNICAL PASS, VOLUME T1
## UPBGE / Blender Production Plan · Scene List · Asset Manifest · Render Reuse Map

Target stack (from your installed tooling): **Blender 5.1** for all asset authoring, **UPBGE 0.50** (Blender 5.0-based) as the runtime — one ecosystem, assets flow author→engine without export friction. The blender-mcp add-on (localhost:9876) means scene assembly can eventually be driven from chat via Claude Desktop; until then, every build task below is scriptable the same way the Episode 1 rostrum script worked: I write the Python, you run it.

---

# 1 · THE LOOK: HOW CLAYMATION SURVIVES BECOMING A GAME

The series renders are *photographs of miniatures*. The game must read as the same world walked through. Three rules achieve it cheaply:

1. **One clay master shader** (Principled BSDF preset): high roughness (0.8–0.95), subtle subsurface on "flesh" clays, a tiling fingerprint/tool-mark normal map (generate once from your R1/R2 close-ups — the thumbprints are literally in the renders), 2–4% hue noise so no surface is flat. Every prop and character inherits it.
2. **Miniature-set camera language:** first-person FOV slightly long (~50mm equivalent), gentle depth-of-field at interaction distance, vignette — the player is a macro lens inside a model.
3. **12fps hold on animation, not on camera:** characters and props animate stepped (Blender's "stepped interpolation" F-modifier / UPBGE anim playback at 12fps) while the camera moves smooth at full rate. This is the modern stop-motion-game trick: judder in the world, silk in the eye. It also halves animation workload — a production gift, not just a style.

Plus the two bespoke shaders the bibles demand: **unwritten-ink** (a world-space dissolve from a pencil-sketch texture pass to full material, driven per-room by a "witnessed" property — author both states, lerp in shader) and **breathing walls** (a 10-second sine displacement at ±2–3mm on wall meshes, amplitude exposed as a global property so it can slow after publication).

---

# 2 · SCENE LIST (.blend organisation)

One library file per floor, rooms as Collections, linked into a master; UPBGE scenes assembled from the same collections. Suffix _S = has scripted sequence.

**WW_Ground.blend** — EntranceHall_S (chandelier states ×2, portrait, clock + countdown wheel) · DiningRoom (12 settings, place-card puzzle props) · Library (anonymous shelf, flue interior) · Study (ledger shelves ×2, map roller, letter-lock drawer) · Kitchen_S (HUB: table/board/ledger/dock, dumbwaiter shaft lower, breathing-wall tutorial) · WestWingHall (plan frame, cellar door states ×3) · BackStair · MasterBedroom (cheval mirror rig, jewellery box) · Washroom (steam/mirror-writing FX) · Nursery (music box, horse states) · Chapel (5 candle spikes, grille niche, register) · Conservatory (lemon trees, living tree, frost-etch pane) · WingDoors_S (Chapter 3 threshold).

**WW_First.blend** — ServantsPassage (bell board rig — 12 labelled + 1 blank, DW upper hatch) · MaidI–IV (IV: scorch decal, blacked-window scrape mask) · Housekeeper (sewing-box dial rig, chatelaine, pendulum) · BoxRoom (14 tagged cases + agreements) · ConnectingDoor (two-face mesh: blank west / bolted east) · GalleryLanding_S (raised chandelier close, handprint decal, camera-verb tutorial) · GuestUnnumbered_S (overnight-trade controller, reset logic) · GuestI+Bath (Whitmore set) · GuestII (toy theatre rig, height marks) · MorningRoom (pigeonholes, watermark light-check, window seat).

**WW_Attic.blend** — AtticStair · LongAttic (wire-trace spline + crawl spaces, sheet rigs incl. the one-empty-sheet event) · WaterTank (3-valve rig, drain water level, tin) · SickNorth / SickSouth (mirror-link constraint system: south mirrors north's prop transforms; reverses after 2:47) · Void (exterior only — clean-wall material, wire hole, recorder-post slot) · RoofWalk_S (façade window instances ×13, the lit-window 2:47 event) · PhantomStair_S (procedural step-count: stair collection instanced N times from a property; N=28 down / 30 up / grows per cycle; Act-4 dark-descent variant ends at ArchwayInterior_S).

**WW_Cellar.blend** — CellarStairs · Undercroft (pillar array, bootprint decals, 47 hooks) · CatonPillar_S (initials decal sheet, chisel choice) · WineCellar (3 standing bottles, label-roll rack, 1887 port) · CoalRoom_S (3-stage coal-mass states, breach reveal) · ColdStore (hook-shadow projector trick: shadow-only meshes on a light layer the hooks aren't on) · WellRoom_S (windlass rig, recorder-lowering sequence, jar + list incl. moth-and-mountain) · BrickedArchway_S (loose brick, weep decal at 2:47, interior one-shot) · FoundationChamber_S (testament book page rig, three-affordance staging, endings).

**WW_Wing.blend** — Corridor_S (42/28 measurement volumes, ink-render gaze driver) · BareBedroom (4 accumulation states) · SewingRoom (hem-stitch minigame rig) · Nursery2 (Boston letter) · PrivateStudy_S (diary, contract self-writing shader — UV-scroll reveal mask over the text texture, relocation logic, the date beat) · EleanorsRoom_S (frozen-window sky rig: separate "September" world on a window portal; journal haptic flags; the Witnessing sequence).

**WW_Systems.blend / .py** — MainMenu (R4 hero) · LedgerUI (two-hand font pipeline: generate "Mara" and "Eleanor" handwriting fonts once; ledger composes entries from templated strings — this is the self-writing-book feature and it is mostly *string templates + font*, deliciously cheap for what it buys) · EvidenceBoard (pin/string graph, meter, witnessed-unprovable half-weight class) · RecorderUI (per-room yield table — every yield in the bibles is one audio file keyed room×act) · MapUI (your four parchment maps + Eleanor's wing page as literal textures; Caton overlay as a second layer) · Clock/Calendar (2:47 scheduler, Dec 2 countdown) · ChapterCards · Stinger_S.

---

# 3 · ASSET MANIFEST — EXISTING RENDERS → IN-GAME USES

Your generated art is already a content pipeline. Direct reuses (zero new cost):

| Asset | In-game uses |
|---|---|
| R4 manor exterior | Main menu (slow rostrum loop via the Ep1 script), intro matte, box art, every "window view" impostor card, Roof Walk distant set extension |
| R1 Mara turnaround | Character modelling sheet (she's mostly first-person: build **FP hands/forearms in navy knit** + a full puppet for mirrors/endings), pause-menu portrait |
| R2 Mara face | Cheval-mirror reflection portrait states, save-slot icon, clay shader reference (lift the fingerprint normal map from this render) |
| R3 Price | December-First-adjacent lore photo (Price's card), intro cutscene puppet ref — Price never appears in-game live; Caldwell needs a NEW puppet (re-prompt R3's style: older, neat, wool coat, briefcase) |
| R5 kitchen | Hub lighting bible, loading screen, Reader Mode still |
| R6 entrance hall · R7 corridor/doors · R8 dining | Set-dressing bibles per room + **evidence-photo textures** (when Mara photographs a room, the photo in the board IS a crop of these renders — the player's photos matching the series' look is free transmedia glue) |
| R9 keys · R10 recorder | Inventory icon sources, prop modelling refs; R10 is also the save-screen image and the Scene 14/15 stinger |
| 4 parchment maps + Map D (wing page) | **Direct UI textures** — the in-game map is literally these documents |
| Episode 1 rostrum renders (Blender MP4s) | **Reader Mode** cutscene library + marketing; the series VO = Reader Mode narration track |
| S1–S3 stinger stills | The post-credits epilogue, as authored |

**New-build priority list (the actual work):** Tier 1 (vertical slice): FP hands · recorder (hero prop, fully interactive) · oil lamp · tape measure · notebook/ledger · kitchen + WestWingHall + cellar door meshes · clay master shader · breathing-wall shader · ledger fonts. Tier 2: journal, black book, testament book (the three hero books — temperature haptics flagged), iron key, chatelaine, candles, music box, jewellery box, pendulum, camera/phone. Tier 3: per-room dressing passes in bible order Vol 1→5. Characters: Eleanor puppet (one, well — she carries Acts 3–4), Caldwell puppet (one scene, fully voiced), Mara full puppet (endings/mirrors only).

**Audio manifest note:** the bibles' per-room recorder yields total ~45 unique files plus the lullaby, the loop, the hum bed, and Eleanor's 40-minute testimony (record it once — it's also the series' Episode-bible audio: one session, two products, again).

---

# 4 · BUILD ORDER

**Milestone 0 — Look test (1 scene):** Kitchen at night in UPBGE: clay shader, breathing wall, lamp radius, recorder on table, one 2:47 audio event. If this *feels* right, everything downstream is content, not research.
**Milestone 1 — Vertical slice (Act 1 spine):** Kitchen ↔ Hall ↔ WestWingHall ↔ cellar-door refusal ↔ Dining letter-opener ↔ recorder yield ↔ ledger writes its first entry overnight. Ten minutes of play containing every signature system in embryo.
**Milestone 2 — Act 1 complete** (dumbwaiter, back stair, chapter card 2). **M3** — Floors 1+attic shells, measurement system, Caton overlay. **M4** — Wing (the showcase: ink-render, author-shift, Witnessing). **M5** — Cellar, endings, countdown, Caldwell scene, stinger. **M6** — Reader Mode assembly from series assets.

Next concrete deliverable on request: the **Milestone 0 build script** — a paste-and-run Blender/UPBGE Python that assembles the kitchen look-test from a folder of placeholder meshes, exactly like the Episode 1 pilot script worked.

# THE WEEPING WALLS — TECHNICAL BIBLE, VOLUME T3
## The Art & Shader Pipeline Bible · The Blender Side · How a Claymation Film Becomes a Game

T1 = scenes & assets. T2 = the runtime systems (Godot). T3 = the **authoring pipeline** (Blender) and the **look contract** that guarantees the game reads as the same world as the series renders. This is a *convention* document: it specifies the rules every asset obeys so that anything any artist (or any AI generation, or any future Claude session) produces drops into the engine looking like *The Weeping Walls* and not like a different game wearing its name.

**The one-sentence thesis:** the series is *photographs of clay puppets on miniature sets*; the game must read as *that world, walked through, at 12 frames a second in the hands and silk in the eye*. Everything below serves that sentence.

**Pipeline direction, fixed:** Blender authors → glTF (.glb) → Godot runs. Blender owns geometry, UVs, materials-as-authored, the clay look-dev, and the stepped-animation convention. Godot owns lighting, post, gameplay materials-at-runtime, and the two live shaders (ink-render, breath). The handoff is the glTF export contract (§6) — get that right and the two halves never fight.

---

# 1 · THE LOOK CONTRACT (the rules nothing may break)

Five rules. If an asset violates one, it will look wrong in-engine no matter how good it is in isolation.

1. **Everything is clay or built from real materials.** No surface is "digital-clean." Clay puppets, plasticine with visible fingerprints and tool marks; sets of balsa, painted card, real fabric, fine grit. The clay master shader (§3) enforces this on every mesh by default — the artist opts *out* for the rare slick surface (glass, the recorder's screen), never *in*.
2. **The hand is visible.** Fingerprints, tool marks, seams, the slight asymmetry of handmade things. Symmetry is the enemy; a 2–4% variation (hue noise, normal jitter, position offset) on every repeated element kills the "stamped" CG look.
3. **Miniature scale lighting.** Light behaves as if the set is 30cm across and lit by tiny practical sources — short, warm key against deep cold shadow, fast falloff, shallow depth of field at interaction range. (Godot owns the lights, but Blender look-dev must preview under these conditions or materials get authored for the wrong light.)
4. **12fps in the world, full-rate in the eye.** Characters and prop animation play **stepped at 12fps** (the stop-motion judder). The *camera* moves smooth at full framerate. This is the single most identity-defining rule and it is also a production gift — see §4.
5. **Muted Victorian palette, locked.** Slate grey, bone, dried-blood burgundy, candle amber, lemon (conservatory), rose-charcoal (wing). No saturated colour enters the manor except the recorder's red LED and the living lemon — both of which therefore *mean* something. Palette is enforced as a shared Blender material library (§3) and a Godot palette resource.

---

# 2 · COLOUR & LIGHT BIBLE (per-zone, so every floor is recognisable in a screenshot)

Each floor has a signature so a player always knows where they are from one frame. Authored in Blender look-dev, finalised by Godot's `Atmosphere.set_zone` (T2 §7).

| Zone | Key light | Shadow | Accent | Lamp range | Hum |
|---|---|---|---|---|---|
| Kitchen / hub | candle amber, warm | cold blue (window) | recorder red | 4.5 | base, soft |
| Ground floor halls | single failing sconce | near-black | burgundy runner | 4.0 | base |
| Library/Study | shafted grey daylight | pewter | warm-book glow | 4.2 | base |
| Conservatory | cold north glass-light | frost blue | **living lemon** | 4.3 | thickens fast |
| First floor — west (servants) | whitewash, bare | hard | none (bare) | 4.0 | base |
| First floor — east (family) | lamp-warm, papered | soft | rose posy | 4.2 | base |
| Unnumbered room | hotel-perfect even light | *too even* | fresh roses | 4.5 | **dead silence** |
| Attic | slate-gap daylight blades | deep | none | 3.8 | wind + shelving |
| Roof Walk (2:47) | moon + the 13th window | sky | the lit window | open | pacing through slate |
| Cellar | lamp only, **deficit −22%** | absolute, dense | none | **3.5** | resolves to voices |
| Sealed wing | the September afternoon bleeding from one door | layered, no fog | rose | 4.0 | absent (out-of-phase breath) |
| Foundation Chamber | the three affordances lit, nothing else | total | — | tight | **true silence** |

Two house-wide truths: **the player carries the only reliable light**, and **saturated colour is reserved** (red LED, lemon, the wing's roses). When you break either, break it on purpose.

---

# 3 · THE CLAY MASTER SHADER (Blender authoring spec)

One master material, variant per surface family. Authored in Blender so it previews correctly; exported as standard PBR so Godot reads it without custom shaders (the *gameplay* shaders are separate and live in Godot — §5/T2). The M0 script already builds a first version; this is the production spec.

**Node graph (Principled BSDF based):**
- **Base Colour** ← palette swatch → MixRGB (COLOR, fac 0.02–0.04) ← Noise (scale 14–20) for hue variation. *Rule 2.*
- **Roughness** 0.80–0.95. Clay is matte. Slick exceptions (glass, screen, glaze) drop to 0.1–0.3 and are explicitly named `*_slick`.
- **Subsurface** 0.0 for set materials; 0.05–0.12 for "flesh" clays (faces, hands) — the faint waxy translucency of skin-toned plasticine.
- **Normal** ← the **fingerprint/tool-mark normal map**, baked once from a crop of your **R2 Mara face render** (the thumbprints are literally in your existing art). Strength 0.4–0.7. Tiling, shared across all clay surfaces. Fallback: procedural Bump from high-scale noise (M0 uses this).
- **No metallic** on clay (≤0.1). Metal props use a separate `ClayMetal` variant with a brushed-but-matte profile, never chrome.

**Variant library (one .blend, linked everywhere):** `ClayWall`, `ClayStone`, `ClayWood`, `ClayMetalDark`, `ClayFlesh` (subsurface), `ClayFabric` (sheen up, roughness max), `Glaze_slick`, `Glass_slick`, `Emissive_LED`, `Emissive_Lemon`, `Emissive_Moon`. Adding the manor's whole material range is choosing from this shelf, not authoring new graphs.

**The shared-normal trick.** Because every clay surface shares the one fingerprint normal map, the *entire manor* feels handmade for the texture cost of a single map. This is the cheapest identity win after the lamp deficit.

---

# 4 · THE 12FPS CLAYMATION ANIMATION CONVENTION

The defining motion rule, and a workload *halver*.

**Authoring (Blender):** animate normally on the full timeline, then apply a **Stepped Interpolation F-Curve modifier** (step size = framerate/12, e.g. 2 on a 24fps timeline) to the armature/object actions. Preview at 12fps holds. The judder is baked into the curve, not faked.

**Runtime (Godot):** two options, pick per-object —
- *Baked:* export the stepped action; Godot plays it as-is (simplest; what most props use).
- *Live step:* an AnimationTree with a step node sampling at 12fps (for blended locomotion that must still judder — Eleanor's drift, Caldwell's one scene).

**The split that defines the look:** **world animates stepped; camera moves smooth.** The Godot first-person camera, doors-as-camera-moves, and the rostrum cutscenes all run full-rate. Clay puppets, the rocking horse, the self-falling sheet, flickering light *animation* (not the light itself) run stepped. Player hands: stepped on gesture, smooth on traversal — the compromise that keeps FP movement non-nauseating while gestures read as stop-motion.

**Why it's a gift:** 12fps is half the keyframes of 24, and stop-motion *expects* held poses and snappy transitions — so animation is both cheaper and stylistically *more* correct when done minimally. Do not smooth it to "fix" it; the judder is the brand.

---

# 5 · THE TWO GAMEPLAY SHADERS — authored in Blender, finished in Godot

These are not clay-master variants; they're live shaders T2 drives. Blender's job is to **bake their input textures**; Godot's job is to run them.

**5.1 Ink-Render (unwritten ink).** Two states per surface: full PBR, and a **sketch pass**. Blender bakes the sketch pass automatically as part of export: take the full base-colour texture → posterize → edge-detect (Sobel) → tint to iron-gall brown on parchment cream. Scriptable as a compositor/bake step (§6 export script does it). Godot lerps state by the `witnessed` float (T2 §6). *Authoring rule: every surface ships both textures from day one — the sketch bake is automatic, so this costs nothing extra at author time.*

**5.2 Breath (breathing walls).** M0 does this as CPU vertex offset; **production migrates it to a Godot vertex shader** (a sine displacement along the surface normal, amplitude/period as global uniforms `Breath.amplitude/period`). Blender's only job: **mark wall meshes** (the `ww_breathing` custom property, §6) and ensure their normals point inward so the displacement breathes the right way. No Blender shader work — it's a tag plus correct normals.

---

# 6 · THE glTF EXPORT CONTRACT (the handoff that prevents all the pain)

The single most important page for keeping Blender and Godot from fighting. Obey it and assets drop in clean; break it and you debug import bugs for weeks.

**Scale & orientation.** 1 Blender unit = 1 metre. Apply all transforms before export (scale 1,1,1, rotation 0). Blender Z-up → Godot Y-up: use the exporter's `+Y up` (on by default). Doors/props authored at origin, placed by empties.

**Naming = behaviour.** Godot finds things by name and by custom property. Conventions:
- Rooms: `Room_<id>` (collections → Godot nodes).
- Breathing walls: name `Wall_*` **and** custom property `ww_breathing=1`.
- Interactables: custom property `ww_interact="<verb>"` (e.g. `examine`, `record`, `measure`, `take`) — Godot auto-adds an interaction component to anything carrying it.
- Hero props: `ww_prop="recorder|journal|blackbook|lamp|..."` — Godot attaches the prop's script (LED, haptics, etc.).
- Markers: empties named `PlayerSpawn`, `LampSpot`, `Cam_*` (cutscene cameras), `Trigger_*` (volumes).
- Measurement volumes: `Measure_<space_id>` with props `interior_m`, `exterior_m`.

**Custom properties survive via `export_extras=True`** (M0 already sets this). Godot reads them as node metadata (with the name-fallback T2 §3 uses for version safety).

**Materials.** Export the clay master as baked PBR (base/roughness/normal). Do **not** export emission strength expecting Godot parity — Godot owns final emission energy (LED, lemon, moon) via its own materials keyed off the `Emissive_*` name. Lights: **never export** (Godot owns all lighting; `export_lights=False`).

**The sketch-pass bake** runs in the export script: for each exported base-colour texture, write a `<name>_sketch.png` beside it (posterize+Sobel+tint). Godot's ink-render material auto-pairs `_sketch` to the full texture by filename.

**One export script per .blend**, run headless in CI later: `blender -b WW_Ground.blend -P export_contract.py`. The M0 Part-A script is the seed of this.

---

# 7 · SERIES RENDERS → GAME ASSETS (your existing art is a pipeline)

Restating T1's manifest as *pipeline steps*, because these are free or near-free:

- **R2 face render → fingerprint normal map.** Crop a high-detail patch, desaturate, high-pass, convert to normal (Blender bake or a normal-from-height node). This one map texturises the whole manor (§3).
- **Room renders (R5–R8) → evidence-photo textures.** When the player photographs a room, the board image is a crop of the matching render. Player photos match the series look for free — pure transmedia glue.
- **R4 manor → menu/box/impostors.** The rostrum loop from the Ep1 Blender script *is* the main menu background.
- **Parchment maps + Eleanor's wing page → MapUI textures, direct.** No conversion.
- **Episode 1 rostrum MP4s → Reader Mode cutscenes + marketing.** The series VO becomes Reader Mode narration. One asset, two products — the standing rule of this project.
- **Stinger stills S1–S3 → post-credits, as authored.**

**The standing rule, formalised:** before authoring any new art asset, check whether a series render already covers it. The series and the game share one art bible on purpose; divergence is a bug, not a style choice.

---

# 8 · ASSET AUTHORING CHECKLIST (tape to the monitor)

Every mesh, before export:
- [ ] Inherits a clay-master variant (or is explicitly `*_slick`)
- [ ] Transforms applied (scale 1, rot 0), 1 unit = 1 m
- [ ] UVs sane; fingerprint normal reads at interaction distance
- [ ] 2–4% variation present (no stamped repeats)
- [ ] Palette-legal (no stray saturation unless it *means* something)
- [ ] Named per §6; behaviour props set (`ww_interact`, `ww_prop`, `ww_breathing`)
- [ ] If animated: stepped-12fps modifier applied; camera-facing motion excluded
- [ ] Walls: normals inward, `ww_breathing=1`
- [ ] Sketch pass will bake (base-colour texture present for the export step)
- [ ] Previews correctly under miniature-scale test lighting, not just the modelling viewport

---

# 9 · PRODUCTION ORDER (Blender side, mirroring the Milestones)

- **M0 (now):** clay master v1 (done), greybox kitchen export, fingerprint normal from R2.
- **M1:** hero props authored to spec — recorder (+ LED slot), lamp, tape measure, notebook/ledger; kitchen/hall/cellar-door meshes dressed; clay variant library finalised.
- **M2–3:** per-room dressing passes in bible order (Vol 1 → 2 → 3); measurement volumes; sketch-pass bake wired into export; the three hero books (journal/black/testament) with their slick-vs-clay contrast and haptic-flag naming.
- **M4:** the wing — ink-render both-state textures everywhere; the frozen-September window portal; Eleanor puppet (the one well-made character).
- **M5:** cellar deficit lighting authored; Caldwell puppet; the Foundation Chamber three-affordance staging; stinger stills.
- **M6:** Reader Mode assembly from series renders.

**Character budget, restated:** Mara is mostly first-person — build FP hands/forearms (navy knit) to full spec, a full puppet only for mirrors/endings. Eleanor gets the one careful build (she carries Acts 3–4). Caldwell: one scene, fully built, fully voiced. Everyone else is environmental or audio-only.

---

# 10 · THE PRINCIPLE BEHIND THE PIPELINE
T2's principle was *push complexity into data, not code*. T3's twin is: **push identity into shared conventions, not per-asset craft.** One clay shader, one fingerprint normal, one palette, one animation rule, one export contract — and the manor coheres no matter who or what authors a given mesh. The look isn't defended asset-by-asset; it's defended by the rules. That's what lets the series renders, hand-built models, and engine geometry all read as one haunted house — and what lets a small team (or a chat-driven Blender session) build a game this size without the world fragmenting.

Next technical deliverable on request: **T4 — Milestone 1 build notes** (written *as* M1 is built: the Act 1 spine, the ledger's first three real entries, and the actual Godot/Blender numbers that M0 and M1 teach us — the first "earned" spec rather than an authored one).

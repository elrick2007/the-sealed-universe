# Entrance Hall / West Wing Hall Blender Replacement Pass v4

Last updated: 2026-06-16

## Purpose

This is the first production-style claymation architecture replacement pair, now moving from v1/v2 proof-of-pipeline and the fresh v3 rebuild into a v4 runtime-aligned live shell.

`Documents/BOOK1_ROOM_ART_SOURCE_OF_TRUTH.md` governs this pass: Blender is the source of truth for final visible room architecture. Godot blockouts remain gameplay/collision/trigger scaffolds and should not be polished as final room visuals.

## Source And Exports

- Build script: `assets/blender_source/rooms/ground/build_entrance_westwing.py`.
- Source file: `assets/blender_source/rooms/ground/ww_gf_entrance_westwing.blend`.
- Exports:
  - `assets/blender_exports/rooms/ground/gf_entrance_hall.glb`
  - `assets/blender_exports/rooms/ground/gf_west_wing_hall.glb`
- Godot wrappers:
  - `assets/imported_scenes/rooms/ground/gf_entrance_hall_import.tscn`
  - `assets/imported_scenes/rooms/ground/gf_west_wing_hall_import.tscn`

## Layout Targets

- Entrance Hall target footprint: roughly 10m x 16m, matching the proven Godot starter hall collision.
- West Wing Hall target footprint: roughly 4.25m x 12.2m, matching the proven Godot west corridor collision.
- Door height: 2.1m.
- Minimum playable clearance: 0.9m; preferred clearance: 1.2m.
- Wall thickness should read as physical set construction, not paper-thin planes.
- The player must clearly read the front door, west wing door, sealed boundary, grand stair indication, clock sightline, and chandelier-handprint sightline.

## Claymation Look Targets

- Treat the manor as a miniature clay set built from card, wood, fabric, and painted clay.
- Use visible seams, fingerprints, uneven plaster, slightly warped trim, hand-painted wood, and imperfect corners.
- Keep surfaces matte and tactile, with deep miniature falloff.
- Sconces, trims, runners, handles, frames, and clocks should be sculpted props, but Godot owns the actual dynamic lighting.
- Breathing walls must be named `Wall_*` and tagged with `ww_breathing=1`.
- Avoid perfectly straight clean planes unless the story calls attention to them as impossible or unwritten.

## Gameplay Markers To Preserve

Entrance Hall:

- `Spawn_GF_EntranceHall`
- `Prop_Recorder` with `ww_interact="take"` and `ww_prop="recorder"`
- `Prop_IronKey` with `ww_interact="take"` and `ww_prop="iron_key"`
- `Wall_Whisper_Entrance` with `ww_breathing=1` and `ww_interact="inspect"`
- `Door_GF_EntranceHall__GF_WestWingHall`
- `Prop_GrandfatherClock`
- `Trigger_ChandelierHandprintSightline`

West Wing Hall:

- `Prop_ManorPlans`
- `Trigger_WestWingThresholdScare`
- `Measure_GF_WestWingHall_42_47`
- `Door_GF_WestWingHall__GF_Library`
- `Door_GF_WestWingHall__GF_DiningRoom`
- `Door_GF_WestWingHall__GF_Kitchen`
- `Door_GF_WestWingHall__CellarStairs`

## v2 Blender Build Checklist

- [x] Keep block-accurate floor rectangles against the ground-floor map.
- [x] Upgrade walls and ceilings from plain boxes into irregular clay set surfaces.
- [x] Add/readably improve wall thickness, doorframes, baseboards/skirting, cornice, and trim.
- [x] Add the West Wing door as a sculpted visual shell while preserving the existing scripted Godot door anchor.
- [x] Improve red runners/carpets so they read as cloth strips, not flat debug planes.
- [x] Add sconces/candle holders as sculpted fixed props while leaving final lighting to Godot.
- [x] Preserve recorder, key, manor plans, tape-measure, trigger, door, clock, and sightline marker locations.
- [x] Use the `WW_Mat_Clay_*` material naming family in the Blender export.
- [x] Export updated GLBs and verify wrapper scene paths.
- [x] Run smoke and scene-load validation after import.

## Generated v1 Notes

- Generated with UPBGE/Blender 5.0.1 in headless mode.
- Includes enclosed floors, walls, ceilings, simple trim, rug runners, doorway frames, starter props, breathing-wall markers, route markers, and simple collision helper meshes.
- Godot remains the owner of dynamic lighting, gameplay logic, and final collision verification.
- UPBGE printed a Logic Nodes registration warning during headless startup, but the `.blend` save and both GLB exports completed successfully.
- Added Godot wrapper scenes under `assets/imported_scenes/rooms/ground/` and instanced both exports under `BlenderImportPreview` in `scenes/main.tscn` for side-by-side inspection beside the playable blockout.

## Side-By-Side Route Proof v1

- Godot loads `res://scenes/main.tscn` with the `BlenderImportPreview` wrappers present.
- The smoke playthrough still passes, so the playable starter route remains bound to the proven blockout while the imported GLBs are preview-only.
- Wrapper scenes reference only exported GLBs from `assets/blender_exports/rooms/ground/` and carry preview metadata.
- Replacement can now begin as a controlled pass: swap the Entrance Hall shell first, verify route prompts/collision, then swap the West Wing Hall shell.

## Entrance Hall Controlled Replacement v1

- Promoted `gf_entrance_hall_import.tscn` as `Architecture/EntranceHallClayShell`.
- Kept the original Entrance Hall blockout collision and gameplay anchors authoritative.
- Hid only the duplicate preview entrance import under `BlenderImportPreview`.
- Left West Wing Hall preview-only for the second controlled replacement pass.

## v2 Requirements

- Enclosed Entrance Hall and West Wing Hall with ceilings and readable wall thickness.
- Doorframes, baseboards/skirting, cornice/trim, West Wing door visual shell, red runners, sconces/candle holders, and preserved gameplay prop locations.
- Subtle handmade clay irregularity on walls, trim, edges, doors, and carpets.
- Godot remains responsible for final lighting, gameplay scripts, trigger behavior, and collision verification.

## v2 Generated Notes

- Updated `assets/blender_source/rooms/ground/build_entrance_westwing.py` to generate a richer clay set shell using bevel/displace surface modifiers, fingerprint smears, baseboards, cornice strips, door panels, handles, sconces/candle holders, clock face detail, pendulum bob, runner fringe, and the West Wing door visual leaf.
- Regenerated `assets/blender_source/rooms/ground/ww_gf_entrance_westwing.blend`.
- Re-exported `assets/blender_exports/rooms/ground/gf_entrance_hall.glb` and `assets/blender_exports/rooms/ground/gf_west_wing_hall.glb`.
- Updated wrapper metadata to mark the Entrance Hall as the controlled v2 visual shell and West Wing Hall as controlled v2 preview.
- Validation passed on 2026-06-16:
  - Smoke playthrough passed.
  - `res://scenes/main.tscn` loaded headless for 3 seconds.
  - `res://scenes/menu.tscn` loaded headless for 3 seconds.
  - Godot still prints the known ObjectDB warning on headless quit for main/smoke; no gameplay-blocking error was observed.

## v3 Fresh Rebuild Notes

- Replaced `assets/blender_source/rooms/ground/build_entrance_westwing.py` with a cleaner v3 generator that starts from `bpy.ops.wm.read_factory_settings(use_empty=True)` on every run.
- The old generated Blender scene is not appended to or reused; the script overwrites `ww_gf_entrance_westwing.blend` and both GLBs from a fresh scene.
- Used `Documents/art_reference_intake/GF_EntranceHall.md` and `Documents/art_reference_intake/GF_WestWingHall.md` as the visual target.
- Added stronger modeled wainscoting, floorboard lines, layered cornice, chunky doorframes, raised door panels, repeated sconces, ragged runner edges, carpet foot-smears, plaster patches, ceiling cracks, wall-memory handprints, room glimpses for Library/Dining/Kitchen, and a darker West Wing end wall for the threshold scare.
- Preserved existing gameplay marker names and export paths.
- Updated wrapper metadata to `controlled_v3_visual_shell` for Entrance Hall and `controlled_v3_preview` for West Wing Hall.
- Validation passed on 2026-06-16:
  - Smoke playthrough passed.
  - `res://scenes/main.tscn` loaded headless for 3 seconds.
  - `res://scenes/menu.tscn` loaded headless for 3 seconds.
  - Godot still prints the known ObjectDB warning on headless quit for main/smoke; no gameplay-blocking error was observed.

## v4 Runtime Alignment Notes

- Retuned the Blender generator to the proven Godot blockout footprint rather than the early compact art-preview footprint.
- Entrance Hall now exports at the same 10m x 16m footprint as the playable starter hall.
- West Wing Hall now exports down the existing West Wing route, centered on the blockout corridor and aligned to the scripted West Wing door.
- Promoted `gf_west_wing_hall_import.tscn` as `Architecture/WestWingHallClayShell`.
- Kept original blockout collision, pickup areas, trigger areas, door scripts, and interaction scripts authoritative.
- Hid the old Entrance Hall and West Wing corridor blockout mesh surfaces so the GLB shells provide the visible architecture.
- Left later-room blockout visuals visible for Library, Dining, Kitchen, Conservatory, and onward rooms until those rooms receive their own Blender replacement passes.
- Validation passed on 2026-06-16:
  - Smoke playthrough passed.
  - `res://scenes/main.tscn` loaded headless for 3 seconds.
  - `res://scenes/menu.tscn` loaded headless for 3 seconds.
  - Godot still prints the known ObjectDB warning on headless quit for main/smoke; no gameplay-blocking error was observed.

## v5 Starting-Area Dressing Notes

- Confirmed live Blender control through the MCP socket on `localhost:9876`.
- Opened `assets/blender_source/rooms/ground/ww_gf_entrance_westwing.blend` in the running Blender window, replacing the old unsaved MCP proof scene with the real mansion source scene.
- Darkened the clay wall/floor/fabric material palette so the Entrance Hall reads less like a clean blockout.
- Added a reference-driven Entrance Hall dressing pass: denser plaster cracks, raised wall scars, ceiling collapse patches, an arched West Wing threshold, side chairs, a side table/lamp, and floor debris.
- Hid the old Godot recorder/key pickup meshes while preserving their pickup Areas, collisions, scripts, and route logic; the Blender-authored prop visuals now carry the starting-area art.
- Regenerated `ww_gf_entrance_westwing.blend`, `gf_entrance_hall.glb`, and `gf_west_wing_hall.glb`.
- Validation passed on 2026-06-16:
  - Smoke playthrough passed.
  - `res://scenes/main.tscn` loaded headless for 3 seconds.
  - `res://scenes/menu.tscn` loaded headless for 3 seconds.
  - Godot still prints the known ObjectDB warning on headless quit for main; no gameplay-blocking error was observed.

## v6 Texture And Lighting Notes

- Added generated packed image textures to the Blender material pipeline for clay wall, damaged plaster, floorboards, wood trim, dark wood, burgundy fabric, parchment, metal, and candle/wax materials.
- The GLB export now emits texture PNG sidecars next to each room export; these are intentional for this proof pass so the material source can be inspected and Godot can import the actual texture images.
- Reduced broad ambient and hall light intensity in Godot so the room stops reading as a flat brown wash.
- Added four small warm Entrance Hall candle lights matching the Blender sconce positions.
- Re-exported `gf_entrance_hall.glb` and `gf_west_wing_hall.glb` with the textured material pass.
- Validation passed on 2026-06-16:
  - Smoke playthrough passed.
  - `res://scenes/main.tscn` loaded headless for 3 seconds.
  - `res://scenes/menu.tscn` loaded headless for 3 seconds.
  - Godot still prints the known ObjectDB warning on headless quit for main/smoke; no gameplay-blocking error was observed.

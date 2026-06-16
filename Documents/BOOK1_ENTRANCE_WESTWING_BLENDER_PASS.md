# Entrance Hall / West Wing Hall Blender Replacement Pass v1

Last updated: 2026-06-16

## Purpose

This is the first production-style claymation architecture pass. It replaces only the Entrance Hall and West Wing Hall blockout after the Godot GLB import convention has passed a side-by-side route test.

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

- Entrance Hall target footprint: roughly 6m x 8m, with a 3m ceiling.
- West Wing Hall target width: roughly 2m, with a 3m ceiling and claustrophobic sightlines.
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

## First Blender Build Checklist

- [x] Block accurate floor rectangles against the ground-floor map.
- [x] Add wall thickness and ceilings.
- [x] Place door frames and gameplay marker empties.
- [x] Assign clay material variants.
- [x] Add simple collision meshes.
- [x] Export test GLBs.
- [x] Create Godot wrapper scenes.
- [x] Run side-by-side route test before replacing the blockout.

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

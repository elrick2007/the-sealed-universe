# Book 1 Godot GLB Import Convention

Last updated: 2026-06-16

This locks how Blender room exports land in Godot before replacing any working blockout rooms.

See also `Documents/BOOK1_ROOM_ART_SOURCE_OF_TRUTH.md`. Blender is the source of truth for final visible room architecture; Godot blockouts are gameplay/collision/trigger scaffolds and should not be promoted into final room art.

## Scope

- Applies to Game 01 / Book 1 only.
- Covers room architecture GLBs, connector GLBs, hero prop GLBs, marker empties, and collision helper meshes.
- Blender owns final visible room architecture, wall thickness, ceilings, trim, doorframes, UVs, material assignment, clay surface detail, prop placement empties, and named gameplay markers.
- Godot owns final lighting, scripts, collision verification, UI, save/load, gameplay state, and material overrides when needed.
- Godot wrapper scenes own import metadata and gameplay anchor preservation. They are the handoff layer between imported Blender art and the proven gameplay scaffold.

## Folder Contract

- Blender working files: `assets/blender_source/`
  - Room files: `assets/blender_source/rooms/ground/`
  - Shared material file: `assets/blender_source/materials/ww_clay_material_library.blend`
  - Shared textures: `assets/blender_source/textures/shared/`
- Exported GLBs: `assets/blender_exports/`
  - Ground floor room exports: `assets/blender_exports/rooms/ground/`
- Godot import wrappers: `assets/imported_scenes/`
  - Ground floor wrappers: `assets/imported_scenes/rooms/ground/`
- Final playable scene remains `scenes/main.tscn` until enough rooms are modularized to split safely.

## Naming Contract

- Top room nodes: `Room_GF_EntranceHall`, `Room_GF_WestWingHall`, `Room_GF_DiningRoom`.
- Visual meshes: `Mesh_<material>_<shortname>`.
- Collision meshes: `Col_<room_id>_<surface>`.
- Door markers: `Door_<from_room>__<to_room>`.
- Player spawn markers: `Spawn_<room_id>`.
- Event triggers: `Trigger_<event_id>`.
- Measurement volumes: `Measure_<space_id>`.
- Breathing walls: `Wall_<room_id>_<shortname>` with custom property `ww_breathing=1`.
- Interactables: custom property `ww_interact="take|inspect|record|measure|open|use"`.
- Hero props: custom property `ww_prop="recorder|iron_key|manor_plans|clock|..."`.

## Material And Claymation Contract

- Every exported room uses the shared clay master material variants from T3.
- Required material names: `ClayWall`, `ClayWood`, `ClayStone`, `ClayFabric`, `ClayMetalDark`, `Glass_slick`, `Emissive_LED`, `Emissive_Lemon`, `Emissive_Moon`.
- World and prop animation should be authored with 12fps stepped timing; the first-person camera stays smooth.
- Fingerprint and tool-mark normals must be readable at interaction distance.
- Avoid clean CG planes unless the material is deliberately slick, glassy, or electronic.
- Book 1 palette anchor: bone, slate grey, dried-blood burgundy, candle amber, lemon accent, and rose-charcoal for Sealed Wing material transitions.

## Import Workflow

1. Export GLB from Blender into `assets/blender_exports/...`.
2. Let Godot import the GLB without moving the generated import files by hand.
3. Create or update a wrapper scene under `assets/imported_scenes/...`.
4. Verify `StaticBody3D` collision, interaction metadata, and material slots inside the wrapper.
5. Instance the wrapper into `scenes/main.tscn` in a side-by-side test position before replacing blockout geometry.
6. Compare player height, door clearance, wall thickness, prompt raycasts, saved flags, and route completion.
7. Replace the blockout only after the same route still passes.

## Entrance Hall / West Wing Hall First Pass

- First Blender source file: `assets/blender_source/rooms/ground/ww_gf_entrance_westwing.blend`.
- First exports:
  - `assets/blender_exports/rooms/ground/gf_entrance_hall.glb`
  - `assets/blender_exports/rooms/ground/gf_west_wing_hall.glb`
- First import wrappers:
  - `assets/imported_scenes/rooms/ground/gf_entrance_hall_import.tscn`
  - `assets/imported_scenes/rooms/ground/gf_west_wing_hall_import.tscn`
- Must preserve gameplay: recorder pickup, iron key pickup, whisper wall, west wing door gate, manor plans pickup, threshold scare, Caton 42/47 measurement, clock sightline, and chandelier-handprint sightline.
- Visual targets: enclosed rooms, ceilings, thick walls, real door frames, burgundy runner, candle sconces, clay fingerprints, slight handmade asymmetry, and no digital-clean blockout planes.

## Acceptance Test

- GLB appears in Godot without path errors.
- Wrapper scene opens without missing materials.
- Player collision clearance is at least 0.9m, preferred 1.2m.
- Interactions still raycast from the first-person camera.
- Saved flags still mark objectives, notes, evidence, and map visits correctly.
- The world reads as handmade claymation architecture rather than a flat greybox.
- No final visible room shell is built only from Godot primitive blockout geometry.

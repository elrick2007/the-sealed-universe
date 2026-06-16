# Book 1 Room Art Source Of Truth

Last updated: 2026-06-16

This document locks the production boundary between Godot and Blender for Game 01 / Book 1.

## Core Rule

Blender is the source of truth for final visible room architecture.

Godot blockout geometry exists to prove gameplay, collision, routes, triggers, UI, save/load, and interaction logic. It is not final room art and should not be polished as if it were the finished claymation manor.

## Ownership

- Blender owns final visible room shells, wall thickness, ceilings, doorframes, trim, stairs, fixed props, UVs, material assignment, surface deformation, clay seams, sculpted imperfections, and placement markers.
- Godot owns gameplay scripts, interaction raycasts, triggers, save/load state, UI, route gates, dynamic lighting, final collision verification, and wrapper scenes that bind imported art to working game logic.
- GLB files exported from Blender are the interchange format between the two.
- Godot wrapper scenes under `assets/imported_scenes/` own import metadata, script connections, material overrides when needed, and gameplay anchors that must survive art iteration.

## Do Not Do

- Do not hand-build final room visuals from Godot primitive CSG or MeshInstance blockout pieces.
- Do not replace scripted gameplay anchors with imported meshes until the same route has passed validation.
- Do not treat preview GLBs as live gameplay bindings until their wrapper scene and route test are complete.
- Do not move Blender source files into Godot import paths; Godot imports exported GLBs, not `.blend` files.

## Required Flow

1. Author or update the room in Blender.
2. Use the locked `WW_Mat_Clay_*` naming family and stable gameplay marker names.
3. Export room GLBs into `assets/blender_exports/`.
4. Update or create Godot wrapper scenes in `assets/imported_scenes/`.
5. Instance wrappers side-by-side or as visual shells while preserving proven Godot gameplay anchors.
6. Run smoke and scene-load validation before declaring a room replacement complete.

The current active replacement pass is Entrance Hall / West Wing Hall v2.

# Book 1 Art Prompt Tile Bible

Last updated: 2026-06-16

This document turns visual generation into a repeatable room-by-room pipeline for Book 1 / Game 01.

## Purpose

Use AI image tools for reference images, texture plates, material studies, decals, and prop studies. Blender remains the source of truth for final room geometry and authored assets. Godot remains the source of truth for gameplay, triggers, UI, collision verification, and imported wrapper scenes.

## Folder Contract

Root:

`assets/reference_images/book1/`

Room references:

`assets/reference_images/book1/rooms/<room_id>/`

Material references:

`assets/reference_images/book1/materials/<material_id>/`

Decal references:

`assets/reference_images/book1/decals/<decal_id>/`

Prop references:

`assets/reference_images/book1/props/<prop_id>/`

## Image Naming

Preferred room image names:

- `<room_id>_01_overview.png`
- `<room_id>_02_key_wall.png`
- `<room_id>_03_ceiling_trim.png`
- `<room_id>_04_props.png`
- `<room_id>_05_material_detail.png`
- `<room_id>_06_alt_angle.png`

Imported generator names are acceptable during exploration, but final selected references should be documented in the room reference brief.

## Base Style Tile

Use this style block at the start of room prompts:

```text
first-person claymation horror game environment, Victorian manor interior, handmade stop-motion miniature set, tactile matte clay surfaces, visible fingerprints and tool marks, uneven hand-built edges, warped plaster, dark clay wood trim, warm candle amber light, deep miniature shadows, gothic haunted house, authored for Blender environment modeling, no people, no text, no UI
```

## Negative Tile

Use this negative block for most room prompts:

```text
photorealistic real house, modern hotel, clean CG render, glossy plastic, perfect straight walls, polished showroom, bright cartoon, sci-fi, people, characters, readable text, game UI, floating icons, weapons
```

## Room Prompt Template

```text
{BASE_STYLE_TILE}, {room name}, {room function}, {required architectural features}, {required props}, {lighting mood}, {story-specific details}, wide interior reference image for Blender modeling
```

## Room Intake Checklist

For each room, create or update a brief under:

`Documents/art_reference_intake/`

Each brief should record:

- Reference image folder.
- Best images to follow.
- Features to copy into Blender.
- Features to reject because they fight gameplay or story.
- Required gameplay anchors.
- Export filename and wrapper scene.
- Next Blender action.

## Current First Target

The first reference intake target is:

`Documents/art_reference_intake/GF_EntranceHall.md`

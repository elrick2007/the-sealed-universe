# GF Entrance Hall Art Reference Intake

Last updated: 2026-06-16

## Reference Folder

`assets/reference_images/book1/rooms/gf_entrance_hall/`

Current files:

- `Victorian_manor_entrance_hall_1.png`
- `Victorian_manor_entrance_hall_2.png`
- `Victorian_manor_entrance_hall_3.png`
- `Victorian_manor_entrance_hall_4.png`
- `Victorian_manor_entrance_hall_5.png`
- `Victorian_manor_entrance_hall_6.png`
- `Victorian_manor_entrance_hall_7.png`
- `Victorian_manor_entrance_hall_8.png`

## Best Shared Visual Language

- Handmade miniature clay-box room with low enclosed ceiling.
- Heavy dark clay wood wainscoting around the lower walls.
- Thick doorframes with layered trim and slightly warped edges.
- Distressed clay plaster above the wainscoting, with cracks, scraped patches, and finger/tool marks.
- Burgundy runner carpet with ragged, uneven edges and visible clay/fiber thickness.
- Warm candle sconces as the main visible light language.
- Grandfather clock as the central focal prop, placed near a corner or door transition.
- Matte brown/bone palette with amber light and deep miniature shadows.

## Strongest Design Cues To Copy

- Image 1: two-door composition, corner clock, cracked clay walls, ragged runner.
- Image 2: strong hallway depth, clock and chair scale cue, thick side doorway frame.
- Image 4: arch/side passage language, heavy wainscot, clock between door and connector.
- Image 5: front-door focal wall, large ring/handle, denser ceiling trim.
- Image 7: long first-person playable composition with strong runner alignment and bright side doorway.
- Image 8: clear door/clock/side-door layout with strong readable gameplay sightline.

## Reject Or Adapt

- Do not copy readable clock numbers or decorative details exactly; make them handmade and approximate.
- Avoid tiny chairs or baskets as required props unless they support gameplay scale; optional dressing only.
- Keep playable clearance wider and cleaner than the generated images imply.
- Do not overfill the room with furniture. Recorder, iron key, clock, West Wing door, front door, and whisper wall must remain readable.
- Avoid a bright overhead bulb as the dominant final look. Godot can use hidden fill, but visible lighting should remain candle/sconce-led.

## Required Gameplay Anchors

- `Spawn_GF_EntranceHall`
- `Prop_Recorder`
- `Prop_IronKey`
- `Wall_Whisper_Entrance`
- `Door_GF_EntranceHall__GF_WestWingHall`
- `Prop_GrandfatherClock`
- `Trigger_ChandelierHandprintSightline`

## Blender Action For Next Pass

Update `assets/blender_source/rooms/ground/build_entrance_westwing.py` so the Entrance Hall shell follows the reference set more closely:

- Add continuous wainscoting panels below the chair rail.
- Make the front door and West Wing door thicker and more panelled.
- Add layered top trim and chunkier door headers.
- Make the runner longer, ragged, and visibly thick.
- Improve the grandfather clock silhouette.
- Add more wall patch plates and larger plaster cracks.
- Keep existing gameplay marker names and GLB export paths.

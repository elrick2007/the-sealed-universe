# GF West Wing Hall Art Reference Intake

Last updated: 2026-06-16

## Reference Folder

`assets/reference_images/book1/rooms/gf_west_wing_hall/`

Current files:

- `gf_west_wing_hall_1.png`
- `gf_west_wing_hall_2.png`
- `gf_west_wing_hall_3.png`
- `gf_west_wing_hall_4.png`
- `gf_west_wing_hall_5.png`
- `gf_west_wing_hall_6.png`
- `gf_west_wing_hall_7.png`
- `gf_west_wing_hall_8.png`
- `gf_west_wing_hall_9.png`

## Best Shared Visual Language

- Long enclosed corridor with low, damaged clay ceiling.
- Repeating candle sconces that form warm pools of light down the route.
- Heavy dark clay wood wainscoting, doorframes, and baseboards.
- Several side doorways, with glimpses into Library, Dining Room, and Kitchen spaces.
- Deep end-of-hall darkness, useful for the threshold scare.
- Burgundy runner carpet as the player's visual path, with frayed or lumpy clay/fiber edges.
- Distressed clay plaster above the wainscoting, including cracks, missing chunks, handprints, and tool smears.
- Strong miniature-set feeling: slightly thick props, chunky trim, imperfect edges.

## Strongest Design Cues To Copy

- Image 1: clean gameplay-readable side-room rhythm: Library on one side, Kitchen on the other, Dining or hub space ahead.
- Image 2: best long corridor composition with alternating doorframes and strong runner perspective.
- Image 3: handprints and darker corridor dread; useful for the first West Wing threshold scare.
- Image 4: wide runner and large openings, but keep gameplay clearance controlled.
- Image 5: strong debris, doors, sconces, and wainscoting texture.
- Image 7: good ceiling-collapse language and end-of-hall shadow.
- Image 8: strongest readable long-hall version with playable corridor width and door spacing.
- Image 9: best pure horror corridor read: repeated sconces, dark end, frayed runner, chunky wainscoting.

## Reject Or Adapt

- Do not copy modern kitchen appliances or lamps from the generated images. Kitchen and Dining props must be authored separately from their own room prompts.
- Do not make the West Wing Hall too wide; it should remain claustrophobic while preserving player collision clearance.
- Avoid too many random doors. Required route doors are Library, Dining Room, Kitchen, Cellar Stairs, and the Entrance Hall connection.
- Do not let decorative furniture block the Caton 42/47 measurement volume or the threshold scare route.
- Use end darkness for mood, but do not make interactables unreadable in Godot.
- Treat handprints as wall-memory marks, not gore.

## Required Gameplay Anchors

- `Prop_ManorPlans`
- `Trigger_WestWingThresholdScare`
- `Measure_GF_WestWingHall_42_47`
- `Door_GF_WestWingHall__GF_Library`
- `Door_GF_WestWingHall__GF_DiningRoom`
- `Door_GF_WestWingHall__GF_Kitchen`
- `Door_GF_WestWingHall__CellarStairs`

## Blender Action For Next Pass

Update `assets/blender_source/rooms/ground/build_entrance_westwing.py` so the West Wing Hall follows the reference set more closely:

- Add alternating side doorframes and short visible room-threshold shells for Library, Dining Room, and Kitchen.
- Extend the runner into a stronger corridor path with ragged edges and surface impressions.
- Add repeated sconces along both walls while leaving final lighting to Godot.
- Add continuous wainscoting panels, thicker chair rail, baseboards, and ceiling cornice.
- Add larger plaster patch plates, handprints, tool scratches, and ceiling cracks.
- Keep the end of the corridor visually darker for the threshold scare.
- Preserve all gameplay marker names and the existing GLB export path.

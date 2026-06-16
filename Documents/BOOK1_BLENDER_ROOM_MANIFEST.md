# Book 1 Blender Room Manifest

Last updated: 2026-06-16

This is the pre-export architecture manifest for Game 01 / Book 1. It converts the floor-plan rooms into Blender build targets before blockout replacement begins.

`Documents/BOOK1_ROOM_ART_SOURCE_OF_TRUTH.md` is authoritative for production ownership: Blender owns final visible room architecture; Godot blockouts remain gameplay, collision, trigger, and route scaffolds.

Use this with:

- `Documents/BOOK1_ROOM_COVERAGE_MATRIX.md`
- `Documents/BOOK1_ROOM_PURPOSE_LOCK.md`
- `Documents/Technical_Bible_T3_Art_Shader_Pipeline.md`

## Export Contract

- Build one Blender collection per room or structural connector.
- 1 Blender unit = 1 metre.
- Apply transforms before export.
- Godot owns gameplay lighting, final collision checks, and interaction scripts.
- Blender owns enclosed final architecture, room silhouette, wall thickness, ceilings, trim, doorframes, fixed prop shells, material assignment, UVs, prop placement empties, clay imperfection, and named trigger/measurement helper volumes.
- Export as `.glb` with `export_extras=True`.
- Room export path pattern: `assets/blender_exports/rooms/<floor>/<export_name>.glb`.
- Main room collection name pattern: `Room_<floor>_<room_id>`.
- Door marker pattern: `Door_<from>__<to>`.
- Spawn marker pattern: `Spawn_<room_id>`.
- Measurement volume pattern: `Measure_<space_id>`.
- Breathable wall meshes: name `Wall_*` and set `ww_breathing=1`.
- Interactables: set `ww_interact="<verb>"`.
- Hero props: set `ww_prop="<prop_id>"`.
- Final room visuals must not be hand-built from Godot primitive CSG or MeshInstance blockout pieces.

## Scale Targets

These are starting targets for Blender, not final survey measurements. They exist to keep rooms coherent before exact proportions are tuned in-engine.

- Hall/corridor width: 1.6m to 2.4m.
- Main rooms: 4m to 7m wide unless map shape demands more.
- Service rooms: 2m to 4m wide.
- Ceilings: Ground Floor 3.0m, First Floor 2.8m, Attic 2.1m to 2.5m sloped, Cellar 2.2m to 2.4m.
- Door height: 2.1m normal, 1.8m service/attic/cellar.
- Player collision clearance: 0.9m minimum, 1.2m preferred.
- Clay miniature rule: keep surfaces slightly imperfect, but collision must remain readable.

## Ground Floor

| Build ID | Room / Area | Export Name | Connections | Required Props / Markers | Lighting Mood | Gameplay Hooks |
|---|---|---|---|---|---|---|
| GF_EntranceHall | Entrance Hall | `gf_entrance_hall.glb` | Exterior, West Wing Hall, Grand Stair, Sealed Wing boundary | recorder pickup, iron key pickup, whisper wall, west wing door, grand clock, chandelier, `PlayerSpawn` | warm sconce, deep hall shadow | starter loop, recorder/key gate, clock hook, chandelier sightline |
| GF_WestWingHall | West Wing Hall | `gf_west_wing_hall.glb` | Entrance Hall, Library, Dining Room, Kitchen, Cellar Stair, service link | manor plans, threshold trigger, Caton measurement volume | failing sconce, burgundy runner | first scare, map pickup, Caton 42/47 proof |
| GF_Library | Library | `gf_library.glb` | West Wing Hall, Study | shelf wall, shelf-gap clue, recorder wall, photo crop marker | grey daylight, book glow | wall voice, shelf-gap clue, burnt fragment |
| GF_Study | Study | `gf_study.glb` | Library | tape measure pickup, desk, record shelves, margin note marker | dusty grey, tight lamp pool | tape measure unlock, measurement mechanic tutorial |
| GF_DiningRoom | Dining Room | `gf_dining_room.glb` | West Wing Hall | long table, 13 place settings, Eleanor place card, chair ring | candle amber, chandelier shadow | thirteenth-place puzzle, recorder response |
| GF_Kitchen | Kitchen | `gf_kitchen.glb` | West Wing Hall, service link, cellar/service stair | hub table, Living Ledger, evidence board, recorder dock, kitchen clock, black book, route-return markers | warm table, cold window blue, recorder red | hub, return loop, evidence board, 2:47 scheduler, black-book records |
| GF_Conservatory | Conservatory / Lemon Tree | `gf_conservatory_lemon_tree.glb` | Kitchen route or side corridor, Sealed Wing trace | lemon tree, broken glass, soil, scent trigger, lemon proof marker | cold glass light, living lemon accent | lemon truth, rose misdirection, sealed-wing lead |
| GF_MasterBedroom | Master Bedroom | `gf_master_bedroom.glb` | Family-side ground route | jewellery box, travel residue, mirror marker | quiet lamp, private shadow | optional marriage proof |
| GF_Nursery | Nursery | `gf_nursery.glb` | Family-side ground route | music box, small bed, toy shelf, lullaby trigger | pale candle, soft dead corners | optional absence proof |
| GF_ChapelRoom | Chapel Room | `gf_chapel_room.glb` | Family-side ground route | register, candles, false-blessing marker | candle rows, cold altar shadow | optional register proof |
| GF_SealedBoundary | Locked East / Sealed Wing Boundary | `gf_sealed_wing_boundary.glb` | Entrance Hall, drafted threshold | wrong compass marker, rose-scent trigger, unwritten door | out-of-phase dark, rose hint | east/west contradiction, Act 1/Act 3 gate |
| GF_ServiceLink | Back Stair / Service Link | `gf_service_link.glb` | Kitchen, servants side, cellar stair, attic logic | narrow stair markers, service door markers | low service lamp | circulation, misdirection |

## First Floor

| Build ID | Room / Area | Export Name | Connections | Required Props / Markers | Lighting Mood | Gameplay Hooks |
|---|---|---|---|---|---|---|
| FF_GalleryLanding | Gallery Landing | `ff_gallery_landing.glb` | Grand Stair, family side, servants side | chandelier view marker, handprint photo target, bolt door marker | warm overlook, lower hall shadow | Act 2 arrival, camera proof |
| FF_ServantsPassage | Servants' Passage | `ff_servants_passage.glb` | Maid rooms, Housekeeper, Box Room, D.W., attic stair | bell board, blank bell, wire marker | bare whitewash, hard shadow | servant route spine, blank bell thread |
| FF_MaidsRoom1 | Maid's Room I | `ff_maids_room_01.glb` | Servants' Passage | diary, small bed, fever context | bare lamp | optional Ada context |
| FF_MaidsRoom2 | Maid's Room II | `ff_maids_room_02.glb` | Servants' Passage | struck rule, snapped mirror head | hard bare light | optional testimony |
| FF_MaidsRoom3 | Maid's Room III | `ff_maids_room_03.glb` | Servants' Passage | blacked window, conservatory sightline | dark window, thin lamp | optional lemon-tree sightline |
| FF_MaidsRoom4 | Maid's Room IV | `ff_maids_room_04.glb` | Servants' Passage | scorch, height mark, window count marker | sharp attic-side shadow | required thirteen-window evidence if route retained |
| FF_HousekeeperRoom | Housekeeper's Room | `ff_housekeeper_room.glb` | Servants' Passage | sewing box, chatelaine, pendulum, household record | practical lamp, drawer shadows | sewing-box puzzle |
| FF_BoxRoom | Box Room | `ff_box_room.glb` | Servants' Passage | luggage, Caldwell agreement, dust covers | low warm lamp | optional Caldwell recruiter proof |
| FF_Dumbwaiter | Dumbwaiter / D.W. | `ff_dumbwaiter_shaft.glb` | Servants' Passage, Kitchen implied | shaft door, recorder placement marker | dark vertical slot | sound-carrying connector |
| FF_EastBoltDoor | Connecting Door / East-Side Bolt | `ff_east_bolt_door.glb` | West half, east family half | bolt, loop trigger | line of light under door | floor-folding loop later |
| FF_UnnumberedGuest | Unnumbered Guest Bedroom | `ff_guest_bedroom_unnumbered.glb` | Family side | too-ready bed, guest book, bed-trade markers | too-even hotel light | burnt fragment trade |
| FF_GuestBedroom1 | Guest Bedroom I | `ff_guest_bedroom_01.glb` | Family side | dosage traces, record fragments | soft lamp | optional guest record proof |
| FF_Bathroom | Bathroom | `ff_bathroom.glb` | Family side | mirror, steam marker, basin | cold white, mirror dim | optional mirror dread |
| FF_GuestBedroom2 | Guest Bedroom II | `ff_guest_bedroom_02.glb` | Family side | toy theatre, height mark | warm nursery echo | optional child proof |
| FF_EleanorMorning | Eleanor's Morning Room | `ff_eleanor_morning_room.glb` | Family side | drafts, seal, desk, verification marker | paper warm, rose-adjacent restraint | required publish authority prep |
| FF_AtticStair | Stair to Attics | `ff_attic_stair.glb` | Servants' Passage, Attic Stair | chatelaine lock, stair door marker | narrow overhead light | attic gate |

## Attic

| Build ID | Room / Area | Export Name | Connections | Required Props / Markers | Lighting Mood | Gameplay Hooks |
|---|---|---|---|---|---|---|
| AT_AtticStair | Attic Stair | `at_attic_stair.glb` | First Floor stair, Long Attic | low landing, door marker | cold stair light | attic arrival |
| AT_LongAttic | Long Attic | `at_long_attic.glb` | Sick Rooms, Water Tank, Void, Roof Hatch | wire trace spline, shelving, filing shelf, crawl silhouettes | slate daylight blades | blank bell, filing voice source |
| AT_SickRoomNorth | Servant's Sick Room North | `at_sick_room_north.glb` | Long Attic | recovered fever chart, bed, mirror chest marker | thin cold daylight | duplicated chart proof |
| AT_SickRoomSouth | Servant's Sick Room South | `at_sick_room_south.glb` | Long Attic | deceased fever chart, mirrored chest, wrong chest open marker | matched cold daylight | duplicate-room contradiction |
| AT_WaterTank | Water Tank Room | `at_water_tank_room.glb` | Long Attic | water tank, valves, tin, not-glass marble | wet slate dark | water tank puzzle |
| AT_VoidWall | Void / No Access Room | `at_void_wall.glb` | Long Attic exterior face only | no-access wall, recorder marker, measurement volume | black gap, no interior | void measurement and recording |
| AT_MeasuredThrice | Measured-Thrice Room / Larger-Inside Space | `at_measured_thrice_room.glb` | Long Attic / void-adjacent | handwritten note marker, Caton overlay volume | moonless grey, wrong depth | Caton larger-inside proof |
| AT_RoofHatch | Hatch and Ladder to Roof Walk | `at_roof_hatch_ladder.glb` | Long Attic, Roof Walk | ladder, hatch, conditional trigger | tight overhead line | roof gate |
| AT_RoofWalk | Roof Walk | `at_roof_walk.glb` | Roof Hatch | slate path, thirteen-window sightline markers | moon and lit window | optional thirteen-windows proof |
| AT_PhantomStair | Phantom Stair to Ground Floor | `at_phantom_stair.glb` | Long Attic, Cellar Bricked Archway payoff | impossible stair marker, one-use trigger | light falling upward | Act 4 descent payoff |
| AT_EavesVoids | Hatched Storage Voids / Sloped Eaves | `at_eaves_storage_voids.glb` | Long Attic edges | blocked crawl gaps, wire-hidden space | deep roof shadow | read-only structure |

## Cellar

| Build ID | Room / Area | Export Name | Connections | Required Props / Markers | Lighting Mood | Gameplay Hooks |
|---|---|---|---|---|---|---|
| CE_CellarStairs | Cellar Stairs | `ce_cellar_stairs.glb` | Ground stair, Undercroft | descent marker, low ceiling | lamp falloff deficit | cellar arrival |
| CE_Undercroft | Undercroft | `ce_undercroft.glb` | Cellar Stairs, Coal, Wine, Cold, Well, Bricked Archway | pillar array, hook shadows, route markers | low amber, black edges | cellar spine |
| CE_CatonPillar | Caton Pillar | `ce_caton_pillar.glb` | Undercroft | 47 initials, chisel mark surface, consent marker | tight side light | consent-mark route |
| CE_WineCellar | Wine Cellar | `ce_wine_cellar.glb` | Undercroft | bottle racks, keeper labels, barrel | cool dead amber | optional timeline proof |
| CE_CoalRoom | Coal Room | `ce_coal_room.glb` | Undercroft, Foundation breach | coal pile stages, shovel/dig marker | dusty black | Foundation access |
| CE_HookRoom | Hook Room / Hanging Closet | `ce_hook_room.glb` | Undercroft, Cold Store | hooks, key shapes, hanging silhouettes | hard hook shadows | optional scare/evidence |
| CE_ColdStore | Cold Store | `ce_cold_store.glb` | Undercroft / Hook Room | shelves, jars, frost breath marker | cold white edge | preservation dread |
| CE_WellRoom | Well Room | `ce_well_room.glb` | Undercroft | well rim, windlass, recorder line, jar list marker | old black, wet rim glint | Book 2 stinger |
| CE_BrickedArchway | Bricked Archway | `ce_bricked_archway.glb` | Undercroft, Phantom Stair relation | loose brick, recorder marker | close lamp, dead mortar | archway recorder yield |
| CE_FoundationChamber | Foundation Chamber | `ce_foundation_chamber.glb` | Coal breach, Bricked Archway, Annex | original book shelf, writing stand, pen, oil, proof bundle, send marker | true silence, three lit affordances | canon ending |
| CE_FoundationAnnex | Foundation Annex / Do-Not-Store Alcove | `ce_foundation_annex.glb` | Foundation Chamber | warning note, refused proof surface | still shadow | final-register atmosphere |

## Sealed Wing / East Wing

The Sealed Wing should not look like a normal Caton survey space. In Blender it should support a sketch-to-clay visual transition and wrong-measurement language. The map source remains Eleanor's journal page, not Caton's 1885 survey.

| Build ID | Room / Area | Export Name | Connections | Required Props / Markers | Lighting Mood | Gameplay Hooks |
|---|---|---|---|---|---|---|
| SW_Boundary | Sealed Wing Boundary | `sw_boundary.glb` | Entrance Hall, Drafted Threshold | rose scent, compass contradiction marker | absent hum, rose-charcoal | route gate |
| SW_DraftedThreshold | Drafted Threshold | `sw_drafted_threshold.glb` | Boundary, Impossible Corridor | Eleanor map pickup, sketch/clay blend surfaces | parchment dark | Act 3 entry |
| SW_ImpossibleCorridor | Impossible Corridor | `sw_impossible_corridor.glb` | Drafted Threshold, Five Doors | `42 ft / it is not` marker, measurement volumes | wrong perspective light | measurement proof |
| SW_FiveDoors | Five Doors | `sw_five_doors.glb` | Impossible Corridor, wing rooms | five named/unnamed doors, witness locks | rose edge light | Act 3 framework |
| SW_BareBedroom | Bare Bedroom | `sw_bare_bedroom.glb` | Five Doors | accumulated-Mara traces | dead even light | rejected keeper temptation |
| SW_SewingRoom | Sewing Room | `sw_sewing_room.glb` | Five Doors | mourning dress hem, needle, compassion marker | pin-lamp, fabric shadow | optional witness proof |
| SW_SecondNursery | Second Nursery / Boston Letter | `sw_second_nursery.glb` | Five Doors | Boston letter, second music-box echo | quiet child light | Book 2 seed |
| SW_ThomasStudy | Thomas's Private Study | `sw_thomas_private_study.glb` | Five Doors, Cellar-opening journal logic | diary, contract, black-book authority marker | red desk lamp, rose scent | critical authority proof |
| SW_EleanorRoom | Eleanor's Room | `sw_eleanor_room.glb` | Five Doors | journal/testimony staging, witness marker | September window light | late showcase witness |

## First Blender Build Order

1. `gf_entrance_hall.glb`
2. `gf_west_wing_hall.glb`
3. `gf_kitchen.glb`
4. `gf_library.glb`
5. `gf_study.glb`
6. `gf_dining_room.glb`
7. `gf_conservatory_lemon_tree.glb`
8. `ff_gallery_landing.glb`
9. `ff_housekeeper_room.glb`
10. `ff_guest_bedroom_unnumbered.glb`
11. `at_long_attic.glb`
12. `at_sick_room_north.glb`
13. `at_sick_room_south.glb`
14. `at_water_tank_room.glb`
15. `ce_undercroft.glb`
16. `ce_caton_pillar.glb`
17. `ce_coal_room.glb`
18. `ce_bricked_archway.glb`
19. `ce_foundation_chamber.glb`
20. `ce_well_room.glb`

This order replaces the proven route first, then fills optional and structural rooms around it.

## Open Decisions Before First Export

- Decide the final Conservatory placement on the ground-floor map.
- Decide whether Roof Walk remains optional evidence or becomes required for final proof.
- Decide whether the attic Phantom Stair is built as visible architecture from the start or appears only after Act 4.
- Decide whether manuscript files in `Books/` should move to Git LFS before they grow further.
- Confirm one export folder convention in Godot before importing the first `.glb`.

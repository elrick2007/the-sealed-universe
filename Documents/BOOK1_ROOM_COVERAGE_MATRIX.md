# Book 1 Room Coverage Matrix

Last updated: 2026-06-15

This document tracks every room shown or implied by the current Book 1 maps before Blender architecture replacement. It separates three things that can otherwise blur together:

- **Mapped**: the room exists on a floor plan.
- **Playable**: the room has a Godot blockout route, interaction, puzzle, or evidence beat.
- **Still to plan**: the room needs a gameplay purpose before we spend Blender time dressing it.

Game 01 remains Book 1 only. The ending is one canon publish/send route that resolves Mara's register as `Incomplete` and points toward Book 2 without branching into alternate true endings.

## Recommended Finish Order Before Blender

1. Canon publish/send ending sequence v1.
2. Well Room / Book 2 stinger v1.
3. Save/load persistence pass.
4. Full smoke route with save/reload checkpoint.
5. Room-purpose lock for all mapped but unplanned rooms.
6. Blender room manifest pass: final dimensions, doors, ceilings, collision, lighting, required props, and export names.
7. Blender replacement begins floor by floor.

The key rule: do not start final Blender builds for rooms whose gameplay purpose is still unclear. Blockout first, art second.

## Ground Floor / Main Floor

| Room or Area | Map Status | Godot Status | Purpose Locked? | Still Needed Before Blender |
|---|---|---|---|---|
| Entrance Hall | Mapped | Playable | Yes | Final enclosed hall, chandelier, grand stair alignment, starting prop placement. |
| West Wing Hall | Mapped | Playable | Yes | Correct corridor proportions, door rhythm, subtle threshold scare dressing. |
| Library | Mapped | Playable | Yes | Bookshelf wall, shelf-gap clue, recorder wall surface, final collision. |
| Study | Mapped | Playable | Yes | Tape-measure pickup, desk, ledger shelves, correct route opening from Library. |
| Dining Room | Mapped | Playable | Yes | Thirteenth-place table layout, place-card props, chair/plate scale. |
| Kitchen | Mapped | Playable | Yes | Hub table, ledger, evidence board, recorder dock, clock, return-loop staging. |
| Conservatory / Lemon Tree Route | Implied by design bible, not clearly labelled on current ground map | Playable route stub | Yes | Decide final map location, lemon tree staging, rose-scent contrast toward Sealed Wing. |
| Locked East / Sealed Wing Door | Mapped as locked wing | Playable stub | Yes | Keep east/west contradiction readable; make compass/map lie into a physical clue. |
| Cellar Stairs | Mapped | Playable as route unlock | Yes | Align stairs with cellar map and undercroft arrival. |
| Grand / First Floor Stairs | Mapped | Playable as Act 2 stub | Yes | Align with Gallery Landing and Entrance Hall vertical view. |
| Master Bedroom | Mapped | Not yet playable as its own room | No | Decide whether Book 1 needs a critical route, optional evidence, or locked/readable-only state. |
| Nursery | Mapped | Not yet playable as its own room | No | Decide music-box/lullaby function or reserve for later polish. |
| Chapel Room | Mapped | Not yet playable as its own room | No | Decide register/candle evidence purpose or keep as sealed until later act. |
| Back Stair / Service Link | Implied | Partially represented through route logic | Partial | Clarify how it connects Kitchen, First Floor servants side, and Attic access. |

## First Floor

| Room or Area | Map Status | Godot Status | Purpose Locked? | Still Needed Before Blender |
|---|---|---|---|---|
| Gallery Landing | Mapped | Playable | Yes | Chandelier view down to Entrance Hall, handprint sightline, landing scale. |
| Servants' Passage | Mapped | Route-implied | Partial | Needs full traversal role, bell board placement, and connection to maid rooms. |
| Maid's Room I | Mapped | Not yet individual room | No | Decide whether it holds fever/household clue or dressing only. |
| Maid's Room II | Mapped | Not yet individual room | No | Decide route purpose or fold into servants' wing atmosphere. |
| Maid's Room III | Mapped | Not yet individual room | No | Decide route purpose or fold into servants' wing atmosphere. |
| Maid's Room IV | Mapped | Not yet individual room | Partial | Candidate scorch/black-window evidence from T1; needs route lock. |
| Housekeeper's Room | Mapped | Playable puzzle beat | Yes | Sewing-box puzzle dressing, chatelaine/pendulum props, household record placement. |
| Box Room | Mapped | Not yet playable as room | No | Decide case/agreement evidence purpose or optional lore room. |
| Dumbwaiter / D.W. | Mapped | System-implied | Partial | Needs traversal/puzzle purpose if we keep it in Act 2. |
| Connecting Door / East-Side Bolt | Mapped | Planned, not fully spatialized | Partial | Build the bolted-from-east loop once first floor layout is authored. |
| Guest Bedroom, unnumbered | Mapped accident/canon | Playable | Yes | Overnight bed-trade visual polish and guest-book prop dressing. |
| Guest Bedroom I | Mapped | Not yet playable | Partial | Decide Whitmore clue or locked room purpose. |
| Bathroom | Mapped | Not yet playable | No | Decide mirror/steam clue or atmosphere-only state. |
| Guest Bedroom II | Mapped | Not yet playable | Partial | Candidate toy-theatre/height-mark room from T1; needs route purpose. |
| Eleanor's Morning Room | Mapped | Not yet playable | No | Decide whether it foreshadows Sealed Wing or remains inaccessible until later. |
| Stair to Attics | Mapped | Playable route unlock | Yes | Align with Attic Stair Door and chatelaine gate. |

## Attic

| Room or Area | Map Status | Godot Status | Purpose Locked? | Still Needed Before Blender |
|---|---|---|---|---|
| Attic Stair | Mapped | Playable | Yes | Proper landing and door transition from first floor. |
| Long Attic | Mapped | Playable | Yes | Wire-trace spline, shelving, crawl-space silhouettes. |
| Servant's Sick Room North | Mapped | Playable | Yes | Fever chart, bed, mirrored-prop setup. |
| Servant's Sick Room South | Mapped duplicated room | Playable | Yes | Mirrored fever-chart contradiction and room duplication dressing. |
| Water Tank Room | Mapped | Playable | Yes | Tank, valves, tin, not-glass marble, wet clay effects. |
| Void / No Access Room | Mapped | Playable recorder/measurement wall | Yes | Make exterior dimensions physically impossible; no openable interior. |
| Hatch and Ladder to Roof Walk | Mapped | Not yet routed | Partial | Decide if roof walk/thirteen-windows proof stays in Book 1 playable route. |
| Roof Walk | Implied by hatch | Not yet playable | Partial | If retained, build night window proof and safe traversal. |
| Phantom Stair to Ground Floor | Mapped text | Not yet final-routed | Partial | One-use Act 4 descent should arrive behind or near cellar bricked archway. |

## Cellar

| Room or Area | Map Status | Godot Status | Purpose Locked? | Still Needed Before Blender |
|---|---|---|---|---|
| Cellar Stairs | Mapped | Playable route | Yes | Align with ground-floor stair position and undercroft arrival. |
| Undercroft | Mapped | Playable route space | Yes | Pillar array, hooks, low ceiling, route readability. |
| Caton Pillar | Mapped | Playable | Yes | Forty-seven initials, chisel mark surface, consent-mark affordance. |
| Wine Cellar | Mapped | Not yet individual route | No | Decide optional evidence or atmosphere-only room. |
| Coal Room | Mapped | Playable route beat | Yes | Three-stage coal obstruction and Foundation breach. |
| Cold Store | Mapped | Not yet playable | No | Decide hook-shadow scare or optional evidence. |
| Well Room | Mapped | Planned next | Yes | Build Book 2 stinger: jar list, voices, recorder-lowering beat. |
| Bricked Archway | Mapped | Playable | Yes | Loose brick, recorder yield, later phantom-stair relation. |
| Foundation Chamber | Mapped | Playable blockout | Yes | Original book, proof bundle, pen/oil as rejected offers, final register/send. |

## Sealed Wing / East Wing

The ground map labels the locked wing as East, while the story language says West. Keep this contradiction. The house's geometry lies, and the compass/map disagreement is a core clue.

| Room or Area | Map Status | Godot Status | Purpose Locked? | Still Needed Before Blender |
|---|---|---|---|---|
| Sealed Wing Boundary | Mapped as locked wing | Playable stub | Yes | Physical wrong-compass/east-west proof. |
| Drafted Threshold | Implied by route | Playable stub | Yes | Sketch-to-clay rendering language. |
| Impossible Corridor | Planned in Vol 5 | Playable measurement proof | Yes | Full corridor geometry, `42 ft / it is not` marker, authored measurement volumes. |
| Five Doors | Planned in Vol 5 | Not yet playable | Partial | Decide which doors are real, false, delayed, or journal-only. |
| Bare Bedroom | Planned in T1 | Not yet playable | Partial | Decide accumulation states and route value. |
| Sewing Room | Planned in T1 | Not yet playable | Partial | Decide hem-stitch puzzle role. |
| Second Nursery / Boston Letter | Planned in T1 | Not yet playable | Partial | Decide lore purpose and Book 2 seed limits. |
| Thomas's Private Study | Planned in Vol 5/T1 | Not yet playable | Yes | Diary/contract self-writing scene that leads toward cellar/foundation logic. |
| Eleanor's Room | Planned in Vol 5/T1 | Not yet playable | Yes | Witnessing sequence; should be a late showcase room, not early blockout noise. |

## Rooms Still Needing Gameplay Purpose

These rooms are on the maps or technical manifest but do not yet have a locked Book 1 gameplay purpose:

- Master Bedroom.
- Nursery.
- Chapel Room.
- First Floor Maid's Rooms I-III.
- First Floor Maid's Room IV, unless we lock the scorch/black-window evidence route.
- Box Room.
- Bathroom.
- Guest Bedroom I.
- Guest Bedroom II.
- Eleanor's Morning Room.
- Wine Cellar.
- Cold Store.
- Roof Walk, if retained.
- Sealed Wing five-door side rooms: Bare Bedroom, Sewing Room, second Nursery/Boston Letter.

## Rooms Ready For Blender After Final Route Lock

These rooms already have clear enough gameplay purpose to become first Blender targets after the ending, stinger, and save/load are done:

- Entrance Hall.
- West Wing Hall.
- Library.
- Study.
- Dining Room.
- Kitchen.
- Conservatory / lemon tree space, once final map position is chosen.
- Gallery Landing.
- Unnumbered Guest Bedroom.
- Housekeeper's Room.
- Long Attic.
- Both Servant's Sick Rooms.
- Water Tank Room.
- Attic Void exterior wall.
- Undercroft / Caton Pillar.
- Coal Room.
- Bricked Archway.
- Foundation Chamber.

## Map Decision Notes

- The current maps are enough to proceed. Do not generate a new full-floor map yet unless a route becomes impossible to explain.
- The two ground-floor stair routes should be treated as separate circulation logic: the grand stair leads toward the Gallery Landing / family-side first floor, while the service/cellar stair ties Kitchen, undercroft, servants side, and later attic/cellar misdirection together.
- The missing Sealed Wing map should remain a different document type: Eleanor's journal page, not Caton's survey. This preserves the visual break for Act 3.
- Conservatory placement should be clarified before Blender. Canonically, Eleanor's murder belongs with lemon trees, while rose scent belongs to the Sealed Wing door.

## Next Implementation Step

Finish the canon publish/send ending sequence, then build the Well Room / Book 2 stinger. Those two beats close Book 1's playable route and make the rest of the pre-Blender pass safer to evaluate.

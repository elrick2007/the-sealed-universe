# Project State - The Sealed Universe / Game 01

Last updated: 2026-06-15

## Repository

Target GitHub repository:

`https://github.com/elrick2007/the-sealed-universe`

Local project folder:

`C:\Users\Jason\Documents\New project 6`

Godot version:

`4.6.2 stable`

Godot console executable:

`C:\Users\Jason\Downloads\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe`

Main menu:

`res://scenes/menu.tscn`

Playable scene:

`res://scenes/main.tscn`

## Current Game Identity

Game 01 is a first-person claymation horror game set in Ashford Manor. The central horror is not a combat creature; the walls are the monster. The house stores voices, rewrites geometry, and turns documents into unreliable evidence.

The intended full series is six interlinked games under *The Sealed Universe*. This repository should become the durable source of truth for code, documents, maps, visual references, and build notes so future chats can recover context quickly.

## Locked Creative Decisions

- First-person perspective for the core game.
- Claymation horror art direction, with smooth first-person camera and stepped 12fps world/prop animation later.
- The house's geometry lies. The West/East contradiction on maps and compass readings is canon.
- Caton is the 1885 surveyor whose annotations appear across plans.
- The duplicated attic Sick Rooms, unnumbered guest bedroom, and Caton Pillar are canonized as puzzle/lore features.
- Eleanor was murdered among lemon trees. Rose scent belongs to the sealed-wing door and should not be used as the Conservatory truth.
- The Living Ledger is the signature mechanic: player actions become prose entries timestamped around 2:47 AM.
- Game structure should be open chapters: non-linear within acts, authored act gates between chapters.

## Current Playable Systems

- Main menu with start/options/quit.
- Fullscreen 1920x1080 project settings.
- First-person movement with WASD, arrow-key forward/back and turning, mouse look, interaction prompts.
- Journal/casebook with objectives and notes.
- Inventory with usable recorder/key entries.
- Fogged manor map with visited/known areas and locked floor tabs.
- Living Ledger entries.
- Evidence Board and progression meter.
- Camera / Photo Verb v1 with `C` input and inventory use.
- Kitchen hub return loop.
- Recorder yield system.
- Tape measure/Caton measurement mechanic.
- Library shelf-gap / Caton margin-mark clue.
- December 2 / Incomplete casebook pressure line.
- 2:47 scheduler with Kitchen clock overnight event trigger.
- Conservatory-to-Sealed Wing transition gate.
- Sealed Wing drafted threshold stub.
- Eleanor's hand-drawn sealed-wing map pickup.
- Impossible corridor tape-measure proof.
- Kitchen impossible-measure return and first-floor plan unlock.
- First Floor stair / Act 2 transition stub.
- Gallery Landing v1 with chandelier handprint evidence beat.
- Chandelier handprint photo proof that gates the unnumbered guest bedroom lead.
- Unnumbered Guest Bedroom bed-trade v1 with burnt-page offer, 2:47 return, altered-fragment evidence, and comparison follow-up.
- Altered-fragment guest-book comparison v1, opening a Housekeeper household-record lead into the next First Floor branch.
- Housekeeper sewing-box v1, yielding the chatelaine and stopped clock pendulum from the unnumbered-room cipher.
- Hall-clock pendulum hook v1, restoring the Entrance Hall grandfather clock and unlocking scheduled 2:47 events.
- First scheduled 2:47 payoff v1, letting Mara set a chosen appointment at the restored hall clock and resolve it through the Kitchen clock.
- Attic Stair Door v1, joining the Housekeeper's chatelaine to the chosen 2:47 proof and unlocking the first attic-route stub.
- Long Attic Wire Trace v1, resolving the blank-bell objective and seeding the duplicated Servant's Sick Rooms.
- Duplicated Sick Rooms v1, comparing Ada's recovered/deceased fever charts and opening the not-glass marble route.

## Blender / Godot Pipeline Status

- Blender 5.1.1 is installed at `C:\Users\Jason\Documents\blender-5.1.1-windows-x64\blender.exe`.
- Blender MCP add-on is reachable on `127.0.0.1:9876` when the add-on shows `Server is running`.
- Live Blender MCP control was verified by `tools/blender_mcp_live_test.ps1`, which creates `WW_MCP_Live_Proof_Sphere` and `WW_MCP_Live_Proof_Base` in the open Blender scene.
- Script-driven Blender export is also verified through `assets/blender_source/tests/build_blender_control_test.py`.
- Godot should import exported GLB files from `assets/blender_exports`; Blender source files under `assets/blender_source` are ignored by Godot via `.gdignore`.
- Water Tank / Not-Glass Marble v1, gating the drowned tin behind Ada's contradiction and turning the not-glass marble into an inventory key for the mirror chest route.
- Mirror Chest / Caton Field Book v1, using the not-glass marble in the north Sick Room chest so the south twin opens with Caton's Field Book and unlocks the Caton measurement overlay seed.
- Caton Field Book overlay payoff v1, turning the Field Book into a tape-measure modifier that compares Caton's submitted dimensions against the house's true dimensions.
- Attic Void / Caton overlay payoff v1, using Caton's Field Book on the attic void to compare exterior dimensions against the chain fed through the wire hole.
- Attic Void recorder yield v1, capturing the wrong male filing voice behind the no-access wall after Caton's overlay proof.
- Attic Void Kitchen return beat v1, pinning the filed-alive recording to the Kitchen evidence board and opening the filing-voice source lead.
- Filing Voice Source Route v1, gating an attic filing shelf behind the Kitchen-pinned void recording and turning `CATON / LIVING / BELOW` into the next Caton Pillar route objective.
- Caton Pillar / cellar route seed v1, unlocking the Cellar map tab and chisel thread after the filing voice points below.
- Chisel / consent-mark route v1, turning Caton's chisel into a witness-mark payoff and opening the Foundation Chamber lead.
- Foundation Chamber / coal-below route v1, clearing the coal below Caton's witness mark and opening the chamber threshold.
- Foundation Chamber threshold / Bricked Archway route v1, making the chamber's true silence a clue and confirming the archway as a permanent wall.
- Foundation Chamber interior blockout with original book shelf and pen/oil/proof affordance seed.
- Foundation Chamber first-read / testament page v1, seeding the publish route from the original book without activating any ending choice.
- Foundation Chamber evidence-board return / publish-meter v1, turning the Testament Page into pinned Kitchen proof and starting the first red-thread publish-meter payoff.
- Publish-meter proof chain v1, turning the proof bundle into the second Kitchen-board witness after the Testament Page is pinned.
- Publish-meter final proof v1, turning the refused oil can into the third Kitchen-board witness while keeping the endgame choices inactive.
- Publish choice lock v1, making the pen, oil, and proof bundle answer as locked ending affordances after the 3/3 proof chain, opening the missing-authority objective without selecting an ending.
- Final-authority seed v1, making the original Testament Page reveal that proof is not authority after all three chamber offers refuse Mara, opening the occupant-authority record lead while keeping endings inactive.
- Occupant Authority Record v1, turning Caldwell's black-book record into a second-read proof that Caldwell recruits, while the current occupant must answer for Ashford Manor.
- Current Occupant Proof v1, turning Mara's `Incomplete` entry into proof that she is the occupant held in abeyance, while the final Book 1 ending remains locked.
- Foundation current-occupant return v1, letting the original book accept Mara's authority proof while keeping every final ending affordance inactive.
- Final-register preparation beat v1, turning the completed proof bundle into Mara's prepared register line instead of an ending-choice branch.
- Canon publish/send ending sequence v1, sending Mara's final register as the only Book 1 ending path and resolving the register line to `Incomplete` while pen/oil remain rejected witnessed offers.
- Act 1 progression lock and next-route gate.

## Current Playable Route

1. Entrance Hall: collect recorder and iron key.
2. Whisper Wall: inspect and use recorder.
3. West Wing Door: open after the recorder/key sequence.
4. West Wing Hall: trigger threshold scare and new objective.
5. Manor Plans: collect map and reveal partial ground floor.
6. Library/Study route: inspect Library wall, open Study access, collect tape measure, measure true/false spaces, then inspect the shelf gap to find Caton's missing-inch margin mark.
7. Dining Room route: table inspection, thirteenth-place puzzle, Eleanor place card, recorder response.
8. Kitchen hub: ledger, evidence board, recorder dock, route gating.
9. Conservatory Lemon Tree setup: route opens from Kitchen/Act 1 gate; lemon tree reveals the lemon/rose canon split.
10. Rose-scent trace: after the lemon tree is witnessed, the player can trace the impossible rose scent toward the sealed-wing boundary.
11. Kitchen rose-trace return: the Kitchen accepts the rose contradiction and sends Mara back to test the sealed edge.
12. Sealed Wing boundary stub: the boundary refuses to open and points toward a living name in the records.
13. Martin Caldwell living record: after the sealed boundary asks for a living name, the Kitchen black-book record reveals Caldwell as `Status: Living` and recruiter.
14. Mara December 2 / Incomplete seed: after Caldwell is exposed, Mara's own black-book line rewrites from a death date to `Incomplete`, seeding a subtle casebook countdown pressure line and reserving the next 2:47 Living Ledger event.
15. Kitchen 2:47 clock: the Kitchen clock resolves the reserved page, writes `2:47 AM - Incomplete Writes Back`, completes the reserved-page objective, and changes the casebook line to `2:47 WROTE: INCOMPLETE`.
16. Return to the unwritten door: after the Incomplete beat is armed or written, the sealed boundary accepts the word as a future route condition, pins new evidence, writes `2:47 AM - A Door In Draft`, and reveals the East/Sealed Wing as the next drafted space.
17. Drafted Sealed Wing threshold: a small pencilled threshold takes weight, completes the drafted-door objective, marks the East/Sealed Wing as visited, and adds the next objective to find Eleanor's hand-drawn sealed-wing map.
18. Eleanor's hand-drawn map: a small iron-gall map page in the drafted threshold completes the map objective, pins the `42 ft / it is not` contradiction, and seeds the next impossible-corridor measurement objective.
19. Impossible corridor measurement: using the tape on the drafted sealed-wing corridor after finding Eleanor's map proves the `42 ft` note is unstable, records a `47 ft -> 42 ft` contradiction, and sends Mara back toward the Kitchen evidence loop.
20. Kitchen impossible-measure return: the Kitchen accepts the borrowed five feet, pins an Act 2 gate proof, unlocks the First Floor map tab, and gives Mara the next objective to find the First Floor staircase.
21. First Floor stair stub: after the Kitchen accepts the borrowed five feet, Mara can find a provisional staircase, start Act 2, and receive the Gallery Landing objective.
22. Gallery Landing v1: the borrowed stairs now place Mara on a blockout First Floor landing, reframe the Entrance Hall from above, and seed the raised chandelier handprint clue toward the unnumbered guest bedroom route.
23. Camera / Photo Verb v1: Mara carries a camera from the start, but the verb only matters once the house leaves visible proof. Photographing the opened chandelier links pins a photo-evidence beat and unlocks the unnumbered guest bedroom objective.
24. Unnumbered Guest Bedroom v1: after the chandelier photo, the family-side wrong room can be entered. The guest book and too-ready bed pin the room as missing from household records.
25. Unnumbered bed trade v1: the Library's burnt black-book fragment can be left on the unnumbered bed, resolved through the Kitchen 2:47 clock, and returned as an altered fragment with new evidence, ledger, journal, and guest-book comparison follow-up.
26. Altered-fragment guest-book comparison v1: reading the returned fragment beside the blank guest-book line now pins comparison evidence, opens the Housekeeper-record thread, and lets Mara read a folded household record that points toward the Housekeeper's sewing box.
27. Housekeeper sewing-box v1: the folded household record unlocks the Housekeeper's thread-dial sewing box. Opening it completes the sewing-box objective, adds the Housekeeper's chatelaine and stopped clock pendulum to inventory, pins evidence, writes a Living Ledger beat, and opens the hall-clock and attic-stair objectives.
28. Hall-clock pendulum hook v1: the Entrance Hall grandfather clock now records its missing pendulum before the Housekeeper branch, accepts the stopped pendulum after the sewing box, unlocks deliberate 2:47 scheduling, pins evidence, writes two Living Ledger beats, and opens the first scheduled-event objective.
29. First scheduled 2:47 payoff v1: interacting with the restored grandfather clock sets Mara's chosen 2:47 appointment, completes the scheduling objective, writes an appointment ledger beat, and lets the Kitchen clock resolve the chosen-hour payoff with a new note, evidence pin, and Living Ledger entry.
30. Attic Stair Door v1: the Housekeeper's chatelaine now has a physical servant-side door. It refuses before the chosen 2:47 route proof, then opens the attic route stub, unlocks the Attic map tab, completes the attic-stair objectives, and seeds the blank-bell wire objective.
31. Long Attic Wire Trace v1: after the attic stair opens, Mara can enter the Long Attic, trace the blank bell wire, pin duplicated Sick Rooms evidence, write a Living Ledger beat, and open the objective to compare both Servant's Sick Rooms.
32. Duplicated Sick Rooms v1: after the blank bell wire is traced, Mara can read both mirrored fever charts. One lets Ada recover, one files her death at 2:47, resolving the first explicit attic contradiction and opening the not-glass marble objective.
33. Water Tank / Not-Glass Marble v1: after Ada's contradiction is resolved, Mara can drain the Water Tank, recover a soldered tin and wrong marble, complete the not-glass objective, pin evidence, write a Living Ledger beat, and open the north mirror-chest objective.
34. Mirror Chest / Caton Field Book v1: the north Sick Room chest accepts the not-glass marble, but the south twin opens instead. Mara loses the marble, gains Caton's Field Book, pins the mirrored-chest evidence, writes the `2:47 AM - Caton's Figures` ledger beat, and opens the objective to use Caton's figures with the tape measure.
35. Caton Field Book overlay payoff v1: after the mirrored chest route, using the tape on the West Wing Hall now overlays Caton's submitted `42 ft` against the house's true `47 ft`, pins a submitted/true measurement proof, completes the Field Book objective, and opens the attic-void measurement lead.
36. Attic Void / Caton overlay payoff v1: using Caton's overlay on the attic void after tracing the blank bell wire proves the exterior `9 x 12 ft` dimensions cannot contain the `41 ft` chain measurement, pins the void-measurement evidence, writes the `2:47 AM - The Room That Refused` ledger beat, completes the attic-void objective, and opens the recorder objective for the void wall.
37. Attic Void recorder yield v1: recording the void wall after Caton's proof captures shelving sounds and a patient male dictation, `Item: one journalist, lapsed`, pins the filed-voice evidence, writes `2:47 AM - Filed Alive`, and opens the Kitchen return objective for the void recording.
38. Attic Void Kitchen return beat v1: returning to the Kitchen after the void recording completes the return objective, pins `Kitchen Pin: Filed Alive` to the board, writes `2:47 AM - Filed to the Board`, and opens the objective to trace where the filing voice is shelving Mara's name.
39. Filing Voice Source Route v1: after the Kitchen board accepts the void recording, the Long Attic filing shelf answers with `CATON / LIVING / BELOW`, completes the filing-source objective, pins evidence, writes `2:47 AM - Filed Under Living`, and opens the Caton Pillar objective.
40. Caton Pillar / cellar route seed v1: after the filing shelf points below, Mara can inspect the cellar pillar, complete the Caton Pillar objective, unlock the Cellar map tab, pin forty-seven initials evidence, write the Stone Ledger beat, and open the chisel objective.
41. Chisel / consent-mark route v1: once the Caton Pillar asks for a tool, Mara can recover Caton's chisel, add it to inventory, return to the pillar, carve a witness mark instead of her name, pin consent-mark evidence, write `2:47 AM - Consent in Stone`, and open the Foundation Chamber objective.
42. Foundation Chamber / coal-below route v1: after the pillar is marked, Mara can clear the coal below Caton, reveal the Foundation Chamber threshold, pin cellar evidence, write `2:47 AM - Behind the Coal`, and open the threshold inspection objective.
43. Foundation Chamber threshold / Bricked Archway route v1: after clearing coal, Mara can inspect the silent Foundation threshold, seed the bricked archway route, pull one loose brick from the blocked arch, confirm the permanent-wall rule, pin evidence, write `2:47 AM - Filed Under Later`, and open the bricked-archway recorder objective.
44. Bricked Archway recorder / Foundation Chamber choice seed v1: recording the blocked archway now returns the bricklaying playback, pins the archway recording, writes `2:47 AM - Course By Course`, and re-checking the silent threshold seeds the chamber's future pen/oil/proof offers without opening the endgame room.
45. Foundation Chamber interior blockout v1: after the three offers are seeded, Mara can inspect the original book shelf and study the writing stand, oil can, and proof bundle, completing the chamber-affordance objective and opening the testament-page lead.
46. Foundation Chamber first-read / testament page v1: after the pen/oil/proof affordances are all witnessed, Mara can read the first testament page, seed the publish-meter route, pin the proof seed, write `2:47 AM - Testament Page`, and open the Kitchen evidence-board return without choosing an ending.
47. Foundation Chamber evidence-board return / publish-meter v1: returning to the Kitchen board after reading the Testament Page completes the return objective, pins the page as publish-route proof, reveals the first red thread on the physical board, shows `Publish route witness: 1 / 3`, writes `2:47 AM - The First Red Thread`, and opens the remaining publish-proof objective without choosing an ending.
48. Publish-meter proof chain v1: after the Testament Page is pinned, re-checking the Foundation Chamber proof bundle turns it into evidence rather than an ending button. Returning that witness to the Kitchen board pins the proof bundle, reveals the second red thread, advances the meter to `Publish route witness: 2 / 3`, and keeps the final send/publish choice inactive.
49. Publish-meter final proof v1: after the proof bundle is pinned, re-checking the oil can turns refusal into evidence instead of the burn offer. Returning that witness to the Kitchen board pins the oil refusal, reveals the third red thread, advances the meter to `Publish route witness: 3 / 3`, completes the publish witness chain objective, and still does not activate any ending choice.
50. Publish choice lock v1: after the publish proof chain reaches `3 / 3`, re-testing the pen, oil, and proof bundle records each as a deliberately locked ending affordance. Once all three refuse Mara, the journal opens the final-authority objective while the ending-choice state remains inactive.
51. Final-authority seed v1: re-reading the original Testament Page after all three locked ending affordances refuse Mara reveals the authority clause, completes the missing-authority objective, pins the clause as Foundation evidence, writes `2:47 AM - Authority Clause`, and opens the objective to find the record naming who may answer for Ashford Manor.
52. Occupant Authority Record v1: re-checking Caldwell's black-book record after the authority clause completes the occupant-authority objective, pins the current-occupant proof, writes `2:47 AM - Current Occupant`, and opens the next proof that must establish whether Mara can answer for the house before any final ending can activate.
53. Current Occupant Proof v1: re-reading Mara's `December 2 / Incomplete` entry after Caldwell is reduced to recruiter completes the current-occupant objective, pins Mara as the occupant held in abeyance, writes `2:47 AM - Current Occupant`, and opens the Foundation return objective while keeping every ending locked.
54. Foundation current-occupant return v1: returning Mara's proof to the original book completes the Foundation return objective, pins the occupant-accepted evidence, writes `2:47 AM - Disposition: Hers`, and opens final-register preparation while keeping the ending choice inactive.
55. Final-register preparation beat v1: after the current-occupant proof is accepted, the Foundation proof bundle becomes a prepared register line rather than a branch selector. It completes `prepare_final_register_without_choosing`, opens the canon send objective, pins `Prepared Final Register`, writes `2:47 AM - Final Register`, and still does not unlock or select an ending.
56. Canon publish/send ending sequence v1: interacting with the prepared register sends Mara's final record, completes the Book 1 canon ending state, writes `Voss, M. / December 2 / Incomplete`, completes the send objective, and opens the Well Room handoff without activating alternate endings.
57. Well Room / Book 2 stinger v1: after the canon register is sent, Mara can lower the recorder into the Well Room, raise the dry jar list, seed the five-symbol / moth-and-mountain bridge toward Book 2, complete the post-send handoff objective, and write the final connective Living Ledger beat without creating another ending.

Before Blender architecture replacement, keep the route links across Ground Floor, First Floor, Attic, Cellar, and the future Sealed Wing page aligned as one navigable house. Blockout proves mechanic order first; Blender should then make the rooms enclosed, correctly scaled, and visually consistent.

## Important Documents

- `Documents/Game_Bible_Vol1_Ground_Floor.md`
- `Documents/Game_Bible_Vol2_First_Floor.md`
- `Documents/Game_Bible_Vol3_Attics.md`
- `Documents/Game_Bible_Vol4_Cellar.md`
- `Documents/Game_Bible_Vol5_Sealed_Wing.md`
- `Documents/Continuity_Lore_Audit_Book1.md`
- `Documents/Epilogue_There_Is_Always_One.md`
- `Documents/Technical_Pass_T1_Scenes_and_Assets.md`
- `Documents/Technical_Bible_T2_Systems.md`
- `Documents/Technical_Bible_T3_Art_Shader_Pipeline.md`
- `Documents/Technical_Bible_T4_Milestone1_PROVISIONAL.md`
- `Documents/Technical_Bible_T5_Cinematics.md`
- `Documents/M0_to_M1_Setup_Checklist.md`
- `Documents/BOOK1_ROOM_COVERAGE_MATRIX.md`
- `Documents/BOOK1_ROOM_PURPOSE_LOCK.md`
- `Documents/BOOK1_BLENDER_ROOM_MANIFEST.md`
- `Documents/BOOK1_GODOT_GLB_IMPORT_CONVENTION.md`
- `Documents/BOOK1_ENTRANCE_WESTWING_BLENDER_PASS.md`

## Validation Commands

Smoke playthrough:

```powershell
& "C:\Users\Jason\Downloads\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe" --headless --path "C:\Users\Jason\Documents\New project 6" --script res://scripts/smoke_playthrough.gd
```

Main scene load:

```powershell
& "C:\Users\Jason\Downloads\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe" --headless --path "C:\Users\Jason\Documents\New project 6" --scene res://scenes/main.tscn --quit-after 3
```

Menu scene load:

```powershell
& "C:\Users\Jason\Downloads\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe" --headless --path "C:\Users\Jason\Documents\New project 6" --scene res://scenes/menu.tscn --quit-after 3
```

Last known validation after save/load persistence v1:

- Smoke playthrough passed.
- Main scene headless load passed.
- Menu scene headless load passed.
- Godot may print ObjectDB/resource warnings on headless quit; no gameplay-blocking script error was observed.

## GitHub Setup Recommendation

Use the new repository as the long-term monorepo for the whole six-game series. For the first snapshot, keep the current Godot project at the root to avoid breaking paths. Later, once the project is stable and backed up, consider moving into:

```text
games/
  game-01-the-whispering-walls/
    godot/
    blender/
    docs/
    images/
    audio/
universe/
  lore/
  continuity/
  characters/
  timeline/
tools/
```

For now, commit:

- `project.godot`
- `scenes/`
- `scripts/`
- `images/` and image `.import` files
- `Documents/`
- `README.md`
- `.gitignore`
- `icon.svg` and `icon.svg.import`

Do not commit:

- `.godot/`
- exported builds
- temporary Blender autosaves
- logs and local editor folders

Add Git LFS later before committing large `.blend`, `.wav`, `.mp4`, or final high-resolution asset libraries.

## Next Build Step

Entrance Hall controlled replacement v1: replace only the Entrance Hall blockout shell with the imported GLB wrapper while preserving the current gameplay nodes, route prompts, pickups, wall inspection, door logic, and smoke-playthrough path.

## Latest Build Step

### Godot side-by-side GLB route proof v1

- Confirmed `res://scenes/main.tscn` loads with `BlenderImportPreview` and both GLB wrapper scenes present.
- Confirmed the smoke playthrough still passes while the imported GLBs are preview-only.
- Verified both wrapper scenes reference exported GLBs and carry preview metadata rather than gameplay bindings.
- Cleared the first replacement pair for controlled swap-in: Entrance Hall first, West Wing Hall second.

### Godot wrapper import test v1

- Added wrapper scenes for `gf_entrance_hall.glb` and `gf_west_wing_hall.glb` under `assets/imported_scenes/rooms/ground/`.
- Instanced both wrappers under `BlenderImportPreview` in `scenes/main.tscn`, offset beside the current blockout.
- Marked the preview node as non-gameplay metadata so the working route remains bound to the original blockout until the side-by-side route proof passes.
- Next step is a playable inspection pass before any replacement of starter-room architecture.

### Blender control proof and source ignore v1

- Confirmed Blender 5.1.1 is available at `C:\Users\Jason\Documents\blender-5.1.1-windows-x64\blender.exe`.
- Added `assets/blender_source/tests/build_blender_control_test.py`.
- Generated `assets/blender_source/tests/blender_control_test.blend`.
- Exported `assets/blender_exports/tests/blender_control_test.glb`.
- Added `assets/blender_source/.gdignore` so Godot does not try to import `.blend` source files and ask for a Blender executable path. Godot should import exported GLB files from `assets/blender_exports` instead.
- Local Blender MCP/live-editor control did not respond on `localhost:9876` from this session, so the current reliable route is script-driven Blender generation/export.

### Entrance Hall / West Wing Hall Blender source v1

- Added `assets/blender_source/rooms/ground/build_entrance_westwing.py`.
- Generated `assets/blender_source/rooms/ground/ww_gf_entrance_westwing.blend`.
- Exported `assets/blender_exports/rooms/ground/gf_entrance_hall.glb` and `assets/blender_exports/rooms/ground/gf_west_wing_hall.glb`.
- First pass includes enclosed floors, walls, ceilings, clay material variants, runners, doorway frames, starter props, breathing-wall tags, route markers, a measurement marker, and simple collision helper meshes.
- UPBGE printed a Logic Nodes registration warning during headless startup, but the `.blend` save and both GLB exports completed successfully.
- Next step is a Godot wrapper import test before the working blockout is replaced.

### Godot GLB import convention v1 and first replacement pass started

- Added `Documents/BOOK1_GODOT_GLB_IMPORT_CONVENTION.md`.
- Created the initial `assets/blender_source`, `assets/blender_exports`, and `assets/imported_scenes` folder contract.
- Added `Documents/BOOK1_ENTRANCE_WESTWING_BLENDER_PASS.md` for the first claymation architecture replacement target.
- Locked the first room pair: Entrance Hall and West Wing Hall, preserving starter-loop gameplay while replacing blockout with enclosed claymation architecture.

### Cinematics and setup references archived

- Added `Documents/Technical_Bible_T5_Cinematics.md` as reference-only guidance for rostrum intros, in-engine scares, and limited character-performance cinematics.
- Confirmed `Documents/M0_to_M1_Setup_Checklist.md` is already in the project archive for Blender/Godot setup reference.
- Superseded by the later GLB convention lock; the active next build step is now the Entrance Hall / West Wing Hall Blender source pass.

### Blender room manifest lock v1

- Added `Documents/BOOK1_BLENDER_ROOM_MANIFEST.md`.
- Converted every mapped Book 1 room and structural connector into a Blender build target with export filename, connections, required props, lighting mood, and gameplay hooks.
- Locked the first Blender build order around the proven route first: Entrance Hall, West Wing Hall, Kitchen, Library, Study, Dining, Conservatory, then the First Floor, Attic, and Cellar proof rooms.
- Left only pre-export decisions open at the time: Conservatory placement, Roof Walk status, Phantom Stair visibility, Git LFS for manuscripts, and the Godot GLB import convention. The GLB convention is now locked in `Documents/BOOK1_GODOT_GLB_IMPORT_CONVENTION.md`.

### Full map label audit v1

- Checked the Ground Floor, First Floor, Attic, and Cellar map labels against the room coverage matrix and purpose lock before Blender planning.
- Added the cellar Hook Room / Hanging Closet and Foundation Annex / Do-Not-Store Alcove as locked spaces.
- Added the attic Measured-Thrice Room / Larger-Inside Space, hatched eaves/storage voids, and contradictory ground-floor descent marks as locked spaces or structural notes.
- Marked the full map/floor label audit complete in the pre-Blender checklist.

### Room-purpose lock pass v1

- Added `Documents/BOOK1_ROOM_PURPOSE_LOCK.md` as the pre-Blender purpose lock for remaining mapped rooms.
- Locked Master Bedroom, Nursery, Chapel Room, service links, First Floor side rooms, Roof Walk, Phantom Stair, Wine Cellar, Cold Store, and Sealed Wing side rooms into critical, required-evidence, optional-evidence, atmosphere, or structural roles.
- Preserved the one-ending guardrail: Sealed Wing side rooms can witness rejected offers or temptations, but they do not create alternate true endings.
- Updated the pre-Blender checklist and room coverage matrix so the next step is the Blender room manifest.

### Save/load persistence v1

- Added compact JSON persistence at `user://book1_save.json`.
- F5 quick-saves and F9 quick-loads during play.
- Save/load preserves root story flags, player position/facing/camera pitch, player inventory, recorder state, casebook objectives, notes, Living Ledger, evidence board, map reveals, visited rooms, and unlocked floor tabs.
- The smoke playthrough now saves after the full Book 1 route and Well Room / Book 2 stinger, deliberately clears late-game state, reloads, and verifies the canon ending and anthology bridge return.

## Pre-Blender Room Tracking

`Documents/BOOK1_ROOM_COVERAGE_MATRIX.md` is the current source for mapped rooms, playable rooms, and Blender readiness. `Documents/BOOK1_ROOM_PURPOSE_LOCK.md` records the role of every mapped-but-previously-unplanned room. `Documents/BOOK1_BLENDER_ROOM_MANIFEST.md` converts those rooms into export targets for Blender. `Documents/BOOK1_GODOT_GLB_IMPORT_CONVENTION.md` locks how those exports land in Godot, and `Documents/BOOK1_ENTRANCE_WESTWING_BLENDER_PASS.md` starts the first replacement pair. Use these alongside `Documents/BOOK1_PRE_BLENDER_CHECKLIST.md` before creating final room assets.

## Anthology Ending Guardrail

Book 1 must stay true to the publish-ending spine: Mara's register line resolves to `December 2nd: Incomplete`, then the Well Room/jar-list stinger points toward Book 2 (*The Ink Dwellers*) without explaining the full six-game anthology arc too early.

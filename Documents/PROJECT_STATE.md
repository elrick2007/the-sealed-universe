# Project State - The Sealed Universe / Game 01

Last updated: 2026-06-14

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

Last known validation after Foundation Chamber / coal-below route v1:

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

Build the Foundation Chamber threshold inspection and bricked archway route.

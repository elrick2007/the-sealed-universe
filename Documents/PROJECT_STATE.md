# Project State - The Sealed Universe / Game 01

Last updated: 2026-06-13

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

Last known validation after First Floor Stair / Act 2 Transition Stub v1:

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

Build the Gallery Landing v1 as the first true Act 2 space, keeping it blockout-first and driven by the First Floor map/story gates.

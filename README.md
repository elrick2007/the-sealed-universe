# The Sealed Universe - Game 01: The Whispering Walls

Godot vertical slice for the first game in *The Sealed Universe*, a six-game horror series built around interlinked lore, living documents, and Ashford Manor as an impossible claymation house.

Current design thesis: the walls are the monster. The player explores in first person, gathers evidence, uses the recorder and tape measure to challenge the house's false geometry, and builds a living ledger that writes the game back into prose.

## Open

Open this folder in Godot 4.6.2:

`C:\Users\Jason\Documents\New project 6`

Main scene:

`res://scenes/menu.tscn`

Menu:

- `Start Game`
- `Options / Controls`
- `Quit`

Playable slice:

`res://scenes/main.tscn`

Target runtime:

- 1920x1080
- Fullscreen
- Compatibility renderer

## Controls

- `WASD`: move
- Arrow keys: move forward/back and turn left/right
- Mouse: look
- `E`: interact
- `R`: use recorder
- `T`: use tape measure
- `C`: use camera
- `J`: open/close journal
- `I`: open/close inventory
- `M`: open/close map
- `L`: open/close living ledger
- `Esc`: close journal/inventory or release mouse
- Click: recapture mouse

## Current Playable Loop

1. Pick up the recorder in the entrance hall.
2. Find the iron key.
3. Use the recorder near the right-hand whisper wall.
4. Listen/read the playback message.
5. Use the key to open the west wing door.
6. Cross into the west wing hallway and trigger the first corridor scare.
7. Find the manor plans and press `M` to view the fogged ground-floor map.
8. Follow the Library/Study route, find the tape measure, and test the measurement mechanic.
9. Solve the Dining Room thirteenth-place beat.
10. Return to the Kitchen hub for ledger pages, evidence board progress, recorder transcription, and Act 1 route gating.
11. Open the Conservatory/Lemon Tree setup, correcting the canon: Eleanor's murder belongs to lemon trees; the rose scent belongs to the sealed wing.
12. Photograph visible proof the house leaves behind before the next route opens.

## Project Memory

For future chats or new contributors, start with:

- `Documents/PROJECT_STATE.md`
- `Documents/Game_Bible_Vol1_Ground_Floor.md`
- `Documents/Continuity_Lore_Audit_Book1.md`
- `Documents/Technical_Bible_T2_Systems.md`
- `Documents/Technical_Bible_T3_Art_Shader_Pipeline.md`
- `Documents/Technical_Bible_T4_Milestone1_PROVISIONAL.md`

## Validation

Smoke test:

```powershell
& "C:\Users\Jason\Downloads\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe" --headless --path "C:\Users\Jason\Documents\New project 6" --script res://scripts/smoke_playthrough.gd
```

Main scene load:

```powershell
& "C:\Users\Jason\Downloads\Godot_v4.6.2-stable_win64.exe\Godot_v4.6.2-stable_win64_console.exe" --headless --path "C:\Users\Jason\Documents\New project 6" --scene res://scenes/main.tscn --quit-after 3
```

## Next Build Targets

- Keep building Act 1 ground-floor routes in blockout before Blender art replacement.
- Add the Conservatory rose-scent misdirection and sealed-wing clue chain.
- Expand the Living Ledger into exportable prose.
- Replace blockout room chunks with Blender-authored claymation GLB architecture once mechanics are locked.
- Add voiceover, music, and SFX late, after route pacing is stable.

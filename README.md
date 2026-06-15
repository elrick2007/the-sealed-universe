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
13. Enter the unnumbered guest bedroom, leave the burnt black-book fragment on the bed, and use the 2:47 Kitchen clock to receive the altered fragment.
14. Compare the altered fragment with the blank guest-book line, then read the folded Housekeeper record to open the sewing-box branch.
15. Open the Housekeeper's sewing box to gain the chatelaine and stopped clock pendulum.
16. Return the pendulum to the Entrance Hall grandfather clock to unlock deliberate 2:47 scheduling.
17. Set a chosen 2:47 appointment at the restored hall clock, then resolve it at the Kitchen clock to prove the house can answer a time Mara chooses.
18. Open the attic route, compare both duplicated Sick Room fever charts, then drain the Water Tank to recover the not-glass marble.
19. Use the not-glass marble on the north Sick Room chest, then recover Caton's Field Book from its southern twin.
20. Use Caton's Field Book with the tape measure to compare submitted dimensions against the house's true dimensions.
21. Measure the attic void with Caton's overlay and prove the room is larger through the wire hole than it is from the outside.
22. Record the attic void wall after the measurement proof and capture the wrong male voice filing Mara as an item.
23. Return the void recording to the Kitchen evidence board so Mara can pin the filed-alive proof and open the filing-voice source lead.
24. Trace the filing voice to the attic shelf labelled `CATON / LIVING / BELOW`, opening the Caton Pillar thread.
25. Follow `CATON / LIVING / BELOW` to the first cellar blockout, inspect the Caton Pillar, and unlock the cellar map tab/chisel thread.
26. Recover Caton's chisel, mark the pillar with a witness mark instead of Mara's name, and open the Foundation Chamber lead.
27. Clear the coal below Caton's new mark to reveal the Foundation Chamber threshold.
28. Inspect the Foundation Chamber threshold, then test the bricked archway's loose brick and learn the wall is permanent.
29. Record the bricked archway and re-check the Foundation threshold to seed the chamber's three offers: pen, oil, proof.
30. Enter the Foundation Chamber blockout, inspect the original book shelf, and study the pen/oil/proof affordances without choosing an ending yet.
31. Read the original book's first testament page to seed the publish route without choosing an ending.
32. Return the Testament Page proof to the Kitchen evidence board to start the first red-thread publish-meter payoff.
33. Re-check the proof bundle after the Testament Page is pinned, then return it to the Kitchen evidence board as the second publish-route witness.
34. Re-check the oil can after the proof bundle is pinned, then return its refusal witness to the Kitchen evidence board as the third publish-route proof.
35. Return to the Foundation Chamber and test the pen, oil, and proof bundle again; all three ending choices refuse Mara until the missing authority is found.
36. Re-read the original book's testament page to reveal the authority clause: proof is not enough, and Mara must find the record naming who may answer for Ashford Manor.
37. Re-check Caldwell's black-book record after the authority clause to learn that Caldwell recruits, but the current occupant must answer for Ashford Manor.
38. Re-read Mara's December 2 / Incomplete entry to prove she is the current occupant held in abeyance, without unlocking or choosing the Book 1 ending yet.
39. Return Mara's current-occupant proof to the Foundation Chamber so the original book accepts her authority while the final ending remains unwritten.

## Project Memory

For future chats or new contributors, start with:

- `Documents/PROJECT_STATE.md`
- `Documents/Game_Bible_Vol1_Ground_Floor.md`
- `Documents/Continuity_Lore_Audit_Book1.md`
- `Documents/Technical_Bible_T2_Systems.md`
- `Documents/Technical_Bible_T3_Art_Shader_Pipeline.md`
- `Documents/Technical_Bible_T4_Milestone1_PROVISIONAL.md`

Book 1's ending spine stays fixed: the publish route resolves to `December 2nd: Incomplete`, then the Well Room/jar-list stinger points into Book 2 without explaining the wider six-game anthology too early.

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
- Build the final-register preparation beat after the Foundation Chamber accepts Mara's current-occupant proof, without activating the final ending yet.
- Keep the First Floor, Attic, Cellar, and future Sealed Wing map-route links aligned before Blender architecture replaces the blockout.
- Expand the Living Ledger into exportable prose.
- Replace blockout room chunks with Blender-authored claymation GLB architecture once mechanics are locked.
- Add voiceover, music, and SFX late, after route pacing is stable.

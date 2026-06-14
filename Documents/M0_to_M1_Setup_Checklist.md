# THE WEEPING WALLS — M0 → M1 SETUP CHECKLIST
## Getting Blender and Godot talking, with the least friction · click-by-click

Do these in order. Each block ends with a **✓ proof** — the thing you should see before moving on. If a proof fails, the fix is in that block, not the next one. Total time to a playable breathing kitchen: ~30–45 minutes, most of it install/download.

---

## PHASE 0 — INSTALL (once)

1. **Godot 4.x** — download the *standard* build (not .NET/C#; we use GDScript) from godotengine.org. Unzip; it's a single executable, no installer.
2. **Blender 5.x** — you already have it (5.1, per your screenshots). Confirm `File ▸ Export ▸ glTF 2.0` exists. ✓ **proof:** both apps open.

---

## PHASE 1 — CREATE THE GODOT PROJECT

3. Open Godot ▸ **New Project**. Name `WeepingWalls`. Pick an empty folder. Renderer: **Forward+** (best lighting; falls back fine). Click **Create & Edit**.
4. In the FileSystem dock (bottom-left), right-click `res://` ▸ **New Folder** ▸ name it `assets`.
5. Note the project's real path on disk (e.g. `C:\Users\you\WeepingWalls`). The assets folder is `…\WeepingWalls\assets`. ✓ **proof:** an empty Godot project open with a `res://assets/` folder.

---

## PHASE 2 — BLENDER EXPORTS THE KITCHEN INTO IT

6. Open Blender ▸ **Scripting** workspace ▸ **New** ▸ paste **`ww_m0_blender.py`**.
7. Edit ONE line near the top:
   `EXPORT_DIR = r"C:\Users\you\WeepingWalls\assets"` — point it at the Godot `assets` folder from step 5. (Leave `FINGERPRINT` blank for now.)
8. Press **Run Script** (▶ in the text editor header).
9. Check the System Console (`Window ▸ Toggle System Console`) for `EXPORTED: …\assets\kitchen_lab.glb`. ✓ **proof:** `kitchen_lab.glb` now exists in the Godot assets folder.

> If Run fails: 99% of the time it's the `EXPORT_DIR` path (wrong slashes or folder doesn't exist). Use the `r"..."` raw-string form exactly, and make sure the `assets` folder was created in step 4.

---

## PHASE 3 — GODOT SEES THE FILE

10. Alt-tab to Godot. It **auto-imports** new files in the project folder; you'll see `kitchen_lab.glb` appear in `res://assets/` within a second or two. (If not: click the FileSystem dock and it'll rescan.)
11. Double-click `kitchen_lab.glb` to preview — you should see the grey kitchen box. Close the preview. ✓ **proof:** the glb is in the FileSystem and previews as a room.

---

## PHASE 4 — THE PLAYABLE SCENE (the one bit of manual wiring)

12. Top menu ▸ **Scene ▸ New Scene**.
13. In the Scene dock, click **Other Node** (or the **+**) ▸ search **Node3D** ▸ Create. This is your root.
14. **Rename the root** to `Lab` (double-click it).
15. With `Lab` selected, look at the Inspector / Node toolbar ▸ click the **script icon** (scroll-with-bracket) ▸ **Attach Script**. Path: `res://Lab.gd`. Template: **Empty**. Create.
16. **Delete** whatever Godot put in the new script, and **paste all of `ww_m0_godot_lab.gd`**. Save (Ctrl-S).
17. **Scene ▸ Save Scene As** ▸ `res://Lab.tscn`.
18. Top-right ▸ **Project ▸ Project Settings ▸ General ▸ Application ▸ Run ▸ Main Scene** ▸ set to `res://Lab.tscn`. (Or just press F6 to run the *current* scene.) ✓ **proof:** a scene named `Lab` with the script attached, set as main.

> The script builds the player, camera, lamp, LED, and clock **in code** at startup — that's why there's almost no manual wiring. You attach one script to one node; it does the rest.

---

## PHASE 5 — RUN IT

19. Press **F5** (run project) or **F6** (run this scene).
20. Click the game window to capture the mouse. **WASD** to move, **mouse** to look, **ESC** to release.
21. Walk to the table. Press **E** — console prints `Recorder LEFT RUNNING / STOPPED`.
22. Press **F** — console prints `Clock jumped to 02:46:50`. Wait ~1 second.
23. At 02:47: console prints `02:47. The house speaks.` and the **red LED blooms and flickers** on the table — *if* the recorder was left running. Stop it first (E) and the moment passes uncaptured.

✓ **proof — the M0 acceptance test, all in one run:**
- [ ] The kitchen reads as dark, clay, lamp-lit (clay shader + lamp radius + fog)
- [ ] The walls visibly **breathe** (watch a wall edge against the corner — slow ±2-3mm pulse)
- [ ] Leaving the recorder running vs not **changes** what happens at 2:47
- [ ] The LED **bloom** at 2:47 lands as a small dread beat

If those four are true, **Milestone 0 is done** and the core look + the three of four signature systems are proven on screen.

---

## PHASE 6 — TUNE THE FOUR NUMBERS (this is the real work of M0)

These live at the top of `ww_m0_godot_lab.gd`. Change, save, re-run. This is where you turn a tech demo into *the look* — spend real time here (T3 §10 calls it the highest-value tuning in the game):

- `LAMP_RANGE` (4.5) and the environment `fog_density` (0.06) — **the pair that makes or breaks dread.** Target: table + LED clearly visible, corners genuinely black. Try range 4.0 / fog 0.07.
- `breath_period` (10.0) — 5s in/5s out. Slower = more uneasy; too slow = unnoticed. Try 8–12.
- `CLOCK_SCALE` (900) — debug-fast. For a real feel, lower it so a "day" lasts minutes, and lean on F/sleep to reach night.
- `LAMP_ENERGY` (3.2) / `light_color` — warmth of the carried light.

**Write down the values that feel right.** Those are the `⟨PREDICT⟩` answers in T4 — send them to me and the provisional T4 becomes the real one.

---

## PHASE 7 — THE BRIDGE TO M1

Once M0 feels right, M1 adds (per T4, in this order):
1. **GameState** autoload — Project ▸ Project Settings ▸ **Autoload** ▸ add `res://systems/GameState.gd` as a singleton.
2. **Clock** — promote the M0 clock code into an autoload (same Autoload panel).
3. **Ledger** — the M1 centrepiece; three templates from T4 §2, Mara font, overnight transcription.
4. **Two more rooms** — re-run `ww_m0_blender.py`'s `box()` pattern for West Wing Hall + Dining (I can give you the M1 Blender script when you're ready), export alongside the kitchen.
5. Wire the loop: arrive → take letter opener → leave recorder → 2:47 → sleep → **read the ledger's first page.**

The autoload pattern (Project Settings ▸ Autoload ▸ add script ▸ it becomes a global) is the single Godot concept M1 leans on — once you've added one, the rest are identical.

---

## QUICK TROUBLESHOOTING
- **glb doesn't appear in Godot:** wrong EXPORT_DIR in Blender, or click the FileSystem dock to force a rescan.
- **Pink/missing materials:** Godot import default; double-click the glb ▸ Import dock ▸ set materials to **Use as Placeholder/Keep**, reimport. (M0 overrides materials in code anyway, so this is cosmetic.)
- **Walls don't breathe:** the script finds walls by `Wall_*` name or `ww_breathing` meta; confirm the glb kept its object names (it will, from Part A).
- **Can't move / no mouse look:** click the game window first to capture the mouse (ESC releases it).
- **LED never blooms:** you stopped the recorder (that's correct behaviour — try again leaving it running), or the clock hasn't reached 02:47 (press F).
- **Too dark to see anything:** raise `LAMP_ENERGY` or `LAMP_RANGE` temporarily; then re-tune fog. Some darkness is the point.

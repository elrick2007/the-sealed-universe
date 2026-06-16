# Clay Material Placeholders

These are Godot-side placeholder materials for imported GLB rooms. Blender remains the source of truth for UV layout and final baked texture assignments.

- Use `WW_Mat_Clay_Wall` for plaster shell pieces.
- Use `WW_Mat_Clay_Wood` for frames, shelves, doors, and rails.
- Use `WW_Mat_Clay_Floor` for clay boards and ground timber.
- Use `WW_Mat_Clay_Dark` for unwritten, hidden, or not-yet-rendered house geometry.

Atlas slot definitions live in `assets/textures/atlases` and `assets/ui/atlas` as JSON. Keep slot names stable once Blender meshes start using them.

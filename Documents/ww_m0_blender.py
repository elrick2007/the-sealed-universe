# ============================================================================
#  THE WEEPING WALLS — Milestone 0, Part A (BLENDER)
#  Kitchen look-test: builds a greybox kitchen with the claymation clay master
#  shader and the breathing-wall vertex setup, then exports glTF for Godot.
#
#  PIPELINE ROLE: Blender = author + export. Godot = runtime (Part B).
#  This script does NOT try to be the game. It makes the room Godot will run.
#
#  RUN: Blender 5.x -> Scripting -> New -> paste -> set EXPORT_DIR -> Run.
#  Output: <EXPORT_DIR>/kitchen_lab.glb  (+ a fingerprint normal if none found)
#  Headless: blender -b -P ww_m0_blender.py
# ============================================================================

import bpy, os, math

# ----------------------------- USER SETTINGS --------------------------------
EXPORT_DIR  = r"C:\WeepingWalls\godot_proj\assets"   # <-- Godot project's assets folder
FINGERPRINT = ""   # optional path to a tiling fingerprint/clay normal PNG (from your R2 render). Blank = procedural.

# ---------------------------------------------------------------------------
os.makedirs(EXPORT_DIR, exist_ok=True)

# wipe scene
bpy.ops.wm.read_factory_settings(use_empty=True)
sc = bpy.context.scene
sc.render.engine = "BLENDER_EEVEE_NEXT" if "BLENDER_EEVEE_NEXT" in [e.identifier for e in bpy.types.RenderEngine.__subclasses__()] else "BLENDER_EEVEE"

# ---- CLAY MASTER MATERIAL ---------------------------------------------------
# High roughness, faint subsurface, hue-noise, fingerprint normal. Everything
# in the manor inherits a variant of this. Exports cleanly to Godot's glTF PBR.
def clay_material(name, base_rgb, subsurface=0.0):
    m = bpy.data.materials.new(name)
    m.use_nodes = True
    nt = m.node_tree; nt.nodes.clear()
    out = nt.nodes.new("ShaderNodeOutputMaterial")
    bsdf = nt.nodes.new("ShaderNodeBsdfPrincipled")
    bsdf.inputs["Base Color"].default_value = (*base_rgb, 1)
    bsdf.inputs["Roughness"].default_value = 0.88
    if "Subsurface Weight" in bsdf.inputs:
        bsdf.inputs["Subsurface Weight"].default_value = subsurface
    # hue-noise: break up flat surfaces (the 2-4% variation rule)
    tex = nt.nodes.new("ShaderNodeTexNoise"); tex.inputs["Scale"].default_value = 18.0
    hue = nt.nodes.new("ShaderNodeMixRGB"); hue.blend_type = "COLOR"; hue.inputs["Fac"].default_value = 0.04
    hue.inputs["Color1"].default_value = (*base_rgb, 1)
    nt.links.new(tex.outputs["Color"], hue.inputs["Color2"])
    nt.links.new(hue.outputs["Color"], bsdf.inputs["Base Color"])
    # fingerprint / tool-mark normal
    if FINGERPRINT and os.path.exists(FINGERPRINT):
        img = bpy.data.images.load(FINGERPRINT, check_existing=True)
        img.colorspace_settings.name = "Non-Color"
        t = nt.nodes.new("ShaderNodeTexImage"); t.image = img
        nm = nt.nodes.new("ShaderNodeNormalMap"); nm.inputs["Strength"].default_value = 0.6
        nt.links.new(t.outputs["Color"], nm.inputs["Color"])
        nt.links.new(nm.outputs["Normal"], bsdf.inputs["Normal"])
    else:
        bump = nt.nodes.new("ShaderNodeBump"); bump.inputs["Strength"].default_value = 0.15
        fp = nt.nodes.new("ShaderNodeTexNoise"); fp.inputs["Scale"].default_value = 60.0
        nt.links.new(fp.outputs["Fac"], bump.inputs["Height"])
        nt.links.new(bump.outputs["Normal"], bsdf.inputs["Normal"])
    nt.links.new(bsdf.outputs["BSDF"], out.inputs["Surface"])
    return m

clay_wall  = clay_material("ClayWall",  (0.20, 0.21, 0.23))
clay_stone = clay_material("ClayStone", (0.16, 0.16, 0.17))
clay_wood  = clay_material("ClayWood",  (0.18, 0.12, 0.07))
clay_metal = clay_material("ClayMetalDark", (0.05, 0.05, 0.06))

# ---- ROOM GREYBOX -----------------------------------------------------------
def box(name, size, loc, mat, mark_breathing=False):
    bpy.ops.mesh.primitive_cube_add(size=1, location=loc)
    o = bpy.context.object; o.name = name; o.scale = size
    bpy.ops.object.transform_apply(scale=True)
    o.data.materials.append(mat)
    # tag walls so Godot can find them for the breathing shader
    if mark_breathing:
        o["ww_breathing"] = 1.0
    return o

W, D, H = 6.0, 5.0, 3.2   # kitchen interior, metres
t = 0.15
box("Floor",   (W, D, t), (0, 0, 0),     clay_stone)
box("Ceiling", (W, D, t), (0, 0, H),     clay_wall)
box("Wall_N",  (W, t, H), (0,  D/2, H/2), clay_wall, True)
box("Wall_S",  (W, t, H), (0, -D/2, H/2), clay_wall, True)
box("Wall_E",  (t, D, H), ( W/2, 0, H/2), clay_wall, True)
box("Wall_W",  (t, D, H), (-W/2, 0, H/2), clay_wall, True)

# scarred table (the hub), enamel mug placeholder, recorder placeholder marker
table = box("Table", (1.6, 0.9, 0.12), (0, 0, 0.78), clay_wood)
box("TableLeg1", (0.1,0.1,0.78), ( 0.7, 0.35, 0.39), clay_wood)
box("TableLeg2", (0.1,0.1,0.78), (-0.7, 0.35, 0.39), clay_wood)
box("TableLeg3", (0.1,0.1,0.78), ( 0.7,-0.35, 0.39), clay_wood)
box("TableLeg4", (0.1,0.1,0.78), (-0.7,-0.35, 0.39), clay_wood)

# recorder: a small box at a known spot; Godot finds it by name and adds the LED + logic
rec = box("Recorder", (0.06, 0.12, 0.03), (0.2, 0.0, 0.855), clay_metal)
rec["ww_recorder"] = 1   # tag for Godot

# small window opening on Wall_S (just an emissive slab = cold moonlight)
win_mat = bpy.data.materials.new("MoonGlow"); win_mat.use_nodes = True
wb = win_mat.node_tree.nodes.get("Principled BSDF")
if wb:
    wb.inputs["Emission Color"].default_value = (0.4, 0.5, 0.7, 1)
    wb.inputs["Emission Strength"].default_value = 2.0
win = box("Window", (1.0, t*1.1, 1.0), (0, -D/2, 1.7), win_mat)

# a marker empty for Godot's player spawn (named so the importer can place the camera rig)
bpy.ops.object.empty_add(location=(0, -1.6, 1.6)); bpy.context.object.name = "PlayerSpawn"
# a marker empty for the lamp's resting position on the table
bpy.ops.object.empty_add(location=(-0.3, 0.0, 0.9)); bpy.context.object.name = "LampSpot"

# ---- EXPORT ----------------------------------------------------------------
out_path = os.path.join(EXPORT_DIR, "kitchen_lab.glb")
bpy.ops.export_scene.gltf(
    filepath=out_path,
    export_format="GLB",
    export_extras=True,          # carries our ww_* custom properties into Godot
    export_apply=True,
    export_cameras=False,
    export_lights=False,         # Godot owns lighting (the lamp-radius rule lives in-engine)
)
print("EXPORTED:", out_path)
print("Custom props carried: ww_breathing (walls), ww_recorder (prop), markers PlayerSpawn/LampSpot")
print("Next: run the Godot Part B importer/look-test script.")

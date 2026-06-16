"""
The Weeping Walls - Book 1
Entrance Hall / West Wing Hall Blender replacement pass v2.

Run from Blender:
    blender -b -P build_entrance_westwing.py

Outputs:
    assets/blender_source/rooms/ground/ww_gf_entrance_westwing.blend
    assets/blender_exports/rooms/ground/gf_entrance_hall.glb
    assets/blender_exports/rooms/ground/gf_west_wing_hall.glb
"""

from __future__ import annotations

import math
import random
from pathlib import Path

import bpy


SCRIPT_PATH = Path(__file__).resolve()
PROJECT_ROOT = SCRIPT_PATH.parents[4]
SOURCE_PATH = PROJECT_ROOT / "assets" / "blender_source" / "rooms" / "ground" / "ww_gf_entrance_westwing.blend"
EXPORT_DIR = PROJECT_ROOT / "assets" / "blender_exports" / "rooms" / "ground"
RNG = random.Random(247)


def reset_scene() -> None:
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.context.scene.unit_settings.system = "METRIC"
    bpy.context.scene.unit_settings.scale_length = 1.0


def clay_material(name: str, color: tuple[float, float, float], roughness: float = 0.88) -> bpy.types.Material:
    mat = bpy.data.materials.new(name)
    mat.use_nodes = True
    nodes = mat.node_tree.nodes
    bsdf = nodes.get("Principled BSDF")
    if bsdf:
        bsdf.inputs["Base Color"].default_value = (*color, 1.0)
        bsdf.inputs["Roughness"].default_value = roughness
    mat["ww_material_family"] = "clay"
    return mat


def glass_material(name: str, color: tuple[float, float, float]) -> bpy.types.Material:
    mat = bpy.data.materials.new(name)
    mat.use_nodes = True
    nodes = mat.node_tree.nodes
    bsdf = nodes.get("Principled BSDF")
    if bsdf:
        bsdf.inputs["Base Color"].default_value = (*color, 0.55)
        bsdf.inputs["Roughness"].default_value = 0.35
        bsdf.inputs["Alpha"].default_value = 0.55
    mat.blend_method = "BLEND"
    return mat


def collection(name: str) -> bpy.types.Collection:
    col = bpy.data.collections.new(name)
    bpy.context.scene.collection.children.link(col)
    return col


def link_to_collection(obj: bpy.types.Object, col: bpy.types.Collection) -> bpy.types.Object:
    for existing in list(obj.users_collection):
        existing.objects.unlink(obj)
    col.objects.link(obj)
    return obj


def cube(
    name: str,
    size: tuple[float, float, float],
    loc: tuple[float, float, float],
    mat: bpy.types.Material,
    col: bpy.types.Collection,
    props: dict[str, object] | None = None,
) -> bpy.types.Object:
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=loc)
    obj = bpy.context.object
    obj.name = name
    obj.scale = size
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    obj.data.materials.append(mat)
    if props:
        for key, value in props.items():
            obj[key] = value
    if not name.startswith("Col_") and "Collision" not in mat.name and "Glass" not in mat.name:
        add_clay_surface(obj, amount=0.012 if "Wall" not in name else 0.022)
    return link_to_collection(obj, col)


def add_clay_surface(obj: bpy.types.Object, amount: float = 0.015, bevel: float = 0.025) -> None:
    bevel_mod = obj.modifiers.new(name="Clay_soft_edges", type="BEVEL")
    bevel_mod.width = bevel
    bevel_mod.segments = 2
    bevel_mod.affect = "EDGES"
    tex = bpy.data.textures.new(f"{obj.name}_finger_noise", type="VORONOI")
    tex.noise_scale = 1.35
    tex.intensity = 0.24
    disp = obj.modifiers.new(name="Clay_handmade_wobble", type="DISPLACE")
    disp.strength = amount
    disp.texture = tex


def cylinder(
    name: str,
    radius: float,
    depth: float,
    loc: tuple[float, float, float],
    mat: bpy.types.Material,
    col: bpy.types.Collection,
    vertices: int = 16,
    rot: tuple[float, float, float] = (0.0, 0.0, 0.0),
    props: dict[str, object] | None = None,
) -> bpy.types.Object:
    bpy.ops.mesh.primitive_cylinder_add(vertices=vertices, radius=radius, depth=depth, location=loc, rotation=rot)
    obj = bpy.context.object
    obj.name = name
    obj.data.materials.append(mat)
    if props:
        for key, value in props.items():
            obj[key] = value
    add_clay_surface(obj, amount=0.008, bevel=0.01)
    return link_to_collection(obj, col)


def sphere(
    name: str,
    radius: float,
    loc: tuple[float, float, float],
    mat: bpy.types.Material,
    col: bpy.types.Collection,
    scale: tuple[float, float, float] = (1.0, 1.0, 1.0),
    props: dict[str, object] | None = None,
) -> bpy.types.Object:
    bpy.ops.mesh.primitive_uv_sphere_add(segments=16, ring_count=8, radius=radius, location=loc)
    obj = bpy.context.object
    obj.name = name
    obj.scale = scale
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    obj.data.materials.append(mat)
    if props:
        for key, value in props.items():
            obj[key] = value
    add_clay_surface(obj, amount=0.01, bevel=0.0)
    return link_to_collection(obj, col)


def empty(
    name: str,
    loc: tuple[float, float, float],
    col: bpy.types.Collection,
    props: dict[str, object] | None = None,
    display: str = "CUBE",
) -> bpy.types.Object:
    bpy.ops.object.empty_add(type=display, location=loc)
    obj = bpy.context.object
    obj.name = name
    obj.empty_display_size = 0.35
    if props:
        for key, value in props.items():
            obj[key] = value
    return link_to_collection(obj, col)


def add_wall_set(
    room_id: str,
    col: bpy.types.Collection,
    center: tuple[float, float],
    size: tuple[float, float],
    height: float,
    mat: bpy.types.Material,
    breathable: bool = False,
) -> None:
    cx, cy = center
    sx, sy = size
    t = 0.22
    props = {"ww_breathing": 1} if breathable else None
    cube(f"Wall_{room_id}_North", (sx, t, height), (cx, cy + sy / 2.0, height / 2.0), mat, col, props)
    cube(f"Wall_{room_id}_South", (sx, t, height), (cx, cy - sy / 2.0, height / 2.0), mat, col, props)
    cube(f"Wall_{room_id}_East", (t, sy, height), (cx + sx / 2.0, cy, height / 2.0), mat, col, props)
    cube(f"Wall_{room_id}_West", (t, sy, height), (cx - sx / 2.0, cy, height / 2.0), mat, col, props)
    add_room_trim(room_id, col, center, size, height)


def add_room_trim(
    room_id: str,
    col: bpy.types.Collection,
    center: tuple[float, float],
    size: tuple[float, float],
    height: float,
) -> None:
    cx, cy = center
    sx, sy = size
    wood = bpy.data.materials["WW_Mat_Clay_Wood"]
    wall = bpy.data.materials["WW_Mat_Clay_Wall"]
    for z, label, trim_mat, depth in (
        (0.18, "Baseboard", wood, 0.08),
        (height - 0.18, "Cornice", wall, 0.10),
    ):
        cube(f"Mesh_ClayTrim_{room_id}_{label}_North", (sx - 0.28, 0.08, depth), (cx, cy + sy / 2.0 - 0.14, z), trim_mat, col)
        cube(f"Mesh_ClayTrim_{room_id}_{label}_South", (sx - 0.28, 0.08, depth), (cx, cy - sy / 2.0 + 0.14, z), trim_mat, col)
        cube(f"Mesh_ClayTrim_{room_id}_{label}_East", (0.08, sy - 0.28, depth), (cx + sx / 2.0 - 0.14, cy, z), trim_mat, col)
        cube(f"Mesh_ClayTrim_{room_id}_{label}_West", (0.08, sy - 0.28, depth), (cx - sx / 2.0 + 0.14, cy, z), trim_mat, col)


def add_wall_smears(room_id: str, col: bpy.types.Collection, center: tuple[float, float], size: tuple[float, float], mat: bpy.types.Material) -> None:
    cx, cy = center
    sx, sy = size
    for idx in range(12):
        side = idx % 4
        z = RNG.uniform(0.7, 2.35)
        if side == 0:
            loc = (cx + RNG.uniform(-sx * 0.35, sx * 0.35), cy + sy / 2.0 - 0.118, z)
            size_vec = (RNG.uniform(0.25, 0.7), 0.012, RNG.uniform(0.025, 0.055))
        elif side == 1:
            loc = (cx + RNG.uniform(-sx * 0.35, sx * 0.35), cy - sy / 2.0 + 0.118, z)
            size_vec = (RNG.uniform(0.25, 0.7), 0.012, RNG.uniform(0.025, 0.055))
        elif side == 2:
            loc = (cx + sx / 2.0 - 0.118, cy + RNG.uniform(-sy * 0.35, sy * 0.35), z)
            size_vec = (0.012, RNG.uniform(0.25, 0.7), RNG.uniform(0.025, 0.055))
        else:
            loc = (cx - sx / 2.0 + 0.118, cy + RNG.uniform(-sy * 0.35, sy * 0.35), z)
            size_vec = (0.012, RNG.uniform(0.25, 0.7), RNG.uniform(0.025, 0.055))
        cube(f"Mesh_ClayFingerprint_{room_id}_{idx:02d}", size_vec, loc, mat, col)


def add_arch_frame(prefix: str, loc: tuple[float, float, float], rot_z: float, col: bpy.types.Collection, wood: bpy.types.Material) -> None:
    x, y, z = loc
    parts = [
        ("LeftJamb", (-0.58, 0.0, 0.95), (0.12, 0.22, 1.9)),
        ("RightJamb", (0.58, 0.0, 0.95), (0.12, 0.22, 1.9)),
        ("Header", (0.0, 0.0, 1.95), (1.28, 0.24, 0.16)),
    ]
    for suffix, offset, size in parts:
        ox, oy, oz = offset
        rx = ox * math.cos(rot_z) - oy * math.sin(rot_z)
        ry = ox * math.sin(rot_z) + oy * math.cos(rot_z)
        obj = cube(f"Mesh_ClayWood_{prefix}_{suffix}", size, (x + rx, y + ry, z + oz), wood, col)
        obj.rotation_euler[2] = rot_z


def add_sconce(prefix: str, loc: tuple[float, float, float], rot_z: float, col: bpy.types.Collection, mats: dict[str, bpy.types.Material]) -> None:
    x, y, z = loc
    arm = cube(f"Mesh_ClayMetalDark_{prefix}_SconceArm", (0.08, 0.42, 0.07), (x, y, z), mats["ClayMetalDark"], col)
    arm.rotation_euler[2] = rot_z
    cylinder(
        f"Mesh_ClayMetalDark_{prefix}_Cup",
        0.11,
        0.08,
        (x, y, z + 0.13),
        mats["ClayMetalDark"],
        col,
        vertices=12,
        rot=(math.radians(90), 0.0, 0.0),
    )
    sphere(f"Mesh_ClayAmber_{prefix}_CandleGlow", 0.095, (x, y, z + 0.25), mats["ClayCandle"], col, scale=(0.75, 0.75, 1.35))


def add_carpet_fringe(prefix: str, loc: tuple[float, float, float], width: float, col: bpy.types.Collection, mat: bpy.types.Material) -> None:
    x, y, z = loc
    for i in range(9):
        dx = -width / 2.0 + (i + 0.5) * width / 9.0
        cube(f"Mesh_ClayFabric_{prefix}_Fringe_{i:02d}", (0.035, 0.22, 0.018), (x + dx, y, z), mat, col)


def add_entrance_hall(col: bpy.types.Collection, mats: dict[str, bpy.types.Material]) -> None:
    height = 3.0
    center = (0.0, 0.0)
    size = (6.0, 8.0)
    cube("Mesh_ClayStone_GF_EntranceHall_Floor", (6.0, 8.0, 0.16), (0.0, 0.0, -0.08), mats["ClayStone"], col)
    cube("Mesh_ClayWall_GF_EntranceHall_Ceiling", (6.0, 8.0, 0.16), (0.0, 0.0, height + 0.08), mats["ClayWall"], col)
    add_wall_set("GF_EntranceHall", col, center, size, height, mats["ClayWall"], breathable=True)
    add_wall_smears("GF_EntranceHall", col, center, size, mats["ClayWallDark"])
    cube("Mesh_ClayFabric_GF_EntranceHall_BurgundyRunner", (1.4, 6.4, 0.045), (-0.35, 0.25, 0.025), mats["ClayFabric"], col)
    add_carpet_fringe("GF_EntranceHall_North", (-0.35, 3.42, 0.052), 1.35, col, mats["ClayFabric"])
    add_carpet_fringe("GF_EntranceHall_South", (-0.35, -2.92, 0.052), 1.35, col, mats["ClayFabric"])
    cube("Mesh_ClayWood_GF_EntranceHall_FrontDoor", (1.45, 0.16, 2.1), (0.0, -3.93, 1.05), mats["ClayWood"], col, {"ww_interact": "inspect"})
    cube("Mesh_ClayWood_GF_EntranceHall_FrontDoor_LeftPanel", (0.42, 0.04, 1.38), (-0.32, -4.02, 1.05), mats["ClayWoodDark"], col)
    cube("Mesh_ClayWood_GF_EntranceHall_FrontDoor_RightPanel", (0.42, 0.04, 1.38), (0.32, -4.02, 1.05), mats["ClayWoodDark"], col)
    cylinder("Mesh_ClayMetalDark_GF_EntranceHall_FrontDoor_Handle", 0.045, 0.11, (0.55, -4.08, 1.05), mats["ClayMetalDark"], col, vertices=12, rot=(math.radians(90), 0.0, 0.0))
    cube("Mesh_ClayWood_GF_EntranceHall_SealedWingBoundary", (0.18, 2.4, 2.55), (2.95, 1.25, 1.28), mats["ClayRoseCharcoal"], col, {"ww_interact": "inspect"})
    cube("Mesh_ClayWood_GF_EntranceHall_GrandStairHint", (1.4, 2.4, 0.18), (1.65, 2.5, 0.55), mats["ClayWood"], col)
    cube("Mesh_ClayWood_GF_EntranceHall_ClockCase", (0.48, 0.28, 2.1), (-2.42, 2.65, 1.05), mats["ClayWood"], col, {"ww_prop": "clock"})
    cylinder("Mesh_ClayWall_GF_EntranceHall_ClockFace", 0.22, 0.035, (-2.42, 2.48, 1.62), mats["Parchment"], col, vertices=24, rot=(math.radians(90), 0.0, 0.0))
    sphere("Mesh_ClayMetalDark_GF_EntranceHall_PendulumBob", 0.085, (-2.42, 2.49, 0.78), mats["ClayMetalDark"], col, scale=(0.75, 0.22, 1.0))
    cube("Mesh_ClayMetalDark_GF_EntranceHall_ChandelierSightline", (0.28, 0.28, 0.08), (-0.3, 1.0, 2.85), mats["ClayMetalDark"], col)
    cube("Prop_Recorder", (0.32, 0.18, 0.08), (-1.45, -2.35, 0.08), mats["ClayMetalDark"], col, {"ww_interact": "take", "ww_prop": "recorder"})
    cube("Prop_IronKey", (0.28, 0.06, 0.04), (1.35, -2.2, 0.07), mats["ClayMetalDark"], col, {"ww_interact": "take", "ww_prop": "iron_key"})
    add_arch_frame("EntranceToWestWing", (-3.03, 0.1, 0.0), math.radians(90), col, mats["ClayWood"])
    cube("Mesh_ClayWood_EntranceToWestWing_DoorLeaf", (0.14, 1.06, 2.08), (-3.11, -0.28, 1.04), mats["ClayWoodDark"], col, {"ww_interact": "open", "ww_door": "west_wing_visual"})
    cylinder("Mesh_ClayMetalDark_EntranceToWestWing_DoorKnob", 0.045, 0.10, (-3.2, 0.18, 1.0), mats["ClayMetalDark"], col, vertices=12, rot=(0.0, math.radians(90), 0.0))
    add_sconce("GF_EntranceHall_West", (-2.86, -1.25, 1.65), math.radians(90), col, mats)
    add_sconce("GF_EntranceHall_East", (2.86, -1.0, 1.65), math.radians(-90), col, mats)
    empty("Spawn_GF_EntranceHall", (0.0, -2.5, 1.6), col, {"ww_spawn": "player"})
    empty("Door_GF_EntranceHall__GF_WestWingHall", (-3.05, 0.1, 1.0), col, {"ww_interact": "open", "ww_door": "west_wing"})
    empty("Wall_Whisper_Entrance", (-2.85, 1.4, 1.35), col, {"ww_breathing": 1, "ww_interact": "inspect"})
    empty("Trigger_ChandelierHandprintSightline", (-0.3, 1.0, 1.6), col, {"ww_trigger": "chandelier_handprint"})
    cube("Col_GF_EntranceHall_Floor", (5.8, 7.8, 0.1), (0.0, 0.0, -0.05), mats["Collision"], col, {"ww_collision": "static"})


def add_west_wing_hall(col: bpy.types.Collection, mats: dict[str, bpy.types.Material]) -> None:
    height = 3.0
    center = (-5.0, 1.0)
    size = (2.2, 7.0)
    cube("Mesh_ClayStone_GF_WestWingHall_Floor", (2.2, 7.0, 0.16), (-5.0, 1.0, -0.08), mats["ClayStone"], col)
    cube("Mesh_ClayWall_GF_WestWingHall_Ceiling", (2.2, 7.0, 0.16), (-5.0, 1.0, height + 0.08), mats["ClayWall"], col)
    add_wall_set("GF_WestWingHall", col, center, size, height, mats["ClayWall"], breathable=True)
    add_wall_smears("GF_WestWingHall", col, center, size, mats["ClayWallDark"])
    cube("Mesh_ClayFabric_GF_WestWingHall_BurgundyRunner", (0.95, 6.2, 0.045), (-5.0, 1.0, 0.025), mats["ClayFabric"], col)
    add_carpet_fringe("GF_WestWingHall_North", (-5.0, 4.05, 0.052), 0.9, col, mats["ClayFabric"])
    add_carpet_fringe("GF_WestWingHall_South", (-5.0, -2.05, 0.052), 0.9, col, mats["ClayFabric"])
    cube("Prop_ManorPlans", (0.44, 0.28, 0.035), (-4.72, -1.1, 0.08), mats["Parchment"], col, {"ww_interact": "take", "ww_prop": "manor_plans"})
    cube("Mesh_ClayWood_GF_WestWingHall_Cellardoor", (0.92, 0.14, 1.85), (-4.55, 3.98, 0.93), mats["ClayWood"], col, {"ww_interact": "inspect"})
    cube("Measure_GF_WestWingHall_42_47", (1.7, 5.8, 0.05), (-5.0, 1.0, 0.08), mats["MeasureGlass"], col, {"ww_measure": "42_47"})
    add_arch_frame("WestHallToLibrary", (-6.13, -0.9, 0.0), 0.0, col, mats["ClayWood"])
    add_arch_frame("WestHallToDining", (-3.87, 0.4, 0.0), 0.0, col, mats["ClayWood"])
    add_arch_frame("WestHallToKitchen", (-5.0, 4.52, 0.0), math.radians(0), col, mats["ClayWood"])
    add_sconce("GF_WestWingHall_LeftA", (-5.96, -1.3, 1.58), 0.0, col, mats)
    add_sconce("GF_WestWingHall_RightA", (-4.04, 1.35, 1.58), math.radians(180), col, mats)
    add_sconce("GF_WestWingHall_LeftB", (-5.96, 3.1, 1.58), 0.0, col, mats)
    empty("Trigger_WestWingThresholdScare", (-4.8, -2.1, 1.2), col, {"ww_trigger": "west_wing_threshold"})
    empty("Door_GF_WestWingHall__GF_Library", (-6.15, -0.9, 1.0), col, {"ww_door": "library"})
    empty("Door_GF_WestWingHall__GF_DiningRoom", (-3.85, 0.4, 1.0), col, {"ww_door": "dining"})
    empty("Door_GF_WestWingHall__GF_Kitchen", (-5.0, 4.48, 1.0), col, {"ww_door": "kitchen"})
    empty("Door_GF_WestWingHall__CellarStairs", (-4.55, 3.85, 1.0), col, {"ww_door": "cellar_stairs"})
    cube("Col_GF_WestWingHall_Floor", (2.0, 6.8, 0.1), (-5.0, 1.0, -0.05), mats["Collision"], col, {"ww_collision": "static"})


def export_collection(col: bpy.types.Collection, filepath: Path) -> None:
    bpy.ops.object.select_all(action="DESELECT")
    for obj in col.objects:
        obj.select_set(True)
    bpy.context.view_layer.objects.active = next(iter(col.objects), None)
    bpy.ops.export_scene.gltf(
        filepath=str(filepath),
        export_format="GLB",
        use_selection=True,
        export_extras=True,
        export_apply=True,
        export_cameras=False,
        export_lights=False,
    )


def main() -> None:
    reset_scene()
    EXPORT_DIR.mkdir(parents=True, exist_ok=True)
    SOURCE_PATH.parent.mkdir(parents=True, exist_ok=True)

    mats = {
        "ClayWall": clay_material("WW_Mat_Clay_Wall", (0.42, 0.32, 0.24)),
        "ClayWallDark": clay_material("WW_Mat_Clay_Wall_Fingerprint_Dark", (0.24, 0.20, 0.17)),
        "ClayStone": clay_material("WW_Mat_Clay_Floor", (0.22, 0.18, 0.15)),
        "ClayWood": clay_material("WW_Mat_Clay_Wood", (0.25, 0.13, 0.07)),
        "ClayWoodDark": clay_material("WW_Mat_Clay_Wood_Dark", (0.12, 0.065, 0.04)),
        "ClayFabric": clay_material("WW_Mat_Clay_Fabric_Burgundy", (0.36, 0.03, 0.02)),
        "ClayMetalDark": clay_material("WW_Mat_Clay_Dark_Metal", (0.04, 0.04, 0.045), 0.72),
        "ClayRoseCharcoal": clay_material("WW_Mat_Clay_Rose_Charcoal", (0.12, 0.035, 0.04)),
        "ClayCandle": clay_material("WW_Mat_Clay_Candle_Amber", (0.88, 0.46, 0.16), 0.8),
        "Parchment": clay_material("WW_Mat_Clay_Parchment", (0.63, 0.52, 0.35)),
        "MeasureGlass": glass_material("Glass_slick", (0.55, 0.75, 0.85)),
        "Collision": glass_material("Collision_Debug", (0.1, 0.5, 0.8)),
    }

    entrance = collection("Room_GF_EntranceHall")
    west = collection("Room_GF_WestWingHall")
    add_entrance_hall(entrance, mats)
    add_west_wing_hall(west, mats)

    bpy.ops.wm.save_as_mainfile(filepath=str(SOURCE_PATH))
    export_collection(entrance, EXPORT_DIR / "gf_entrance_hall.glb")
    export_collection(west, EXPORT_DIR / "gf_west_wing_hall.glb")
    print(f"SAVED {SOURCE_PATH}")
    print(f"EXPORTED {EXPORT_DIR / 'gf_entrance_hall.glb'}")
    print(f"EXPORTED {EXPORT_DIR / 'gf_west_wing_hall.glb'}")


if __name__ == "__main__":
    main()

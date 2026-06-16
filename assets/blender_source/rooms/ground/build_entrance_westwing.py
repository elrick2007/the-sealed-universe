"""
The Weeping Walls - Book 1
Entrance Hall / West Wing Hall Blender replacement pass v3.

This script intentionally starts from a factory-clean Blender scene each run.
It overwrites the old .blend and GLB exports while preserving gameplay marker
names and export paths used by Godot wrapper scenes.

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


def clay_material(name: str, color: tuple[float, float, float], roughness: float = 0.9) -> bpy.types.Material:
    mat = bpy.data.materials.new(name)
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes.get("Principled BSDF")
    if bsdf:
        bsdf.inputs["Base Color"].default_value = (*color, 1.0)
        bsdf.inputs["Roughness"].default_value = roughness
    mat["ww_material_family"] = "clay"
    return mat


def glass_material(name: str, color: tuple[float, float, float]) -> bpy.types.Material:
    mat = bpy.data.materials.new(name)
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes.get("Principled BSDF")
    if bsdf:
        bsdf.inputs["Base Color"].default_value = (*color, 0.35)
        bsdf.inputs["Alpha"].default_value = 0.35
        bsdf.inputs["Roughness"].default_value = 0.45
    mat.blend_method = "BLEND"
    return mat


def build_materials() -> dict[str, bpy.types.Material]:
    return {
        "wall": clay_material("WW_Mat_Clay_Wall", (0.43, 0.34, 0.25), 0.96),
        "wall_dark": clay_material("WW_Mat_Clay_Wall_Fingerprint_Dark", (0.18, 0.14, 0.11), 0.98),
        "wall_light": clay_material("WW_Mat_Clay_Wall_Patch_Light", (0.62, 0.52, 0.40), 0.97),
        "floor": clay_material("WW_Mat_Clay_Floor", (0.20, 0.15, 0.11), 0.94),
        "wood": clay_material("WW_Mat_Clay_Wood", (0.24, 0.13, 0.07), 0.91),
        "wood_dark": clay_material("WW_Mat_Clay_Wood_Dark", (0.11, 0.06, 0.035), 0.94),
        "fabric": clay_material("WW_Mat_Clay_Fabric_Burgundy", (0.35, 0.035, 0.035), 0.98),
        "fabric_dark": clay_material("WW_Mat_Clay_Fabric_Burgundy_Dark", (0.16, 0.015, 0.018), 0.99),
        "metal": clay_material("WW_Mat_Clay_Dark_Metal", (0.04, 0.038, 0.036), 0.78),
        "candle": clay_material("WW_Mat_Clay_Candle_Amber", (0.92, 0.55, 0.17), 0.7),
        "parchment": clay_material("WW_Mat_Clay_Parchment", (0.64, 0.54, 0.37), 0.96),
        "sealed": clay_material("WW_Mat_Clay_Rose_Charcoal", (0.12, 0.035, 0.042), 0.96),
        "glass": glass_material("Glass_slick", (0.45, 0.65, 0.75)),
        "collision": glass_material("Collision_Debug", (0.10, 0.45, 0.75)),
    }


def collection(name: str) -> bpy.types.Collection:
    col = bpy.data.collections.new(name)
    bpy.context.scene.collection.children.link(col)
    return col


def link_to_collection(obj: bpy.types.Object, col: bpy.types.Collection) -> bpy.types.Object:
    for existing in list(obj.users_collection):
        existing.objects.unlink(obj)
    col.objects.link(obj)
    return obj


def clay_modifiers(obj: bpy.types.Object, amount: float = 0.012, bevel: float = 0.018) -> None:
    if bevel > 0:
        mod = obj.modifiers.new(name="Clay_soft_edges", type="BEVEL")
        mod.width = bevel
        mod.segments = 2
        mod.affect = "EDGES"
    if amount > 0:
        tex = bpy.data.textures.new(f"{obj.name}_wobble_noise", type="VORONOI")
        tex.noise_scale = 1.2
        tex.intensity = 0.28
        disp = obj.modifiers.new(name="Clay_handmade_wobble", type="DISPLACE")
        disp.strength = amount
        disp.texture = tex


def box(
    name: str,
    size: tuple[float, float, float],
    loc: tuple[float, float, float],
    mat: bpy.types.Material,
    col: bpy.types.Collection,
    props: dict[str, object] | None = None,
    rot_z: float = 0.0,
    wobble: float = 0.012,
    bevel: float = 0.018,
) -> bpy.types.Object:
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=loc, rotation=(0.0, 0.0, rot_z))
    obj = bpy.context.object
    obj.name = name
    obj.scale = size
    bpy.ops.object.transform_apply(location=False, rotation=True, scale=True)
    obj.data.materials.append(mat)
    if props:
        for key, value in props.items():
            obj[key] = value
    if not name.startswith("Col_") and "Collision" not in mat.name and "Glass" not in mat.name:
        clay_modifiers(obj, amount=wobble, bevel=bevel)
    return link_to_collection(obj, col)


def cyl(
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
    clay_modifiers(obj, amount=0.006, bevel=0.01)
    return link_to_collection(obj, col)


def sphere(
    name: str,
    radius: float,
    loc: tuple[float, float, float],
    mat: bpy.types.Material,
    col: bpy.types.Collection,
    scale: tuple[float, float, float] = (1.0, 1.0, 1.0),
) -> bpy.types.Object:
    bpy.ops.mesh.primitive_uv_sphere_add(segments=16, ring_count=8, radius=radius, location=loc)
    obj = bpy.context.object
    obj.name = name
    obj.scale = scale
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    obj.data.materials.append(mat)
    clay_modifiers(obj, amount=0.006, bevel=0.0)
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


def add_room_shell(
    room_id: str,
    col: bpy.types.Collection,
    mats: dict[str, bpy.types.Material],
    center: tuple[float, float],
    size: tuple[float, float],
    height: float,
    breathable: bool = True,
) -> None:
    cx, cy = center
    sx, sy = size
    t = 0.28
    props = {"ww_breathing": 1} if breathable else None
    box(f"Mesh_ClayStone_{room_id}_FloorBoards", (sx, sy, 0.16), (cx, cy, -0.08), mats["floor"], col, wobble=0.01)
    box(f"Mesh_ClayWall_{room_id}_LowCeiling", (sx, sy, 0.18), (cx, cy, height + 0.06), mats["wall"], col, wobble=0.025)
    box(f"Wall_{room_id}_North", (sx, t, height), (cx, cy + sy / 2.0, height / 2.0), mats["wall"], col, props, wobble=0.025)
    box(f"Wall_{room_id}_South", (sx, t, height), (cx, cy - sy / 2.0, height / 2.0), mats["wall"], col, props, wobble=0.025)
    box(f"Wall_{room_id}_East", (t, sy, height), (cx + sx / 2.0, cy, height / 2.0), mats["wall"], col, props, wobble=0.025)
    box(f"Wall_{room_id}_West", (t, sy, height), (cx - sx / 2.0, cy, height / 2.0), mats["wall"], col, props, wobble=0.025)
    add_wainscot(room_id, col, mats, center, size)
    add_cornice(room_id, col, mats, center, size, height)
    add_plaster_damage(room_id, col, mats, center, size, height)
    add_floor_boards(room_id, col, mats, center, size)


def add_floor_boards(room_id: str, col: bpy.types.Collection, mats: dict[str, bpy.types.Material], center: tuple[float, float], size: tuple[float, float]) -> None:
    cx, cy = center
    sx, sy = size
    board_count = max(6, int(sx / 0.45))
    for i in range(board_count):
        x = cx - sx / 2.0 + (i + 0.5) * sx / board_count
        box(f"Mesh_ClayWood_{room_id}_FloorBoardLine_{i:02d}", (0.018, sy - 0.25, 0.018), (x, cy, 0.015), mats["wood_dark"], col, wobble=0.004, bevel=0.004)


def add_wainscot(room_id: str, col: bpy.types.Collection, mats: dict[str, bpy.types.Material], center: tuple[float, float], size: tuple[float, float]) -> None:
    cx, cy = center
    sx, sy = size
    panel_h = 0.86
    z = panel_h / 2.0
    rail_z = 0.96
    base_z = 0.16
    # Horizontal rails
    for y, side in ((cy + sy / 2.0 - 0.155, "North"), (cy - sy / 2.0 + 0.155, "South")):
        box(f"Mesh_ClayWood_{room_id}_Wainscot_{side}", (sx - 0.26, 0.05, panel_h), (cx, y, z), mats["wood"], col, wobble=0.012)
        box(f"Mesh_ClayWood_{room_id}_ChairRail_{side}", (sx - 0.18, 0.10, 0.08), (cx, y, rail_z), mats["wood_dark"], col)
        box(f"Mesh_ClayWood_{room_id}_BaseRail_{side}", (sx - 0.18, 0.12, 0.12), (cx, y, base_z), mats["wood_dark"], col)
    for x, side in ((cx + sx / 2.0 - 0.155, "East"), (cx - sx / 2.0 + 0.155, "West")):
        box(f"Mesh_ClayWood_{room_id}_Wainscot_{side}", (0.05, sy - 0.26, panel_h), (x, cy, z), mats["wood"], col, wobble=0.012)
        box(f"Mesh_ClayWood_{room_id}_ChairRail_{side}", (0.10, sy - 0.18, 0.08), (x, cy, rail_z), mats["wood_dark"], col)
        box(f"Mesh_ClayWood_{room_id}_BaseRail_{side}", (0.12, sy - 0.18, 0.12), (x, cy, base_z), mats["wood_dark"], col)
    # Vertical panel seams.
    for idx in range(max(4, int(sx / 0.8))):
        x = cx - sx / 2.0 + 0.45 + idx * 0.8
        if x < cx + sx / 2.0 - 0.4:
            box(f"Mesh_ClayWood_{room_id}_NorthPanelSeam_{idx:02d}", (0.035, 0.08, panel_h), (x, cy + sy / 2.0 - 0.12, z), mats["wood_dark"], col, wobble=0.008)
            box(f"Mesh_ClayWood_{room_id}_SouthPanelSeam_{idx:02d}", (0.035, 0.08, panel_h), (x, cy - sy / 2.0 + 0.12, z), mats["wood_dark"], col, wobble=0.008)
    for idx in range(max(4, int(sy / 0.8))):
        y = cy - sy / 2.0 + 0.45 + idx * 0.8
        if y < cy + sy / 2.0 - 0.4:
            box(f"Mesh_ClayWood_{room_id}_EastPanelSeam_{idx:02d}", (0.08, 0.035, panel_h), (cx + sx / 2.0 - 0.12, y, z), mats["wood_dark"], col, wobble=0.008)
            box(f"Mesh_ClayWood_{room_id}_WestPanelSeam_{idx:02d}", (0.08, 0.035, panel_h), (cx - sx / 2.0 + 0.12, y, z), mats["wood_dark"], col, wobble=0.008)


def add_cornice(room_id: str, col: bpy.types.Collection, mats: dict[str, bpy.types.Material], center: tuple[float, float], size: tuple[float, float], height: float) -> None:
    cx, cy = center
    sx, sy = size
    z = height - 0.18
    for step, inset in enumerate((0.0, 0.07, 0.14)):
        depth = 0.075 - step * 0.012
        box(f"Mesh_ClayWood_{room_id}_Cornice_North_{step}", (sx - 0.2, depth, 0.06), (cx, cy + sy / 2.0 - 0.13 - inset, z + step * 0.08), mats["wood_dark"], col)
        box(f"Mesh_ClayWood_{room_id}_Cornice_South_{step}", (sx - 0.2, depth, 0.06), (cx, cy - sy / 2.0 + 0.13 + inset, z + step * 0.08), mats["wood_dark"], col)
        box(f"Mesh_ClayWood_{room_id}_Cornice_East_{step}", (depth, sy - 0.2, 0.06), (cx + sx / 2.0 - 0.13 - inset, cy, z + step * 0.08), mats["wood_dark"], col)
        box(f"Mesh_ClayWood_{room_id}_Cornice_West_{step}", (depth, sy - 0.2, 0.06), (cx - sx / 2.0 + 0.13 + inset, cy, z + step * 0.08), mats["wood_dark"], col)


def add_plaster_damage(room_id: str, col: bpy.types.Collection, mats: dict[str, bpy.types.Material], center: tuple[float, float], size: tuple[float, float], height: float) -> None:
    cx, cy = center
    sx, sy = size
    sides = ("north", "south", "east", "west")
    for idx in range(22):
        side = sides[idx % 4]
        z = RNG.uniform(1.15, height - 0.42)
        large = idx % 5 == 0
        length = RNG.uniform(0.30, 0.82) if not large else RNG.uniform(0.8, 1.25)
        thick = RNG.uniform(0.035, 0.075)
        patch_mat = mats["wall_light"] if idx % 3 else mats["wall_dark"]
        if side == "north":
            x = cx + RNG.uniform(-sx * 0.38, sx * 0.38)
            y = cy + sy / 2.0 - 0.305
            box(f"Mesh_ClayPatch_{room_id}_{idx:02d}", (length, 0.022, thick), (x, y, z), patch_mat, col, rot_z=RNG.uniform(-0.18, 0.18), wobble=0.02, bevel=0.01)
        elif side == "south":
            x = cx + RNG.uniform(-sx * 0.38, sx * 0.38)
            y = cy - sy / 2.0 + 0.305
            box(f"Mesh_ClayPatch_{room_id}_{idx:02d}", (length, 0.022, thick), (x, y, z), patch_mat, col, rot_z=RNG.uniform(-0.18, 0.18), wobble=0.02, bevel=0.01)
        elif side == "east":
            x = cx + sx / 2.0 - 0.305
            y = cy + RNG.uniform(-sy * 0.38, sy * 0.38)
            box(f"Mesh_ClayPatch_{room_id}_{idx:02d}", (0.022, length, thick), (x, y, z), patch_mat, col, rot_z=RNG.uniform(-0.18, 0.18), wobble=0.02, bevel=0.01)
        else:
            x = cx - sx / 2.0 + 0.305
            y = cy + RNG.uniform(-sy * 0.38, sy * 0.38)
            box(f"Mesh_ClayPatch_{room_id}_{idx:02d}", (0.022, length, thick), (x, y, z), patch_mat, col, rot_z=RNG.uniform(-0.18, 0.18), wobble=0.02, bevel=0.01)
    for idx in range(12):
        x = cx + RNG.uniform(-sx * 0.35, sx * 0.35)
        y = cy + RNG.uniform(-sy * 0.35, sy * 0.35)
        box(f"Mesh_ClayCeilingCrack_{room_id}_{idx:02d}", (RNG.uniform(0.35, 0.9), 0.024, 0.018), (x, y, height + 0.165), mats["wall_dark"], col, rot_z=RNG.uniform(-0.8, 0.8), wobble=0.008, bevel=0.004)


def add_handprint(name: str, loc: tuple[float, float, float], wall_axis: str, col: bpy.types.Collection, mats: dict[str, bpy.types.Material]) -> None:
    x, y, z = loc
    palm_size = (0.14, 0.014, 0.16) if wall_axis in ("north", "south") else (0.014, 0.14, 0.16)
    box(f"Mesh_ClayHandprint_{name}_Palm", palm_size, loc, mats["wall_dark"], col, wobble=0.004, bevel=0.008)
    for i in range(5):
        dz = 0.10 + i * 0.018
        offset = -0.12 + i * 0.06
        if wall_axis in ("north", "south"):
            box(f"Mesh_ClayHandprint_{name}_Finger_{i}", (0.025, 0.014, 0.17), (x + offset, y, z + dz), mats["wall_dark"], col, wobble=0.003, bevel=0.006)
        else:
            box(f"Mesh_ClayHandprint_{name}_Finger_{i}", (0.014, 0.025, 0.17), (x, y + offset, z + dz), mats["wall_dark"], col, wobble=0.003, bevel=0.006)


def add_door(
    prefix: str,
    loc: tuple[float, float, float],
    col: bpy.types.Collection,
    mats: dict[str, bpy.types.Material],
    orientation: str,
    width: float = 1.16,
    height: float = 2.15,
    closed: bool = True,
    props: dict[str, object] | None = None,
) -> None:
    x, y, z = loc
    if orientation in ("north", "south"):
        frame_size = (width + 0.45, 0.16, height + 0.38)
        leaf_size = (width, 0.10, height)
        panel_size = (width * 0.32, 0.12, height * 0.28)
        knob_loc = (x + width * 0.34, y - 0.09 if orientation == "north" else y + 0.09, z + 0.02)
    else:
        frame_size = (0.16, width + 0.45, height + 0.38)
        leaf_size = (0.10, width, height)
        panel_size = (0.12, width * 0.32, height * 0.28)
        knob_loc = (x - 0.09 if orientation == "east" else x + 0.09, y + width * 0.34, z + 0.02)
    box(f"Mesh_ClayWood_{prefix}_ChunkyFrame", frame_size, (x, y, z), mats["wood_dark"], col, wobble=0.014, bevel=0.025)
    if closed:
        box(f"Mesh_ClayWood_{prefix}_DoorLeaf", leaf_size, (x, y, z), mats["wood"], col, props, wobble=0.016, bevel=0.025)
        for i, px in enumerate((-0.25, 0.25)):
            for j, pz in enumerate((-0.36, 0.36)):
                if orientation in ("north", "south"):
                    box(f"Mesh_ClayWood_{prefix}_RaisedPanel_{i}_{j}", panel_size, (x + px, y - 0.065 if orientation == "north" else y + 0.065, z + pz), mats["wood_dark"], col, wobble=0.01, bevel=0.02)
                else:
                    box(f"Mesh_ClayWood_{prefix}_RaisedPanel_{i}_{j}", panel_size, (x - 0.065 if orientation == "east" else x + 0.065, y + px, z + pz), mats["wood_dark"], col, wobble=0.01, bevel=0.02)
    cyl(f"Mesh_ClayMetalDark_{prefix}_Knob", 0.045, 0.10, knob_loc, mats["metal"], col, vertices=12, rot=(math.radians(90), 0.0, 0.0))


def add_open_threshold(
    prefix: str,
    loc: tuple[float, float, float],
    col: bpy.types.Collection,
    mats: dict[str, bpy.types.Material],
    orientation: str,
    width: float = 1.34,
    height: float = 2.16,
    glimpse: str = "dark",
) -> None:
    x, y, z = loc
    if orientation in ("north", "south"):
        frame_size = (width + 0.42, 0.18, height + 0.32)
        shadow_size = (width, 0.035, height - 0.18)
        shadow_loc = (x, y + (0.10 if orientation == "south" else -0.10), z)
    else:
        frame_size = (0.18, width + 0.42, height + 0.32)
        shadow_size = (0.035, width, height - 0.18)
        shadow_loc = (x + (0.10 if orientation == "west" else -0.10), y, z)
    box(f"Mesh_ClayWood_{prefix}_OpenFrame", frame_size, (x, y, z), mats["wood_dark"], col, wobble=0.014, bevel=0.026)
    fill_mat = mats["wood"] if glimpse == "room" else mats["wall_dark"]
    box(f"Mesh_ClayShadow_{prefix}_RoomGlimpse", shadow_size, shadow_loc, fill_mat, col, wobble=0.01, bevel=0.006)


def add_sconce(prefix: str, loc: tuple[float, float, float], col: bpy.types.Collection, mats: dict[str, bpy.types.Material], axis: str) -> None:
    x, y, z = loc
    if axis in ("north", "south"):
        arm_size = (0.36, 0.055, 0.055)
        cup_rot = (math.radians(90), 0.0, 0.0)
    else:
        arm_size = (0.055, 0.36, 0.055)
        cup_rot = (0.0, math.radians(90), 0.0)
    box(f"Mesh_ClayMetalDark_{prefix}_SconceBack", (0.18, 0.045, 0.22) if axis in ("north", "south") else (0.045, 0.18, 0.22), (x, y, z), mats["metal"], col, wobble=0.006, bevel=0.012)
    box(f"Mesh_ClayMetalDark_{prefix}_SconceArm", arm_size, (x, y, z + 0.02), mats["metal"], col, wobble=0.006, bevel=0.012)
    cyl(f"Mesh_ClayMetalDark_{prefix}_CandleCup", 0.10, 0.075, (x, y, z + 0.13), mats["metal"], col, vertices=12, rot=cup_rot)
    sphere(f"Mesh_ClayAmber_{prefix}_CandleFlame", 0.10, (x, y, z + 0.31), mats["candle"], col, scale=(0.65, 0.65, 1.25))


def add_ragged_runner(
    prefix: str,
    center: tuple[float, float],
    length: float,
    width: float,
    col: bpy.types.Collection,
    mats: dict[str, bpy.types.Material],
) -> None:
    cx, cy = center
    box(f"Mesh_ClayFabric_{prefix}_BurgundyRunner", (width, length, 0.052), (cx, cy, 0.035), mats["fabric"], col, wobble=0.018, bevel=0.012)
    for i in range(24):
        y = cy - length / 2.0 + RNG.random() * length
        side = -1 if i % 2 else 1
        x = cx + side * (width / 2.0 + RNG.uniform(-0.02, 0.04))
        box(f"Mesh_ClayFabric_{prefix}_RaggedEdge_{i:02d}", (RNG.uniform(0.035, 0.08), RNG.uniform(0.12, 0.32), 0.028), (x, y, 0.07), mats["fabric_dark"], col, rot_z=RNG.uniform(-0.28, 0.28), wobble=0.012, bevel=0.006)
    for i in range(10):
        box(f"Mesh_ClayFabric_{prefix}_FootSmear_{i:02d}", (RNG.uniform(0.16, 0.32), RNG.uniform(0.035, 0.06), 0.018), (cx + RNG.uniform(-width * 0.28, width * 0.28), cy - length / 2.0 + RNG.random() * length, 0.08), mats["fabric_dark"], col, rot_z=RNG.uniform(-0.55, 0.55), wobble=0.006, bevel=0.004)


def add_grandfather_clock(col: bpy.types.Collection, mats: dict[str, bpy.types.Material], loc: tuple[float, float, float]) -> None:
    x, y, z = loc
    box("Prop_GrandfatherClock", (0.56, 0.34, 2.05), (x, y, z + 1.02), mats["wood"], col, {"ww_prop": "clock"}, wobble=0.016, bevel=0.025)
    box("Mesh_ClayWood_GF_EntranceHall_ClockBase", (0.75, 0.44, 0.22), (x, y, z + 0.12), mats["wood_dark"], col)
    box("Mesh_ClayWood_GF_EntranceHall_ClockTop", (0.68, 0.40, 0.28), (x, y, z + 2.10), mats["wood_dark"], col)
    cyl("Mesh_ClayParchment_GF_EntranceHall_ClockFace", 0.23, 0.035, (x, y - 0.19, z + 1.72), mats["parchment"], col, vertices=24, rot=(math.radians(90), 0.0, 0.0))
    box("Mesh_ClayMetalDark_GF_EntranceHall_ClockHandA", (0.018, 0.012, 0.19), (x, y - 0.215, z + 1.74), mats["metal"], col, rot_z=0.55, wobble=0.002, bevel=0.002)
    box("Mesh_ClayMetalDark_GF_EntranceHall_ClockHandB", (0.014, 0.012, 0.15), (x, y - 0.216, z + 1.72), mats["metal"], col, rot_z=-0.35, wobble=0.002, bevel=0.002)
    cyl("Mesh_ClayMetalDark_GF_EntranceHall_PendulumRod", 0.012, 0.72, (x, y - 0.18, z + 0.86), mats["metal"], col, vertices=8)
    sphere("Mesh_ClayMetalDark_GF_EntranceHall_PendulumBob", 0.09, (x, y - 0.18, z + 0.55), mats["metal"], col, scale=(0.85, 0.25, 1.0))


def add_entrance_hall(col: bpy.types.Collection, mats: dict[str, bpy.types.Material]) -> None:
    height = 3.0
    center = (0.0, 0.0)
    size = (6.0, 8.0)
    add_room_shell("GF_EntranceHall", col, mats, center, size, height, breathable=True)
    add_ragged_runner("GF_EntranceHall", (-0.28, 0.15), 6.7, 1.45, col, mats)
    add_door("GF_EntranceHall_FrontDoor", (0.0, -3.94, 1.08), col, mats, "south", width=1.35, height=2.18, props={"ww_interact": "inspect"})
    add_door("GF_EntranceHall_SealedBoundary", (2.94, 1.35, 1.18), col, mats, "east", width=1.70, height=2.35, props={"ww_interact": "inspect"})
    add_open_threshold("EntranceToWestWing", (-3.02, 0.1, 1.08), col, mats, "west", width=1.30, height=2.14, glimpse="dark")
    add_grandfather_clock(col, mats, (-2.15, 2.45, 0.0))
    add_sconce("GF_EntranceHall_WestFront", (-2.88, -1.45, 1.48), col, mats, "west")
    add_sconce("GF_EntranceHall_EastFront", (2.88, -1.25, 1.48), col, mats, "east")
    add_sconce("GF_EntranceHall_Back", (-0.8, 3.84, 1.48), col, mats, "north")
    add_handprint("EntranceWhisperNorth", (-2.4, 3.70, 1.58), "north", col, mats)
    box("Mesh_ClayMetalDark_GF_EntranceHall_ChandelierSightline", (0.28, 0.28, 0.08), (-0.3, 1.0, 2.84), mats["metal"], col, wobble=0.006)
    box("Prop_Recorder", (0.32, 0.18, 0.08), (-1.45, -2.35, 0.09), mats["metal"], col, {"ww_interact": "take", "ww_prop": "recorder"}, wobble=0.006)
    box("Prop_IronKey", (0.28, 0.06, 0.04), (1.35, -2.2, 0.08), mats["metal"], col, {"ww_interact": "take", "ww_prop": "iron_key"}, wobble=0.004)
    empty("Spawn_GF_EntranceHall", (0.0, -2.5, 1.6), col, {"ww_spawn": "player"})
    empty("Door_GF_EntranceHall__GF_WestWingHall", (-3.05, 0.1, 1.0), col, {"ww_interact": "open", "ww_door": "west_wing"})
    empty("Wall_Whisper_Entrance", (-2.85, 1.4, 1.35), col, {"ww_breathing": 1, "ww_interact": "inspect"})
    empty("Trigger_ChandelierHandprintSightline", (-0.3, 1.0, 1.6), col, {"ww_trigger": "chandelier_handprint"})
    box("Col_GF_EntranceHall_Floor", (5.8, 7.8, 0.1), (0.0, 0.0, -0.05), mats["collision"], col, {"ww_collision": "static"})


def add_room_glimpse(prefix: str, col: bpy.types.Collection, mats: dict[str, bpy.types.Material], loc: tuple[float, float, float], side: str, kind: str) -> None:
    x, y, z = loc
    add_open_threshold(prefix, (x, y, z), col, mats, side, width=1.18, height=2.10, glimpse="room")
    if side in ("east", "west"):
        x_offset = -0.34 if side == "east" else 0.34
        shelf_x = x + x_offset
        box(f"Mesh_ClayWood_{prefix}_{kind}_BackWall", (0.06, 1.15, 1.85), (shelf_x, y, 1.05), mats["wall_dark"], col, wobble=0.012)
        if kind == "Library":
            for i in range(4):
                box(f"Mesh_ClayBook_{prefix}_{i:02d}", (0.08, 0.12, 0.28), (shelf_x, y - 0.35 + i * 0.22, 1.20), mats["parchment"], col, wobble=0.004, bevel=0.004)
        elif kind == "Kitchen":
            box(f"Mesh_ClayWood_{prefix}_PrepTable", (0.34, 0.75, 0.12), (shelf_x, y, 0.65), mats["wood"], col)
            box(f"Mesh_ClayParchment_{prefix}_TableScrap", (0.28, 0.20, 0.02), (shelf_x, y + 0.12, 0.74), mats["parchment"], col)
        else:
            box(f"Mesh_ClayWood_{prefix}_TableEdge", (0.32, 0.85, 0.11), (shelf_x, y, 0.72), mats["wood"], col)


def add_west_wing_hall(col: bpy.types.Collection, mats: dict[str, bpy.types.Material]) -> None:
    height = 2.9
    center = (-5.2, 1.0)
    size = (2.55, 8.6)
    add_room_shell("GF_WestWingHall", col, mats, center, size, height, breathable=True)
    add_ragged_runner("GF_WestWingHall", (-5.2, 1.0), 7.75, 1.08, col, mats)
    add_open_threshold("WestWingToEntrance", (-5.2, -3.36, 1.05), col, mats, "south", width=1.28, height=2.10, glimpse="dark")
    add_room_glimpse("WestHallToLibrary", col, mats, (-6.42, -1.35, 1.05), "west", "Library")
    add_room_glimpse("WestHallToDining", col, mats, (-3.98, 0.35, 1.05), "east", "Dining")
    add_room_glimpse("WestHallToKitchen", col, mats, (-3.98, 2.75, 1.05), "east", "Kitchen")
    add_door("GF_WestWingHall_CellarDoor", (-4.45, 3.98, 0.96), col, mats, "north", width=0.95, height=1.86, props={"ww_interact": "inspect"})
    box("Mesh_ClayShadow_GF_WestWingHall_EndDarkness", (2.15, 0.08, 2.35), (-5.2, 4.12, 1.22), mats["wall_dark"], col, wobble=0.01)
    for idx, y in enumerate((-2.15, -0.65, 1.05, 2.55)):
        add_sconce(f"GF_WestWingHall_Left_{idx}", (-6.28, y, 1.45), col, mats, "west")
    for idx, y in enumerate((-1.45, 0.45, 2.15, 3.45)):
        add_sconce(f"GF_WestWingHall_Right_{idx}", (-4.12, y, 1.45), col, mats, "east")
    add_handprint("WestWingThresholdA", (-6.27, -2.28, 1.55), "west", col, mats)
    add_handprint("WestWingCeilingA", (-5.42, -0.2, height + 0.17), "north", col, mats)
    box("Prop_ManorPlans", (0.48, 0.30, 0.035), (-4.72, -1.1, 0.09), mats["parchment"], col, {"ww_interact": "take", "ww_prop": "manor_plans"}, wobble=0.004)
    box("Measure_GF_WestWingHall_42_47", (1.75, 6.25, 0.05), (-5.2, 0.75, 0.09), mats["glass"], col, {"ww_measure": "42_47"}, wobble=0.0, bevel=0.0)
    empty("Trigger_WestWingThresholdScare", (-4.8, -2.1, 1.2), col, {"ww_trigger": "west_wing_threshold"})
    empty("Door_GF_WestWingHall__GF_Library", (-6.45, -1.35, 1.0), col, {"ww_door": "library"})
    empty("Door_GF_WestWingHall__GF_DiningRoom", (-3.95, 0.35, 1.0), col, {"ww_door": "dining"})
    empty("Door_GF_WestWingHall__GF_Kitchen", (-3.95, 2.75, 1.0), col, {"ww_door": "kitchen"})
    empty("Door_GF_WestWingHall__CellarStairs", (-4.55, 3.85, 1.0), col, {"ww_door": "cellar_stairs"})
    box("Col_GF_WestWingHall_Floor", (2.25, 8.2, 0.1), (-5.2, 1.0, -0.05), mats["collision"], col, {"ww_collision": "static"})


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
    mats = build_materials()
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

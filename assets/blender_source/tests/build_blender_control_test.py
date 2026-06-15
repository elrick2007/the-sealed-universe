from __future__ import annotations

from pathlib import Path

import bpy


SCRIPT_PATH = Path(__file__).resolve()
PROJECT_ROOT = SCRIPT_PATH.parents[3]
BLEND_OUT = PROJECT_ROOT / "assets" / "blender_source" / "tests" / "blender_control_test.blend"
GLB_OUT = PROJECT_ROOT / "assets" / "blender_exports" / "tests" / "blender_control_test.glb"


def reset_scene() -> None:
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete()


def clay_material(name: str, color: tuple[float, float, float, float]) -> bpy.types.Material:
    mat = bpy.data.materials.new(name)
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes.get("Principled BSDF")
    if bsdf:
        bsdf.inputs["Base Color"].default_value = color
        bsdf.inputs["Roughness"].default_value = 0.92
    return mat


def add_cube(name: str, location: tuple[float, float, float], scale: tuple[float, float, float], mat: bpy.types.Material) -> bpy.types.Object:
    bpy.ops.mesh.primitive_cube_add(size=1, location=location)
    obj = bpy.context.object
    obj.name = name
    obj.scale = scale
    obj.data.materials.append(mat)
    obj["ww_test_shape"] = "blender_control_proof"
    return obj


def add_label_marker(name: str, location: tuple[float, float, float]) -> bpy.types.Object:
    empty = bpy.data.objects.new(name, None)
    bpy.context.collection.objects.link(empty)
    empty.empty_display_type = "PLAIN_AXES"
    empty.empty_display_size = 0.35
    empty.location = location
    empty["ww_marker"] = "test_import_marker"
    return empty


def main() -> None:
    reset_scene()

    clay_red = clay_material("WW_Test_Clay_Red", (0.55, 0.08, 0.04, 1.0))
    clay_dark = clay_material("WW_Test_Clay_Shadow", (0.08, 0.045, 0.035, 1.0))
    clay_gold = clay_material("WW_Test_Muted_Gold", (0.83, 0.61, 0.28, 1.0))

    block = add_cube("WW_Test_Clay_Block", (0, 0, 0.5), (1.0, 1.0, 0.5), clay_red)
    block.rotation_euler[2] = 0.18

    add_cube("WW_Test_Shadow_Base", (0.06, -0.12, 0.04), (1.1, 1.08, 0.04), clay_dark)
    add_cube("WW_Test_Gold_Pin", (0.0, -0.56, 0.88), (0.12, 0.04, 0.12), clay_gold)
    add_label_marker("Marker_WW_Blender_Control_Proof", (0, 0, 1.25))

    bpy.ops.object.light_add(type="AREA", location=(0, -3, 4))
    light = bpy.context.object
    light.name = "Preview_Area_Light"
    light.data.energy = 350
    light.data.size = 4

    bpy.ops.object.camera_add(location=(3, -4, 2.2), rotation=(1.15, 0, 0.62))
    bpy.context.scene.camera = bpy.context.object

    BLEND_OUT.parent.mkdir(parents=True, exist_ok=True)
    GLB_OUT.parent.mkdir(parents=True, exist_ok=True)

    bpy.ops.wm.save_as_mainfile(filepath=str(BLEND_OUT))
    bpy.ops.export_scene.gltf(
        filepath=str(GLB_OUT),
        export_format="GLB",
        export_apply=True,
        export_extras=True,
        export_lights=False,
    )

    print(f"SAVED {BLEND_OUT}")
    print(f"EXPORTED {GLB_OUT}")


if __name__ == "__main__":
    main()

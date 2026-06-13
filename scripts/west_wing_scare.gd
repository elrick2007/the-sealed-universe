extends Area3D

@export var hall_light_path: NodePath
@export var shadow_path: NodePath

@onready var hall_light: OmniLight3D = get_node(hall_light_path)
@onready var shadow: MeshInstance3D = get_node(shadow_path)

var triggered := false
var scare_time := 0.0
var original_light_energy := 0.0
var shadow_original_scale := Vector3.ONE

func _ready() -> void:
	original_light_energy = hall_light.light_energy
	shadow_original_scale = shadow.scale
	shadow.visible = false
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if scare_time <= 0.0:
		return
	scare_time -= delta
	var pulse := (sin(Time.get_ticks_msec() * 0.008) + 1.0) * 0.5
	hall_light.light_energy = lerp(original_light_energy * 0.72, original_light_energy * 1.08, pulse)
	shadow.scale = shadow_original_scale * lerp(0.96, 1.03, pulse)
	if scare_time <= 0.0:
		hall_light.light_energy = original_light_energy
		shadow.scale = shadow_original_scale
		shadow.visible = false

func _on_body_entered(body: Node3D) -> void:
	if triggered or not body.has_method("show_message"):
		return
	triggered = true
	shadow.visible = true
	scare_time = 4.5
	body.visit_map_area("west_wing_hall")
	body.complete_journal_objective("open_west_wing")
	body.add_journal_objective("follow_west_wing", "Follow the whisper down the west wing hallway.")
	body.add_journal_note("west_wing_shift", "The west wing changed as Mara crossed the threshold.")
	body.show_message("The west wing folds itself around Mara. Find the manor plans.", 6.0)

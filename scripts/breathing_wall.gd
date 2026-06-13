extends MeshInstance3D

@export var pulse_amount := 0.035
@export var pulse_speed := 1.1

var base_scale := Vector3.ONE

func _ready() -> void:
	base_scale = scale

func _process(_delta: float) -> void:
	var pulse := 1.0 + sin(Time.get_ticks_msec() * 0.001 * pulse_speed) * pulse_amount
	scale = Vector3(base_scale.x, base_scale.y, base_scale.z * pulse)

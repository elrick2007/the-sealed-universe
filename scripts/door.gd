extends StaticBody3D

@export var locked := true
@export var required_key := "service_key"
@export var open_angle := -95.0
@export var open_speed := 4.0

var is_open := false
var base_rotation := 0.0

func _ready() -> void:
	base_rotation = rotation.y

func get_prompt(player: Node) -> String:
	if is_open:
		return ""
	if locked and not player.has_item(required_key):
		return "E - Service door is locked"
	return "E - Open west wing door"

func interact(player: Node) -> void:
	if locked and not player.has_item(required_key):
		player.show_message("The door will not move. Something behind the wall clicks three times.")
		player.add_journal_objective("find_service_key", "Find the service key for the west wing door.")
		return
	locked = false
	is_open = true
	player.complete_journal_objective("open_west_wing")
	player.show_message("The west wing door opens. The hallway beyond is listening.")

func _process(delta: float) -> void:
	if is_open:
		rotation.y = lerp_angle(rotation.y, base_rotation + deg_to_rad(open_angle), min(delta * open_speed, 1.0))

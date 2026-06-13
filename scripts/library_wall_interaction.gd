extends StaticBody3D

var is_open_to_study := false

func get_prompt(_player: Node) -> String:
	if is_open_to_study:
		return ""
	return "E - Inspect library wall"

func interact(player: Node) -> void:
	if is_open_to_study:
		return
	if get_tree().root.get_meta("library_wall_recorded", false):
		player.show_message("The Library wall has gone quiet. The way into the Study is open.")
		return
	if player.has_recorder:
		player.show_message("The recorder light steadies near the shelves. Press R to capture the Library wall.")
		player.add_journal_objective("record_library_wall", "Use the recorder on the Library wall.")
	else:
		player.show_message("The shelves creak toward the wall, waiting for a device Mara does not yet have.")
		player.add_journal_objective("find_recorder", "Find Mara's recorder.")

func reveal_study_passage() -> void:
	if is_open_to_study:
		return
	is_open_to_study = true
	collision_layer = 0
	collision_mask = 0
	var wall_mesh := get_node_or_null("Mesh")
	if wall_mesh:
		wall_mesh.visible = false
	var wall_collision := get_node_or_null("CollisionShape3D")
	if wall_collision:
		wall_collision.disabled = true
	var shelf := get_parent().get_node_or_null("ShelfBack")
	if shelf:
		shelf.visible = false

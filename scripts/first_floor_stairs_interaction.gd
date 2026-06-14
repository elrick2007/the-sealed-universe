extends StaticBody3D

var climbed := false


func get_prompt(_player: Node) -> String:
	if not bool(get_tree().root.get_meta("act_2_gate_seeded", false)):
		return "E - Inspect stairs"
	if climbed:
		return "E - Re-read stair landing"
	return "E - Follow borrowed stairs"


func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("act_2_gate_seeded", false)):
		player.show_message("The stairs do not admit they go anywhere yet. The house has not given Mara the missing five feet.", 6.0)
		return
	if climbed:
		player.show_message("The landing waits above the Kitchen, pencilled in but not yet furnished.", 6.0)
		return

	climbed = true
	root.set_meta("act_2_started", true)
	root.set_meta("current_act", 2)
	root.set_meta("first_floor_stairs_found", true)
	root.set_meta("first_floor_landing_seeded", true)

	player.complete_journal_objective("find_first_floor_stairs")
	player.add_journal_note(
		"first_floor_stairs_found",
		"The staircase appears where the borrowed five feet can fit. Caton's survey did not forget the stairs; the house withheld them."
	)
	player.add_ledger_entry(
		"first_floor_stairs_found",
		"Mara found the stairs by following a measurement the house had tried to retract. The landing above was not built yet, but it had already started waiting.",
		"2:47 AM - Act Two"
	)
	player.add_evidence(
		"first_floor_stairs_found",
		"First Floor Stair Found",
		"The borrowed five feet exposes a staircase route toward the First Floor.",
		"Route"
	)
	player.add_journal_objective("reach_gallery_landing", "Reach the Gallery Landing on the First Floor.")
	if player.has_method("unlock_map_floor"):
		player.unlock_map_floor("first_floor")
	player.show_message("Act II: The floor above begins in borrowed space. The Gallery Landing is next.", 8.0)

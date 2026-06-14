extends StaticBody3D

const NOTE_ID := "attic_stair_door_opened"

var opened := false

func get_prompt(player: Node) -> String:
	var root := get_tree().root
	if bool(root.get_meta("attic_stair_unlocked", false)):
		return "E - Re-read attic stair door"
	if _player_has_chatelaine(player) and bool(root.get_meta("scheduled_247_route_gate_ready", false)):
		return "E - Use chatelaine on attic stair"
	return "E - Inspect attic stair door"

func interact(player: Node) -> void:
	var root := get_tree().root
	if bool(root.get_meta("attic_stair_unlocked", false)) or opened:
		if player.has_method("show_message"):
			player.show_message("The attic stair door is open. Above it, the house keeps its stored breath.", 6.0)
		return
	if not _player_has_chatelaine(player):
		if player.has_method("show_message"):
			player.show_message("The door has a servant-side lock. Mara needs the Housekeeper's chatelaine.", 6.0)
		return
	if not bool(root.get_meta("scheduled_247_route_gate_ready", false)):
		if player.has_method("show_message"):
			player.show_message("One key fits, but the lock will not turn until the chosen 2:47 page has answered.", 7.0)
		return

	opened = true
	root.set_meta("attic_stair_unlocked", true)
	root.set_meta("attic_route_stub_open", true)
	root.set_meta("attic_plan_unlocked", true)
	root.set_meta("attic_stair_stub_seeded", true)
	root.set_meta("act_3_route_seeded", true)

	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective("find_attic_stair_door")
		player.complete_journal_objective("follow_chosen_247_to_attic")
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			NOTE_ID,
			"The chatelaine opens the attic stair door only after the chosen 2:47 page names the route. The stair creaks the first five notes of the lullaby."
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			NOTE_ID,
			"The largest key turned when the hour allowed it. Above the door, the stair inhaled through old wood and waited for Mara to count upward.",
			"2:47 AM - The Stair Unlocked"
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			NOTE_ID,
			"Attic Stair Door Opened",
			"The Housekeeper's chatelaine opens the attic stair only after the chosen 2:47 route proof.",
			"Route"
		)
	if player.has_method("add_journal_objective"):
		player.add_journal_objective("trace_blank_bell_wire", "Follow the blank bell's wire into the Long Attic.")
	if player.has_method("unlock_map_floor"):
		player.unlock_map_floor("attic")
	if player.has_method("show_message"):
		player.show_message("The chatelaine turns. The attic stair answers with five careful creaks.", 8.0)

func _player_has_chatelaine(player: Node) -> bool:
	return player != null and player.has_method("has_item") and bool(player.has_item("chatelaine"))

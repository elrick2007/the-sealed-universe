extends StaticBody3D

var witnessed := false

func get_prompt(_player: Node) -> String:
	if not bool(get_tree().root.get_meta("sealed_wing_transition_ready", false)):
		return "E - Touch unwritten sketch"
	if witnessed:
		return "E - Re-read drafted corridor"
	return "E - Step into drafted corridor"

func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("sealed_wing_transition_ready", false)):
		player.show_message("The sketch will not take weight yet. The door has not accepted Mara's unfinished word.", 6.0)
		return
	if witnessed:
		player.show_message("The drafted corridor holds at forty-two feet, except when Mara looks directly at the end.", 7.0)
		return

	witnessed = true
	root.set_meta("sealed_wing_draft_witnessed", true)
	player.complete_journal_objective("enter_drafted_sealed_wing")
	player.add_journal_note(
		"sealed_wing_draft_witnessed",
		"The sealed wing appears as a pencilled corridor before it becomes architecture. The map calls it east; every other record calls it west."
	)
	player.add_ledger_entry(
		"sealed_wing_draft_witnessed",
		"Mara stepped where the room had only been sketched. The corridor accepted her weight, then wrote forty-two feet beside her shoe. It was not forty-two feet.",
		"2:47 AM - Corridor In Pencil"
	)
	player.add_evidence(
		"sealed_wing_draft_witnessed",
		"Drafted Sealed Wing Threshold",
		"The sealed wing appears first as unfinished pencil-work after Mara's Incomplete entry is witnessed.",
		"Threshold"
	)
	player.add_journal_objective("find_eleanor_journal_map", "Find Eleanor's hand-drawn map of the sealed wing.")
	player.visit_map_area("east_wing")
	player.show_message("The sealed wing draws itself in pencil. Forty-two feet. It is not.", 8.0)

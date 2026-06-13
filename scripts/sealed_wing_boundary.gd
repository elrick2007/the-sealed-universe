extends StaticBody3D

var tested := false
var transition_ready := false

func get_prompt(_player: Node) -> String:
	var root := get_tree().root
	if transition_ready or bool(root.get_meta("sealed_wing_transition_ready", false)):
		return "E - Touch unwritten door"
	if _has_incomplete_route_condition():
		return "E - Offer Incomplete"
	return "E - Test sealed boundary"

func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("rose_scent_traced", false)):
		player.show_message("The sealed edge of the house smells briefly of roses, then refuses to be evidence.", 6.0)
		return
	if not bool(root.get_meta("rose_trace_returned", false)):
		player.show_message("Mara has the scent, but not the pattern. The Kitchen needs the contradiction pinned first.", 6.0)
		return
	if bool(root.get_meta("sealed_wing_transition_ready", false)):
		player.show_message("The door is still unwritten, but now it knows Mara's name. The next page will have to draw it.", 7.0)
		return
	if tested and _has_incomplete_route_condition():
		_open_transition(player)
		return
	if tested:
		player.show_message("The sealed boundary stays unwritten. Somewhere, a living name is still holding it shut.", 6.0)
		return

	tested = true
	root.set_meta("sealed_wing_boundary_tested", true)
	player.complete_journal_objective("approach_sealed_wing_edge")
	player.add_journal_note("sealed_wing_boundary", "The sealed wing will not open from scent alone. It answers to a living name in the records.")
	player.add_ledger_entry(
		"sealed_wing_boundary",
		"The sealed wing did not unlock. It behaved like a sentence with the final word removed. Mara smelled roses, then ink, then something alive behind the paper.",
		"2:47 AM - The Unwritten Door"
	)
	player.add_evidence(
		"sealed_wing_boundary",
		"Sealed Wing Boundary",
		"The rose trace leads to the sealed wing, but the door responds to a living record rather than a key.",
		"Threshold"
	)
	player.add_journal_objective("find_living_name", "Find the living name that keeps the sealed wing unwritten.")
	player.show_message("The sealed wing remains unwritten. The door is waiting for a living name, not another key.", 8.0)

func _has_incomplete_route_condition() -> bool:
	var root := get_tree().root
	return bool(root.get_meta("incomplete_247_armed", false)) or bool(root.get_meta("incomplete_247_fired", false))

func _open_transition(player: Node) -> void:
	transition_ready = true
	var root := get_tree().root
	root.set_meta("sealed_wing_transition_ready", true)
	player.complete_journal_objective("decode_incomplete")
	player.complete_journal_objective("return_to_unwritten_door")
	player.add_journal_note(
		"sealed_wing_transition_ready",
		"The sealed wing does not open, but the unwritten door accepts Mara's Incomplete entry as a future route."
	)
	player.add_ledger_entry(
		"sealed_wing_transition_ready",
		"Mara pressed the unfinished word to the sealed door. The paper did not tear. It made room. Somewhere beyond it, a corridor waited to be written at 2:47.",
		"2:47 AM - A Door In Draft"
	)
	player.add_evidence(
		"sealed_wing_transition_ready",
		"Unwritten Door Accepted Incomplete",
		"After Mara's own entry rewrites, the sealed wing acknowledges the word Incomplete as a route condition.",
		"Threshold"
	)
	player.reveal_map_area("east_wing")
	player.add_journal_objective("enter_drafted_sealed_wing", "Step into the drafted sealed-wing threshold.")
	player.show_message("The sealed wing does not open. It drafts itself around the word Incomplete.", 8.0)

extends StaticBody3D

var tested := false

func get_prompt(_player: Node) -> String:
	return "E - Test sealed boundary"

func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("rose_scent_traced", false)):
		player.show_message("The sealed edge of the house smells briefly of roses, then refuses to be evidence.", 6.0)
		return
	if not bool(root.get_meta("rose_trace_returned", false)):
		player.show_message("Mara has the scent, but not the pattern. The Kitchen needs the contradiction pinned first.", 6.0)
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

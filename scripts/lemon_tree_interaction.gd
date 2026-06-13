extends StaticBody3D

var inspected := false

func get_prompt(_player: Node) -> String:
	return "E - Inspect lemon tree"

func interact(player: Node) -> void:
	if not bool(get_tree().root.get_meta("next_route_gate_open", false)):
		player.show_message("The lemon leaves are still only a sketch on the plan.", 5.0)
		return
	if inspected:
		player.show_message("The lemon tree keeps its cold scent. Still no roses.", 5.0)
		return
	inspected = true
	get_tree().root.set_meta("lemon_tree_inspected", true)
	player.complete_journal_objective("inspect_lemon_trees")
	player.add_journal_note("lemon_tree_witness", "Eleanor's murder belongs among lemon trees. Rose scent is a false trail from the sealed wing door.")
	player.add_ledger_entry("lemon_tree_witness", "There were no roses in the Conservatory. Only lemons, hard and yellow in the dark, each one bright as a warning Mara had been trained to misread.", "2:47 AM - Lemon Witness")
	player.add_evidence("lemon_tree_witness", "Lemon Tree Witness", "The Conservatory confirms the murder memory belongs to lemon trees, while rose scent points somewhere else.", "Witness")
	player.add_journal_objective("find_rose_scent_source", "Find where the rose scent really belongs.")
	player.show_message("Lemon oil, cold glass, no roses. The house has been moving the scent.", 8.0)

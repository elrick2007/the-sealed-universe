extends StaticBody3D

var traced := false

func get_prompt(_player: Node) -> String:
	return "E - Trace rose scent"

func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("next_route_gate_open", false)):
		player.show_message("A sweet smell slips under the plan, then vanishes before Mara can name it.", 5.0)
		return
	if not bool(root.get_meta("lemon_tree_inspected", false)):
		player.show_message("Roses for one breath, lemon oil for the next. Mara needs the tree before she trusts the scent.", 6.0)
		return
	if traced:
		player.show_message("The rose scent stays at the sealed edge of the house. Not a flower. A warning.", 5.0)
		return

	traced = true
	root.set_meta("rose_scent_traced", true)
	player.complete_journal_objective("find_rose_scent_source")
	player.add_journal_note("rose_scent_trace", "The rose scent does not belong to the Conservatory. It gathers at the sealed wing edge.")
	player.add_ledger_entry(
		"rose_scent_trace",
		"I found the roses where no rose could grow. The lemon tree told the truth; the sealed door kept the perfume.",
		"2:47 AM - Roses Behind A Door"
	)
	player.add_evidence(
		"rose_scent_trace",
		"Rose Scent Trace",
		"No flowers in the Conservatory. The scent gathers near the sealed wing boundary.",
		"Scent"
	)
	player.add_journal_objective(
		"return_rose_trace_to_kitchen",
		"Return to the Kitchen hub and pin the rose-scent contradiction."
	)
	player.reveal_map_area("east_wing")
	player.show_message(
		"Rose scent gathers at the sealed edge of the house. No flower, no vase, no soil. Just a locked door remembering perfume.",
		8.0
	)

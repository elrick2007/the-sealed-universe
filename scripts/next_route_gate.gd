extends StaticBody3D

var unlocked := false

func get_prompt(player: Node) -> String:
	if _act_1_ready(player):
		return "E - Choose next route"
	return "E - Review next route"

func interact(player: Node) -> void:
	if not _act_1_ready(player):
		player.show_message("The Kitchen will not give up another route yet. Review the ledger, evidence board, and recorder transcriptions.", 7.0)
		return
	if unlocked:
		player.show_message("The next route is marked: find the Conservatory witness among the lemon trees.", 6.0)
		return
	unlocked = true
	get_tree().root.set_meta("next_route_gate_open", true)
	player.complete_journal_objective("choose_next_route")
	player.add_journal_objective("find_conservatory_route", "Find the route toward the Conservatory lemon trees.")
	player.add_journal_note("next_route_conservatory", "The next route points toward lemon trees, not roses. The rose scent belongs to the sealed wing door.")
	player.add_ledger_entry(
		"next_route_conservatory",
		"The Kitchen offered the next route only after Mara filed the proof. The word Conservatory appeared beside a smear of yellow ink, sharp as lemon oil.",
		"2:47 AM - The Lemon Route"
	)
	player.reveal_map_area("east_wing")
	player.show_message("Route chosen: Conservatory. The map admits only the edge of it for now.", 7.0)

func _act_1_ready(player: Node) -> bool:
	if player.has_method("is_act_1_ready"):
		return player.is_act_1_ready()
	return bool(get_tree().root.get_meta("act_1_ready", false))

extends StaticBody3D

var found := false

func get_prompt(_player: Node) -> String:
	return "E - Read rewritten entry"

func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("caldwell_record_found", false)):
		player.show_message("Mara's line will not hold ink yet. The living name has to be witnessed first.", 6.0)
		return
	if found:
		player.show_message("Mara Voss. December 2. The final word remains: Incomplete.", 6.0)
		return

	found = true
	root.set_meta("mara_incomplete_seeded", true)
	root.set_meta("incomplete_countdown_seeded", true)
	player.complete_journal_objective("trace_caldwell_recruiter")
	player.add_journal_note("mara_incomplete_entry", "Mara's own black-book line shows December 2, then rewrites itself as Incomplete.")
	player.add_ledger_entry(
		"mara_incomplete_entry",
		"Mara found her own name where no living person should be indexed. December 2 waited beside it, then failed to finish its sentence.",
		"2:47 AM - Incomplete"
	)
	player.add_evidence(
		"mara_incomplete_entry",
		"Mara Voss - December 2 / Incomplete",
		"Mara's entry names a death date, then rewrites the status as Incomplete. The house has not finished with her.",
		"Black Book"
	)
	player.add_journal_objective("decode_incomplete", "Find why Mara's December 2 entry rewrites to Incomplete.")
	var scheduler := get_node_or_null("/root/Main/ClockScheduler")
	if scheduler != null and scheduler.has_method("arm_incomplete_event"):
		scheduler.arm_incomplete_event(player)
	player.show_message("Mara Voss. December 2. The ink hesitates, then rewrites itself: Incomplete.", 8.0)

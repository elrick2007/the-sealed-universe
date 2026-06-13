extends StaticBody3D

var found := false

func get_prompt(_player: Node) -> String:
	return "E - Check Caldwell record"

func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("sealed_wing_boundary_tested", false)):
		player.show_message("The black-book page is blank here. The sealed wing has not asked the right question yet.", 6.0)
		return
	if found:
		player.show_message("Martin Caldwell remains in the book as Status: Living. The house does not list him as prey.", 6.0)
		return

	found = true
	root.set_meta("caldwell_record_found", true)
	player.complete_journal_objective("find_living_name")
	player.add_journal_note("caldwell_living_record", "Martin Caldwell, the estate agent, appears in the black book as Status: Living. The house records him as recruiter, not victim.")
	player.add_ledger_entry(
		"caldwell_living_record",
		"Mara found Martin Caldwell in the black book. Not dead. Not missing. Living. The word had been written with the confidence of a key turning from the other side.",
		"2:47 AM - Status: Living"
	)
	player.add_evidence(
		"caldwell_living_record",
		"Martin Caldwell - Status: Living",
		"The estate agent is listed in the black book as living. His role is not witness or victim, but recruiter.",
		"Black Book"
	)
	player.add_journal_objective("trace_caldwell_recruiter", "Trace how Martin Caldwell feeds names into Ashford Manor.")
	player.show_message("Martin Caldwell. Estate agent. Status: Living. Not witness. Recruiter.", 8.0)

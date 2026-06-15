extends StaticBody3D

const FINAL_AUTHORITY_SEEDED_META := "foundation_final_authority_seeded"
const OCCUPANT_AUTHORITY_RECORD_META := "occupant_authority_record_found"

var found := false

func get_prompt(_player: Node) -> String:
	if found and bool(get_tree().root.get_meta(FINAL_AUTHORITY_SEEDED_META, false)) and not bool(get_tree().root.get_meta(OCCUPANT_AUTHORITY_RECORD_META, false)):
		return "E - Check authority record"
	return "E - Check Caldwell record"

func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("sealed_wing_boundary_tested", false)):
		player.show_message("The black-book page is blank here. The sealed wing has not asked the right question yet.", 6.0)
		return
	if found and bool(root.get_meta(FINAL_AUTHORITY_SEEDED_META, false)):
		_read_occupant_authority_record(player)
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

func _read_occupant_authority_record(player: Node) -> void:
	var root := get_tree().root
	if bool(root.get_meta(OCCUPANT_AUTHORITY_RECORD_META, false)):
		player.show_message("The record is steady now: Caldwell recruits. The current occupant answers. Mara's line is still Incomplete.", 7.0)
		return
	root.set_meta(OCCUPANT_AUTHORITY_RECORD_META, true)
	player.complete_journal_objective("find_occupant_authority_record")
	player.add_journal_objective("prove_mara_current_occupant", "Prove whether Mara is the current occupant before choosing the house's final state.")
	player.add_journal_note("occupant_authority_record", "The black book does not make Martin Caldwell the authority. He feeds names into Ashford Manor. The final answer belongs to the current occupant, and Mara's entry remains Incomplete.")
	player.add_evidence(
		"occupant_authority_record",
		"Authority Record: Current Occupant",
		"Caldwell is listed as recruiter, not decision-maker. The Foundation Chamber requires the current occupant before any final state can be chosen.",
		"Black Book"
	)
	player.add_ledger_entry(
		"occupant_authority_record",
		"Mara checked Caldwell's line again and found the book had not moved him closer to mercy. Recruiter, it said. Not owner. Not witness. The final authority belonged to the current occupant, and her own line still refused to finish.",
		"2:47 AM - Current Occupant"
	)
	player.show_message("Caldwell recruits. The current occupant answers. Mara's line is still Incomplete.", 8.0)

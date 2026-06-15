extends StaticBody3D

const OCCUPANT_AUTHORITY_RECORD_META := "occupant_authority_record_found"
const CURRENT_OCCUPANT_PROOF_META := "mara_current_occupant_proved"

var found := false

func get_prompt(_player: Node) -> String:
	var root := get_tree().root
	if bool(root.get_meta("mara_incomplete_seeded", found)) and bool(root.get_meta(OCCUPANT_AUTHORITY_RECORD_META, false)) and not bool(root.get_meta(CURRENT_OCCUPANT_PROOF_META, false)):
		return "E - Compare occupant proof"
	if bool(root.get_meta(CURRENT_OCCUPANT_PROOF_META, false)):
		return "E - Re-read current proof"
	return "E - Read rewritten entry"

func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("caldwell_record_found", false)):
		player.show_message("Mara's line will not hold ink yet. The living name has to be witnessed first.", 6.0)
		return
	if bool(root.get_meta("mara_incomplete_seeded", found)):
		if _try_prove_current_occupant(player):
			return
		if bool(root.get_meta(CURRENT_OCCUPANT_PROOF_META, false)):
			player.show_message("Mara's entry remains Incomplete because the house is waiting for her answer.", 7.0)
			return
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


func _try_prove_current_occupant(player: Node) -> bool:
	var root := get_tree().root
	if not bool(root.get_meta(OCCUPANT_AUTHORITY_RECORD_META, false)):
		return false
	if bool(root.get_meta(CURRENT_OCCUPANT_PROOF_META, false)):
		return false

	root.set_meta(CURRENT_OCCUPANT_PROOF_META, true)
	player.complete_journal_objective("prove_mara_current_occupant")
	player.add_journal_objective(
		"return_current_occupant_proof_to_foundation",
		"Return Mara's current-occupant proof to the Foundation Chamber."
	)
	player.add_journal_note(
		"current_occupant_proof",
		"Mara's Incomplete entry is not only a warning. After Caldwell is reduced to recruiter, the book treats Mara as the current occupant held in abeyance."
	)
	player.add_evidence(
		"current_occupant_proof",
		"Mara Voss - Current Occupant / Incomplete",
		"The black book links Mara's unfinished entry to the authority clause. The house is waiting for her answer, but the ending remains locked.",
		"Black Book"
	)
	player.add_ledger_entry(
		"current_occupant_proof",
		"Mara read her own unfinished line beside Caldwell's living one and understood the cruelty of the grammar. Recruiter was not authority. Incomplete was not absence. It was a place left for her hand.",
		"2:47 AM - Current Occupant"
	)
	player.show_message("Incomplete is not absence. It is the space left for Mara's answer.", 8.0)
	return true

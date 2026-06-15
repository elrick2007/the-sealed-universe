extends StaticBody3D

const REQUIRED_META := "foundation_chamber_affordances_seen"
const READ_META := "foundation_testament_page_read"
const PUBLISH_SEED_META := "foundation_publish_meter_seeded"
const CHOICE_LOCK_META := "foundation_choice_lock_understood"
const AUTHORITY_SEED_META := "foundation_final_authority_seeded"
const CURRENT_OCCUPANT_PROOF_META := "mara_current_occupant_proved"
const CURRENT_OCCUPANT_RETURN_META := "foundation_current_occupant_proof_returned"


func get_prompt(_player: Node) -> String:
	if bool(get_tree().root.get_meta(CURRENT_OCCUPANT_RETURN_META, false)):
		return "E - Re-read occupant clause"
	if bool(get_tree().root.get_meta(AUTHORITY_SEED_META, false)) and bool(get_tree().root.get_meta(CURRENT_OCCUPANT_PROOF_META, false)):
		return "E - Return occupant proof"
	if bool(get_tree().root.get_meta(CHOICE_LOCK_META, false)) and not bool(get_tree().root.get_meta(AUTHORITY_SEED_META, false)):
		return "E - Re-read for authority"
	if bool(get_tree().root.get_meta(READ_META, false)):
		return "E - Re-read testament page"
	return "E - Read testament page"


func interact(player: Node) -> void:
	if not bool(get_tree().root.get_meta(REQUIRED_META, false)):
		player.show_message("The page stays blank until Mara has seen every offer.")
		return

	if bool(get_tree().root.get_meta(READ_META, false)):
		if _try_seed_final_authority(player):
			return
		if _try_return_current_occupant_proof(player):
			return
		if bool(get_tree().root.get_meta(CURRENT_OCCUPANT_RETURN_META, false)):
			player.show_message("The book keeps Mara's name in the margin. The ending is still unwritten.")
			return
		player.show_message("The testament page keeps the same sentence. That feels new.")
		return

	get_tree().root.set_meta(READ_META, true)
	get_tree().root.set_meta(PUBLISH_SEED_META, true)

	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective("read_foundation_testament_pages")
	if player.has_method("add_journal_objective"):
		player.add_journal_objective(
			"return_testament_to_evidence_board",
			"Return the testament page proof to the Kitchen evidence board."
		)
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			"foundation_testament_page",
			"The original book's first readable page names the pen, the oil, and the proof bundle as choices previous keepers already made."
		)
		player.add_journal_note(
			"foundation_publish_meter_seed",
			"Mara has the first publish-route proof, but the chamber has not asked her to choose an ending."
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			"foundation_testament_page",
			"Foundation Testament Page",
			"The original book describes write, burn, and publish as witnessed offers rather than endings. It seeds the publish route without choosing it.",
			"Foundation"
		)
		player.add_evidence(
			"foundation_publish_meter_seed",
			"Publish Route Seed",
			"The proof route begins as a requirement for complete witness, not as a send button. The ending remains locked.",
			"Publish"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			"foundation_testament_page",
			"The first page Mara could read had already read her back. It named the pen, the oil, and the witness bundle as if the room had been keeping score long before she found it.",
			"2:47 AM - Testament Page"
		)
	player.show_message("The first readable page names the offers as if someone has already chosen them.")


func _try_seed_final_authority(player: Node) -> bool:
	if not bool(get_tree().root.get_meta(CHOICE_LOCK_META, false)):
		return false
	if bool(get_tree().root.get_meta(AUTHORITY_SEED_META, false)):
		return false

	get_tree().root.set_meta(AUTHORITY_SEED_META, true)

	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective("find_final_authority_before_ending")
	if player.has_method("add_journal_objective"):
		player.add_journal_objective(
			"find_occupant_authority_record",
			"Find the record that names who may answer for Ashford Manor."
		)
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			"foundation_final_authority_seed",
			"The first book adds a margin line after the choices refuse Mara: proof is not authority. The right to answer belongs to the current occupant, witnessed in the house's own hand."
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			"foundation_final_authority_seed",
			"Foundation Testament: Authority Clause",
			"A new margin clause appears only after Mara tests all three ending-shaped offers. Proof can witness the house, but only the recorded occupant can send its final state.",
			"Foundation"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			"foundation_final_authority_seed",
			"The page did not give Mara permission. It gave her a problem with her name already close to the answer.",
			"2:47 AM - Authority Clause"
		)
	player.show_message("A new margin line appears: proof is not authority. Find the record that names who may answer.")
	return true


func _try_return_current_occupant_proof(player: Node) -> bool:
	if not bool(get_tree().root.get_meta(AUTHORITY_SEED_META, false)):
		return false
	if not bool(get_tree().root.get_meta(CURRENT_OCCUPANT_PROOF_META, false)):
		return false
	if bool(get_tree().root.get_meta(CURRENT_OCCUPANT_RETURN_META, false)):
		return false

	get_tree().root.set_meta(CURRENT_OCCUPANT_RETURN_META, true)

	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective("return_current_occupant_proof_to_foundation")
	if player.has_method("add_journal_objective"):
		player.add_journal_objective(
			"prepare_final_register_without_choosing",
			"Prepare the final register without choosing the house's ending."
		)
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			"foundation_current_occupant_return",
			"The original book accepts Mara as current occupant held in abeyance. It can wait for her final answer, but it has not asked her to choose the ending yet."
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			"foundation_current_occupant_return",
			"Foundation Book: Occupant Accepted",
			"Mara's Incomplete proof returns to the authority clause. The book acknowledges she may answer for Ashford Manor, but the final affordances remain locked.",
			"Foundation"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			"foundation_current_occupant_return",
			"The house had spent a century confusing ownership with witness. By morning, the margin had learned the difference. Voss, M. Status: living. Disposition: hers.",
			"2:47 AM - Disposition: Hers"
		)
	player.show_message("The book accepts the proof: Voss, M. Disposition: hers. The ending is still unwritten.")
	return true

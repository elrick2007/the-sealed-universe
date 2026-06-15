extends StaticBody3D

@export var required_meta := "foundation_chamber_choices_read"
@export var state_meta := ""
@export var prompt := "E - Inspect foundation object"
@export var repeat_prompt := "E - Re-check foundation object"
@export var gate_message := "The chamber has not offered this shape yet."
@export var repeat_message := ""
@export var message := ""
@export var complete_objective_id := ""
@export var next_objective_id := ""
@export var next_objective_text := ""
@export var note_id := ""
@export_multiline var note_text := ""
@export var evidence_id := ""
@export var evidence_title := ""
@export_multiline var evidence_text := ""
@export var evidence_location := "Foundation Chamber"
@export var ledger_id := ""
@export_multiline var ledger_text := ""
@export var ledger_timestamp := "2:47 AM - Foundation Chamber"
@export var counts_toward_foundation_offers := false
@export_enum("none", "serve", "destroy", "publish") var ending_choice_id := "none"

const FOUNDATION_OFFER_METAS := [
	"foundation_pen_offer_seen",
	"foundation_oil_offer_seen",
	"foundation_publish_offer_seen",
]

func get_prompt(_player: Node) -> String:
	if _can_show_choice_lock():
		return "E - Test locked ending"
	if state_meta != "" and bool(get_tree().root.get_meta(state_meta, false)):
		return repeat_prompt
	return prompt

func interact(player: Node) -> void:
	var root := get_tree().root
	if required_meta != "" and not bool(root.get_meta(required_meta, false)):
		if player.has_method("show_message"):
			player.show_message(gate_message, 6.0)
		return

	if state_meta != "" and bool(root.get_meta(state_meta, false)):
		if _try_mark_publish_bundle_witness(player):
			return
		if _try_mark_oil_final_witness(player):
			return
		if _try_show_publish_choice_lock(player):
			return
		if player.has_method("show_message"):
			player.show_message(repeat_message if repeat_message != "" else message, 6.0)
		return

	if state_meta != "":
		root.set_meta(state_meta, true)

	if complete_objective_id != "" and player.has_method("complete_journal_objective"):
		player.complete_journal_objective(complete_objective_id)
	if next_objective_id != "" and player.has_method("add_journal_objective"):
		player.add_journal_objective(next_objective_id, next_objective_text)
	if note_id != "" and player.has_method("add_journal_note"):
		player.add_journal_note(note_id, note_text)
	if evidence_id != "" and player.has_method("add_evidence"):
		player.add_evidence(evidence_id, evidence_title, evidence_text, evidence_location)
	if ledger_id != "" and player.has_method("add_ledger_entry"):
		player.add_ledger_entry(ledger_id, ledger_text, ledger_timestamp)
	if message != "" and player.has_method("show_message"):
		player.show_message(message, 7.0)

	if counts_toward_foundation_offers:
		_check_foundation_offers(player)

func _try_mark_publish_bundle_witness(player: Node) -> bool:
	if state_meta != "foundation_publish_offer_seen":
		return false
	var root := get_tree().root
	if not bool(root.get_meta("foundation_testament_returned_to_board", false)):
		return false
	if bool(root.get_meta("foundation_publish_bundle_witnessed", false)):
		return false
	root.set_meta("foundation_publish_bundle_witnessed", true)
	if player.has_method("add_journal_objective"):
		player.add_journal_objective(
			"return_publish_bundle_to_evidence_board",
			"Return the proof bundle witness to the Kitchen evidence board."
		)
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			"foundation_publish_bundle_witness",
			"The proof bundle is no longer blank. It has begun to list the things Mara can prove without asking her to send them yet."
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			"foundation_publish_bundle_witness",
			"Foundation Proof Bundle",
			"The bundle accepts the Testament Page as its first attachment. It is becoming a witness packet, not an ending button.",
			"Publish"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			"foundation_publish_bundle_witness",
			"The proof bundle had learned Mara's order of evidence. That was worse than being empty. Empty paper can still be innocent.",
			"2:47 AM - Second Proof"
		)
	if player.has_method("show_message"):
		player.show_message("The proof bundle is ready for the Kitchen board. It is evidence now, not a choice.", 7.0)
	return true

func _try_mark_oil_final_witness(player: Node) -> bool:
	if state_meta != "foundation_oil_offer_seen":
		return false
	var root := get_tree().root
	if not bool(root.get_meta("foundation_publish_bundle_returned_to_board", false)):
		return false
	if bool(root.get_meta("foundation_oil_final_witnessed", false)):
		return false
	root.set_meta("foundation_oil_final_witnessed", true)
	if player.has_method("add_journal_objective"):
		player.add_journal_objective(
			"return_oil_witness_to_evidence_board",
			"Return the oil-can witness to the Kitchen evidence board."
		)
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			"foundation_oil_final_witness",
			"The oil can stops being a temptation when Mara refuses to use it. It becomes proof that the house keeps destruction ready."
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			"foundation_oil_final_witness",
			"Foundation Oil Can Refusal",
			"The full oil can and dry matches prove the destroy route exists, but Mara has not chosen it. Refusal becomes the third publish witness.",
			"Publish"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			"foundation_oil_final_witness",
			"The oil did not need to burn to testify. Mara wrote that down before the room could call restraint cowardice.",
			"2:47 AM - The Third Proof"
		)
	if player.has_method("show_message"):
		player.show_message("The oil can is final proof now, not permission to burn.", 7.0)
	return true

func _can_show_choice_lock() -> bool:
	if ending_choice_id == "none":
		return false
	if state_meta == "":
		return false
	var root := get_tree().root
	if not bool(root.get_meta(state_meta, false)):
		return false
	if bool(root.get_meta("foundation_ending_choice_unlocked", false)):
		return false
	return bool(root.get_meta("foundation_oil_final_returned_to_board", false)) and int(root.get_meta("foundation_publish_meter_count", 0)) >= 3

func _try_show_publish_choice_lock(player: Node) -> bool:
	if not _can_show_choice_lock():
		return false

	var lock_meta := _choice_lock_meta(ending_choice_id)
	if lock_meta == "":
		return false

	var root := get_tree().root
	if bool(root.get_meta(lock_meta, false)):
		if player.has_method("show_message"):
			player.show_message(_choice_lock_repeat_message(ending_choice_id), 6.0)
		return true

	root.set_meta(lock_meta, true)
	if player.has_method("add_journal_note"):
		player.add_journal_note(_choice_lock_note_id(ending_choice_id), _choice_lock_note_text(ending_choice_id))
	if player.has_method("add_evidence"):
		player.add_evidence(
			_choice_lock_note_id(ending_choice_id),
			_choice_lock_title(ending_choice_id),
			_choice_lock_evidence_text(ending_choice_id),
			"Foundation Chamber"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			_choice_lock_note_id(ending_choice_id),
			_choice_lock_ledger_text(ending_choice_id),
			_choice_lock_ledger_timestamp(ending_choice_id)
		)
	if player.has_method("show_message"):
		player.show_message(_choice_lock_message(ending_choice_id), 7.0)

	_check_choice_lock_summary(player)
	return true

func _choice_lock_meta(choice_id: String) -> String:
	match choice_id:
		"serve":
			return "foundation_choice_lock_seen_serve"
		"destroy":
			return "foundation_choice_lock_seen_destroy"
		"publish":
			return "foundation_choice_lock_seen_publish"
	return ""

func _choice_lock_note_id(choice_id: String) -> String:
	match choice_id:
		"serve":
			return "foundation_choice_lock_serve"
		"destroy":
			return "foundation_choice_lock_destroy"
		"publish":
			return "foundation_choice_lock_publish"
	return "foundation_choice_lock_unknown"

func _choice_lock_title(choice_id: String) -> String:
	match choice_id:
		"serve":
			return "Locked Choice: Serve"
		"destroy":
			return "Locked Choice: Destroy"
		"publish":
			return "Locked Choice: Publish"
	return "Locked Choice"

func _choice_lock_message(choice_id: String) -> String:
	match choice_id:
		"serve":
			return "The pen will not write yet. The page waits for authority Mara does not have."
		"destroy":
			return "The oil will not catch. The house keeps destruction ready, but not available."
		"publish":
			return "The proof bundle is complete, but Send is still a blank verb."
	return "The choice refuses to become an ending."

func _choice_lock_repeat_message(choice_id: String) -> String:
	match choice_id:
		"serve":
			return "The pen stays clean. Serving the house is still locked."
		"destroy":
			return "The matches stay dry. Destruction is still locked."
		"publish":
			return "The proof bundle waits. Publishing is still locked."
	return "The ending remains locked."

func _choice_lock_note_text(choice_id: String) -> String:
	match choice_id:
		"serve":
			return "The pen is ready, but it will not mark the page. Service is an ending-shaped object, not a permitted act."
		"destroy":
			return "The oil and matches are prepared, but they refuse to burn. The destroy route exists without being available."
		"publish":
			return "The proof bundle has three witnesses, but no final send command. Evidence is not the same as authority."
	return "The chamber shows a choice that still refuses Mara."

func _choice_lock_evidence_text(choice_id: String) -> String:
	match choice_id:
		"serve":
			return "The writing stand remains usable-looking but inactive after the proof chain completes. The serve ending is visibly present and deliberately locked."
		"destroy":
			return "The oil can and dry matches remain prepared but inactive after the proof chain completes. The destroy ending is visibly present and deliberately locked."
		"publish":
			return "The proof bundle has all three witnesses, but the send affordance remains inactive. The publish ending needs a later authority beat."
	return "The chamber presents an ending affordance without permitting an ending."

func _choice_lock_ledger_text(choice_id: String) -> String:
	match choice_id:
		"serve":
			return "The pen would not move for Mara. It had the politeness of a door held shut from the other side."
		"destroy":
			return "The matches stayed dry and useless in her hand. Even fire had rules in that room."
		"publish":
			return "The proof bundle was complete, which made its silence worse. Send was not a button yet. It was a dare with the word removed."
	return "The choice waited without becoming a choice."

func _choice_lock_ledger_timestamp(choice_id: String) -> String:
	match choice_id:
		"serve":
			return "2:47 AM - The Pen Refuses"
		"destroy":
			return "2:47 AM - The Oil Refuses"
		"publish":
			return "2:47 AM - Send Refuses"
	return "2:47 AM - Not Yet"

func _check_choice_lock_summary(player: Node) -> void:
	var root := get_tree().root
	if bool(root.get_meta("foundation_choice_lock_understood", false)):
		return
	for choice_id in ["serve", "destroy", "publish"]:
		if not bool(root.get_meta(_choice_lock_meta(choice_id), false)):
			return

	root.set_meta("foundation_choice_lock_understood", true)
	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective("test_locked_foundation_choices")
	if player.has_method("add_journal_objective"):
		player.add_journal_objective(
			"find_final_authority_before_ending",
			"Find what gives Mara the right to choose what happens to the house."
		)
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			"foundation_choice_lock_understood",
			"The chamber has three endings, but none will obey until Mara brings back the missing authority."
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			"foundation_choice_lock_understood",
			"Foundation Chamber: Choices Locked",
			"The pen, oil, and proof bundle all refuse action after the publish chain is complete. Proof is ready; authority is missing.",
			"Foundation Chamber"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			"foundation_choice_lock_understood",
			"The chamber showed Mara all three endings and let none of them open. The cruelty was not refusal. The cruelty was timing.",
			"2:47 AM - Not Yet"
		)
	if player.has_method("show_message"):
		player.show_message("The chamber has three endings and none of them are ready to be chosen.", 7.0)

func _check_foundation_offers(player: Node) -> void:
	var root := get_tree().root
	if bool(root.get_meta("foundation_chamber_affordances_seen", false)):
		return

	for meta_name in FOUNDATION_OFFER_METAS:
		if not bool(root.get_meta(meta_name, false)):
			return

	root.set_meta("foundation_chamber_affordances_seen", true)
	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective("understand_foundation_offers")
	if player.has_method("add_journal_objective"):
		player.add_journal_objective(
			"read_foundation_testament_pages",
			"Read what the original book has written before Mara arrived."
		)
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			"foundation_chamber_affordances_seen",
			"Mara has seen the chamber's three offers: write, burn, or witness. The room has not asked her to choose yet."
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			"foundation_chamber_affordances_seen",
			"Foundation Chamber: Three Ways Out",
			"The pen, the oil, and the proof bundle form three endings without becoming endings yet. The original book waits between them.",
			"Foundation Chamber"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			"foundation_chamber_affordances_seen",
			"The chamber was generous in the way a trap can be generous. It offered Mara a pen, a flame, and a witness stand, and let her pretend those were choices.",
			"2:47 AM - Three Ways Out"
		)
	if player.has_method("show_message"):
		player.show_message("The chamber has shown its three offers. Now the book wants to be read.", 7.0)

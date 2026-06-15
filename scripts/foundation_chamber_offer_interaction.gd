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

const FOUNDATION_OFFER_METAS := [
	"foundation_pen_offer_seen",
	"foundation_oil_offer_seen",
	"foundation_publish_offer_seen",
]

func get_prompt(_player: Node) -> String:
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

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

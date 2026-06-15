extends StaticBody3D

const REQUIRED_META := "foundation_chamber_affordances_seen"
const READ_META := "foundation_testament_page_read"
const PUBLISH_SEED_META := "foundation_publish_meter_seeded"


func get_prompt(_player: Node) -> String:
	if bool(get_tree().root.get_meta(READ_META, false)):
		return "E - Re-read testament page"
	return "E - Read testament page"


func interact(player: Node) -> void:
	if not bool(get_tree().root.get_meta(REQUIRED_META, false)):
		player.show_message("The page stays blank until Mara has seen every offer.")
		return

	if bool(get_tree().root.get_meta(READ_META, false)):
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

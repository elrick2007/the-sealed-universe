extends StaticBody3D

const NOTE_ID := "foundation_chamber_threshold"
const CHOICE_NOTE_ID := "foundation_chamber_choices_seeded"
const SOURCE_OBJECTIVE_ID := "inspect_foundation_chamber_threshold"
const NEXT_OBJECTIVE_ID := "inspect_bricked_archway"

func get_prompt(_player: Node) -> String:
	if bool(get_tree().root.get_meta("foundation_chamber_threshold_inspected", false)):
		return "E - Re-check chamber threshold"
	if bool(get_tree().root.get_meta("foundation_threshold_route_seeded", false)):
		return "E - Inspect Foundation threshold"
	return "E - Inspect dark breach"

func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("foundation_threshold_route_seeded", false)):
		if player.has_method("show_message"):
			player.show_message("There is only packed coal and stone until the pillar points Mara beneath it.", 6.0)
		return

	if bool(root.get_meta("foundation_chamber_threshold_inspected", false)):
		if bool(root.get_meta("foundation_chamber_choice_seeded", false)) and not bool(root.get_meta("foundation_chamber_choices_read", false)):
			_seed_foundation_choices(player)
			return
		if player.has_method("show_message"):
			player.show_message("The threshold keeps its silence. The room beyond feels older than the house above it.", 6.0)
		return

	root.set_meta("foundation_chamber_threshold_inspected", true)
	root.set_meta("foundation_chamber_silent_threshold", true)
	root.set_meta("bricked_archway_route_seeded", true)

	if player.has_method("visit_map_area"):
		player.visit_map_area("foundation_chamber")
	if player.has_method("reveal_map_area"):
		player.reveal_map_area("bricked_archway")
	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective(SOURCE_OBJECTIVE_ID)
	if player.has_method("add_journal_objective"):
		player.add_journal_objective(NEXT_OBJECTIVE_ID, "Inspect the bricked archway marked blocked on Caton's cellar plan.")
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			NOTE_ID,
			"The Foundation Chamber threshold is silent. The chamber door will not grant entry; the breach is the only way forward."
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			NOTE_ID,
			"Foundation Threshold: True Silence",
			"The room-tone dies at the breach. Caton's plan warned not to store goods here, but the warning feels older than storage.",
			"Cellar"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			NOTE_ID,
			"The threshold did not breathe. That was worse. Mara had grown used to the house answering back.",
			"2:47 AM - True Silence"
		)
	if player.has_method("show_message"):
		player.show_message("At the breach, the room-tone stops. The Foundation Chamber waits in true silence.", 7.0)

func _seed_foundation_choices(player: Node) -> void:
	var root := get_tree().root
	root.set_meta("foundation_chamber_choices_read", true)

	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective("read_foundation_chamber_choices")
	if player.has_method("add_journal_objective"):
		player.add_journal_objective("find_original_book", "Enter the Foundation Chamber when the house grants the breach.")
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			CHOICE_NOTE_ID,
			"The chamber offers three shapes before Mara can see the room: pen, oil, and proof. None of them feel like keys."
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			"foundation_chamber_choices",
			"Foundation Chamber: Three Offers",
			"At the silent threshold, Mara understands the chamber as three affordances before she sees them: pen, oil, and the weight of proof.",
			"Cellar"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			"foundation_chamber_choices",
			"The silence around the chamber arranged itself into three offers: write, burn, or witness. Mara disliked that each one felt polite.",
			"2:47 AM - Three Offers"
		)
	if player.has_method("show_message"):
		player.show_message("In the silence, three offers take shape before Mara can see them: pen, oil, proof.", 8.0)

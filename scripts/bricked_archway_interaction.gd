extends StaticBody3D

const NOTE_ID := "bricked_archway_loose_brick"
const SOURCE_OBJECTIVE_ID := "inspect_bricked_archway"
const NEXT_OBJECTIVE_ID := "record_bricked_archway"

func get_prompt(_player: Node) -> String:
	if bool(get_tree().root.get_meta("bricked_archway_loose_brick_read", false)):
		return "E - Re-check loose brick"
	if bool(get_tree().root.get_meta("bricked_archway_route_seeded", false)):
		return "E - Inspect bricked archway"
	return "E - Inspect blocked arch"

func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("bricked_archway_route_seeded", false)):
		if player.has_method("show_message"):
			player.show_message("The blocked archway is just masonry until the Foundation threshold admits its silence.", 6.0)
		return

	if bool(root.get_meta("bricked_archway_loose_brick_read", false)):
		if player.has_method("show_message"):
			player.show_message("The loose brick opens onto nothing. The archway keeps the far side filed under later.", 6.0)
		return

	root.set_meta("bricked_archway_loose_brick_read", true)
	root.set_meta("bricked_archway_permanent_wall", true)
	root.set_meta("bricked_archway_recorder_route_seeded", true)

	if player.has_method("visit_map_area"):
		player.visit_map_area("bricked_archway")
	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective(SOURCE_OBJECTIVE_ID)
	if player.has_method("add_journal_objective"):
		player.add_journal_objective(NEXT_OBJECTIVE_ID, "Use the recorder on the bricked archway.")
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			NOTE_ID,
			"One brick pulls loose from the blocked archway. Light enters the gap and does not come back."
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			NOTE_ID,
			"Bricked Archway: Loose Brick",
			"The blocked arch is newer than the surrounding stone. The hole behind the loose brick returns no light and no draught.",
			"Cellar"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			NOTE_ID,
			"Mara pulled one brick free and found no other side. Some walls do not hide rooms. Some walls are decisions.",
			"2:47 AM - Filed Under Later"
		)
	if player.has_method("show_message"):
		player.show_message("The loose brick comes free. The gap behind it refuses the lamp.", 7.0)

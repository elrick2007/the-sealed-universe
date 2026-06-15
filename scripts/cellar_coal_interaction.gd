extends StaticBody3D

const NOTE_ID := "foundation_chamber_found"
const SOURCE_OBJECTIVE_ID := "find_foundation_chamber"
const NEXT_OBJECTIVE_ID := "inspect_foundation_chamber_threshold"

func get_prompt(_player: Node) -> String:
	if bool(get_tree().root.get_meta("foundation_chamber_found", false)):
		return "E - Re-check coal opening"
	if bool(get_tree().root.get_meta("foundation_chamber_route_seeded", false)):
		return "E - Clear coal below Caton"
	return "E - Inspect coal seam"

func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("foundation_chamber_route_seeded", false)):
		if player.has_method("show_message"):
			player.show_message("The coal is cold rubble until the pillar gives it a direction.", 6.0)
		return

	if bool(root.get_meta("foundation_chamber_found", false)):
		if player.has_method("show_message"):
			player.show_message("The coal stays parted. The Foundation Chamber has already admitted it is there.", 6.0)
		return

	root.set_meta("coal_below_caton_cleared", true)
	root.set_meta("foundation_chamber_found", true)
	root.set_meta("foundation_chamber_unlocked", true)
	root.set_meta("foundation_threshold_route_seeded", true)

	if player.has_method("visit_map_area"):
		player.visit_map_area("foundation_chamber")
	if player.has_method("reveal_map_area"):
		player.reveal_map_area("foundation_chamber")
	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective(SOURCE_OBJECTIVE_ID)
	if player.has_method("add_journal_objective"):
		player.add_journal_objective(NEXT_OBJECTIVE_ID, "Inspect the Foundation Chamber threshold behind the coal.")
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			NOTE_ID,
			"Below Caton's new mark, the coal gives way to a bricked Foundation Chamber entrance."
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			NOTE_ID,
			"Coal Below Caton: Foundation Chamber",
			"The pillar's witness mark points below the coal, to a chamber the cellar plan warned against using.",
			"Cellar"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			NOTE_ID,
			"Mara cleared the coal by hand. Behind it, the foundation did not look older than the house. It looked patient.",
			"2:47 AM - Behind the Coal"
		)
	if player.has_method("show_message"):
		player.show_message("The coal shifts below Caton's mark. Behind it, the Foundation Chamber waits.", 7.0)

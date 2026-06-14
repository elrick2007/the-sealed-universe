extends StaticBody3D

const NOTE_ID := "caton_pillar_found"
const SOURCE_OBJECTIVE_ID := "find_caton_pillar_below_filing_voice"
const NEXT_OBJECTIVE_ID := "find_chisel_for_caton_pillar"

func get_prompt(_player: Node) -> String:
	if bool(get_tree().root.get_meta("caton_pillar_found", false)):
		return "E - Re-read Caton Pillar"
	if bool(get_tree().root.get_meta("caton_pillar_route_seeded", false)):
		return "E - Inspect Caton Pillar"
	return "E - Inspect cellar pillar"

func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("caton_pillar_route_seeded", false)):
		if player.has_method("show_message"):
			player.show_message("The cellar pillar is only damp stone until the filing voice points Mara below.", 6.0)
		return

	if bool(root.get_meta("caton_pillar_found", false)):
		if player.has_method("show_message"):
			player.show_message("The Caton Pillar still has one clean place waiting for a name.", 6.0)
		return

	root.set_meta("caton_pillar_found", true)
	root.set_meta("cellar_plan_unlocked", true)
	root.set_meta("caton_pillar_initials_read", true)
	root.set_meta("caton_pillar_chisel_route_seeded", true)

	if player.has_method("unlock_map_floor"):
		player.unlock_map_floor("cellar")
	if player.has_method("visit_map_area"):
		player.visit_map_area("cellar_stairs")
	if player.has_method("reveal_map_area"):
		player.reveal_map_area("cellar_stairs")
	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective(SOURCE_OBJECTIVE_ID)
	if player.has_method("add_journal_objective"):
		player.add_journal_objective(NEXT_OBJECTIVE_ID, "Find the chisel that belongs to the Caton Pillar.")
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			NOTE_ID,
			"The Caton Pillar carries forty-seven sets of keeper initials. One fresh line waits without a name."
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			NOTE_ID,
			"Caton Pillar: Forty-Seven Initials",
			"The cellar pillar confirms Caton's survey was not only paperwork. The house kept its witnesses in stone.",
			"Cellar"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			NOTE_ID,
			"Caton put his truth where paper could not burn. Forty-seven hands had signed the pillar before Mara found the space left for hers.",
			"2:47 AM - Stone Ledger"
		)
	if player.has_method("show_message"):
		player.show_message("The Caton Pillar is carved with forty-seven sets of initials. One line is empty.", 7.0)

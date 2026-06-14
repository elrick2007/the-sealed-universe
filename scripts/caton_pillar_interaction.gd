extends StaticBody3D

const NOTE_ID := "caton_pillar_found"
const SOURCE_OBJECTIVE_ID := "find_caton_pillar_below_filing_voice"
const NEXT_OBJECTIVE_ID := "find_chisel_for_caton_pillar"
const CONSENT_NOTE_ID := "caton_pillar_consent_mark"

func get_prompt(_player: Node) -> String:
	if bool(get_tree().root.get_meta("caton_pillar_consent_marked", false)):
		return "E - Read new pillar mark"
	if bool(get_tree().root.get_meta("caton_chisel_found", false)):
		return "E - Mark Caton Pillar"
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
		if bool(root.get_meta("caton_pillar_consent_marked", false)):
			if player.has_method("show_message"):
				player.show_message("Mara's mark is not her name. The house has accepted the difference for now.", 6.0)
			return
		if player.has_method("has_item") and player.has_item("caton_chisel"):
			_mark_pillar(player)
			return
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

func _mark_pillar(player: Node) -> void:
	var root := get_tree().root
	root.set_meta("caton_pillar_consent_marked", true)
	root.set_meta("caton_pillar_consent_route_seeded", true)
	root.set_meta("foundation_chamber_route_seeded", true)

	if player.has_method("remove_inventory_item"):
		player.remove_inventory_item("caton_chisel")
	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective("mark_caton_pillar")
	if player.has_method("add_journal_objective"):
		player.add_journal_objective("find_foundation_chamber", "Find where the pillar's new mark points below the coal.")
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			CONSENT_NOTE_ID,
			"Mara does not carve her name. She carves one short witness-mark beside the forty-seven keepers."
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			CONSENT_NOTE_ID,
			"Caton Pillar: New Witness Mark",
			"The fresh mark is not a signature. It is a refusal to be filed without being witnessed.",
			"Cellar"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			CONSENT_NOTE_ID,
			"Mara used the chisel once. The sound was small, but the pillar answered through the coal beneath the house.",
			"2:47 AM - Consent in Stone"
		)
	if player.has_method("show_message"):
		player.show_message("Mara carves a witness-mark, not a name. Somewhere below, coal shifts.", 7.0)

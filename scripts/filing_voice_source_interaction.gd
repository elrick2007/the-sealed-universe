extends StaticBody3D

const NOTE_ID := "filing_voice_source_found"
const SOURCE_OBJECTIVE_ID := "trace_filing_voice_source"
const NEXT_OBJECTIVE_ID := "find_caton_pillar_below_filing_voice"

func get_prompt(_player: Node) -> String:
	if bool(get_tree().root.get_meta("filing_voice_source_found", false)):
		return "E - Re-read filing shelf"
	if bool(get_tree().root.get_meta("attic_void_recording_pinned", false)):
		return "E - Trace filing voice"
	return "E - Inspect filing shelf"

func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("attic_void_recording_pinned", false)):
		if player.has_method("show_message"):
			player.show_message("The shelf is only warped timber until the void recording has somewhere to answer from.", 6.0)
		return

	if bool(root.get_meta("filing_voice_source_found", false)):
		if player.has_method("show_message"):
			player.show_message("The label drawer still reads CATON / LIVING / BELOW. It has no drawer for dead things.", 6.0)
		return

	root.set_meta("filing_voice_source_found", true)
	root.set_meta("cellar_route_seeded", true)
	root.set_meta("caton_pillar_route_seeded", true)

	if player.has_method("visit_map_area"):
		player.visit_map_area("long_attic")
	if player.has_method("reveal_map_area"):
		player.reveal_map_area("long_attic")
		player.reveal_map_area("cellar_stairs")
	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective(SOURCE_OBJECTIVE_ID)
	if player.has_method("add_journal_objective"):
		player.add_journal_objective(NEXT_OBJECTIVE_ID, "Find the Caton Pillar below the filing voice.")
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			NOTE_ID,
			"The filing voice answers from a shelf that should be too high in the house. Its label drawer reads: CATON / LIVING / BELOW."
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			NOTE_ID,
			"Attic Filing Shelf: Caton / Living / Below",
			"The filed-alive recording points to a labelled attic drawer that sends Mara downward toward Caton's pillar.",
			"Attic"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			NOTE_ID,
			"The shelf did not contain papers. It contained headings. CATON. LIVING. BELOW. Mara copied them because the house had already copied her.",
			"2:47 AM - Filed Under Living"
		)
	if player.has_method("show_message"):
		player.show_message("The shelf answers the recording: CATON / LIVING / BELOW.", 7.0)

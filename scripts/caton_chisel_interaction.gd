extends StaticBody3D

const ITEM_ID := "caton_chisel"
const OBJECTIVE_ID := "find_chisel_for_caton_pillar"
const NOTE_ID := "caton_chisel_found"

func get_prompt(_player: Node) -> String:
	if bool(get_tree().root.get_meta("caton_chisel_found", false)):
		return "E - Re-check chisel mark"
	if bool(get_tree().root.get_meta("caton_pillar_chisel_route_seeded", false)):
		return "E - Take Caton's chisel"
	return "E - Inspect chisel"

func interact(player: Node) -> void:
	var root := get_tree().root
	if bool(root.get_meta("caton_chisel_found", false)):
		if player.has_method("show_message"):
			player.show_message("Only the clean outline of Caton's chisel remains in the dust.", 6.0)
		return

	if not bool(root.get_meta("caton_pillar_chisel_route_seeded", false)):
		if player.has_method("show_message"):
			player.show_message("The chisel is ordinary until the pillar asks what it is for.", 6.0)
		return

	root.set_meta("caton_chisel_found", true)
	root.set_meta("caton_consent_mark_ready", true)

	if player.has_method("add_inventory_item"):
		player.add_inventory_item(
			ITEM_ID,
			"Caton's Chisel",
			"A stone chisel wrapped in oilcloth. It belongs to the empty line on the Caton Pillar."
		)
	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective(OBJECTIVE_ID)
	if player.has_method("add_journal_objective"):
		player.add_journal_objective("mark_caton_pillar", "Use Caton's chisel on the empty line of the Caton Pillar.")
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			NOTE_ID,
			"Caton's chisel was left near the cellar wall, wrapped as if returning it would have been rude."
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			NOTE_ID,
			"Caton's Chisel",
			"The tool that made the keeper initials is still in the cellar. Its handle is clean where a hand keeps finding it.",
			"Cellar"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			NOTE_ID,
			"The chisel had no rust on the blade. Someone had either used it recently, or the house had been keeping it ready.",
			"2:47 AM - The Tool Kept Sharp"
		)
	if player.has_method("show_message"):
		player.show_message("Mara takes Caton's chisel. The empty line on the pillar feels less empty.", 7.0)

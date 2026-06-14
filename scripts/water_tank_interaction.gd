extends StaticBody3D

const NOTE_ID := "water_tank_soldered_tin"
const MARBLE_OBJECTIVE_ID := "find_not_glass_marble"
const MIRROR_OBJECTIVE_ID := "open_mirror_chest"

func get_prompt(_player: Node) -> String:
	if bool(get_tree().root.get_meta("not_glass_marble_found", false)):
		return "E - Re-check drained water tank"
	if bool(get_tree().root.get_meta("sick_room_contradiction_resolved", false)):
		return "E - Drain water tank"
	return "E - Inspect water tank"

func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("sick_room_contradiction_resolved", false)):
		if player.has_method("show_message"):
			player.show_message("The tank knocks softly through the pipes, but Mara does not yet know which room it is answering.", 6.0)
		return

	if bool(root.get_meta("not_glass_marble_found", false)):
		if player.has_method("show_message"):
			player.show_message("The tank is lower now. The soldered tin has already given up its wrong little marble.", 6.0)
		return

	root.set_meta("water_tank_drained", true)
	root.set_meta("marble_bag_found", true)
	root.set_meta("not_glass_marble_found", true)
	root.set_meta("mirror_chest_route_seeded", true)

	if player.has_method("visit_map_area"):
		player.visit_map_area("water_tank_room")
	if player.has_method("reveal_map_area"):
		player.reveal_map_area("water_tank_room")
	if player.has_method("add_inventory_item"):
		player.add_inventory_item(
			"not_glass_marble",
			"Not-Glass Marble",
			"One marble from the drowned bag is too heavy, too warm, and not glass."
		)
	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective(MARBLE_OBJECTIVE_ID)
	if player.has_method("add_journal_objective"):
		player.add_journal_objective(MIRROR_OBJECTIVE_ID, "Use the not-glass marble on the north Sick Room chest.")
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			NOTE_ID,
			"The Water Tank hides a soldered tin. Inside it is a bag of marbles, and one of them is pretending badly."
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			NOTE_ID,
			"Water Tank Tin: Not-Glass Marble",
			"The drained tank reveals a soldered tin and a marble bag. One marble is warm and heavy enough to be a key.",
			"Attic"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			NOTE_ID,
			"The tank lowered by inches, not gallons. At the bottom waited a tin that had been soldered shut by someone who did not trust locks.",
			"2:47 AM - The Drowned Tin"
		)
	if player.has_method("show_message"):
		player.show_message("The tank gives up a soldered tin. Inside: a marble that is not glass.", 7.0)

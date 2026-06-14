extends StaticBody3D


func get_prompt(_player: Node) -> String:
	if bool(get_tree().root.get_meta("housekeeper_sewing_box_opened", false)):
		return "E - Re-check sewing box"
	if bool(get_tree().root.get_meta("housekeeper_unnumbered_record_found", false)):
		return "E - Open sewing box"
	return "E - Inspect sewing box"


func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("housekeeper_unnumbered_record_found", false)):
		player.show_message("The sewing box lid has three thread dials. Mara does not yet know whose routine opens it.", 7.0)
		return
	if bool(root.get_meta("housekeeper_sewing_box_opened", false)):
		player.show_message("The sewing box is open. The empty thread dials still point at Guest Bedroom I, Guest Bedroom II, and no number at all.", 8.0)
		return

	root.set_meta("housekeeper_sewing_box_opened", true)
	player.complete_journal_objective("find_housekeeper_sewing_box")
	player.add_inventory_item(
		"chatelaine",
		"Housekeeper's Chatelaine",
		"A heavy ring of domestic keys. It should open servant-side cupboards, presses, and the attic stair door."
	)
	player.add_inventory_item(
		"clock_pendulum",
		"Clock Pendulum",
		"Wrapped in cloth with Mrs. H.'s note: Stopped the hall clock myself. It kept time we do not keep."
	)
	player.add_journal_note(
		"housekeeper_sewing_box_opened",
		"The sewing box opened on the unnumbered-room pattern. Inside were the Housekeeper's chatelaine and the missing hall-clock pendulum."
	)
	player.add_evidence(
		"housekeeper_sewing_box_opened",
		"Housekeeper's Sewing Box",
		"The sewing box uses the missing room as its cipher and yields the chatelaine plus the stopped clock pendulum.",
		"First Floor"
	)
	player.add_ledger_entry(
		"housekeeper_sewing_box_opened",
		"The box opened when Mara counted the room the house refused to count. The keys sounded ordinary in her hand. The pendulum did not.",
		"2:47 AM - The Box Counts Thirteen"
	)
	player.add_journal_objective("return_clock_pendulum", "Return the pendulum to the hall clock and see what time the house keeps.")
	player.add_journal_objective("find_attic_stair_door", "Use the chatelaine to find the attic stair door.")
	player.show_message("The sewing box opens. Keys. A wrapped pendulum. Mrs. H. stopped more than a clock.", 8.0)

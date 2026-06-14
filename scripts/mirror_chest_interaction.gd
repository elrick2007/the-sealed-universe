extends StaticBody3D

@export_enum("north", "south") var chest_side := "north"

const NOTE_ID := "caton_field_book_found"
const OBJECTIVE_ID := "open_mirror_chest"
const NEXT_OBJECTIVE_ID := "use_caton_field_book"

func get_prompt(_player: Node) -> String:
	if bool(get_tree().root.get_meta("caton_field_book_found", false)):
		return "E - Re-check mirror chest"
	if chest_side == "north":
		return "E - Open north mirror chest"
	return "E - Inspect south mirror chest"

func interact(player: Node) -> void:
	var root := get_tree().root
	if bool(root.get_meta("caton_field_book_found", false)):
		player.show_message("The south chest remains open. Caton's Field Book has already been taken.", 6.0)
		return

	if chest_side == "south":
		player.show_message("The south chest is rusted shut. Its twin seems to be the one that still believes in keys.", 6.0)
		return

	if not bool(root.get_meta("mirror_chest_route_seeded", false)):
		player.show_message("The north chest has a round socket in its lock. Something is missing from the argument.", 6.0)
		return

	if not player.has_item("not_glass_marble"):
		player.show_message("The chest wants the warm marble from the water tank, not a key.", 6.0)
		return

	root.set_meta("mirror_chest_unlocked", true)
	root.set_meta("north_mirror_chest_opened", true)
	root.set_meta("south_mirror_chest_opened", true)
	root.set_meta("caton_field_book_found", true)
	root.set_meta("caton_overlay_unlocked", true)
	root.set_meta("measurement_overlay_unlocked", true)

	player.remove_inventory_item("not_glass_marble")
	player.add_inventory_item("caton_field_book", "Caton's Field Book", "Submitted figures beside true figures; the house lied in two columns.")
	player.complete_journal_objective(OBJECTIVE_ID)
	player.add_journal_objective(NEXT_OBJECTIVE_ID, "Use Caton's Field Book with the tape measure to compare the manor's true dimensions.")
	player.add_journal_note(NOTE_ID, "The north Sick Room chest accepts the not-glass marble. Its southern twin opens instead, revealing Caton's Field Book.")
	player.add_evidence(NOTE_ID, "Caton's Field Book", "Surveyor Caton recorded submitted dimensions beside true ones. The house's plans are not mistakes; they are compromises.", "Attic")
	player.add_ledger_entry(NOTE_ID, "The marble clicked in the north chest, but the sound came from the south room. Caton had written the same corridor twice and trusted neither version.", "2:47 AM - Caton's Figures")
	player.visit_map_area("servants_sick_rooms")
	player.reveal_map_area("servants_sick_rooms")
	_show_field_book_visual()
	player.show_message("The north chest accepts the marble. In the south Sick Room, its twin opens with Caton's Field Book inside.", 7.0)

func _show_field_book_visual() -> void:
	var book := get_node_or_null("/root/Main/Architecture/Attic/LongAttic/SickRooms/SouthSickRoom/SouthMirrorChest/CatonFieldBook")
	if book:
		book.visible = true

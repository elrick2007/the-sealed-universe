extends StaticBody3D

var inspected := false


func get_prompt(player: Node) -> String:
	var root := get_tree().root
	if not bool(root.get_meta("chandelier_handprint_photographed", false)):
		return "E - Inspect unnumbered door"
	if bool(root.get_meta("unnumbered_page_trade_complete", false)):
		return "E - Read altered fragment"
	if bool(root.get_meta("unnumbered_page_trade_armed", false)):
		return "E - Check unnumbered bed"
	if inspected or bool(root.get_meta("unnumbered_guest_room_found", false)):
		if player.has_method("has_item") and player.has_item("burnt_page_fragment"):
			return "E - Leave burnt page"
		return "E - Re-read guest book"
	return "E - Enter unnumbered room"


func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("chandelier_handprint_photographed", false)):
		player.show_message("The door has no number. The handle stays still until Mara has proof the house touched the chandelier.", 6.0)
		return
	if not inspected and not bool(root.get_meta("unnumbered_guest_room_found", false)):
		_discover_room(player, root)
		return

	if bool(root.get_meta("unnumbered_page_trade_complete", false)):
		player.complete_journal_objective("read_altered_fragment")
		player.add_journal_note(
			"altered_fragment_read",
			"The altered fragment now gives a partial name: ASHFORD, E. The guest book's blank line feels less empty."
		)
		player.add_ledger_entry(
			"altered_fragment_read",
			"Mara compared the corrected fragment with the guest book. The room had not changed the past. It had returned one name to the page.",
			"2:47 AM - A Name Comes Back"
		)
		player.show_message("The altered fragment names only enough to hurt: ASHFORD, E. The guest book still refuses the rest.", 8.0)
		return
	if bool(root.get_meta("unnumbered_page_trade_armed", false)):
		player.show_message("The burnt fragment is under the sheet. The bed will not give anything back before 2:47.", 7.0)
		return
	if player.has_method("has_item") and player.has_item("burnt_page_fragment"):
		_offer_burnt_fragment(player, root)
		return

	player.show_message("The guest book is open to a blank line. The bed looks ready to exchange something while Mara sleeps.", 7.0)


func _discover_room(player: Node, root: Window) -> void:
	inspected = true
	root.set_meta("unnumbered_guest_room_found", true)
	root.set_meta("unnumbered_room_trade_seeded", true)

	if player.has_method("visit_map_area"):
		player.visit_map_area("unnumbered_guest_room")
	if player.has_method("reveal_map_area"):
		player.reveal_map_area("unnumbered_guest_room")
	player.complete_journal_objective("find_unnumbered_guest_room")
	player.add_journal_note(
		"unnumbered_guest_room",
		"The guest bedroom has no number, no bell label, and a guest book waiting on a blank line."
	)
	player.add_ledger_entry(
		"unnumbered_guest_room",
		"Mara entered the guest room no household record admitted. The water in the ewer was fresh. The bed was turned down for someone who had already arrived.",
		"2:47 AM - The Room Without A Number"
	)
	player.add_evidence(
		"unnumbered_guest_room",
		"Unnumbered Guest Room",
		"The first-floor guest room is maintained, but missing from the numbered household records.",
		"Room"
	)
	player.add_journal_objective("test_unnumbered_bed_trade", "Find what the unnumbered room will trade overnight.")
	player.show_message("The guest book waits on a blank line. The bed is made for a trade Mara has not agreed to.", 8.0)


func _offer_burnt_fragment(player: Node, root: Window) -> void:
	root.set_meta("unnumbered_page_trade_armed", true)
	root.set_meta("next_247_trade_id", "burnt_page_fragment")
	player.remove_inventory_item("burnt_page_fragment")
	player.complete_journal_objective("test_unnumbered_bed_trade")
	player.complete_journal_objective("bring_fragment_to_unnumbered_bed")
	player.add_journal_note(
		"unnumbered_trade_offered",
		"Mara left the burnt black-book fragment on the unnumbered bed. The sheet settled around it before her hand was clear."
	)
	player.add_ledger_entry(
		"unnumbered_trade_offered",
		"Mara left the burned page on the bed that had no room number. The sheet folded over it by itself, neat as a nurse.",
		"2:47 AM - The Bed Accepts"
	)
	player.add_journal_objective("wait_247_bed_trade", "Wait for 2:47 and see what the unnumbered bed gives back.")
	player.show_message("Mara leaves the burnt fragment on the bed. The sheet settles around it before her hand is clear.", 8.0)

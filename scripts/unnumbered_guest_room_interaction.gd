extends StaticBody3D

var inspected := false


func get_prompt(_player: Node) -> String:
	if not bool(get_tree().root.get_meta("chandelier_handprint_photographed", false)):
		return "E - Inspect unnumbered door"
	if inspected or bool(get_tree().root.get_meta("unnumbered_guest_room_found", false)):
		return "E - Re-read guest book"
	return "E - Enter unnumbered room"


func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("chandelier_handprint_photographed", false)):
		player.show_message("The door has no number. The handle stays still until Mara has proof the house touched the chandelier.", 6.0)
		return
	if inspected or bool(root.get_meta("unnumbered_guest_room_found", false)):
		player.show_message("The guest book is open to a blank line. The bed looks ready to exchange something while Mara sleeps.", 7.0)
		return

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

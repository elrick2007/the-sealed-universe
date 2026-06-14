extends StaticBody3D


func get_prompt(_player: Node) -> String:
	if bool(get_tree().root.get_meta("housekeeper_unnumbered_record_found", false)):
		return "E - Re-read folded record"
	if bool(get_tree().root.get_meta("altered_fragment_compared", false)):
		return "E - Read folded record"
	return "E - Inspect folded record"


func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("altered_fragment_compared", false)):
		player.show_message("The folded record is only a laundry mark until Mara compares the returned page with the blank guest-book line.", 7.0)
		return
	if bool(root.get_meta("housekeeper_unnumbered_record_found", false)):
		player.show_message("The folded record names the routine: keep the room made, keep it unnumbered, and do not ask who sleeps there.", 7.0)
		return

	root.set_meta("housekeeper_unnumbered_record_found", true)
	player.complete_journal_objective("follow_guest_book_thread")
	player.add_journal_note(
		"housekeeper_unnumbered_record",
		"The Housekeeper's folded record lists Guest Bedroom I, Guest Bedroom II, and one room marked: keep made; do not number."
	)
	player.add_evidence(
		"housekeeper_unnumbered_record",
		"Housekeeper's Unnumbered Room Record",
		"A folded household record confirms the missing guest room was maintained on purpose, not forgotten.",
		"First Floor"
	)
	player.add_ledger_entry(
		"housekeeper_unnumbered_record",
		"The housekeeper kept the room made and unnamed. A servant can erase a person by obeying an instruction perfectly.",
		"2:47 AM - Kept And Unnumbered"
	)
	player.add_journal_objective("find_housekeeper_sewing_box", "Find the Housekeeper's sewing box on the First Floor.")
	player.show_message("The record is plain enough to be cruel: keep the room made; do not number.", 8.0)

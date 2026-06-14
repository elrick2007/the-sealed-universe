extends StaticBody3D

const NOTE_ID := "long_attic_blank_bell_wire"

var traced := false

func get_prompt(_player: Node) -> String:
	if bool(get_tree().root.get_meta("long_attic_wire_traced", false)):
		return "E - Re-read blank bell wire"
	return "E - Trace blank bell wire"

func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("attic_route_stub_open", false)):
		if player.has_method("show_message"):
			player.show_message("The attic is still only a locked breath above the Housekeeper's room.", 6.0)
		return
	if traced or bool(root.get_meta("long_attic_wire_traced", false)):
		if player.has_method("show_message"):
			player.show_message("The blank bell wire disappears into two sick-room walls. One room should not be here twice.", 7.0)
		return

	traced = true
	root.set_meta("long_attic_wire_traced", true)
	root.set_meta("duplicated_sick_room_route_seeded", true)
	root.set_meta("current_act", 3)

	if player.has_method("visit_map_area"):
		player.visit_map_area("long_attic")
	if player.has_method("reveal_map_area"):
		player.reveal_map_area("long_attic")
		player.reveal_map_area("servants_sick_rooms")
	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective("trace_blank_bell_wire")
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			NOTE_ID,
			"The Long Attic bell board has one blank label. Its wire runs left, then right, and both directions claim the Servant's Sick Room."
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			NOTE_ID,
			"The attic did not begin with a room. It began with a wire no servant had named. Mara followed it until it divided, and both ends led to the same sickbed.",
			"2:47 AM - The Blank Bell"
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			NOTE_ID,
			"Blank Bell Wire",
			"The unlabelled bell wire splits toward two identically named Servant's Sick Rooms.",
			"Attic"
		)
	if player.has_method("add_journal_objective"):
		player.add_journal_objective("compare_servants_sick_rooms", "Compare the two Servant's Sick Rooms in the attic.")
	if player.has_method("show_message"):
		player.show_message("The blank bell wire divides. Both ends say Sick Room.", 7.0)

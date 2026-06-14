extends StaticBody3D

@export_enum("north", "south") var room_side := "north"

const NORTH_ID := "sick_room_north_chart"
const SOUTH_ID := "sick_room_south_chart"
const CONTRADICTION_ID := "ada_sick_room_contradiction"

func get_prompt(_player: Node) -> String:
	if room_side == "south":
		if bool(get_tree().root.get_meta("sick_room_south_chart_read", false)):
			return "E - Re-read south fever chart"
		return "E - Read south fever chart"
	if bool(get_tree().root.get_meta("sick_room_north_chart_read", false)):
		return "E - Re-read north fever chart"
	return "E - Read north fever chart"

func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("duplicated_sick_room_route_seeded", false)):
		if player.has_method("show_message"):
			player.show_message("The sick-room doors are only black rectangles until the blank bell wire is traced.", 6.0)
		return

	var side_meta := "sick_room_%s_chart_read" % room_side
	if bool(root.get_meta(side_meta, false)):
		if player.has_method("show_message"):
			player.show_message(_repeat_message(), 6.0)
		return

	root.set_meta(side_meta, true)
	root.set_meta("sick_rooms_visited", true)

	if player.has_method("visit_map_area"):
		player.visit_map_area("servants_sick_rooms")
	if player.has_method("reveal_map_area"):
		player.reveal_map_area("servants_sick_rooms")
	if player.has_method("add_journal_note"):
		player.add_journal_note(_note_id(), _note_text())
	if player.has_method("add_evidence"):
		player.add_evidence(_note_id(), _evidence_title(), _evidence_detail(), "Attic")
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(_note_id(), _ledger_text(), _ledger_title())
	if player.has_method("show_message"):
		player.show_message(_first_message(), 7.0)

	_try_resolve_contradiction(player)

func _try_resolve_contradiction(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("sick_room_north_chart_read", false)):
		return
	if not bool(root.get_meta("sick_room_south_chart_read", false)):
		return
	if bool(root.get_meta("sick_room_contradiction_resolved", false)):
		return

	root.set_meta("sick_room_contradiction_resolved", true)
	root.set_meta("caton_field_book_route_seeded", true)
	root.set_meta("current_act", 3)

	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective("compare_servants_sick_rooms")
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			CONTRADICTION_ID,
			"Ada P. recovered in one Servant's Sick Room and died at 2:47 in the other. The house kept the version nobody witnessed."
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			CONTRADICTION_ID,
			"Contradiction: Ada's Two Fever Charts",
			"Two charts name the same maid and the same illness. One discharges her on 22 March; the other files her death at 2:47 on the 29th.",
			"Contradiction"
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			CONTRADICTION_ID,
			"Ada lived in one room and died in the other. Mara pinned both charts because the house had finally made paperwork out of a murder it did not need to commit.",
			"2:47 AM - Both Adas"
		)
	if player.has_method("add_journal_objective"):
		player.add_journal_objective("find_not_glass_marble", "Find the not-glass marble that opens the north sick-room chest.")
	if player.has_method("show_message"):
		player.show_message("Both fever charts name Ada. One lets her leave. One files her at 2:47.", 8.0)

func _note_id() -> String:
	if room_side == "south":
		return SOUTH_ID
	return NORTH_ID

func _note_text() -> String:
	if room_side == "south":
		return "The south Sick Room's fever chart keeps Ada P. past recovery and ends with: deceased 2:47, the 29th."
	return "The north Sick Room's fever chart discharges Ada P. on 22 March 1893. In this room, she recovered."

func _evidence_title() -> String:
	if room_side == "south":
		return "South Fever Chart: Ada Deceased"
	return "North Fever Chart: Ada Recovered"

func _evidence_detail() -> String:
	if room_side == "south":
		return "The mirrored south chart keeps Ada P. in bed until a death line at 2:47 on the 29th."
	return "The north chart records Ada P. leaving the Sick Room and resuming duties on 22 March 1893."

func _ledger_title() -> String:
	if room_side == "south":
		return "2:47 AM - The Copy"
	return "2:47 AM - The Mercy"

func _ledger_text() -> String:
	if room_side == "south":
		return "The second sick room had copied the bed, the washstand, the shutter, and the patient. It had not copied mercy."
	return "The first sick room was small, whitewashed, and almost kind. Ada's chart let the fever leave her name."

func _first_message() -> String:
	if room_side == "south":
		return "South chart: Ada P., deceased 2:47, the 29th."
	return "North chart: Ada P., resumed duties 22 March."

func _repeat_message() -> String:
	if room_side == "south":
		return "The south chart still ends at 2:47. It has no discharge line."
	return "The north chart still lets Ada leave the room alive."

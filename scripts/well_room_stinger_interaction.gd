extends StaticBody3D

const REQUIRED_STATE := "book1_canon_ending_complete"
const STINGER_STATE := "well_room_book2_stinger_complete"
const OBJECTIVE_ID := "follow_well_room_after_send"
const NOTE_ID := "well_room_book2_stinger"
const EVIDENCE_ID := "well_room_jar_list"
const LEDGER_ID := "well_room_book2_stinger"


func get_prompt(_player: Node) -> String:
	if bool(get_tree().root.get_meta(STINGER_STATE, false)):
		return "E - Read jar list"
	if not bool(get_tree().root.get_meta(REQUIRED_STATE, false)):
		return "E - Listen at well"
	return "E - Lower recorder"


func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta(REQUIRED_STATE, false)):
		player.show_message("The well is only water until the final record is sent.", 6.0)
		return
	if bool(root.get_meta(STINGER_STATE, false)):
		player.show_message("The jar list stays dry. House. Tent. Tower. Ship. Tree. The moth around the mountain is older than the ink.", 7.0)
		return

	root.set_meta(STINGER_STATE, true)
	root.set_meta("well_room_network_recorded", true)
	root.set_meta("well_room_jar_list_found", true)
	root.set_meta("book2_stinger_seeded", true)
	root.set_meta("anthology_bridge_seeded", true)

	player.complete_journal_objective(OBJECTIVE_ID)
	player.add_journal_note(
		NOTE_ID,
		"The Well Room recording carries voices from places Mara has never visited. The jar list names symbols instead of answers: house, tent, tower, ship, tree, and an older moth around a mountain."
	)
	player.add_evidence(
		EVIDENCE_ID,
		"Well Room Jar List",
		"A sealed preserving jar rises from the well with a dry list of five circled symbols and one older uncircled moth-and-mountain mark. The recorder catches: The sun returns. We return to see it.",
		"Well Room"
	)
	player.add_ledger_entry(
		LEDGER_ID,
		"The well did not end below the house. It reached outward. Mara brought up a jar, a list, and a sentence that did not belong to Ashford: The sun returns. We return to see it.",
		"2:47 AM - Water Under Ink"
	)
	player.show_message("The recorder comes back wet with voices: The sun returns. We return to see it.", 8.0)

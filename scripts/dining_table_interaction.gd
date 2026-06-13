extends StaticBody3D

var inspected := false

func get_prompt(_player: Node) -> String:
	return "E - Inspect dining table"

func interact(player: Node) -> void:
	if inspected:
		player.show_message("The table has already given up its first secret.")
		return
	inspected = true
	player.complete_journal_objective("inspect_dining_table")
	player.add_journal_note("dining_table_setting", "There are thirteen places at a table built for twelve. The extra place faces the wall, not the door.")
	player.add_ledger_entry("dining_table_counted", "Mara counted thirteen places at a table made for twelve, and the empty place faced the wall like someone ashamed to be seen eating.", "2:47 AM - Thirteen Places")
	player.add_evidence("dining_table", "Thirteenth Place Setting", "The table is arranged for thirteen although the room is built around twelve chairs.", "Physical")
	player.add_journal_objective("measure_dining_room", "Measure the Dining Room before leaving.")
	player.show_message("Thirteen places. Twelve chairs. The extra setting has no chair, only a shadow.", 7.0)

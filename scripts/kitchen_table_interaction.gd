extends StaticBody3D

var inspected := false

func get_prompt(_player: Node) -> String:
	return "E - Inspect preparation table"

func interact(player: Node) -> void:
	if inspected:
		player.show_message("The plates are cold now, except the one Mara has already counted.")
		return
	inspected = true
	player.complete_journal_objective("inspect_kitchen_table")
	player.add_journal_note("kitchen_count", "Twelve plates are washed clean. The thirteenth plate is still warm at the centre of the preparation table.")
	player.add_ledger_entry("kitchen_table_counted", "There were twelve clean plates and one warm plate. Mara counted them twice, then stopped, because the thirteenth still seemed to be counting her.", "2:47 AM - The Warm Plate")
	player.add_journal_objective("record_kitchen_wall", "Use the recorder on the Kitchen wall.")
	player.show_message("Twelve clean plates. One warm plate. The Kitchen remembers serving Eleanor last.", 7.0)

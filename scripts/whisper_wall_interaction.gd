extends StaticBody3D

func get_prompt(_player: Node) -> String:
	return "E - Inspect wall"

func interact(player: Node) -> void:
	if get_tree().root.get_meta("entrance_wall_recorded", false):
		player.show_message("The wall is still now. The west wing door is the next answer.")
		player.add_journal_objective("open_west_wing", "Open the west wing door.")
		return
	if player.has_recorder:
		player.show_message("The plaster flexes around the recorder's red light. Press R to record the wall.")
		player.complete_journal_objective("inspect_wall")
		player.add_journal_objective("record_wall", "Use the recorder on the whisper wall.")
	else:
		player.show_message("The wall is breathing. Mara needs something that can capture sound.")
		player.add_journal_note("wall_needs_recorder", "The wall reacts like it is holding a voice. Find the recorder and return.")
		player.add_journal_objective("find_recorder", "Find Mara's recorder.")

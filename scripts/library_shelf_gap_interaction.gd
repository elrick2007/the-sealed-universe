extends StaticBody3D

var inspected := false

func get_prompt(_player: Node) -> String:
	if inspected:
		return "E - Recheck Caton's mark"
	if bool(get_tree().root.get_meta("library_missing_inch_measured", false)):
		return "E - Check shelf gap"
	return ""

func interact(player: Node) -> void:
	if not bool(get_tree().root.get_meta("library_missing_inch_measured", false)):
		return
	if inspected:
		player.show_message("Caton's pencil mark stays visible now. The missing inch points out of the Library.", 6.0)
		return
	inspected = true
	get_tree().root.set_meta("caton_margin_mark_found", true)
	player.complete_journal_objective("check_shelf_gap")
	player.add_journal_note(
		"caton_margin_mark",
		"Behind the Library shelf, Caton pencilled a tiny margin mark: one inch missing, arrowed toward the Dining Room."
	)
	player.add_evidence(
		"caton_margin_mark",
		"Caton's Shelf-Margin Mark",
		"A pencil mark behind the Library shelf confirms the missing inch was noticed in 1885 and points toward the Dining Room.",
		"Measurement"
	)
	player.add_ledger_entry(
		"caton_margin_mark",
		"Behind the shelves Mara found Caton's smallest confession: an inch marked, circled, and sent onward with an arrow. Surveyors did not write prayers, but this looked close.",
		"2:47 AM - Caton's Inch"
	)
	player.show_message("Behind the shelf: Caton's pencil mark. One inch missing. Arrow toward the Dining Room.", 7.0)

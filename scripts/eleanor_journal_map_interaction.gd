extends Area3D

var collected := false

func get_prompt(_player: Node) -> String:
	if not bool(get_tree().root.get_meta("sealed_wing_draft_witnessed", false)):
		return "E - Read pencil page"
	if collected:
		return "E - Re-read Eleanor's map"
	return "E - Take Eleanor's map"

func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("sealed_wing_draft_witnessed", false)):
		player.show_message("The page is blank until Mara stands where the corridor is trying to become real.", 6.0)
		return
	if collected:
		player.show_message("Eleanor's hand marks the corridor as forty-two feet. The ink adds, in a different pressure: it is not.", 7.0)
		return

	collected = true
	root.set_meta("eleanor_journal_map_found", true)
	root.set_meta("impossible_corridor_seeded", true)
	player.add_inventory_item("eleanor_journal_map", "Eleanor's Journal Map", "A sealed-wing map drawn in iron-gall ink. It marks the corridor as 42 ft, then denies the number.")
	player.complete_journal_objective("find_eleanor_journal_map")
	player.add_journal_note(
		"eleanor_journal_map_found",
		"Eleanor's map does not match Caton's survey. Her corridor is labelled 42 ft, then corrected in a tighter hand: it is not."
	)
	player.add_ledger_entry(
		"eleanor_journal_map_found",
		"Eleanor had drawn the sealed wing by hand. The corridor was marked forty-two feet, then denied by the same ink. Mara folded the page and felt it continue measuring itself.",
		"2:47 AM - Eleanor's Map"
	)
	player.add_evidence(
		"eleanor_journal_map_found",
		"Eleanor's Hand-Drawn Sealed Wing Map",
		"The map contradicts Caton's survey and labels the sealed-wing corridor as 42 ft, then denies the measurement.",
		"Document"
	)
	player.add_journal_objective("measure_impossible_corridor", "Measure the sealed-wing corridor against Eleanor's 42 ft note.")
	player.show_message("Eleanor's map recovered: 42 ft. In smaller ink: it is not.", 8.0)

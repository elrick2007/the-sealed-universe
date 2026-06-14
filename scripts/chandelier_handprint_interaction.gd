extends StaticBody3D

var inspected := false


func get_prompt(_player: Node) -> String:
	if not bool(get_tree().root.get_meta("gallery_landing_reached", false)):
		return "E - Inspect chandelier"
	if inspected or bool(get_tree().root.get_meta("chandelier_handprint_found", false)):
		return "E - Re-read opened links"
	return "E - Inspect opened links"


func interact(player: Node) -> void:
	var root := get_tree().root
	if not bool(root.get_meta("gallery_landing_reached", false)):
		player.show_message("The chandelier hangs above a landing Mara has not reached yet.", 5.0)
		return
	if inspected or bool(root.get_meta("chandelier_handprint_found", false)):
		player.show_message("The brass links remain opened, not snapped. The long handprint is still in the dust.", 6.0)
		return

	inspected = true
	root.set_meta("chandelier_handprint_found", true)
	root.set_meta("camera_verb_seeded", true)

	player.complete_journal_objective("inspect_chandelier_handprint")
	player.add_journal_note(
		"chandelier_handprint",
		"The chandelier links were opened, not broken. A five-finger handprint is too long for a human hand."
	)
	player.add_ledger_entry(
		"chandelier_handprint",
		"Mara saw the chandelier's opened links and the long handprint in the dust. The house had touched its own evidence before she could.",
		"2:47 AM - Opened Links"
	)
	player.add_evidence(
		"chandelier_handprint",
		"Chandelier Handprint",
		"Opened brass links and an elongated five-finger print prove the fall was handled, not accidental.",
		"Physical"
	)
	player.add_journal_objective("photograph_chandelier_handprint", "Photograph the opened chandelier links.")
	player.show_message("The chain links are opened, not snapped. Press C to photograph the handprint before it changes.", 7.0)

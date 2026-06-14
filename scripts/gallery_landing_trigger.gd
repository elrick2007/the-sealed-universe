extends Area3D

var reached := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if not body.has_method("add_journal_note"):
		return
	var root := get_tree().root
	if not bool(root.get_meta("first_floor_landing_seeded", false)):
		if body.has_method("show_message"):
			body.show_message("The landing is still only a pencilled line above the Kitchen.", 5.0)
		return
	if reached or bool(root.get_meta("gallery_landing_reached", false)):
		return

	reached = true
	root.set_meta("gallery_landing_reached", true)
	root.set_meta("current_act", 2)

	if body.has_method("visit_map_area"):
		body.visit_map_area("gallery_landing")
	if body.has_method("reveal_map_area"):
		body.reveal_map_area("gallery_landing")
	body.complete_journal_objective("reach_gallery_landing")
	body.add_journal_note(
		"gallery_landing_reached",
		"The Gallery Landing looks down into the Entrance Hall, but the footsteps come from overhead."
	)
	body.add_ledger_entry(
		"gallery_landing_reached",
		"Mara reached the landing above the Entrance Hall. From there, the ground floor looked arranged rather than built.",
		"2:47 AM - Above The Hall"
	)
	body.add_evidence(
		"gallery_landing_reached",
		"Gallery Landing View",
		"The First Floor reframes the Entrance Hall from above; the house's height no longer feels trustworthy.",
		"Route"
	)
	body.add_journal_objective("inspect_chandelier_handprint", "Inspect the raised chandelier at the Gallery Landing.")
	body.show_message("The Gallery Landing looks down on Act I. The footsteps are still above.", 7.0)

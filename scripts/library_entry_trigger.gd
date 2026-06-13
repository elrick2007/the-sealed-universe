extends Area3D

var triggered := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if triggered or not body.has_method("show_message"):
		return
	triggered = true
	body.visit_map_area("library")
	body.complete_journal_objective("study_west_wing")
	body.add_journal_objective("listen_library_wall", "Find the wall voice hidden in the Library.")
	body.add_journal_note("library_found", "The west wing opens into a Library that was not fully drawn on the first map.")
	body.show_message("The Library remembers footsteps. The shelves lean toward one wall.", 6.0)

extends Area3D

var triggered := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if triggered or not body.has_method("show_message"):
		return
	triggered = true
	body.visit_map_area("study")
	body.complete_journal_objective("find_missing_room")
	body.add_journal_objective("find_tape_measure", "Find Thomas Ashford's tape measure.")
	body.add_journal_note("study_found", "The Study sits where the Library shelves were facing. The map knew it before Mara did.")
	body.show_message("The Study performs honesty. Mara does not trust it. The tape measure is on Thomas's desk.", 7.0)

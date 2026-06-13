extends Area3D

var triggered := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if triggered or not body.has_method("show_message"):
		return
	triggered = true
	body.visit_map_area("dining_room")
	body.complete_journal_objective("follow_missing_inch")
	body.add_journal_objective("inspect_dining_table", "Inspect the Dining Room table setting.")
	body.add_journal_note("dining_room_found", "The missing inch leads to the Dining Room. The table is set for one more guest than the map admits.")
	body.show_message("The missing inch ends at the Dining Room. One place setting waits for a name.", 7.0)

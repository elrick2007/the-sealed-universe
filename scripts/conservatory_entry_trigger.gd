extends Area3D

var triggered := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not body.has_method("show_message"):
		return
	if not bool(get_tree().root.get_meta("next_route_gate_open", false)):
		body.show_message("The passage toward the Conservatory stays sketch-thin until the Kitchen route is chosen.", 5.0)
		return
	if triggered:
		return
	triggered = true
	body.visit_map_area("conservatory")
	body.complete_journal_objective("find_conservatory_route")
	body.add_journal_objective("inspect_lemon_trees", "Inspect the lemon trees in the Conservatory.")
	body.add_journal_note("conservatory_found", "The Conservatory smells of lemon oil and cold glass. No roses.")
	body.add_ledger_entry("conservatory_found", "Mara found the Conservatory by following yellow ink across Caton's plan. The glass held the night outside, but the lemon trees held something older.", "2:47 AM - Lemon Glass")
	body.show_message("The Conservatory smells of lemon oil and cold glass. No roses.", 7.0)

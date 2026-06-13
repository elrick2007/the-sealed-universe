extends Area3D

var visited_once := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not body.has_method("show_message"):
		return
	body.visit_map_area("kitchen")
	if visited_once:
		body.show_message(_return_message(body), 7.0)
		return
	visited_once = true
	body.complete_journal_objective("follow_table_sound")
	body.add_journal_objective("inspect_kitchen_table", "Inspect the Kitchen preparation table.")
	body.add_journal_note("kitchen_found", "The Kitchen is the first room that watched Eleanor eat. Every surface points back to the table.")
	body.add_journal_objective("review_living_ledger", "Review the Living Ledger in the Kitchen.")
	body.add_ledger_entry("kitchen_found", "Mara reached the Kitchen and the house became almost domestic. Cold ash. Old sugar. A table that had learned to count grief as crockery.", "2:47 AM - The Kitchen")
	var message := "The Kitchen smells of cold ash and old sugar. This can be Mara's base. Find the ledger, board, and recorder dock."
	var reasons := _return_reasons(body)
	if not reasons.is_empty():
		message += " Waiting now: %s." % _join_reasons(reasons)
	body.show_message(message, 8.0)

func _return_message(body: Node) -> String:
	var reasons := _return_reasons(body)
	if reasons.is_empty():
		return "The Kitchen is quiet for now. No new page, proof, or transcription has appeared."
	return "The Kitchen has changed: %s." % _join_reasons(reasons)

func _return_reasons(body: Node) -> Array:
	var reasons := []
	if body.has_method("ledger_unread_count") and body.ledger_unread_count() > 0:
		reasons.append("new ledger page")
	if body.has_method("evidence_unread_count") and body.evidence_unread_count() > 0:
		reasons.append("new evidence pinned")
	var pending := int(get_tree().root.get_meta("pending_transcription_count", 0))
	if pending > 0:
		reasons.append("recorder transcription ready")
	return reasons

func _join_reasons(reasons: Array) -> String:
	if reasons.size() == 1:
		return String(reasons[0])
	if reasons.size() == 2:
		return "%s and %s" % [String(reasons[0]), String(reasons[1])]
	var parts := []
	for index in range(reasons.size() - 1):
		parts.append(String(reasons[index]))
	return "%s, and %s" % [", ".join(parts), String(reasons[reasons.size() - 1])]

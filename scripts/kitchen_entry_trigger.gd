extends Area3D

var visited_once := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not body.has_method("show_message"):
		return
	body.visit_map_area("kitchen")
	if _acknowledge_rose_trace_return(body):
		return
	if _acknowledge_impossible_measure_return(body):
		return
	if _acknowledge_void_recording_return(body):
		return
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
	var root := get_tree().root
	if bool(root.get_meta("rose_scent_traced", false)) and not bool(root.get_meta("rose_trace_returned", false)):
		reasons.append("rose-scent contradiction ready")
	if bool(root.get_meta("impossible_corridor_measured", false)) and not bool(root.get_meta("impossible_measure_returned", false)):
		reasons.append("impossible measurement ready")
	if bool(root.get_meta("attic_void_recorder_yield_found", false)) and not bool(root.get_meta("attic_void_recording_returned", false)):
		reasons.append("attic void recording ready")
	if body.has_method("ledger_unread_count") and body.ledger_unread_count() > 0:
		reasons.append("new ledger page")
	if body.has_method("evidence_unread_count") and body.evidence_unread_count() > 0:
		reasons.append("new evidence pinned")
	var pending := int(root.get_meta("pending_transcription_count", 0))
	if pending > 0:
		reasons.append("recorder transcription ready")
	return reasons

func _acknowledge_rose_trace_return(body: Node) -> bool:
	var root := get_tree().root
	if not bool(root.get_meta("rose_scent_traced", false)):
		return false
	if bool(root.get_meta("rose_trace_returned", false)):
		return false
	root.set_meta("rose_trace_returned", true)
	body.complete_journal_objective("return_rose_trace_to_kitchen")
	body.add_journal_note("rose_trace_pinned", "Back in the Kitchen, the rose scent files as a contradiction: lemons witnessed the murder, but roses mark the sealed door.")
	body.add_ledger_entry(
		"rose_trace_pinned",
		"Mara brought the smell of roses back to the Kitchen and pinned it beside the lemon-tree witness. The board did not solve the lie. It gave the lie a direction.",
		"2:47 AM - Pinned Scent"
	)
	body.add_journal_objective("approach_sealed_wing_edge", "Return to the rose trace and test the sealed wing boundary.")
	body.show_message("The Kitchen accepts the rose trace as evidence. The sealed edge of the house is ready to test.", 8.0)
	return true

func _acknowledge_impossible_measure_return(body: Node) -> bool:
	var root := get_tree().root
	if not bool(root.get_meta("impossible_corridor_measured", false)):
		return false
	if bool(root.get_meta("impossible_measure_returned", false)):
		return false
	root.set_meta("impossible_measure_returned", true)
	root.set_meta("act_2_gate_seeded", true)
	root.set_meta("first_floor_plan_unlocked", true)
	body.complete_journal_objective("return_impossible_measure_to_kitchen")
	body.add_journal_note("impossible_measure_pinned", "Back in the Kitchen, the 47 ft measurement gives the house a new floor to answer for.")
	body.add_evidence("act_2_first_floor_gate", "Act 2 Gate: Borrowed Five Feet", "The impossible corridor gives Mara enough missing distance to begin looking above the ground floor.", "Gate")
	body.add_ledger_entry(
		"impossible_measure_pinned",
		"Mara pinned the borrowed five feet to the Kitchen board. The ground floor did not get longer. Somewhere above it, a staircase remembered being owed a room.",
		"2:47 AM - Borrowed Space"
	)
	if body.has_method("unlock_map_floor"):
		body.unlock_map_floor("first_floor")
	body.add_journal_objective("find_first_floor_stairs", "Use the borrowed five feet to find the staircase to the First Floor.")
	body.show_message("The Kitchen accepts the impossible measurement. A first-floor plan unlocks in the map.", 8.0)
	return true

func _acknowledge_void_recording_return(body: Node) -> bool:
	var root := get_tree().root
	if not bool(root.get_meta("attic_void_recorder_yield_found", false)):
		return false
	if bool(root.get_meta("attic_void_recording_returned", false)):
		return false
	root.set_meta("attic_void_recording_returned", true)
	root.set_meta("attic_void_recording_pinned", true)
	body.complete_journal_objective("return_void_recording_to_kitchen")
	body.add_journal_note("attic_void_recording_pinned", "Back in the Kitchen, the attic void recording files as proof that the house is cataloguing Mara before she is gone.")
	body.add_evidence(
		"attic_void_recording_pinned",
		"Kitchen Pin: Filed Alive",
		"The void recording is copied to the Kitchen board: shelving sounds, a patient male voice, and Mara handled as an item before she is missing.",
		"Recording"
	)
	body.add_ledger_entry(
		"attic_void_recording_pinned",
		"Mara pinned the attic void recording to the Kitchen board. The voice had not threatened her. It had filed her. That was worse; threats still believed she could answer.",
		"2:47 AM - Filed to the Board"
	)
	body.add_journal_objective("trace_filing_voice_source", "Trace where the filing voice is shelving Mara's name.")
	body.show_message("The Kitchen accepts the void recording. Mara has been filed before she is missing.", 8.0)
	return true

func _join_reasons(reasons: Array) -> String:
	if reasons.size() == 1:
		return String(reasons[0])
	if reasons.size() == 2:
		return "%s and %s" % [String(reasons[0]), String(reasons[1])]
	var parts := []
	for index in range(reasons.size() - 1):
		parts.append(String(reasons[index]))
	return "%s, and %s" % [", ".join(parts), String(reasons[reasons.size() - 1])]

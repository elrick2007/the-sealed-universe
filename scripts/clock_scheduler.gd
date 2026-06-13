extends Node

const INCOMPLETE_EVENT_ID := "mara_incomplete"
const RESERVED_NOTE_ID := "two_forty_seven_reserved"
const FIRED_NOTE_ID := "two_forty_seven_incomplete"

var incomplete_event_armed := false
var incomplete_event_fired := false

func _ready() -> void:
	var root := get_tree().root
	root.set_meta("clock_scheduler_active", true)
	root.set_meta("incomplete_247_armed", false)
	root.set_meta("incomplete_247_fired", false)
	root.set_meta("next_247_event_id", "")
	root.set_meta("last_247_event_id", "")

func arm_incomplete_event(player: Node = null) -> void:
	if incomplete_event_armed or incomplete_event_fired:
		return
	incomplete_event_armed = true
	var root := get_tree().root
	root.set_meta("incomplete_247_armed", true)
	root.set_meta("next_247_event_id", INCOMPLETE_EVENT_ID)
	if player == null:
		return
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			RESERVED_NOTE_ID,
			"The Living Ledger reserves a page for 2:47, as if the time is an appointment the house intends to keep."
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			RESERVED_NOTE_ID,
			"The ledger did not turn the page. It reserved one. 2:47 waited in the margin like a time a person could arrive at.",
			"2:47 AM - Reserved Page"
		)
	if player.has_method("add_journal_objective"):
		player.add_journal_objective("watch_247_ledger", "Watch what the Living Ledger writes at 2:47.")
		player.add_journal_objective("return_to_unwritten_door", "Return to the unwritten door with Mara's Incomplete entry.")

func trigger_next_event(player: Node = null) -> bool:
	if has_incomplete_event_fired() or not is_incomplete_event_armed():
		return false
	incomplete_event_armed = false
	incomplete_event_fired = true
	var root := get_tree().root
	root.set_meta("incomplete_247_armed", false)
	root.set_meta("incomplete_247_fired", true)
	root.set_meta("next_247_event_id", "")
	root.set_meta("last_247_event_id", INCOMPLETE_EVENT_ID)
	if player == null:
		return true
	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective("watch_247_ledger")
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			FIRED_NOTE_ID,
			"At 2:47, the Living Ledger writes Mara's Incomplete status as if the house has corrected the record."
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			FIRED_NOTE_ID,
			"At 2:47, Mara watched the reserved page fill itself. Her name appeared first. The word Incomplete followed, neater than her own hand.",
			"2:47 AM - Incomplete Writes Back"
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			FIRED_NOTE_ID,
			"2:47 Ledger Entry - Incomplete",
			"The reserved ledger page writes Mara's Incomplete status at 2:47, confirming the house treats the word as an active condition.",
			"Ledger"
		)
	if player.has_method("show_message"):
		player.show_message("At 2:47, the Living Ledger writes Mara's name without her hand.", 7.0)
	return true

func is_incomplete_event_armed() -> bool:
	return incomplete_event_armed or bool(get_tree().root.get_meta("incomplete_247_armed", false))

func has_incomplete_event_fired() -> bool:
	return incomplete_event_fired or bool(get_tree().root.get_meta("incomplete_247_fired", false))

func scheduler_status_line() -> String:
	if has_incomplete_event_fired():
		return "2:47 WROTE: INCOMPLETE"
	if not is_incomplete_event_armed():
		return ""
	return "NEXT 2:47 RESERVED"

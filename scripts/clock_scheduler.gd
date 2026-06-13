extends Node

const INCOMPLETE_EVENT_ID := "mara_incomplete"
const RESERVED_NOTE_ID := "two_forty_seven_reserved"

var incomplete_event_armed := false
var incomplete_event_fired := false

func _ready() -> void:
	var root := get_tree().root
	root.set_meta("clock_scheduler_active", true)
	root.set_meta("incomplete_247_armed", false)
	root.set_meta("incomplete_247_fired", false)
	root.set_meta("next_247_event_id", "")

func arm_incomplete_event(player: Node = null) -> void:
	if incomplete_event_armed:
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

func is_incomplete_event_armed() -> bool:
	return incomplete_event_armed or bool(get_tree().root.get_meta("incomplete_247_armed", false))

func has_incomplete_event_fired() -> bool:
	return incomplete_event_fired or bool(get_tree().root.get_meta("incomplete_247_fired", false))

func scheduler_status_line() -> String:
	if not is_incomplete_event_armed():
		return ""
	return "NEXT 2:47 RESERVED"

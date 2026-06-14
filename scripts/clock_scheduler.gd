extends Node

const INCOMPLETE_EVENT_ID := "mara_incomplete"
const RESERVED_NOTE_ID := "two_forty_seven_reserved"
const FIRED_NOTE_ID := "two_forty_seven_incomplete"
const SCHEDULED_WATCH_EVENT_ID := "hall_clock_watch"
const SCHEDULED_WATCH_ARMED_NOTE_ID := "scheduled_hall_watch_armed"
const SCHEDULED_WATCH_FIRED_NOTE_ID := "scheduled_hall_watch_fired"

var incomplete_event_armed := false
var incomplete_event_fired := false
var time_scheduling_unlocked := false
var scheduled_hall_watch_armed := false
var scheduled_hall_watch_fired := false

func _ready() -> void:
	var root := get_tree().root
	root.set_meta("clock_scheduler_active", true)
	root.set_meta("incomplete_247_armed", false)
	root.set_meta("incomplete_247_fired", false)
	root.set_meta("time_scheduling_unlocked", false)
	root.set_meta("scheduled_247_available", false)
	root.set_meta("scheduled_hall_watch_armed", false)
	root.set_meta("scheduled_hall_watch_fired", false)
	root.set_meta("next_247_event_id", "")
	root.set_meta("next_scheduled_247_event_id", "")
	root.set_meta("last_247_event_id", "")

func unlock_time_scheduling(player: Node = null) -> void:
	if time_scheduling_unlocked or bool(get_tree().root.get_meta("time_scheduling_unlocked", false)):
		return
	time_scheduling_unlocked = true
	var root := get_tree().root
	root.set_meta("time_scheduling_unlocked", true)
	root.set_meta("scheduled_247_available", true)
	if player == null:
		return
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			"scheduled_247_unlocked",
			"With the pendulum returned, Mara can wait for 2:47 deliberately instead of stumbling into it."
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			"scheduled_247_unlocked",
			"The clock did not start. It resumed, as if it had only been holding its breath until Mara supplied the missing weight.",
			"2:47 AM - Scheduled Time"
		)

func schedule_hall_watch_event(player: Node = null) -> bool:
	if not is_time_scheduling_unlocked():
		return false
	if has_scheduled_hall_watch_fired() or is_scheduled_hall_watch_armed():
		return false
	scheduled_hall_watch_armed = true
	var root := get_tree().root
	root.set_meta("scheduled_hall_watch_armed", true)
	root.set_meta("next_scheduled_247_event_id", SCHEDULED_WATCH_EVENT_ID)
	if player == null:
		return true
	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective("schedule_247_event")
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			SCHEDULED_WATCH_ARMED_NOTE_ID,
			"Mara set the grandfather clock for a deliberate 2:47 watch. The house now has an appointment she chose."
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			SCHEDULED_WATCH_ARMED_NOTE_ID,
			"Mara moved the hands to 2:47 and felt the house notice the difference between being hunted by a time and arriving at it willingly.",
			"2:47 AM - Appointment Set"
		)
	if player.has_method("add_journal_objective"):
		player.add_journal_objective("wait_scheduled_247", "Return to the Kitchen clock and keep Mara's chosen 2:47 appointment.")
	if player.has_method("show_message"):
		player.show_message("Mara sets the clock for 2:47. This time, the appointment is hers.", 7.0)
	return true

func trigger_scheduled_hall_watch_event(player: Node = null) -> bool:
	if has_scheduled_hall_watch_fired() or not is_scheduled_hall_watch_armed():
		return false
	scheduled_hall_watch_armed = false
	scheduled_hall_watch_fired = true
	var root := get_tree().root
	root.set_meta("scheduled_hall_watch_armed", false)
	root.set_meta("scheduled_hall_watch_fired", true)
	root.set_meta("next_scheduled_247_event_id", "")
	root.set_meta("last_247_event_id", SCHEDULED_WATCH_EVENT_ID)
	if player == null:
		return true
	if player.has_method("complete_journal_objective"):
		player.complete_journal_objective("wait_scheduled_247")
	if player.has_method("add_journal_note"):
		player.add_journal_note(
			SCHEDULED_WATCH_FIRED_NOTE_ID,
			"At Mara's chosen 2:47, the Living Ledger wrote a line before the grandfather clock struck. The house can keep appointments."
		)
	if player.has_method("add_ledger_entry"):
		player.add_ledger_entry(
			SCHEDULED_WATCH_FIRED_NOTE_ID,
			"At 2:47, the ledger opened to a clean page. Mara had chosen the hour, but the house chose the sentence.",
			"2:47 AM - The Chosen Hour"
		)
	if player.has_method("add_evidence"):
		player.add_evidence(
			SCHEDULED_WATCH_FIRED_NOTE_ID,
			"Scheduled 2:47 Ledger Page",
			"After the pendulum was returned, Mara could choose a 2:47 appointment. The ledger answered at the chosen hour.",
			"Clock"
		)
	if player.has_method("show_message"):
		player.show_message("At the chosen 2:47, the ledger opens before the clock finishes striking.", 7.0)
	return true

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

func is_time_scheduling_unlocked() -> bool:
	return time_scheduling_unlocked or bool(get_tree().root.get_meta("time_scheduling_unlocked", false))

func is_scheduled_hall_watch_armed() -> bool:
	return scheduled_hall_watch_armed or bool(get_tree().root.get_meta("scheduled_hall_watch_armed", false))

func has_scheduled_hall_watch_fired() -> bool:
	return scheduled_hall_watch_fired or bool(get_tree().root.get_meta("scheduled_hall_watch_fired", false))

func scheduler_status_line() -> String:
	if has_scheduled_hall_watch_fired():
		return "CHOSEN 2:47 ANSWERED"
	if is_scheduled_hall_watch_armed():
		return "CHOSEN 2:47 WAITING"
	if has_incomplete_event_fired():
		return "2:47 WROTE: INCOMPLETE"
	if is_incomplete_event_armed():
		return "NEXT 2:47 RESERVED"
	if is_time_scheduling_unlocked():
		return "2:47 CAN BE SCHEDULED"
	return ""

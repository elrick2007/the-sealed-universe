extends StaticBody3D


func get_prompt(player: Node) -> String:
	var root := get_tree().root
	if bool(root.get_meta("hall_clock_pendulum_installed", false)):
		return "E - Check grandfather clock"
	if player.has_method("has_item") and player.has_item("clock_pendulum"):
		return "E - Return pendulum"
	return "E - Inspect grandfather clock"


func interact(player: Node) -> void:
	var root := get_tree().root
	if bool(root.get_meta("hall_clock_pendulum_installed", false)):
		player.show_message("The grandfather clock keeps time again. 2:47 is no longer only something Mara waits for.", 7.0)
		return
	if not player.has_method("has_item") or not player.has_item("clock_pendulum"):
		player.show_message("The grandfather clock is stopped at 2:47. Inside the case, the pendulum hook hangs empty.", 7.0)
		if player.has_method("add_journal_note"):
			player.add_journal_note("hall_clock_missing_pendulum", "The Entrance Hall grandfather clock is stopped at 2:47. Its pendulum is missing.")
		return

	_install_pendulum(player)


func _install_pendulum(player: Node) -> void:
	var root := get_tree().root
	root.set_meta("hall_clock_pendulum_installed", true)
	var scheduler := get_node_or_null("/root/Main/ClockScheduler")
	if scheduler != null and scheduler.has_method("unlock_time_scheduling"):
		scheduler.unlock_time_scheduling(player)
	else:
		root.set_meta("time_scheduling_unlocked", true)
		root.set_meta("scheduled_247_available", true)
	player.complete_journal_objective("return_clock_pendulum")
	player.add_journal_note(
		"hall_clock_pendulum_returned",
		"Mara returned the Housekeeper's pendulum to the Entrance Hall clock. The clock struck once, then waited for 2:47."
	)
	player.add_evidence(
		"hall_clock_pendulum_returned",
		"Grandfather Clock Restored",
		"The Housekeeper stopped the hall clock because it kept time the house could use. Returning the pendulum unlocks deliberate 2:47 scheduling.",
		"Clock"
	)
	player.add_ledger_entry(
		"hall_clock_pendulum_returned",
		"Mara set the pendulum back on its hook. The first swing sounded too heavy for brass, as if it had moved the house by one small second.",
		"2:47 AM - The Clock Accepts Its Weight"
	)
	player.add_journal_objective("schedule_247_event", "Use the restored clock to choose when Mara waits for 2:47.")
	player.show_message("The pendulum starts moving. The house has a time now, and Mara can choose to meet it.", 8.0)

extends StaticBody3D

func get_prompt(_player: Node) -> String:
	var root := get_tree().root
	if bool(root.get_meta("incomplete_247_fired", false)):
		return "E - Read 2:47 page"
	if bool(root.get_meta("incomplete_247_armed", false)):
		return "E - Wait for 2:47"
	return "E - Check Kitchen clock"

func interact(player: Node) -> void:
	var root := get_tree().root
	if bool(root.get_meta("incomplete_247_fired", false)):
		player.show_message("The Kitchen clock is stopped at 2:47. The ledger page is no longer blank.", 6.0)
		return
	if not bool(root.get_meta("incomplete_247_armed", false)):
		player.show_message("The Kitchen clock ticks, but no page is waiting for it yet.", 6.0)
		return
	var scheduler := get_node_or_null("/root/Main/ClockScheduler")
	if scheduler == null or not scheduler.has_method("trigger_next_event"):
		player.show_message("The clock tries to keep the appointment, but the ledger does not answer.", 6.0)
		return
	scheduler.trigger_next_event(player)

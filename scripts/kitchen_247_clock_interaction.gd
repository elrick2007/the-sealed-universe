extends StaticBody3D

func get_prompt(_player: Node) -> String:
	var root := get_tree().root
	if bool(root.get_meta("unnumbered_page_trade_armed", false)) and not bool(root.get_meta("unnumbered_page_trade_complete", false)):
		return "E - Wait for bed trade"
	if bool(root.get_meta("unnumbered_page_trade_complete", false)):
		return "E - Check altered page"
	if bool(root.get_meta("scheduled_hall_watch_armed", false)):
		return "E - Wait for chosen 2:47"
	if bool(root.get_meta("scheduled_hall_watch_fired", false)):
		return "E - Read chosen 2:47 page"
	if bool(root.get_meta("incomplete_247_fired", false)):
		return "E - Read 2:47 page"
	if bool(root.get_meta("incomplete_247_armed", false)):
		return "E - Wait for 2:47"
	return "E - Check Kitchen clock"

func interact(player: Node) -> void:
	var root := get_tree().root
	if bool(root.get_meta("unnumbered_page_trade_armed", false)) and not bool(root.get_meta("unnumbered_page_trade_complete", false)):
		_resolve_unnumbered_trade(player)
		return
	if bool(root.get_meta("scheduled_hall_watch_armed", false)):
		var scheduler := get_node_or_null("/root/Main/ClockScheduler")
		if scheduler == null or not scheduler.has_method("trigger_scheduled_hall_watch_event"):
			player.show_message("The Kitchen clock reaches for the appointment, but the hall clock does not answer.", 6.0)
			return
		scheduler.trigger_scheduled_hall_watch_event(player)
		return
	if bool(root.get_meta("scheduled_hall_watch_fired", false)):
		player.show_message("The Kitchen clock is quiet. Mara's chosen 2:47 already wrote back.", 6.0)
		return
	if bool(root.get_meta("unnumbered_page_trade_complete", false)) and bool(root.get_meta("incomplete_247_fired", false)):
		player.show_message("The Kitchen clock is stopped at 2:47. The altered fragment is no longer warm.", 6.0)
		return
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


func _resolve_unnumbered_trade(player: Node) -> void:
	var root := get_tree().root
	root.set_meta("unnumbered_page_trade_armed", false)
	root.set_meta("unnumbered_page_trade_complete", true)
	root.set_meta("last_247_trade_id", "unnumbered_bed_trade")
	player.add_inventory_item("altered_burnt_page_fragment", "Altered Burnt Page", "The charred corner has returned with one more line unburned.")
	player.complete_journal_objective("wait_247_bed_trade")
	player.add_journal_note(
		"unnumbered_trade_returned",
		"At 2:47, the unnumbered bed returned the black-book fragment less burned. The letters ...ASHFORD, E... are now readable."
	)
	player.add_ledger_entry(
		"unnumbered_trade_returned",
		"At 2:47 the bed gave back the burnt corner with a little more of the fire undone. The page had not healed. It had been corrected.",
		"2:47 AM - The Bed Gives Back"
	)
	player.add_evidence(
		"altered_burnt_page_fragment",
		"Altered Burnt Page Fragment",
		"The unnumbered bed returned the Library fragment with more of Eleanor's entry visible: ...ASHFORD, E...",
		"Document"
	)
	player.add_journal_objective("read_altered_fragment", "Compare the altered fragment with the guest book's blank line.")
	player.show_message("At 2:47, the bed gives back the fragment less burnt. The new letters read: ...ASHFORD, E...", 8.0)

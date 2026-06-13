extends StaticBody3D

var docked_once := false

func get_prompt(player: Node) -> String:
	if player.has_method("has_item") and player.has_item("recorder"):
		return "E - Dock recorder"
	return "E - Inspect recorder dock"

func interact(player: Node) -> void:
	if not player.has_method("has_item") or not player.has_item("recorder"):
		player.show_message("The empty dock is shaped for Mara's recorder. The Kitchen is waiting for its voice.", 6.0)
		return
	var pending := int(get_tree().root.get_meta("pending_transcription_count", 0))
	if not docked_once:
		docked_once = true
		player.add_journal_note("recorder_docked", "The Kitchen table can hold the recorder steady. Later, this will be where field recordings become evidence.")
		player.add_ledger_entry("recorder_docked", "Mara set the recorder on the Kitchen table. The red light blinked once, like the house had noticed the witness had made a habit of listening.", "2:47 AM - The Dock")
		if pending > 0:
			_review_transcriptions(player, pending)
			player.show_message("Recorder docked. %d recording(s) are copied into the Kitchen case file.", 7.0)
		else:
			player.show_message("Recorder docked. For now it marks the Kitchen as Mara's base of operations.", 7.0)
		return
	if pending > 0:
		_review_transcriptions(player, pending)
		player.show_message("Recorder transcription ready. Mara copies %d recording(s) into the Kitchen case file.", 7.0)
	else:
		player.show_message("The recorder clicks into the dock, but no new voice rises from the tape.", 5.0)

func _review_transcriptions(player: Node, pending: int) -> void:
	get_tree().root.set_meta("pending_transcription_count", 0)
	player.add_journal_note("recorder_transcriptions_reviewed", "The Kitchen dock makes wall voices legible enough to file as testimony.")
	player.add_ledger_entry("recorder_transcriptions_reviewed", "The recorder's hiss became sentences in the Kitchen. Mara copied them down, then found the same words already waiting in the ledger.", "2:47 AM - Transcription Ready")

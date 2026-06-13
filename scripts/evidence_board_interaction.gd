extends StaticBody3D

var inspected := false
var hud: Node
var evidence_visuals := {
	"wall_warning": ["EvidenceScrapWallWarning", "EvidencePinWallWarning"],
	"manor_plans": ["EvidenceScrapPlans", "EvidencePinPlans"],
	"library_wall_recording": ["EvidenceScrapLibraryRecording", "EvidencePinLibraryRecording"],
	"library_measurement": ["EvidenceScrapLibraryMeasure", "EvidencePinLibraryMeasure"],
	"dining_table": ["EvidenceScrapDiningTable", "EvidencePinDiningTable"],
	"eleanor_place_card": ["EvidenceScrapEleanorCard", "EvidencePinEleanorCard"],
	"kitchen_wall_recording": ["EvidenceScrapKitchenRecording", "EvidencePinKitchenRecording", "EvidenceThreadAB", "EvidenceThreadBC", "EvidenceThreadFinal"],
	"caldwell_living_record": ["EvidenceScrapCaldwell", "EvidencePinCaldwell"],
	"mara_incomplete_entry": ["EvidenceScrapIncomplete", "EvidencePinIncomplete"]
}

func _ready() -> void:
	_hide_all_evidence_visuals()
	hud = get_node_or_null("/root/Main/HUD")
	if hud != null:
		if hud.has_signal("evidence_added"):
			hud.evidence_added.connect(_on_evidence_added)
		var existing_evidence: Array = hud.get("evidence_items")
		for item in existing_evidence:
			_reveal_evidence_visual(String(item.id))

func get_prompt(_player: Node) -> String:
	return "E - Open evidence board"

func interact(player: Node) -> void:
	if inspected:
		player.show_message(_progress_message(player.evidence_completion_percent()), 5.0)
		player.open_evidence_board()
		return
	inspected = true
	player.add_journal_note("evidence_board_found", "The Kitchen wall is becoming an evidence board. Mara needs proof, not just impressions.")
	player.add_ledger_entry("evidence_board_found", "Mara pinned the first scraps to the Kitchen wall and pretended arrangement was the same thing as control.", "2:47 AM - Proof")
	player.show_message(_progress_message(player.evidence_completion_percent()), 7.0)
	player.open_evidence_board()

func _on_evidence_added(id: String) -> void:
	_reveal_evidence_visual(id)

func _hide_all_evidence_visuals() -> void:
	for id in evidence_visuals.keys():
		for node_name in evidence_visuals[id]:
			var node := get_parent().get_node_or_null(String(node_name))
			if node != null:
				node.visible = false

func _reveal_evidence_visual(id: String) -> void:
	if not evidence_visuals.has(id):
		return
	for node_name in evidence_visuals[id]:
		var node := get_parent().get_node_or_null(String(node_name))
		if node != null:
			node.visible = true

func _progress_message(percent: int) -> String:
	if percent >= 100:
		return "Evidence board complete for this route. Publish readiness: 100%."
	if percent >= 70:
		return "The board is nearly coherent. Publish readiness: %d%%." % percent
	if percent >= 35:
		return "The board has a shape now. Publish readiness: %d%%." % percent
	return "Evidence board started. Publish readiness: %d%%." % percent

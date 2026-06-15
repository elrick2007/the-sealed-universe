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
	"mara_incomplete_entry": ["EvidenceScrapIncomplete", "EvidencePinIncomplete"],
	"act_2_first_floor_gate": ["EvidenceScrapAct2Gate", "EvidencePinAct2Gate"],
	"attic_void_recording_pinned": ["EvidenceScrapAtticVoid", "EvidencePinAtticVoid"],
	"foundation_testament_board_return": ["EvidenceScrapFoundationTestament", "EvidencePinFoundationTestament"],
	"foundation_publish_thread_seed": ["EvidenceThreadPublishSeed"],
	"foundation_publish_bundle_board_return": ["EvidenceScrapPublishBundle", "EvidencePinPublishBundle"],
	"foundation_publish_thread_second": ["EvidenceThreadPublishSecond"],
	"foundation_oil_final_board_return": ["EvidenceScrapOilFinal", "EvidencePinOilFinal"],
	"foundation_publish_thread_final": ["EvidenceThreadPublishFinal"]
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
	var pinned_testament := _try_pin_foundation_testament(player)
	var pinned_publish_bundle := _try_pin_publish_bundle(player)
	var pinned_oil_final := _try_pin_oil_final(player)
	if inspected:
		if pinned_testament or pinned_publish_bundle or pinned_oil_final:
			player.show_message(_pin_message(pinned_testament, pinned_publish_bundle, pinned_oil_final), 6.0)
		else:
			player.show_message(_progress_message(player.evidence_completion_percent()), 5.0)
		player.open_evidence_board()
		return
	inspected = true
	player.add_journal_note("evidence_board_found", "The Kitchen wall is becoming an evidence board. Mara needs proof, not just impressions.")
	player.add_ledger_entry("evidence_board_found", "Mara pinned the first scraps to the Kitchen wall and pretended arrangement was the same thing as control.", "2:47 AM - Proof")
	if pinned_testament or pinned_publish_bundle or pinned_oil_final:
		player.show_message(_pin_message(pinned_testament, pinned_publish_bundle, pinned_oil_final), 7.0)
	else:
		player.show_message(_progress_message(player.evidence_completion_percent()), 7.0)
	player.open_evidence_board()

func _try_pin_foundation_testament(player: Node) -> bool:
	var root := get_tree().root
	if not bool(root.get_meta("foundation_testament_page_read", false)):
		return false
	if bool(root.get_meta("foundation_testament_returned_to_board", false)):
		return false
	root.set_meta("foundation_testament_returned_to_board", true)
	root.set_meta("foundation_publish_meter_board_started", true)
	root.set_meta("foundation_publish_meter_count", max(1, int(root.get_meta("foundation_publish_meter_count", 0))))
	player.complete_journal_objective("return_testament_to_evidence_board")
	root.set_meta("foundation_publish_witness_chain_objective_added", true)
	player.add_journal_objective("complete_publish_witness_chain", "Find the remaining publish-route proofs before Mara presses send.")
	player.add_journal_note("foundation_testament_board_return", "Pinned to the Kitchen board, the Testament Page pulls the first red thread toward the floor plan.")
	player.add_evidence(
		"foundation_testament_board_return",
		"Kitchen Pin: Testament Page",
		"The Testament Page belongs on the board, not in Mara's hand. It starts the publish route as physical proof.",
		"Publish"
	)
	player.add_evidence(
		"foundation_publish_thread_seed",
		"Publish Meter: First Red Thread",
		"The board accepts the Testament Page as the first proof Mara can publish.",
		"Publish"
	)
	player.add_ledger_entry(
		"foundation_testament_board_return",
		"Mara brought the Testament Page back to the Kitchen board. The first red thread crossed the map without her tying it.",
		"2:47 AM - The First Red Thread"
	)
	return true

func _try_pin_publish_bundle(player: Node) -> bool:
	var root := get_tree().root
	if not bool(root.get_meta("foundation_publish_bundle_witnessed", false)):
		return false
	if bool(root.get_meta("foundation_publish_bundle_returned_to_board", false)):
		return false
	root.set_meta("foundation_publish_bundle_returned_to_board", true)
	root.set_meta("foundation_publish_meter_board_started", true)
	root.set_meta("foundation_publish_meter_count", max(2, int(root.get_meta("foundation_publish_meter_count", 0))))
	player.complete_journal_objective("return_publish_bundle_to_evidence_board")
	if not bool(root.get_meta("foundation_publish_witness_chain_objective_added", false)):
		root.set_meta("foundation_publish_witness_chain_objective_added", true)
		player.add_journal_objective("complete_publish_witness_chain", "Find the remaining publish-route proofs before Mara presses send.")
	player.add_journal_note("foundation_publish_bundle_board_return", "Pinned beside the Testament Page, the proof bundle becomes the second witness in Mara's publish route.")
	player.add_evidence(
		"foundation_publish_bundle_board_return",
		"Kitchen Pin: Proof Bundle",
		"The proof bundle is attached to the board as the second publish-route witness. It is still not a send button.",
		"Publish"
	)
	player.add_evidence(
		"foundation_publish_thread_second",
		"Publish Meter: Second Red Thread",
		"The red thread now runs from the Testament Page to the proof bundle. One witness is still missing.",
		"Publish"
	)
	player.add_ledger_entry(
		"foundation_publish_bundle_board_return",
		"Mara pinned the proof bundle beside the Testament Page. The second thread joined them, and the board looked less like a wall than a verdict.",
		"2:47 AM - The Second Red Thread"
	)
	return true

func _try_pin_oil_final(player: Node) -> bool:
	var root := get_tree().root
	if not bool(root.get_meta("foundation_oil_final_witnessed", false)):
		return false
	if bool(root.get_meta("foundation_oil_final_returned_to_board", false)):
		return false
	root.set_meta("foundation_oil_final_returned_to_board", true)
	root.set_meta("foundation_publish_meter_board_started", true)
	root.set_meta("foundation_publish_meter_count", max(3, int(root.get_meta("foundation_publish_meter_count", 0))))
	player.complete_journal_objective("return_oil_witness_to_evidence_board")
	player.complete_journal_objective("complete_publish_witness_chain")
	player.add_journal_note("foundation_oil_final_board_return", "Pinned as refusal, the oil can closes the publish chain without becoming the burn ending.")
	player.add_evidence(
		"foundation_oil_final_board_return",
		"Kitchen Pin: Oil Refusal",
		"The oil can is proof because Mara did not use it. The publish route now has three witnesses and still no chosen ending.",
		"Publish"
	)
	player.add_evidence(
		"foundation_publish_thread_final",
		"Publish Meter: Third Red Thread",
		"The red thread closes the route from Testament Page to proof bundle to refused oil. Send remains locked behind the final story choice.",
		"Publish"
	)
	player.add_ledger_entry(
		"foundation_oil_final_board_return",
		"Mara pinned the oil beside the proof bundle as a refusal, not a promise. The board accepted restraint as evidence.",
		"2:47 AM - The Third Red Thread"
	)
	return true

func _pin_message(pinned_testament: bool, pinned_publish_bundle: bool, pinned_oil_final: bool) -> String:
	if pinned_oil_final:
		if pinned_testament and pinned_publish_bundle:
			return "Three red threads cross the board. The proof chain is complete, but no ending has been chosen."
		return "The third red thread closes the publish chain. Send still waits."
	if pinned_testament and pinned_publish_bundle:
		return "Two red threads cross the board. The publish route is no longer theoretical."
	if pinned_publish_bundle:
		return "A second red thread joins the proof bundle to the Testament Page."
	return "The Testament Page pulls the first red thread across the board."

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

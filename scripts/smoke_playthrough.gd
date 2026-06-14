extends SceneTree

var failures: Array[String] = []

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var packed_scene: PackedScene = load("res://scenes/main.tscn")
	var scene: Node = packed_scene.instantiate()
	root.add_child(scene)
	await process_frame
	await process_frame

	var player: Node = scene.get_node("Player")
	var hud: Node = scene.get_node("HUD")
	var clock_scheduler: Node = scene.get_node("ClockScheduler")
	var director: Node = scene.get_node("WallHorrorDirector")
	var recorder: Node = scene.get_node("Props/Recorder")
	var key: Node = scene.get_node("Props/ServiceKey")
	var door: Node = scene.get_node("Architecture/WestWingDoor")
	var scare: Node = scene.get_node("Architecture/WestWingHallway/WestWingScareTrigger")
	var plans: Node = scene.get_node("Props/ManorPlans")
	var library_trigger: Node = scene.get_node("Architecture/WestWingHallway/Library/LibraryEntryTrigger")
	var library_wall: Node3D = scene.get_node("Architecture/WestWingHallway/Library/LibraryWhisperWall")
	var library_shelf_gap: Node = scene.get_node("Architecture/WestWingHallway/Library/LibraryShelfGap")
	var study_trigger: Node = scene.get_node("Architecture/WestWingHallway/Study/StudyEntryTrigger")
	var tape_measure: Node = scene.get_node("Props/TapeMeasure")
	var dining_trigger: Node = scene.get_node("Architecture/WestWingHallway/DiningRoom/DiningEntryTrigger")
	var dining_table: Node = scene.get_node("Architecture/WestWingHallway/DiningRoom/DiningTable")
	var place_card: Node = scene.get_node("Architecture/WestWingHallway/DiningRoom/EleanorPlaceCard")
	var thirteenth_place: Node = scene.get_node("Architecture/WestWingHallway/DiningRoom/DiningExtraSetting")
	var kitchen_trigger: Node = scene.get_node("Architecture/WestWingHallway/Kitchen/KitchenEntryTrigger")
	var kitchen_table: Node = scene.get_node("Architecture/WestWingHallway/Kitchen/KitchenPrepTable")
	var kitchen_wall: Node3D = scene.get_node("Architecture/WestWingHallway/Kitchen/KitchenWhisperWall")
	var kitchen_ledger: Node = scene.get_node("Architecture/WestWingHallway/Kitchen/KitchenLedgerBook")
	var evidence_board: Node = scene.get_node("Architecture/WestWingHallway/Kitchen/KitchenEvidenceBoard")
	var recorder_dock: Node = scene.get_node("Architecture/WestWingHallway/Kitchen/KitchenRecorderDock")
	var next_route_gate: Node = scene.get_node("Architecture/WestWingHallway/Kitchen/KitchenRouteGate")
	var first_floor_stairs: Node = scene.get_node("Architecture/WestWingHallway/Kitchen/FirstFloorStairs")
	var gallery_landing_trigger: Node = scene.get_node("Architecture/FirstFloor/GalleryLanding/GalleryLandingTrigger")
	var chandelier_handprint: Node = scene.get_node("Architecture/FirstFloor/GalleryLanding/ChandelierHandprint")
	var unnumbered_guest_room: Node = scene.get_node("Architecture/FirstFloor/UnnumberedGuestRoom/UnnumberedBed")
	var conservatory_trigger: Node = scene.get_node("Architecture/WestWingHallway/Conservatory/ConservatoryEntryTrigger")
	var lemon_tree: Node = scene.get_node("Architecture/WestWingHallway/Conservatory/LemonTree")
	var rose_trace: Node = scene.get_node("Architecture/WestWingHallway/Conservatory/RoseScentTrace")
	var sealed_boundary: Node = scene.get_node("Architecture/WestWingHallway/Conservatory/SealedWingBoundary")
	var sealed_draft_threshold: Node = scene.get_node("Architecture/WestWingHallway/Conservatory/SealedWingDraftThreshold")
	var eleanor_journal_map: Node = scene.get_node("Architecture/WestWingHallway/Conservatory/EleanorJournalMap")
	var caldwell_record: Node = scene.get_node("Architecture/WestWingHallway/Kitchen/CaldwellLivingRecord")
	var mara_incomplete_entry: Node = scene.get_node("Architecture/WestWingHallway/Kitchen/MaraIncompleteEntry")
	var kitchen_clock_247: Node = scene.get_node("Architecture/WestWingHallway/Kitchen/KitchenClock247")
	var evidence_wall_warning: Node3D = scene.get_node("Architecture/WestWingHallway/Kitchen/EvidenceScrapWallWarning")
	var evidence_plans: Node3D = scene.get_node("Architecture/WestWingHallway/Kitchen/EvidenceScrapPlans")
	var evidence_kitchen_recording: Node3D = scene.get_node("Architecture/WestWingHallway/Kitchen/EvidenceScrapKitchenRecording")
	var evidence_caldwell: Node3D = scene.get_node("Architecture/WestWingHallway/Kitchen/EvidenceScrapCaldwell")
	var evidence_incomplete: Node3D = scene.get_node("Architecture/WestWingHallway/Kitchen/EvidenceScrapIncomplete")
	var evidence_act_2_gate: Node3D = scene.get_node("Architecture/WestWingHallway/Kitchen/EvidenceScrapAct2Gate")

	_assert(not player.has_recorder, "Player starts without recorder")
	_assert(not player.has_item("service_key"), "Player starts without service key")
	_assert(not clock_scheduler.is_incomplete_event_armed(), "2:47 scheduler starts unarmed")
	_assert(not bool(scene.get_tree().root.get_meta("incomplete_247_armed", false)), "2:47 scheduler root state starts unarmed")
	_assert(not evidence_wall_warning.visible, "Evidence board starts with wall warning scrap hidden")
	_assert(not evidence_plans.visible, "Evidence board starts with plan scrap hidden")
	_assert(not evidence_caldwell.visible, "Evidence board starts with Caldwell record scrap hidden")
	_assert(not evidence_incomplete.visible, "Evidence board starts with Incomplete scrap hidden")
	_assert(not evidence_act_2_gate.visible, "Evidence board starts with Act 2 gate scrap hidden")
	next_route_gate.interact(player)
	await process_frame
	_assert(not bool(scene.get_tree().root.get_meta("next_route_gate_open", false)), "Next route gate starts closed")
	_assert(not _has_objective(hud, "find_conservatory_route"), "Next route gate does not reveal route before Act 1 is ready")
	first_floor_stairs.interact(player)
	await process_frame
	_assert(not bool(scene.get_tree().root.get_meta("act_2_started", false)), "First-floor stairs stay closed before Act 2 gate")
	_assert(not _has_objective(hud, "reach_gallery_landing"), "First-floor stairs do not reveal landing objective before Act 2 gate")
	gallery_landing_trigger._on_body_entered(player)
	await process_frame
	_assert(not bool(scene.get_tree().root.get_meta("gallery_landing_reached", false)), "Gallery Landing stays unwritten before staircase seed")
	chandelier_handprint.interact(player)
	await process_frame
	_assert(not bool(scene.get_tree().root.get_meta("chandelier_handprint_found", false)), "Chandelier handprint waits until Gallery Landing is reached")
	unnumbered_guest_room.interact(player)
	await process_frame
	_assert(not bool(scene.get_tree().root.get_meta("unnumbered_guest_room_found", false)), "Unnumbered guest room waits until chandelier photo proof")

	recorder.interact(player)
	await process_frame
	_assert(player.has_recorder, "Recorder pickup grants recorder")
	_assert(player.has_item("recorder"), "Recorder appears in inventory")
	_assert(_has_objective(hud, "inspect_wall"), "Recorder pickup adds wall inspection objective")
	_assert(_has_ledger_entry(hud, "recorder_found"), "Recorder pickup writes Living Ledger entry")
	_assert(hud.ledger_unread_count() > 0, "Ledger tracks unread pages after recorder pickup")

	director.use_recorder(Vector3(0, 0, 0))
	await process_frame
	_assert(_has_objective(hud, "open_west_wing"), "Wall recording adds west wing objective")
	_assert(_objective_complete(hud, "record_wall"), "Wall recording completes recorder objective")
	_assert(_has_note(hud, "wall_warning"), "Wall recording adds warning note")
	_assert(_has_ledger_entry(hud, "entrance_wall_recorded"), "Wall recording writes Living Ledger entry")
	_assert(_has_evidence(hud, "wall_warning"), "Wall recording pins evidence")
	_assert(int(scene.get_tree().root.get_meta("pending_transcription_count", 0)) > 0, "Wall recording creates pending transcription")
	_assert(evidence_wall_warning.visible, "Wall recording reveals physical evidence scrap")

	var note_count: int = hud.notes.size()
	director.use_recorder(Vector3(0, 0, 0))
	await process_frame
	_assert(hud.notes.size() == note_count, "Repeated wall recording does not add duplicate notes")

	key.interact(player)
	await process_frame
	_assert(player.has_item("service_key"), "Service key pickup grants key")

	door.interact(player)
	await process_frame
	_assert(door.is_open, "West wing door opens with key")
	_assert(_objective_complete(hud, "open_west_wing"), "Door opening completes west wing objective")

	scare._on_body_entered(player)
	await process_frame
	_assert(_has_objective(hud, "follow_west_wing"), "Hallway scare adds follow objective")
	_assert(_has_note(hud, "west_wing_shift"), "Hallway scare adds shift note")
	_assert(hud.visited_map.has("west_wing_hall"), "Hallway scare marks west wing visited")

	scare._on_body_entered(player)
	await process_frame
	_assert(_count_objective(hud, "follow_west_wing") == 1, "Hallway scare objective is one-shot")
	_assert(_count_note(hud, "west_wing_shift") == 1, "Hallway scare note is one-shot")

	plans.interact(player)
	await process_frame
	_assert(player.has_item("manor_plans"), "Manor plans pickup grants map item")
	_assert(hud.discovered_map.has("west_wing_hall"), "Manor plans reveal west wing map")
	_assert(_objective_complete(hud, "follow_west_wing"), "Manor plans complete hallway follow objective")
	_assert(_has_ledger_entry(hud, "manor_plans_found"), "Manor plans write Living Ledger entry")
	_assert(_has_evidence(hud, "manor_plans"), "Manor plans pin evidence")
	_assert(evidence_plans.visible, "Manor plans reveal physical evidence scrap")

	library_trigger._on_body_entered(player)
	await process_frame
	_assert(hud.visited_map.has("library"), "Entering the library marks it visited")
	_assert(_has_objective(hud, "listen_library_wall"), "Library entry adds wall voice objective")
	_assert(_has_note(hud, "library_found"), "Library entry adds discovery note")

	director.use_recorder(library_wall.global_position)
	await process_frame
	_assert(_objective_complete(hud, "record_library_wall"), "Library wall recording completes recorder objective")
	_assert(_has_note(hud, "library_wall_playback"), "Library wall recording adds playback note")
	_assert(hud.discovered_map.has("study"), "Library wall recording reveals the study on the map")
	_assert(library_wall.is_open_to_study, "Library wall recording opens the Study passage")
	_assert(_has_ledger_entry(hud, "library_wall_recorded"), "Library wall recording writes Living Ledger entry")
	_assert(_has_evidence(hud, "library_wall_recording"), "Library wall recording pins evidence")

	study_trigger._on_body_entered(player)
	await process_frame
	_assert(hud.visited_map.has("study"), "Entering the study marks it visited")
	_assert(_has_objective(hud, "find_tape_measure"), "Study entry adds tape measure objective")

	tape_measure.interact(player)
	await process_frame
	_assert(player.has_item("tape_measure"), "Tape measure pickup grants measurement item")
	_assert(_objective_complete(hud, "find_tape_measure"), "Tape measure pickup completes objective")
	_assert(_has_ledger_entry(hud, "tape_measure_found"), "Tape measure pickup writes Living Ledger entry")

	player.global_position = Vector3(-5.1, 0.95, -20.15)
	player.use_tape_measure_on_surface("study_wall")
	await process_frame
	_assert(_has_note(hud, "measure_study"), "Tape measure records Study measurement note")
	_assert(_has_objective(hud, "measure_library_wall"), "Study measurement adds Library wall objective")
	_assert(_has_evidence(hud, "study_measurement"), "Study measurement pins control evidence")
	_assert(_has_ledger_entry(hud, "measure_study_ledger"), "Study measurement writes Living Ledger entry")

	player.global_position = Vector3(-5.65, 0.95, -14.2)
	player.use_tape_measure_on_surface("library_wall")
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("library_missing_inch_measured", false)), "Library wall measurement exposes shelf-gap state")
	_assert(_has_note(hud, "measure_library_discrepancy"), "Tape measure records Library wall discrepancy")
	_assert(_objective_complete(hud, "measure_library_wall"), "Library wall measurement completes contradiction objective")
	_assert(_has_objective(hud, "check_shelf_gap"), "Library wall measurement adds shelf-gap objective")
	_assert(_has_objective(hud, "follow_missing_inch"), "Library wall measurement adds follow-up objective")
	_assert(_has_evidence(hud, "library_measurement"), "Library wall measurement pins required evidence")
	_assert(_has_ledger_entry(hud, "measure_library_ledger"), "Library wall measurement writes Living Ledger entry")

	library_shelf_gap.interact(player)
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("caton_margin_mark_found", false)), "Shelf gap inspection finds Caton's margin mark")
	_assert(_objective_complete(hud, "check_shelf_gap"), "Shelf gap inspection completes shelf-gap objective")
	_assert(_has_note(hud, "caton_margin_mark"), "Shelf gap inspection adds Caton mark note")
	_assert(_has_evidence(hud, "caton_margin_mark"), "Shelf gap inspection pins Caton mark evidence")
	_assert(_has_ledger_entry(hud, "caton_margin_mark"), "Shelf gap inspection writes Living Ledger entry")

	var caton_mark_note_count: int = _count_note(hud, "caton_margin_mark")
	library_shelf_gap.interact(player)
	await process_frame
	_assert(_count_note(hud, "caton_margin_mark") == caton_mark_note_count, "Repeated shelf gap inspection does not duplicate Caton mark note")

	player.global_position = Vector3(0.0, 0.95, -14.0)
	player.use_tape_measure_on_surface("west_wing_wall")
	await process_frame
	_assert(_has_note(hud, "measure_west_wing"), "Tape measure records west wing hall contradiction")
	_assert(_has_evidence(hud, "west_wing_measurement"), "West wing measurement pins evidence")
	_assert(_has_ledger_entry(hud, "measure_west_wing_ledger"), "West wing measurement writes Living Ledger entry")

	player.global_position = Vector3(5.4, 0.95, -14.4)
	dining_trigger._on_body_entered(player)
	await process_frame
	_assert(hud.visited_map.has("dining_room"), "Entering Dining Room marks it visited")
	_assert(_objective_complete(hud, "follow_missing_inch"), "Dining Room entry completes missing inch objective")
	_assert(_has_objective(hud, "inspect_dining_table"), "Dining Room entry adds table inspection objective")
	_assert(_has_note(hud, "dining_room_found"), "Dining Room entry adds discovery note")

	dining_table.interact(player)
	await process_frame
	_assert(_objective_complete(hud, "inspect_dining_table"), "Dining table inspection completes objective")
	_assert(_has_note(hud, "dining_table_setting"), "Dining table inspection adds note")
	_assert(_has_objective(hud, "measure_dining_room"), "Dining table inspection adds measurement objective")
	_assert(_has_ledger_entry(hud, "dining_table_counted"), "Dining table inspection writes Living Ledger entry")
	_assert(_has_evidence(hud, "dining_table"), "Dining table inspection pins required evidence")

	player.use_tape_measure_on_surface("dining_room")
	await process_frame
	_assert(_has_note(hud, "measure_dining_room"), "Tape measure records Dining Room contradiction")
	_assert(_objective_complete(hud, "measure_dining_room"), "Dining measurement completes objective")
	_assert(_has_objective(hud, "find_thirteenth_place"), "Dining measurement adds thirteenth place objective")
	_assert(_has_evidence(hud, "dining_measurement"), "Dining measurement pins evidence")
	_assert(_has_ledger_entry(hud, "measure_dining_ledger"), "Dining measurement writes Living Ledger entry")

	thirteenth_place.interact(player)
	await process_frame
	_assert(not _objective_complete(hud, "set_thirteenth_place"), "Thirteenth place cannot be solved without Eleanor's card")

	place_card.interact(player)
	await process_frame
	_assert(player.has_item("eleanor_place_card"), "Eleanor place card pickup grants inventory item")
	_assert(_count_objective(hud, "find_thirteenth_place") == 1, "Place card pickup keeps find objective unique")
	_assert(_objective_complete(hud, "find_thirteenth_place"), "Place card pickup completes find objective")
	_assert(_has_objective(hud, "set_thirteenth_place"), "Place card pickup adds set objective")
	_assert(_has_note(hud, "eleanor_place_card"), "Place card pickup adds note")

	thirteenth_place.interact(player)
	await process_frame
	_assert(_objective_complete(hud, "set_thirteenth_place"), "Setting Eleanor card completes puzzle objective")
	_assert(_has_note(hud, "thirteenth_place_set"), "Setting Eleanor card adds puzzle note")
	_assert(_has_objective(hud, "listen_after_eleanor"), "Setting Eleanor card adds next listening objective")
	_assert(_has_ledger_entry(hud, "eleanor_named"), "Setting Eleanor card writes Living Ledger entry")
	_assert(_has_evidence(hud, "eleanor_place_card"), "Setting Eleanor card pins required evidence")

	thirteenth_place.interact(player)
	await process_frame
	_assert(_count_note(hud, "thirteenth_place_set") == 1, "Repeated thirteenth place inspection does not duplicate puzzle note")

	director.use_recorder(thirteenth_place.global_position)
	await process_frame
	_assert(_objective_complete(hud, "listen_after_eleanor"), "Dining recorder response completes Eleanor listening objective")
	_assert(_has_note(hud, "dining_room_playback"), "Dining recorder response adds playback note")
	_assert(_has_objective(hud, "follow_table_sound"), "Dining recorder response adds Kitchen route objective")
	_assert(hud.discovered_map.has("kitchen"), "Dining recorder response reveals Kitchen map area")
	_assert(_has_ledger_entry(hud, "dining_room_recorded"), "Dining recorder response writes Living Ledger entry")
	_assert(_has_evidence(hud, "dining_room_recording"), "Dining recorder response pins evidence")
	_assert(int(scene.get_tree().root.get_meta("pending_transcription_count", 0)) > 0, "Dining recording creates Kitchen transcription work")

	var dining_note_count: int = _count_note(hud, "dining_room_playback")
	director.use_recorder(thirteenth_place.global_position)
	await process_frame
	_assert(_count_note(hud, "dining_room_playback") == dining_note_count, "Repeated Dining recorder response does not duplicate note")

	player.global_position = Vector3(5.4, 0.95, -22.4)
	kitchen_trigger._on_body_entered(player)
	await process_frame
	_assert(hud.visited_map.has("kitchen"), "Entering Kitchen marks it visited")
	_assert(_objective_complete(hud, "follow_table_sound"), "Kitchen entry completes Dining sound objective")
	_assert(_has_objective(hud, "inspect_kitchen_table"), "Kitchen entry adds table inspection objective")
	_assert(_has_objective(hud, "review_living_ledger"), "Kitchen entry adds Living Ledger objective")
	_assert(_has_note(hud, "kitchen_found"), "Kitchen entry adds discovery note")
	_assert(_has_ledger_entry(hud, "kitchen_found"), "Kitchen entry writes Living Ledger entry")
	_assert(hud.ledger_unread_count() > 0, "Ledger has unread pages before opening in Kitchen")
	_assert(player.message_label.text.contains("recorder transcription ready"), "Kitchen entry reports pending recorder transcription")

	kitchen_ledger.interact(player)
	await process_frame
	_assert(_objective_complete(hud, "review_living_ledger"), "Kitchen ledger interaction completes review objective")
	_assert(_has_note(hud, "living_ledger_found"), "Kitchen ledger interaction adds discovery note")
	_assert(_has_ledger_entry(hud, "kitchen_ledger_found"), "Kitchen ledger interaction writes its own entry")
	_assert(hud.ledger_unread_count() == 0, "Opening Kitchen ledger clears unread pages")

	evidence_board.interact(player)
	await process_frame
	_assert(_has_note(hud, "evidence_board_found"), "Evidence board interaction adds note")
	_assert(_has_ledger_entry(hud, "evidence_board_found"), "Evidence board interaction writes Living Ledger entry")
	_assert(hud.active_panel == "evidence", "Evidence board interaction opens evidence panel")
	_assert(hud.evidence_unread_count() == 0, "Evidence board review clears new evidence count")
	hud._close_panels()

	recorder_dock.interact(player)
	await process_frame
	_assert(_has_note(hud, "recorder_docked"), "Recorder dock interaction adds note")
	_assert(_has_ledger_entry(hud, "recorder_docked"), "Recorder dock interaction writes Living Ledger entry")
	_assert(_has_note(hud, "recorder_transcriptions_reviewed"), "Recorder dock reviews pending transcriptions")
	_assert(int(scene.get_tree().root.get_meta("pending_transcription_count", 0)) == 0, "Recorder dock clears pending transcriptions")

	kitchen_table.interact(player)
	await process_frame
	_assert(_objective_complete(hud, "inspect_kitchen_table"), "Kitchen table inspection completes objective")
	_assert(_has_note(hud, "kitchen_count"), "Kitchen table inspection adds thirteenth plate note")
	_assert(_has_objective(hud, "record_kitchen_wall"), "Kitchen table inspection adds recorder objective")
	_assert(_has_ledger_entry(hud, "kitchen_table_counted"), "Kitchen table inspection writes Living Ledger entry")

	player.use_tape_measure_on_surface("kitchen_wall")
	await process_frame
	_assert(_has_note(hud, "measure_kitchen"), "Tape measure records Kitchen measurement note")
	_assert(_has_ledger_entry(hud, "measure_kitchen_ledger"), "Kitchen measurement writes Living Ledger entry")
	_assert(hud.ledger_unread_count() > 0, "New ledger pages become unread after Kitchen interactions")

	director.use_recorder(kitchen_wall.global_position)
	await process_frame
	_assert(_objective_complete(hud, "record_kitchen_wall"), "Kitchen recorder response completes objective")
	_assert(_has_note(hud, "kitchen_wall_playback"), "Kitchen recorder response adds playback note")
	_assert(_has_objective(hud, "find_second_watching_room"), "Kitchen recorder response adds next route objective")
	_assert(hud.discovered_map.has("cellar_stairs"), "Kitchen recorder response reveals cellar stairs map area")
	_assert(_has_ledger_entry(hud, "kitchen_wall_recorded"), "Kitchen recorder response writes Living Ledger entry")
	_assert(_has_evidence(hud, "kitchen_wall_recording"), "Kitchen recorder response pins required evidence")
	_assert(hud.ledger_unread_count() > 0, "Kitchen recording creates unread ledger page")
	_assert(hud.evidence_unread_count() > 0, "Kitchen recording creates new evidence alert")
	_assert(int(scene.get_tree().root.get_meta("pending_transcription_count", 0)) > 0, "Kitchen recording creates pending transcription")
	_assert(hud.evidence_completion_percent() == 100, "Current Act 1 required evidence reaches 100 percent")
	_assert(evidence_kitchen_recording.visible, "Kitchen recording reveals final physical evidence scrap")
	_assert(not hud.is_act_1_ready(), "Act 1 stays locked while Kitchen hub work is pending")

	kitchen_trigger._on_body_entered(player)
	await process_frame
	_assert(player.message_label.text.contains("new ledger page"), "Kitchen return reports unread ledger")
	_assert(player.message_label.text.contains("new evidence pinned"), "Kitchen return reports unread evidence")
	_assert(player.message_label.text.contains("recorder transcription ready"), "Kitchen return reports pending transcription")
	_assert(not hud.is_act_1_ready(), "Act 1 stays locked before transcription is reviewed")

	recorder_dock.interact(player)
	await process_frame
	_assert(int(scene.get_tree().root.get_meta("pending_transcription_count", 0)) == 0, "Repeat dock clears later transcription")
	_assert(not hud.is_act_1_ready(), "Act 1 stays locked until new proof and ledger pages are reviewed")

	evidence_board.interact(player)
	await process_frame
	_assert(hud.evidence_unread_count() == 0, "Final evidence board review clears new Kitchen proof")
	_assert(not hud.is_act_1_ready(), "Act 1 stays locked until the Living Ledger is current")

	kitchen_ledger.interact(player)
	await process_frame
	_assert(hud.ledger_unread_count() == 0, "Final Living Ledger review clears all unread pages")
	_assert(hud.is_act_1_ready(), "Act 1 progression lock opens after Kitchen hub is current")
	_assert(bool(scene.get_tree().root.get_meta("act_1_ready", false)), "Act 1 ready state is exposed for the next route gate")
	_assert(_has_objective(hud, "choose_next_route"), "Act 1 readiness adds next route objective")
	_assert(_has_note(hud, "act_1_ready"), "Act 1 readiness adds journal note")
	_assert(_has_ledger_entry(hud, "act_1_ready_ledger"), "Act 1 readiness writes Living Ledger beat")

	next_route_gate.interact(player)
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("next_route_gate_open", false)), "Next route gate opens after Act 1 is ready")
	_assert(_objective_complete(hud, "choose_next_route"), "Next route gate completes choose route objective")
	_assert(_has_objective(hud, "find_conservatory_route"), "Next route gate adds Conservatory route objective")
	_assert(_has_note(hud, "next_route_conservatory"), "Next route gate records lemon-tree route note")
	_assert(_has_ledger_entry(hud, "next_route_conservatory"), "Next route gate writes Living Ledger route beat")
	_assert(hud.discovered_map.has("east_wing"), "Next route gate reveals the locked wing edge on the map")

	player.global_position = Vector3(10.8, 0.95, -22.45)
	conservatory_trigger._on_body_entered(player)
	await process_frame
	_assert(hud.visited_map.has("conservatory"), "Entering Conservatory marks it visited")
	_assert(_objective_complete(hud, "find_conservatory_route"), "Conservatory entry completes route objective")
	_assert(_has_objective(hud, "inspect_lemon_trees"), "Conservatory entry adds lemon tree objective")
	_assert(_has_note(hud, "conservatory_found"), "Conservatory entry records lemon/no-roses note")
	_assert(_has_ledger_entry(hud, "conservatory_found"), "Conservatory entry writes Living Ledger beat")

	rose_trace.interact(player)
	await process_frame
	_assert(not bool(scene.get_tree().root.get_meta("rose_scent_traced", false)), "Rose scent trace waits until lemon tree is witnessed")
	_assert(not _objective_complete(hud, "find_rose_scent_source"), "Rose scent objective cannot complete before lemon tree truth")

	player.global_position = Vector3(12.7, 0.95, -22.6)
	lemon_tree.interact(player)
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("lemon_tree_inspected", false)), "Lemon tree inspection sets story state")
	_assert(_objective_complete(hud, "inspect_lemon_trees"), "Lemon tree inspection completes objective")
	_assert(_has_note(hud, "lemon_tree_witness"), "Lemon tree inspection adds canon correction note")
	_assert(_has_evidence(hud, "lemon_tree_witness"), "Lemon tree inspection pins witness evidence")
	_assert(_has_ledger_entry(hud, "lemon_tree_witness"), "Lemon tree inspection writes Living Ledger beat")
	_assert(_has_objective(hud, "find_rose_scent_source"), "Lemon tree inspection points rose scent toward sealed wing")

	rose_trace.interact(player)
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("rose_scent_traced", false)), "Rose scent trace sets sealed-wing clue state")
	_assert(_objective_complete(hud, "find_rose_scent_source"), "Rose scent trace completes source objective")
	_assert(_has_note(hud, "rose_scent_trace"), "Rose scent trace adds sealed-wing scent note")
	_assert(_has_evidence(hud, "rose_scent_trace"), "Rose scent trace pins scent evidence")
	_assert(_has_ledger_entry(hud, "rose_scent_trace"), "Rose scent trace writes Living Ledger beat")
	_assert(_has_objective(hud, "return_rose_trace_to_kitchen"), "Rose scent trace adds Kitchen return objective")
	_assert(hud.discovered_map.has("east_wing"), "Rose scent trace keeps sealed wing edge known on the map")

	sealed_boundary.interact(player)
	await process_frame
	_assert(not bool(scene.get_tree().root.get_meta("sealed_wing_boundary_tested", false)), "Sealed boundary waits until rose trace is pinned in Kitchen")
	caldwell_record.interact(player)
	await process_frame
	_assert(not bool(scene.get_tree().root.get_meta("caldwell_record_found", false)), "Caldwell record stays blank before the sealed boundary asks for a living name")
	mara_incomplete_entry.interact(player)
	await process_frame
	_assert(not bool(scene.get_tree().root.get_meta("mara_incomplete_seeded", false)), "Mara's Incomplete entry waits for Caldwell's living record")
	_assert(not clock_scheduler.is_incomplete_event_armed(), "2:47 scheduler does not arm before Caldwell's living record")

	kitchen_trigger._on_body_entered(player)
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("rose_trace_returned", false)), "Kitchen return acknowledges rose trace")
	_assert(_objective_complete(hud, "return_rose_trace_to_kitchen"), "Kitchen return completes rose trace return objective")
	_assert(_has_note(hud, "rose_trace_pinned"), "Kitchen return records pinned scent note")
	_assert(_has_ledger_entry(hud, "rose_trace_pinned"), "Kitchen return writes pinned scent Living Ledger beat")
	_assert(_has_objective(hud, "approach_sealed_wing_edge"), "Kitchen return adds sealed boundary objective")

	sealed_boundary.interact(player)
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("sealed_wing_boundary_tested", false)), "Sealed boundary test sets route-gate state")
	_assert(_objective_complete(hud, "approach_sealed_wing_edge"), "Sealed boundary test completes approach objective")
	_assert(_has_note(hud, "sealed_wing_boundary"), "Sealed boundary test adds threshold note")
	_assert(_has_evidence(hud, "sealed_wing_boundary"), "Sealed boundary test pins threshold evidence")
	_assert(_has_ledger_entry(hud, "sealed_wing_boundary"), "Sealed boundary test writes Living Ledger beat")
	_assert(_has_objective(hud, "find_living_name"), "Sealed boundary test adds living-name objective")

	caldwell_record.interact(player)
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("caldwell_record_found", false)), "Caldwell record sets living-name state")
	_assert(_objective_complete(hud, "find_living_name"), "Caldwell record completes living-name objective")
	_assert(_has_note(hud, "caldwell_living_record"), "Caldwell record adds living-name note")
	_assert(_has_evidence(hud, "caldwell_living_record"), "Caldwell record pins living-name evidence")
	_assert(_has_ledger_entry(hud, "caldwell_living_record"), "Caldwell record writes Living Ledger beat")
	_assert(_has_objective(hud, "trace_caldwell_recruiter"), "Caldwell record adds recruiter follow-up objective")
	_assert(evidence_caldwell.visible, "Caldwell record reveals physical evidence scrap")

	mara_incomplete_entry.interact(player)
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("mara_incomplete_seeded", false)), "Mara's Incomplete entry sets countdown seed state")
	_assert(bool(scene.get_tree().root.get_meta("incomplete_countdown_seeded", false)), "Incomplete entry exposes countdown seed flag")
	_assert(clock_scheduler.is_incomplete_event_armed(), "Incomplete entry arms the first 2:47 scheduler hook")
	_assert(bool(scene.get_tree().root.get_meta("incomplete_247_armed", false)), "2:47 scheduler exposes armed root state")
	_assert(String(scene.get_tree().root.get_meta("next_247_event_id", "")) == "mara_incomplete", "2:47 scheduler reserves Mara's Incomplete event")
	_assert(hud.incomplete_countdown_active(), "Casebook exposes active Incomplete countdown state")
	_assert(hud.incomplete_status_line().contains("DECEMBER 2 / INCOMPLETE"), "Casebook exposes subtle Incomplete status line")
	_assert(hud.incomplete_status_line().contains("NEXT 2:47 RESERVED"), "Casebook exposes subtle reserved 2:47 status")
	_assert(_objective_complete(hud, "trace_caldwell_recruiter"), "Incomplete entry completes Caldwell recruiter follow-up")
	_assert(_has_note(hud, "mara_incomplete_entry"), "Incomplete entry adds December 2 note")
	_assert(_has_note(hud, "two_forty_seven_reserved"), "2:47 scheduler adds reserved page note")
	_assert(_has_evidence(hud, "mara_incomplete_entry"), "Incomplete entry pins December 2 evidence")
	_assert(_has_ledger_entry(hud, "mara_incomplete_entry"), "Incomplete entry writes Living Ledger beat")
	_assert(_has_ledger_entry(hud, "two_forty_seven_reserved"), "2:47 scheduler writes Living Ledger reservation")
	_assert(_has_objective(hud, "decode_incomplete"), "Incomplete entry adds countdown follow-up objective")
	_assert(_has_objective(hud, "watch_247_ledger"), "2:47 scheduler adds reserved-page objective")
	_assert(_has_objective(hud, "return_to_unwritten_door"), "2:47 scheduler sends Mara back to the unwritten door")
	_assert(evidence_incomplete.visible, "Incomplete entry reveals physical evidence scrap")

	kitchen_clock_247.interact(player)
	await process_frame
	_assert(not clock_scheduler.is_incomplete_event_armed(), "2:47 event clears the armed scheduler state")
	_assert(clock_scheduler.has_incomplete_event_fired(), "Kitchen clock fires the reserved 2:47 event")
	_assert(not bool(scene.get_tree().root.get_meta("incomplete_247_armed", false)), "2:47 event clears reserved root state")
	_assert(bool(scene.get_tree().root.get_meta("incomplete_247_fired", false)), "2:47 event exposes fired root state")
	_assert(String(scene.get_tree().root.get_meta("last_247_event_id", "")) == "mara_incomplete", "2:47 event records the last fired event")
	_assert(_objective_complete(hud, "watch_247_ledger"), "Kitchen clock completes the reserved-page objective")
	_assert(_has_note(hud, "two_forty_seven_incomplete"), "Kitchen clock adds 2:47 written note")
	_assert(_has_evidence(hud, "two_forty_seven_incomplete"), "Kitchen clock pins 2:47 written evidence")
	_assert(_has_ledger_entry(hud, "two_forty_seven_incomplete"), "Kitchen clock writes Living Ledger event")
	_assert(hud.incomplete_status_line().contains("2:47 WROTE: INCOMPLETE"), "Casebook shows fired 2:47 status after Kitchen clock")

	sealed_boundary.interact(player)
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("sealed_wing_transition_ready", false)), "Incomplete entry lets the sealed boundary accept the future route")
	_assert(_objective_complete(hud, "decode_incomplete"), "Sealed transition completes the Incomplete decoding objective")
	_assert(_objective_complete(hud, "return_to_unwritten_door"), "Sealed transition completes the return-to-door objective")
	_assert(_has_note(hud, "sealed_wing_transition_ready"), "Sealed transition adds future-route note")
	_assert(_has_evidence(hud, "sealed_wing_transition_ready"), "Sealed transition pins future-route evidence")
	_assert(_has_ledger_entry(hud, "sealed_wing_transition_ready"), "Sealed transition writes Living Ledger future-route beat")
	_assert(_has_objective(hud, "enter_drafted_sealed_wing"), "Sealed transition adds drafted threshold objective")

	sealed_draft_threshold.interact(player)
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("sealed_wing_draft_witnessed", false)), "Drafted threshold sets witnessed state")
	_assert(_objective_complete(hud, "enter_drafted_sealed_wing"), "Drafted threshold completes its objective")
	_assert(_has_note(hud, "sealed_wing_draft_witnessed"), "Drafted threshold adds east-west contradiction note")
	_assert(_has_evidence(hud, "sealed_wing_draft_witnessed"), "Drafted threshold pins pencil corridor evidence")
	_assert(_has_ledger_entry(hud, "sealed_wing_draft_witnessed"), "Drafted threshold writes Living Ledger pencil-corridor beat")
	_assert(_has_objective(hud, "find_eleanor_journal_map"), "Drafted threshold adds Eleanor journal-map objective")
	_assert(hud.visited_map.has("east_wing"), "Drafted threshold marks sealed wing edge visited")

	eleanor_journal_map.interact(player)
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("eleanor_journal_map_found", false)), "Eleanor journal map sets found state")
	_assert(bool(scene.get_tree().root.get_meta("impossible_corridor_seeded", false)), "Eleanor journal map seeds impossible corridor state")
	_assert(player.has_item("eleanor_journal_map"), "Eleanor journal map becomes an inventory document")
	_assert(_objective_complete(hud, "find_eleanor_journal_map"), "Eleanor journal map completes its objective")
	_assert(_has_note(hud, "eleanor_journal_map_found"), "Eleanor journal map adds the 42 ft contradiction note")
	_assert(_has_evidence(hud, "eleanor_journal_map_found"), "Eleanor journal map pins sealed-wing map evidence")
	_assert(_has_ledger_entry(hud, "eleanor_journal_map_found"), "Eleanor journal map writes Living Ledger map beat")
	_assert(_has_objective(hud, "measure_impossible_corridor"), "Eleanor journal map adds impossible-corridor measurement objective")

	player.use_tape_measure_on_surface("impossible_corridor")
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("impossible_corridor_measured", false)), "Tape measure records impossible corridor measurement state")
	_assert(_objective_complete(hud, "measure_impossible_corridor"), "Tape measure completes impossible-corridor objective")
	_assert(_has_note(hud, "measure_impossible_corridor"), "Tape measure adds impossible-corridor note")
	_assert(_has_evidence(hud, "impossible_corridor_measurement"), "Tape measure pins impossible-corridor evidence")
	_assert(_has_ledger_entry(hud, "measure_impossible_corridor_ledger"), "Tape measure writes impossible-corridor Living Ledger beat")
	_assert(_has_objective(hud, "return_impossible_measure_to_kitchen"), "Tape measure adds Kitchen return objective")

	kitchen_trigger._on_body_entered(player)
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("impossible_measure_returned", false)), "Kitchen accepts returned impossible corridor measurement")
	_assert(bool(scene.get_tree().root.get_meta("act_2_gate_seeded", false)), "Kitchen seeds Act 2 gate state from impossible measurement")
	_assert(bool(scene.get_tree().root.get_meta("first_floor_plan_unlocked", false)), "Kitchen return unlocks first-floor plan state")
	_assert(_objective_complete(hud, "return_impossible_measure_to_kitchen"), "Kitchen return completes impossible-measure objective")
	_assert(_has_note(hud, "impossible_measure_pinned"), "Kitchen return adds impossible-measure pinned note")
	_assert(_has_evidence(hud, "act_2_first_floor_gate"), "Kitchen return pins Act 2 gate evidence")
	_assert(_has_ledger_entry(hud, "impossible_measure_pinned"), "Kitchen return writes Living Ledger Act 2 gate beat")
	_assert(_has_objective(hud, "find_first_floor_stairs"), "Kitchen return adds first-floor stairs objective")
	_assert(hud.unlocked_map_floors.has("first_floor"), "Kitchen return unlocks first-floor map tab")
	_assert(evidence_act_2_gate.visible, "Evidence board reveals Act 2 gate scrap after Kitchen return")

	first_floor_stairs.interact(player)
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("act_2_started", false)), "First-floor stairs seed Act 2")
	_assert(int(scene.get_tree().root.get_meta("current_act", 0)) == 2, "First-floor stairs expose current act 2")
	_assert(bool(scene.get_tree().root.get_meta("first_floor_stairs_found", false)), "First-floor stairs set found state")
	_assert(bool(scene.get_tree().root.get_meta("first_floor_landing_seeded", false)), "First-floor stairs seed Gallery Landing route state")
	_assert(_objective_complete(hud, "find_first_floor_stairs"), "First-floor stairs complete staircase objective")
	_assert(_has_note(hud, "first_floor_stairs_found"), "First-floor stairs add route note")
	_assert(_has_evidence(hud, "first_floor_stairs_found"), "First-floor stairs pin route evidence")
	_assert(_has_ledger_entry(hud, "first_floor_stairs_found"), "First-floor stairs write Living Ledger route beat")
	_assert(_has_objective(hud, "reach_gallery_landing"), "First-floor stairs add Gallery Landing objective")

	gallery_landing_trigger._on_body_entered(player)
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("gallery_landing_reached", false)), "Gallery Landing trigger sets reached state")
	_assert(_objective_complete(hud, "reach_gallery_landing"), "Gallery Landing completes landing objective")
	_assert(hud.visited_map.has("gallery_landing"), "Gallery Landing marks its map area visited")
	_assert(_has_note(hud, "gallery_landing_reached"), "Gallery Landing adds route note")
	_assert(_has_evidence(hud, "gallery_landing_reached"), "Gallery Landing pins route evidence")
	_assert(_has_ledger_entry(hud, "gallery_landing_reached"), "Gallery Landing writes Living Ledger route beat")
	_assert(_has_objective(hud, "inspect_chandelier_handprint"), "Gallery Landing adds chandelier inspection objective")

	chandelier_handprint.interact(player)
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("chandelier_handprint_found", false)), "Chandelier inspection sets handprint state")
	_assert(bool(scene.get_tree().root.get_meta("camera_verb_seeded", false)), "Chandelier inspection seeds camera verb state")
	_assert(_objective_complete(hud, "inspect_chandelier_handprint"), "Chandelier inspection completes objective")
	_assert(_has_note(hud, "chandelier_handprint"), "Chandelier inspection adds handprint note")
	_assert(_has_evidence(hud, "chandelier_handprint"), "Chandelier inspection pins handprint evidence")
	_assert(_has_ledger_entry(hud, "chandelier_handprint"), "Chandelier inspection writes Living Ledger beat")
	_assert(_has_objective(hud, "photograph_chandelier_handprint"), "Chandelier inspection adds photo objective")
	_assert(not _has_objective(hud, "find_unnumbered_guest_room"), "Unnumbered room waits until the handprint is photographed")

	player._photograph_chandelier_handprint()
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("chandelier_handprint_photographed", false)), "Camera photo sets handprint photographed state")
	_assert(_objective_complete(hud, "photograph_chandelier_handprint"), "Camera photo completes photo objective")
	_assert(_has_note(hud, "chandelier_handprint_photo"), "Camera photo adds handprint photo note")
	_assert(_has_evidence(hud, "chandelier_handprint_photo"), "Camera photo pins photo evidence")
	_assert(_has_ledger_entry(hud, "chandelier_handprint_photo"), "Camera photo writes Living Ledger beat")
	_assert(_has_objective(hud, "find_unnumbered_guest_room"), "Camera photo adds unnumbered guest room objective")

	unnumbered_guest_room.interact(player)
	await process_frame
	_assert(bool(scene.get_tree().root.get_meta("unnumbered_guest_room_found", false)), "Unnumbered guest room sets found state")
	_assert(bool(scene.get_tree().root.get_meta("unnumbered_room_trade_seeded", false)), "Unnumbered guest room seeds bed trade state")
	_assert(_objective_complete(hud, "find_unnumbered_guest_room"), "Unnumbered guest room completes objective")
	_assert(_has_note(hud, "unnumbered_guest_room"), "Unnumbered guest room adds note")
	_assert(_has_evidence(hud, "unnumbered_guest_room"), "Unnumbered guest room pins room evidence")
	_assert(_has_ledger_entry(hud, "unnumbered_guest_room"), "Unnumbered guest room writes Living Ledger beat")
	_assert(_has_objective(hud, "test_unnumbered_bed_trade"), "Unnumbered guest room adds trade objective")

	var caldwell_note_count: int = _count_note(hud, "caldwell_living_record")
	caldwell_record.interact(player)
	await process_frame
	_assert(_count_note(hud, "caldwell_living_record") == caldwell_note_count, "Repeated Caldwell record inspection does not duplicate note")

	var incomplete_note_count: int = _count_note(hud, "mara_incomplete_entry")
	var reserved_note_count: int = _count_note(hud, "two_forty_seven_reserved")
	var fired_note_count: int = _count_note(hud, "two_forty_seven_incomplete")
	var transition_note_count: int = _count_note(hud, "sealed_wing_transition_ready")
	var draft_note_count: int = _count_note(hud, "sealed_wing_draft_witnessed")
	var eleanor_map_note_count: int = _count_note(hud, "eleanor_journal_map_found")
	var impossible_corridor_note_count: int = _count_note(hud, "measure_impossible_corridor")
	var impossible_measure_pinned_count: int = _count_note(hud, "impossible_measure_pinned")
	var first_floor_stairs_note_count: int = _count_note(hud, "first_floor_stairs_found")
	var gallery_landing_note_count: int = _count_note(hud, "gallery_landing_reached")
	var chandelier_handprint_note_count: int = _count_note(hud, "chandelier_handprint")
	var chandelier_photo_note_count: int = _count_note(hud, "chandelier_handprint_photo")
	var unnumbered_room_note_count: int = _count_note(hud, "unnumbered_guest_room")
	mara_incomplete_entry.interact(player)
	await process_frame
	_assert(_count_note(hud, "mara_incomplete_entry") == incomplete_note_count, "Repeated Incomplete entry inspection does not duplicate note")
	_assert(_count_note(hud, "two_forty_seven_reserved") == reserved_note_count, "Repeated Incomplete entry inspection does not duplicate 2:47 reservation")
	kitchen_clock_247.interact(player)
	await process_frame
	_assert(_count_note(hud, "two_forty_seven_incomplete") == fired_note_count, "Repeated Kitchen clock inspection does not duplicate 2:47 event note")
	sealed_boundary.interact(player)
	await process_frame
	_assert(_count_note(hud, "sealed_wing_transition_ready") == transition_note_count, "Repeated sealed transition inspection does not duplicate future-route note")
	sealed_draft_threshold.interact(player)
	await process_frame
	_assert(_count_note(hud, "sealed_wing_draft_witnessed") == draft_note_count, "Repeated drafted threshold inspection does not duplicate pencil-corridor note")
	eleanor_journal_map.interact(player)
	await process_frame
	_assert(_count_note(hud, "eleanor_journal_map_found") == eleanor_map_note_count, "Repeated Eleanor journal map reading does not duplicate map note")
	player.use_tape_measure_on_surface("impossible_corridor")
	await process_frame
	_assert(_count_note(hud, "measure_impossible_corridor") == impossible_corridor_note_count, "Repeated impossible corridor measurement does not duplicate note")
	kitchen_trigger._on_body_entered(player)
	await process_frame
	_assert(_count_note(hud, "impossible_measure_pinned") == impossible_measure_pinned_count, "Repeated Kitchen return does not duplicate impossible-measure note")
	first_floor_stairs.interact(player)
	await process_frame
	_assert(_count_note(hud, "first_floor_stairs_found") == first_floor_stairs_note_count, "Repeated first-floor stair inspection does not duplicate route note")
	gallery_landing_trigger._on_body_entered(player)
	await process_frame
	_assert(_count_note(hud, "gallery_landing_reached") == gallery_landing_note_count, "Repeated Gallery Landing trigger does not duplicate route note")
	chandelier_handprint.interact(player)
	await process_frame
	_assert(_count_note(hud, "chandelier_handprint") == chandelier_handprint_note_count, "Repeated chandelier inspection does not duplicate handprint note")
	player._photograph_chandelier_handprint()
	await process_frame
	_assert(_count_note(hud, "chandelier_handprint_photo") == chandelier_photo_note_count, "Repeated chandelier photo does not duplicate handprint photo note")
	unnumbered_guest_room.interact(player)
	await process_frame
	_assert(_count_note(hud, "unnumbered_guest_room") == unnumbered_room_note_count, "Repeated unnumbered room inspection does not duplicate note")
	hud.open_ledger()
	await process_frame
	_assert(hud.ledger_content.text.contains("BLACK BOOK: MARA VOSS / DECEMBER 2 / INCOMPLETE / 2:47 WROTE: INCOMPLETE"), "Living Ledger shows subtle Incomplete scheduler line")
	hud.open_evidence_board()
	await process_frame
	_assert(hud.evidence_content.text.contains("BLACK BOOK: MARA VOSS / DECEMBER 2 / INCOMPLETE / 2:47 WROTE: INCOMPLETE"), "Evidence board shows subtle Incomplete scheduler line")
	hud._close_panels()

	var rose_note_count: int = _count_note(hud, "rose_scent_trace")
	rose_trace.interact(player)
	await process_frame
	_assert(_count_note(hud, "rose_scent_trace") == rose_note_count, "Repeated rose scent trace does not duplicate note")

	player.use_tape_measure_on_surface("conservatory")
	await process_frame
	_assert(_has_note(hud, "measure_conservatory"), "Tape measure records Conservatory contradiction")
	_assert(_has_ledger_entry(hud, "measure_conservatory_ledger"), "Conservatory measurement writes Living Ledger entry")

	var kitchen_note_count: int = _count_note(hud, "kitchen_wall_playback")
	director.use_recorder(kitchen_wall.global_position)
	await process_frame
	_assert(_count_note(hud, "kitchen_wall_playback") == kitchen_note_count, "Repeated Kitchen recorder response does not duplicate note")

	if failures.is_empty():
		print("SMOKE PLAYTHROUGH PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)

func _assert(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func _has_objective(hud: Node, id: String) -> bool:
	return _count_objective(hud, id) > 0

func _objective_complete(hud: Node, id: String) -> bool:
	for objective in hud.objectives:
		if objective.id == id:
			return objective.complete
	return false

func _count_objective(hud: Node, id: String) -> int:
	var count := 0
	for objective in hud.objectives:
		if objective.id == id:
			count += 1
	return count

func _has_note(hud: Node, id: String) -> bool:
	return _count_note(hud, id) > 0

func _count_note(hud: Node, id: String) -> int:
	var count := 0
	for note in hud.notes:
		if note.id == id:
			count += 1
	return count

func _has_ledger_entry(hud: Node, id: String) -> bool:
	for entry in hud.ledger_entries:
		if entry.id == id:
			return true
	return false

func _has_evidence(hud: Node, id: String) -> bool:
	for item in hud.evidence_items:
		if item.id == id:
			return true
	return false

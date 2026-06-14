extends CharacterBody3D

@export var mouse_sensitivity := 0.0025
@export var keyboard_turn_speed := 2.2
@export var walk_speed := 3.2
@export var gravity := 14.0
@export var director_path: NodePath
@export var prompt_label_path: NodePath
@export var message_label_path: NodePath

@onready var camera: Camera3D = $Camera3D
@onready var ray: RayCast3D = $Camera3D/InteractRay
@onready var prompt_label: Label = get_node(prompt_label_path)
@onready var message_label: Label = get_node(message_label_path)
@onready var director: Node = get_node(director_path)
@onready var journal_ui: CanvasLayer = prompt_label.get_parent()

var inventory := {}
var has_recorder := false
var look_pitch := 0.0
var message_time := 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ray.collide_with_areas = true
	add_inventory_item("camera", "Camera", "Press C to photograph proof the house tries to move.")
	show_message("Press J for journal. Press L for the Living Ledger once the Kitchen reveals it.", 6.0)

func _unhandled_input(event: InputEvent) -> void:
	var ui_panel_open: bool = bool(get_tree().root.get_meta("ui_panel_open", false))
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		look_pitch = clamp(look_pitch - event.relative.y * mouse_sensitivity, deg_to_rad(-82), deg_to_rad(82))
		camera.rotation.x = look_pitch
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseButton and event.pressed and not ui_panel_open:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if ui_panel_open:
		return
	if event.is_action_pressed("interact"):
		_try_interact()
	if event.is_action_pressed("use_recorder"):
		_use_recorder()
	if event.is_action_pressed("use_tape_measure"):
		_use_tape_measure()
	if event.is_action_pressed("use_camera"):
		_use_camera()

func _physics_process(delta: float) -> void:
	if get_tree().root.get_meta("ui_panel_open", false):
		velocity = Vector3.ZERO
		move_and_slide()
		_update_message(delta)
		return
	var turn_axis := Input.get_axis("turn_left", "turn_right")
	if not is_zero_approx(turn_axis):
		rotate_y(-turn_axis * keyboard_turn_speed * delta)
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var wish_dir := (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	velocity.x = wish_dir.x * walk_speed
	velocity.z = wish_dir.z * walk_speed
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = -0.1
	move_and_slide()
	_update_prompt()
	_update_message(delta)

func add_item(item_id: String) -> void:
	inventory[item_id] = true

func add_inventory_item(item_id: String, item_name: String, description: String) -> void:
	add_item(item_id)
	if journal_ui.has_method("add_inventory_item"):
		journal_ui.add_inventory_item(item_id, item_name, description)

func remove_inventory_item(item_id: String) -> void:
	inventory.erase(item_id)
	if journal_ui.has_method("remove_inventory_item"):
		journal_ui.remove_inventory_item(item_id)

func has_item(item_id: String) -> bool:
	return inventory.has(item_id)

func give_recorder() -> void:
	has_recorder = true
	add_inventory_item("recorder", "Recorder", "Use near walls that whisper.")
	add_journal_objective("inspect_wall", "Inspect the wall that seems to breathe.")
	complete_journal_objective("find_recorder")
	show_message("Recorder acquired. Press R near strange walls. When the red light glows, Mara is close to a voice trapped in the house.", 7.0)

func add_journal_objective(id: String, text: String) -> void:
	if journal_ui.has_method("add_objective"):
		journal_ui.add_objective(id, text)

func complete_journal_objective(id: String) -> void:
	if journal_ui.has_method("complete_objective"):
		journal_ui.complete_objective(id)

func add_journal_note(id: String, text: String) -> void:
	if journal_ui.has_method("add_note"):
		journal_ui.add_note(id, text)

func add_ledger_entry(id: String, text: String, title := "") -> void:
	if journal_ui.has_method("add_ledger_entry"):
		journal_ui.add_ledger_entry(id, text, title)

func open_ledger() -> void:
	if journal_ui.has_method("open_ledger"):
		journal_ui.open_ledger()

func ledger_unread_count() -> int:
	if journal_ui.has_method("ledger_unread_count"):
		return journal_ui.ledger_unread_count()
	return 0

func evidence_unread_count() -> int:
	if journal_ui.has_method("evidence_unread_count"):
		return journal_ui.evidence_unread_count()
	return 0

func add_evidence(id: String, title: String, detail: String, category := "Evidence") -> void:
	if journal_ui.has_method("add_evidence"):
		journal_ui.add_evidence(id, title, detail, category)

func open_evidence_board() -> void:
	if journal_ui.has_method("open_evidence_board"):
		journal_ui.open_evidence_board()

func evidence_completion_percent() -> int:
	if journal_ui.has_method("evidence_completion_percent"):
		return journal_ui.evidence_completion_percent()
	return 0

func is_act_1_ready() -> bool:
	if journal_ui.has_method("is_act_1_ready"):
		return journal_ui.is_act_1_ready()
	return false

func reveal_map_area(id: String) -> void:
	if journal_ui.has_method("reveal_map_area"):
		journal_ui.reveal_map_area(id)

func visit_map_area(id: String) -> void:
	if journal_ui.has_method("visit_map_area"):
		journal_ui.visit_map_area(id)

func unlock_map_floor(id: String) -> void:
	if journal_ui.has_method("unlock_map_floor"):
		journal_ui.unlock_map_floor(id)

func use_recorder_from_inventory() -> void:
	_use_recorder()

func use_tape_measure_from_inventory() -> void:
	_use_tape_measure()

func use_camera_from_inventory() -> void:
	_use_camera()

func use_clock_pendulum_from_inventory() -> void:
	if not has_item("clock_pendulum"):
		show_message("Mara reaches for the pendulum, then remembers she has not found it.")
		return
	var hall_clock := get_node_or_null("/root/Main/Architecture/HallGrandfatherClock")
	if hall_clock == null or not hall_clock.has_method("interact"):
		show_message("The pendulum is heavy in Mara's hand. Somewhere, a clock is waiting for it.", 6.0)
		return
	if global_position.distance_to(hall_clock.global_position) > 5.0:
		show_message("The pendulum belongs to the Entrance Hall grandfather clock.", 6.0)
		return
	hall_clock.interact(self)

func use_tape_measure_on_surface(surface_id: String) -> void:
	if not has_item("tape_measure"):
		show_message("Mara reaches for the tape measure, then remembers she has not found it.")
		return
	_apply_tape_measurement(surface_id)

func show_message(text: String, duration := 4.0) -> void:
	message_label.text = text
	message_time = duration

func _try_interact() -> void:
	if not ray.is_colliding():
		return
	var target := ray.get_collider()
	if target != null and target.has_method("interact"):
		target.interact(self)

func _use_recorder() -> void:
	if not has_recorder:
		show_message("Mara reaches for the recorder, then remembers it is missing.")
		return
	if director.has_method("use_recorder"):
		director.use_recorder(global_position)

func _use_tape_measure() -> void:
	if not has_item("tape_measure"):
		var area := _current_measurement_area()
		if area == "study":
			show_message("The tape measure is on Thomas's desk. Aim at it and press E before using T.", 6.0)
		else:
			show_message("Mara reaches for the tape measure, then remembers she has not found it.")
		return
	var surface_id := _current_measurement_surface()
	if surface_id != "":
		_apply_tape_measurement(surface_id)
		return
	var area := _current_measurement_area()
	if area == "study":
		_apply_tape_measurement("study")
	elif area == "west_wing_hall":
		_apply_tape_measurement("west_wing_hall")
	elif area == "library":
		_apply_tape_measurement("library")
	elif area == "dining_room":
		_apply_tape_measurement("dining_room")
	elif area == "kitchen":
		_apply_tape_measurement("kitchen")
	elif area == "conservatory":
		_apply_tape_measurement("conservatory")
	else:
		_apply_tape_measurement("entrance_hall")

func _use_camera() -> void:
	if not has_item("camera"):
		show_message("Mara reaches for the camera, then remembers she left it with the rest of her certainty.")
		return
	if not bool(get_tree().root.get_meta("camera_verb_seeded", false)):
		show_message("The camera waits. Mara needs something the house has visibly touched.", 5.0)
		return
	var subject_id := _current_photo_subject()
	if subject_id == "chandelier_handprint":
		_photograph_chandelier_handprint()
	else:
		show_message("The shutter clicks, but the frame gives Mara nothing the board can use yet.", 5.0)

func _photograph_chandelier_handprint() -> void:
	if not bool(get_tree().root.get_meta("chandelier_handprint_found", false)):
		show_message("The camera will not make sense of the chandelier until Mara inspects the links.")
		return
	if bool(get_tree().root.get_meta("chandelier_handprint_photographed", false)):
		show_message("The photo already holds the opened links and the long handprint.", 5.0)
		return
	get_tree().root.set_meta("chandelier_handprint_photographed", true)
	complete_journal_objective("photograph_chandelier_handprint")
	add_journal_note("chandelier_handprint_photo", "The camera caught the chandelier handprint before the dust could settle into something more ordinary.")
	add_ledger_entry(
		"chandelier_handprint_photo",
		"Mara photographed the opened links. In the picture, the long fingers looked closer to the lens than they had been in the room.",
		"2:47 AM - Proof In The Glass"
	)
	add_evidence(
		"chandelier_handprint_photo",
		"Photograph: Opened Chandelier Links",
		"The camera records the long handprint and opened chain links before the house can explain them away.",
		"Photo"
	)
	add_journal_objective("find_unnumbered_guest_room", "Find the guest bedroom that the First Floor plan refuses to number.")
	show_message("The camera catches the opened links. In the photo, the fingers look too close.", 7.0)

func _apply_tape_measurement(surface_id: String) -> void:
	if _try_apply_caton_overlay(surface_id):
		return
	if surface_id == "study" or surface_id == "study_wall":
		show_message("Study: 12 ft by 9 ft. The numbers behave. That makes Mara more nervous.", 6.0)
		add_journal_note("measure_study", "The Study measures true. Honest rooms may be control samples.")
		add_evidence("study_measurement", "Study Control Measurement", "The Study measures true, giving Mara a control sample for rooms that do not.", "Measurement")
		add_ledger_entry("measure_study_ledger", "Thomas's Study measured twelve feet by nine. A room that told the truth felt less comforting than a room that lied.", "2:47 AM - Control Measurement")
		add_journal_objective("measure_library_wall", "Measure the Library wall the shelves were facing.")
	elif surface_id == "library_wall":
		show_message("Library wall: 18 ft by 14 ft, but one inch vanishes behind the shelf line.", 7.0)
		get_tree().root.set_meta("library_missing_inch_measured", true)
		add_journal_note("measure_library_discrepancy", "The Library wall is missing one inch. The house is not hiding rooms; it is shaving truth from them.")
		add_evidence("library_measurement", "Library Missing Inch", "The tape measure proves the Library wall is one inch shorter than the room should allow.", "Measurement")
		add_ledger_entry("measure_library_ledger", "The Library wall lost an inch under the tape. Mara wrote the number down before the house could decide it had always been otherwise.", "2:47 AM - The Missing Inch")
		complete_journal_objective("measure_library_wall")
		add_journal_objective("check_shelf_gap", "Check the shelf gap where the inch disappears.")
		add_journal_objective("follow_missing_inch", "Follow the missing inch toward the Dining Room.")
	elif surface_id == "west_wing_hall" or surface_id == "west_wing_wall":
		show_message("West Wing Hall: Caton's plan says 42 ft. The tape says 47.", 7.0)
		add_journal_note("measure_west_wing", "The west wing hall is five feet longer under the tape than it is on Caton's plan.")
		add_evidence("west_wing_measurement", "West Wing Hall Mismatch", "Caton's plan says 42 ft. The tape says 47 ft.", "Measurement")
		add_ledger_entry("measure_west_wing_ledger", "Caton gave the west wing forty-two feet. Ashford Manor kept five more for itself.", "2:47 AM - Forty-Seven Feet")
		complete_journal_objective("measure_west_wing")
		add_journal_objective("follow_missing_inch", "Follow the missing inch toward the Dining Room.")
	elif surface_id == "library":
		show_message("Library: 18 ft by 14 ft, but the shelves leave one inch unaccounted for.", 6.0)
		add_journal_note("measure_library", "The Library is almost honest. One inch disappears behind the shelf wall.")
		add_journal_objective("measure_library_wall", "Measure the Library wall the shelves were facing.")
	elif surface_id == "dining_room" or surface_id == "dining_wall":
		show_message("Dining Room: 21 ft by 13 ft. The table is built for twelve, but the room holds thirteen places.", 7.0)
		add_journal_note("measure_dining_room", "The Dining Room dimensions hold an extra place setting the floor plan cannot account for.")
		add_evidence("dining_measurement", "Dining Room Thirteenth Space", "The Dining Room measurements support the impossible thirteenth place setting.", "Measurement")
		add_ledger_entry("measure_dining_ledger", "The Dining Room held its shape and still made room for a thirteenth place. Mara preferred a lying room to an honest one with appetite.", "2:47 AM - Thirteen In Twelve")
		complete_journal_objective("measure_dining_room")
		add_journal_objective("find_thirteenth_place", "Find what belongs in the thirteenth place.")
		if has_item("eleanor_place_card"):
			complete_journal_objective("find_thirteenth_place")
			add_journal_objective("set_thirteenth_place", "Set Eleanor's card at the thirteenth place.")
	elif surface_id == "kitchen" or surface_id == "kitchen_wall":
		show_message("Kitchen: 16 ft by 11 ft. The tape stays honest, but the warm plate does not.", 7.0)
		add_journal_note("measure_kitchen", "The Kitchen measures cleanly. The lie is not in the room's size; it is in what the room remembers serving.")
		add_ledger_entry("measure_kitchen_ledger", "The Kitchen measured cleanly. Sixteen by eleven. The tape could not account for the warm plate.", "2:47 AM - Honest Kitchen")
	elif surface_id == "conservatory" or surface_id == "conservatory_wall":
		show_message("Conservatory: 18 ft by 10 ft. The glass agrees. The lemon tree does not.", 7.0)
		add_journal_note("measure_conservatory", "The Conservatory frame measures true, but the lemon tree sits one pace closer than the plan allows.")
		add_ledger_entry("measure_conservatory_ledger", "The Conservatory glass accepted the tape. The lemon tree did not. Mara wrote down the numbers and then the scent changed.", "2:47 AM - Lemon Measure")
	elif surface_id == "impossible_corridor" or surface_id == "sealed_wing_draft":
		if not bool(get_tree().root.get_meta("eleanor_journal_map_found", false)):
			show_message("The tape slides over pencil and refuses to catch. Mara needs Eleanor's map before the number means anything.", 7.0)
			return
		show_message("Eleanor wrote 42 ft. The tape reaches 47, then retracts to 42 while Mara is still holding it.", 8.0)
		get_tree().root.set_meta("impossible_corridor_measured", true)
		add_journal_note("measure_impossible_corridor", "Eleanor's sealed-wing corridor measures 47 ft under the tape, then rewrites itself back to 42 ft.")
		add_evidence("impossible_corridor_measurement", "Impossible Corridor Measurement", "Eleanor's map says 42 ft. Mara's tape reaches 47 ft before the house corrects the number.", "Measurement")
		add_ledger_entry("measure_impossible_corridor_ledger", "The sealed corridor gave Mara forty-seven feet and then took five of them back while the tape was still warm in her hand.", "2:47 AM - The Borrowed Five Feet")
		complete_journal_objective("measure_impossible_corridor")
		add_journal_objective("return_impossible_measure_to_kitchen", "Return the impossible measurement to the Kitchen evidence board.")
	else:
		show_message("The tape ticks against skirting and damp plaster. Nothing here argues with the plan yet.", 5.0)
		add_journal_note("measure_entrance_hall", "The entrance hall has not started lying in numbers yet.")
		add_ledger_entry("measure_entrance_ledger", "The entrance hall gave the tape no contradiction. Mara distrusted its manners.", "2:47 AM - Entrance Control")

func _try_apply_caton_overlay(surface_id: String) -> bool:
	if not bool(get_tree().root.get_meta("caton_overlay_unlocked", false)) and not has_item("caton_field_book"):
		return false
	if surface_id == "west_wing_hall" or surface_id == "west_wing_wall":
		show_message("Caton's overlay writes over the tape: SUBMITTED 42 ft. TRUE 47 ft. The missing five feet are waiting.", 8.0)
		get_tree().root.set_meta("caton_overlay_west_wing_read", true)
		add_journal_note("caton_overlay_west_wing", "Caton's Field Book overlays submitted and true measurements: West Wing Hall submitted 42 ft, true 47 ft.")
		add_evidence("caton_overlay_west_wing", "Caton Overlay: West Wing Hall", "Caton's Field Book proves the plan and the tape are recording two different Ashford Manors.", "Measurement")
		add_ledger_entry("caton_overlay_west_wing", "Caton's figures did not correct the tape. They corrected Mara. Submitted: forty-two feet. True: forty-seven. The house had kept the missing five like a breath.", "2:47 AM - Submitted And True")
		complete_journal_objective("use_caton_field_book")
		add_journal_objective("measure_attic_void_with_caton", "Use Caton's overlay on the attic void that should not have dimensions.")
		return true
	if surface_id == "attic_void" or surface_id == "attic_void_wall":
		if not bool(get_tree().root.get_meta("long_attic_wire_traced", false)):
			show_message("Caton's figures blur at the attic wall. Mara needs to know which wire enters it first.", 7.0)
			return true
		show_message("Caton's overlay cannot fill the void: OUTSIDE 9 x 12 ft. CHAIN 41 ft. NO ACCESS.", 8.0)
		get_tree().root.set_meta("caton_overlay_attic_void_read", true)
		get_tree().root.set_meta("attic_void_measurement_proved", true)
		add_journal_note("caton_overlay_attic_void", "Caton's overlay fails around the attic void: exterior walls say 9 by 12 ft, but Caton's chain paid out 41 ft through the wire hole.")
		add_evidence("caton_overlay_attic_void", "Caton Overlay: Attic Void", "Exterior: 9 by 12 ft. Chain through the wire hole: 41 ft. The map refuses to fill the room-shaped absence.", "Measurement")
		add_ledger_entry("caton_overlay_attic_void", "Caton's Field Book drew numbers around the void, never inside it. Nine by twelve outside. Forty-one feet of chain swallowed through the wire hole. The room did not open. It filed the attempt.", "2:47 AM - The Room That Refused")
		complete_journal_objective("measure_attic_void_with_caton")
		add_journal_objective("record_attic_void_wall", "Use the recorder on the attic void wall.")
		return true
	if surface_id == "library_wall":
		show_message("Caton's overlay finds the Library lie: SUBMITTED 14 ft. TRUE 13 ft 11 in. One inch was filed away.", 7.0)
		get_tree().root.set_meta("caton_overlay_library_read", true)
		add_journal_note("caton_overlay_library", "Caton's overlay confirms the Library shelf wall lost exactly one inch between survey and truth.")
		add_evidence("caton_overlay_library", "Caton Overlay: Library Inch", "Submitted: 14 ft. True: 13 ft 11 in. Caton annotated the missing inch before Mara found it.", "Measurement")
		complete_journal_objective("use_caton_field_book")
		return true
	if surface_id == "study" or surface_id == "study_wall":
		show_message("Caton's overlay agrees with the tape: SUBMITTED 12 ft. TRUE 12 ft. A control sample.", 6.0)
		get_tree().root.set_meta("caton_overlay_study_read", true)
		add_journal_note("caton_overlay_study", "Caton's overlay agrees with the Study measurement. Some rooms tell the truth so the lies have something to stand beside.")
		complete_journal_objective("use_caton_field_book")
		return true
	return false

func _current_measurement_surface() -> String:
	if not ray.is_colliding():
		return ""
	var target := ray.get_collider()
	if target == null:
		return ""
	var target_name := String(target.name)
	if target_name.begins_with("Study"):
		return "study_wall"
	if target_name == "LibraryWhisperWall" or target_name == "LibraryLeftWall" or target_name == "LibraryFrontWall":
		return "library_wall"
	if target_name == "HallLeftWall" or target_name == "HallRightWall" or target_name == "HallEndWall":
		return "west_wing_wall"
	if target_name == "LongAtticBackWall" or target_name == "AtticVoidWall":
		return "attic_void_wall"
	if target_name.begins_with("Dining"):
		return "dining_room"
	if target_name.begins_with("Kitchen"):
		return "kitchen_wall"
	if target_name.begins_with("Conservatory") or target_name == "LemonTree":
		return "conservatory_wall"
	if target_name == "SealedWingDraftThreshold":
		return "impossible_corridor"
	return ""

func _current_photo_subject() -> String:
	if not ray.is_colliding():
		return ""
	var target := ray.get_collider()
	if target == null:
		return ""
	var target_name := String(target.name)
	if target_name == "ChandelierHandprint":
		return "chandelier_handprint"
	return ""

func _current_measurement_area() -> String:
	var pos := global_position
	if pos.x < -2.5 and pos.z < -18.0:
		return "study"
	if pos.x < -2.5 and pos.z < -11.0:
		return "library"
	if pos.x > 2.5 and pos.z < -10.5 and pos.z > -18.6:
		return "dining_room"
	if pos.x > 9.0 and pos.z < -18.0 and pos.z > -26.4:
		return "conservatory"
	if pos.x > 2.5 and pos.z < -19.0 and pos.z > -25.8:
		return "kitchen"
	if pos.z < -8.0:
		return "west_wing_hall"
	return "entrance_hall"

func _update_prompt() -> void:
	prompt_label.text = ""
	if ray.is_colliding():
		var target := ray.get_collider()
		if target != null and target.has_method("get_prompt"):
			prompt_label.text = target.get_prompt(self)

func _update_message(delta: float) -> void:
	if message_time > 0.0:
		message_time -= delta
		if message_time <= 0.0:
			message_label.text = ""

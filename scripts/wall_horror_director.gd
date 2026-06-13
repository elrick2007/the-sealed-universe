extends Node

@export var player_path: NodePath
@export var message_label_path: NodePath
@export var whisper_wall_path: NodePath
@export var library_wall_path: NodePath
@export var dining_place_path: NodePath
@export var dining_light_path: NodePath
@export var kitchen_wall_path: NodePath
@export var kitchen_light_path: NodePath
@export var hall_light_path: NodePath
@export var door_path: NodePath

@onready var player: Node = get_node(player_path)
@onready var message_label: Label = get_node(message_label_path)
@onready var whisper_wall: MeshInstance3D = get_node(whisper_wall_path)
@onready var library_wall: Node3D = get_node_or_null(library_wall_path)
@onready var dining_place: Node3D = get_node_or_null(dining_place_path)
@onready var dining_light: OmniLight3D = get_node_or_null(dining_light_path)
@onready var kitchen_wall: Node3D = get_node_or_null(kitchen_wall_path)
@onready var kitchen_light: OmniLight3D = get_node_or_null(kitchen_light_path)
@onready var hall_light: OmniLight3D = get_node(hall_light_path)
@onready var door: StaticBody3D = get_node(door_path)

var recorder_uses := 0
var scare_active := false
var scare_time := 0.0
var original_light_energy := 0.0
var original_wall_material: Material
var wall_recorded := false
var library_wall_recorded := false
var dining_room_recorded := false
var kitchen_wall_recorded := false

func _ready() -> void:
	original_light_energy = hall_light.light_energy
	original_wall_material = whisper_wall.material_override

func _mark_transcription_ready() -> void:
	var pending := int(get_tree().root.get_meta("pending_transcription_count", 0))
	get_tree().root.set_meta("pending_transcription_count", pending + 1)

func use_recorder(origin: Vector3) -> void:
	if library_wall != null and origin.distance_to(library_wall.global_position) <= 5.2:
		_record_library_wall()
		return
	if dining_place != null and origin.distance_to(dining_place.global_position) <= 5.4:
		_record_dining_room()
		return
	if kitchen_wall != null and origin.distance_to(kitchen_wall.global_position) <= 5.4:
		_record_kitchen_wall()
		return
	var distance := origin.distance_to(whisper_wall.global_position)
	if distance > 5.5:
		player.show_message("The recorder catches only rain, pipes, and Mara's breathing.")
		return
	if wall_recorded:
		player.show_message("The recorder finds only the same damp silence. This wall has given up its voice.")
		return
	recorder_uses += 1
	wall_recorded = true
	get_tree().root.set_meta("entrance_wall_recorded", true)
	_mark_transcription_ready()
	player.show_message("Playback: 'Do not open the west wing.'")
	player.add_journal_objective("record_wall", "Use the recorder on the whisper wall.")
	player.complete_journal_objective("inspect_wall")
	player.complete_journal_objective("record_wall")
	player.add_journal_note("wall_warning", "Playback from the wall: Do not open the west wing.")
	player.add_ledger_entry("entrance_wall_recorded", "The first wall spoke in warning. Mara wrote the words down because writing them made them seem less like a command.", "2:47 AM - The First Wall")
	player.add_evidence("wall_warning", "Entrance Wall Recording", "The wall warns Mara not to open the west wing.", "Recording")
	player.add_journal_objective("open_west_wing", "Open the west wing door.")
	_start_wall_scare()

func _record_library_wall() -> void:
	if library_wall_recorded:
		player.show_message("The Library wall replays only a soft scratch beneath the plaster.")
		return
	library_wall_recorded = true
	get_tree().root.set_meta("library_wall_recorded", true)
	_mark_transcription_ready()
	player.show_message("Playback: 'The shelves face the room that is missing from the map.'")
	player.complete_journal_objective("listen_library_wall")
	player.add_journal_objective("record_library_wall", "Use the recorder on the Library wall.")
	player.complete_journal_objective("record_library_wall")
	player.add_journal_note("library_wall_playback", "Playback from the Library wall: The shelves face the room that is missing from the map.")
	player.add_ledger_entry("library_wall_recorded", "The Library shelves faced a room Caton had not drawn. Mara began to understand that omission was another kind of architecture.", "2:47 AM - The Missing Room")
	player.add_evidence("library_wall_recording", "Library Wall Recording", "The shelves face a missing room that Caton's plan does not admit.", "Recording")
	player.add_journal_objective("find_missing_room", "Find what the Library shelves are facing.")
	player.reveal_map_area("study")
	if library_wall.has_method("reveal_study_passage"):
		library_wall.reveal_study_passage()

func _record_dining_room() -> void:
	if not bool(get_tree().root.get_meta("eleanor_named", false)):
		player.show_message("The recorder catches a knife tapping once, then stopping.")
		return
	if dining_room_recorded:
		player.show_message("The Dining Room has gone still. Eleanor's name remains where Mara left it.")
		return
	dining_room_recorded = true
	get_tree().root.set_meta("dining_room_recorded", true)
	_mark_transcription_ready()
	if dining_light:
		dining_light.light_energy = 0.42
	player.show_message("Playback: 'Count the rooms that watched her eat. Start with the kitchen.'", 8.0)
	player.complete_journal_objective("listen_after_eleanor")
	player.add_journal_note("dining_room_playback", "Playback from the Dining Room: Count the rooms that watched her eat. Start with the kitchen.")
	player.add_ledger_entry("dining_room_recorded", "After Eleanor's place was named, the Dining Room answered. It did not sound relieved. It sounded hungry.", "2:47 AM - Eleanor's Place")
	player.add_evidence("dining_room_recording", "Dining Room Recording", "After Eleanor is named, the Dining Room tells Mara to count the watching rooms.", "Recording")
	player.add_journal_objective("follow_table_sound", "Follow Eleanor's table sound toward the Kitchen.")
	player.reveal_map_area("kitchen")

func _record_kitchen_wall() -> void:
	if not bool(get_tree().root.get_meta("dining_room_recorded", false)):
		player.show_message("The Kitchen wall waits for the table to name its guest.")
		return
	if kitchen_wall_recorded:
		player.show_message("The Kitchen wall gives only a dry scrape, like a plate being turned over.")
		return
	kitchen_wall_recorded = true
	get_tree().root.set_meta("kitchen_wall_recorded", true)
	_mark_transcription_ready()
	if kitchen_light:
		kitchen_light.light_energy = 0.48
	player.show_message("Playback: 'The first room watched hunger. The second watched the bargain.'", 8.0)
	player.add_journal_objective("record_kitchen_wall", "Use the recorder on the Kitchen wall.")
	player.complete_journal_objective("record_kitchen_wall")
	player.add_journal_note("kitchen_wall_playback", "Playback from the Kitchen wall: The first room watched hunger. The second watched the bargain.")
	player.add_ledger_entry("kitchen_wall_recorded", "The Kitchen wall spoke of hunger and bargain. In the ledger, the sentence appeared before Mara finished hearing it.", "2:47 AM - Hunger And Bargain")
	player.add_evidence("kitchen_wall_recording", "Kitchen Wall Recording", "The Kitchen identifies hunger and bargain as separate witnessed events.", "Recording")
	player.add_journal_objective("find_second_watching_room", "Find the second room that watched Eleanor eat.")
	player.reveal_map_area("cellar_stairs")

func _process(delta: float) -> void:
	if not scare_active:
		return
	scare_time -= delta
	hall_light.light_energy = original_light_energy + sin(Time.get_ticks_msec() * 0.03) * 1.3
	if scare_time <= 0.0:
		scare_active = false
		hall_light.light_energy = original_light_energy
		whisper_wall.material_override = original_wall_material

func _start_wall_scare() -> void:
	scare_active = true
	scare_time = 4.0
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.19, 0.03, 0.025)
	mat.emission_enabled = true
	mat.emission = Color(0.7, 0.03, 0.02)
	mat.emission_energy_multiplier = 0.35
	whisper_wall.material_override = mat

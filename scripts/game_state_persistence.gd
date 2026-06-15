extends RefCounted

const SAVE_PATH := "user://book1_save.json"
const SAVE_VERSION := 1

static func save_game(player: Node, casebook: Node) -> bool:
	var data := {
		"version": SAVE_VERSION,
		"root_meta": _collect_root_meta(player.get_tree().root),
		"player": _collect_player_state(player),
		"casebook": casebook.get_persisted_state() if casebook != null and casebook.has_method("get_persisted_state") else {}
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(data, "\t"))
	return true

static func load_game(player: Node, casebook: Node) -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return false
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return false
	var data = json.data
	if typeof(data) != TYPE_DICTIONARY:
		return false
	_apply_root_meta(player.get_tree().root, data.get("root_meta", {}))
	_apply_player_state(player, data.get("player", {}))
	if casebook != null and casebook.has_method("apply_persisted_state"):
		casebook.apply_persisted_state(data.get("casebook", {}))
	return true

static func save_exists() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

static func _collect_root_meta(root: Window) -> Dictionary:
	var state := {}
	for key in root.get_meta_list():
		var key_string := String(key)
		if key_string == "ui_panel_open":
			continue
		var value = root.get_meta(key)
		if _is_json_safe(value):
			state[key_string] = value
	return state

static func _apply_root_meta(root: Window, state: Dictionary) -> void:
	for key in state:
		root.set_meta(String(key), state[key])
	root.set_meta("ui_panel_open", false)

static func _collect_player_state(player: Node) -> Dictionary:
	var inventory_keys: Array[String] = []
	for item_id in player.inventory.keys():
		inventory_keys.append(String(item_id))
	return {
		"position": _vector3_to_dictionary(player.global_position),
		"rotation_y": player.rotation.y,
		"look_pitch": player.look_pitch,
		"inventory": inventory_keys,
		"has_recorder": bool(player.has_recorder)
	}

static func _apply_player_state(player: Node, state: Dictionary) -> void:
	if state.has("position"):
		player.global_position = _dictionary_to_vector3(state.position)
	if state.has("rotation_y"):
		player.rotation.y = float(state.rotation_y)
	player.look_pitch = float(state.get("look_pitch", player.look_pitch))
	var camera := player.get_node_or_null("Camera3D")
	if camera != null:
		camera.rotation.x = player.look_pitch
	player.inventory.clear()
	for item_id in state.get("inventory", []):
		player.inventory[String(item_id)] = true
	player.has_recorder = bool(state.get("has_recorder", player.has_recorder))

static func _vector3_to_dictionary(value: Vector3) -> Dictionary:
	return {"x": value.x, "y": value.y, "z": value.z}

static func _dictionary_to_vector3(value) -> Vector3:
	if typeof(value) != TYPE_DICTIONARY:
		return Vector3.ZERO
	return Vector3(float(value.get("x", 0.0)), float(value.get("y", 0.0)), float(value.get("z", 0.0)))

static func _is_json_safe(value) -> bool:
	match typeof(value):
		TYPE_NIL, TYPE_BOOL, TYPE_INT, TYPE_FLOAT, TYPE_STRING:
			return true
		TYPE_ARRAY:
			for item in value:
				if not _is_json_safe(item):
					return false
			return true
		TYPE_DICTIONARY:
			for key in value:
				if typeof(key) != TYPE_STRING and typeof(key) != TYPE_STRING_NAME:
					return false
				if not _is_json_safe(value[key]):
					return false
			return true
		_:
			return false

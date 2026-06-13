extends CanvasLayer

signal evidence_added(id: String)

const GROUND_MAP_IMAGE_PATH := "res://images/Haunted_manor_floor_plan_parchment_202606120906.jpeg"
const FIRST_FLOOR_MAP_IMAGE_PATH := "res://images/Ashford_Manor_First_Floor_Plan_202606121627.jpeg"
const ATTIC_MAP_IMAGE_PATH := "res://images/Attic_floor_plan_aged_parchment_202606121628.jpeg"
const CELLAR_MAP_IMAGE_PATH := "res://images/Ashford_Manor_Cellar_floor_plan_202606121625.jpeg"
const MAP_DRAW_RECT := Rect2(0, 54, 690, 334)
const CASEBOOK_PANEL_SIZE := Vector2(900, 620)
const ACT_1_REQUIRED_OBJECTIVES := [
	"open_west_wing",
	"review_living_ledger",
	"inspect_kitchen_table",
	"record_kitchen_wall"
]
const ACT_1_REQUIRED_NOTES := [
	"living_ledger_found",
	"evidence_board_found",
	"recorder_transcriptions_reviewed"
]

var journal_panel: PanelContainer
var inventory_panel: PanelContainer
var map_panel: PanelContainer
var ledger_panel: PanelContainer
var evidence_panel: PanelContainer
var journal_content: RichTextLabel
var inventory_content: RichTextLabel
var inventory_buttons: VBoxContainer
var map_content: RichTextLabel
var map_canvas: Control
var ledger_content: RichTextLabel
var evidence_content: RichTextLabel
var map_textures := {}
var active_map_floor := "ground_floor"
var active_panel := ""
var player: Node
var unread_ledger_entries := 0
var unread_evidence_items := 0
var act_1_ready := false

var objectives := [
	{"id": "find_recorder", "text": "Find Mara's recorder.", "complete": false}
]

var notes := []
var ledger_entries := [
	{
		"id": "arrival",
		"title": "2:47 AM - Arrival",
		"text": "Mara entered Ashford Manor with a recorder, a notebook, and the small mercy of not yet knowing what the walls remembered."
	}
]
var evidence_items := []
var evidence_required := {
	"wall_warning": true,
	"manor_plans": true,
	"library_wall_recording": true,
	"library_measurement": true,
	"dining_table": true,
	"eleanor_place_card": true,
	"kitchen_wall_recording": true
}
var inventory_items := {}
var discovered_map := {}
var visited_map := {}
var current_map_area := "entrance_hall"

func _ready() -> void:
	player = get_node_or_null("../Player")
	_build_journal()
	_build_inventory()
	_build_map()
	_build_ledger()
	_build_evidence_board()
	reveal_map_area("entrance_hall")
	visit_map_area("entrance_hall")
	_close_panels()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_casebook"):
		if active_panel == "journal":
			_close_panels()
		else:
			_open_panel("journal")
	if event.is_action_pressed("open_inventory"):
		if active_panel == "inventory":
			_close_panels()
		else:
			_open_panel("inventory")
	if event.is_action_pressed("open_map"):
		if active_panel == "map":
			_close_panels()
		else:
			_open_panel("map")
	if event.is_action_pressed("open_ledger"):
		if active_panel == "ledger":
			_close_panels()
		else:
			_open_panel("ledger")
	if active_panel != "" and event.is_action_pressed("ui_cancel"):
		_close_panels()
		get_viewport().set_input_as_handled()

func add_objective(id: String, text: String) -> void:
	for objective in objectives:
		if objective.id == id:
			return
	objectives.append({"id": id, "text": text, "complete": false})
	_refresh_journal()
	_update_act_1_progression()

func complete_objective(id: String) -> void:
	for objective in objectives:
		if objective.id == id:
			objective.complete = true
	_refresh_journal()
	_update_act_1_progression()

func add_note(id: String, text: String) -> void:
	for note in notes:
		if note.id == id:
			return
	notes.append({"id": id, "text": text})
	_refresh_journal()
	_update_act_1_progression()

func add_ledger_entry(id: String, text: String, title := "") -> void:
	for entry in ledger_entries:
		if entry.id == id:
			return
	var entry_title := title
	if entry_title == "":
		entry_title = "Entry %d" % [ledger_entries.size() + 1]
	ledger_entries.append({"id": id, "title": entry_title, "text": text})
	if active_panel != "ledger":
		unread_ledger_entries += 1
	_refresh_ledger()
	_update_act_1_progression()

func open_ledger() -> void:
	_open_panel("ledger")

func ledger_unread_count() -> int:
	return unread_ledger_entries

func evidence_unread_count() -> int:
	return unread_evidence_items

func is_act_1_ready() -> bool:
	return act_1_ready

func incomplete_countdown_active() -> bool:
	return bool(get_tree().root.get_meta("incomplete_countdown_seeded", false))

func incomplete_status_line() -> String:
	if not incomplete_countdown_active():
		return ""
	var line := "BLACK BOOK: MARA VOSS / DECEMBER 2 / INCOMPLETE"
	if bool(get_tree().root.get_meta("incomplete_247_fired", false)):
		line += " / 2:47 WROTE: INCOMPLETE"
	elif bool(get_tree().root.get_meta("incomplete_247_armed", false)):
		line += " / NEXT 2:47 RESERVED"
	return line

func add_evidence(id: String, title: String, detail: String, category := "Evidence") -> void:
	for item in evidence_items:
		if item.id == id:
			return
	evidence_items.append({
		"id": id,
		"title": title,
		"detail": detail,
		"category": category,
		"required": evidence_required.has(id)
	})
	if active_panel != "evidence":
		unread_evidence_items += 1
	_refresh_evidence_board()
	evidence_added.emit(id)
	_update_act_1_progression()

func open_evidence_board() -> void:
	_open_panel("evidence")

func evidence_completion_percent() -> int:
	var required_total := evidence_required.size()
	if required_total == 0:
		return 0
	var found := 0
	for item in evidence_items:
		if bool(item.required):
			found += 1
	return int(round(float(found) / float(required_total) * 100.0))

func add_inventory_item(id: String, item_name: String, description: String) -> void:
	inventory_items[id] = {
		"name": item_name,
		"description": description
	}
	_refresh_inventory()

func reveal_map_area(id: String) -> void:
	discovered_map[id] = true
	_refresh_map()

func visit_map_area(id: String) -> void:
	discovered_map[id] = true
	visited_map[id] = true
	current_map_area = id
	_refresh_map()

func _build_journal() -> void:
	journal_panel = _make_panel("JournalPanel")
	add_child(journal_panel)
	var margin := _make_margin(journal_panel)
	journal_content = RichTextLabel.new()
	journal_content.bbcode_enabled = true
	journal_content.fit_content = false
	journal_content.scroll_active = true
	journal_content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	journal_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	journal_content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	journal_content.add_theme_font_size_override("normal_font_size", 19)
	journal_content.add_theme_font_size_override("bold_font_size", 25)
	journal_content.add_theme_color_override("default_color", Color(0.93, 0.88, 0.78, 0.92))
	margin.add_child(journal_content)
	_refresh_journal()

func _build_inventory() -> void:
	inventory_panel = _make_panel("InventoryPanel")
	add_child(inventory_panel)
	var margin := _make_margin(inventory_panel)
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 14)
	margin.add_child(stack)
	inventory_content = RichTextLabel.new()
	inventory_content.bbcode_enabled = true
	inventory_content.fit_content = true
	inventory_content.scroll_active = false
	inventory_content.add_theme_font_size_override("normal_font_size", 20)
	inventory_content.add_theme_font_size_override("bold_font_size", 26)
	inventory_content.add_theme_color_override("default_color", Color(0.93, 0.88, 0.78, 0.92))
	stack.add_child(inventory_content)
	inventory_buttons = VBoxContainer.new()
	inventory_buttons.add_theme_constant_override("separation", 10)
	stack.add_child(inventory_buttons)
	_refresh_inventory()

func _build_map() -> void:
	map_panel = _make_panel("MapPanel")
	_center_panel(map_panel, Vector2(860, 640))
	add_child(map_panel)
	map_textures = {
		"ground_floor": load(GROUND_MAP_IMAGE_PATH) as Texture2D,
		"first_floor": load(FIRST_FLOOR_MAP_IMAGE_PATH) as Texture2D,
		"attic": load(ATTIC_MAP_IMAGE_PATH) as Texture2D,
		"cellar": load(CELLAR_MAP_IMAGE_PATH) as Texture2D
	}
	var margin := _make_margin(map_panel)
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 12)
	margin.add_child(stack)
	map_content = RichTextLabel.new()
	map_content.bbcode_enabled = true
	map_content.fit_content = true
	map_content.scroll_active = false
	map_content.add_theme_font_size_override("normal_font_size", 18)
	map_content.add_theme_font_size_override("bold_font_size", 26)
	map_content.add_theme_color_override("default_color", Color(0.93, 0.88, 0.78, 0.92))
	stack.add_child(map_content)
	map_canvas = Control.new()
	map_canvas.custom_minimum_size = Vector2(690, 388)
	map_canvas.draw.connect(_draw_map)
	stack.add_child(map_canvas)
	_refresh_map()

func _build_ledger() -> void:
	ledger_panel = _make_panel("LedgerPanel")
	add_child(ledger_panel)
	var margin := _make_margin(ledger_panel)
	ledger_content = RichTextLabel.new()
	ledger_content.bbcode_enabled = true
	ledger_content.fit_content = false
	ledger_content.scroll_active = true
	ledger_content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ledger_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ledger_content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ledger_content.add_theme_font_size_override("normal_font_size", 19)
	ledger_content.add_theme_font_size_override("bold_font_size", 25)
	ledger_content.add_theme_color_override("default_color", Color(0.93, 0.88, 0.78, 0.92))
	margin.add_child(ledger_content)
	_refresh_ledger()

func _build_evidence_board() -> void:
	evidence_panel = _make_panel("EvidencePanel")
	add_child(evidence_panel)
	var margin := _make_margin(evidence_panel)
	evidence_content = RichTextLabel.new()
	evidence_content.bbcode_enabled = true
	evidence_content.fit_content = false
	evidence_content.scroll_active = true
	evidence_content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	evidence_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	evidence_content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	evidence_content.add_theme_font_size_override("normal_font_size", 18)
	evidence_content.add_theme_font_size_override("bold_font_size", 25)
	evidence_content.add_theme_color_override("default_color", Color(0.93, 0.88, 0.78, 0.92))
	margin.add_child(evidence_content)
	_refresh_evidence_board()

func _make_panel(panel_name: String) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.name = panel_name
	panel.set_anchors_preset(Control.PRESET_CENTER)
	_center_panel(panel, CASEBOOK_PANEL_SIZE)
	panel.add_theme_stylebox_override("panel", _make_box_style(Color(0.018, 0.014, 0.012, 0.42), Color(0.95, 0.78, 0.52, 0.24)))
	return panel

func _center_panel(panel: PanelContainer, size: Vector2) -> void:
	panel.custom_minimum_size = size
	panel.offset_left = -size.x * 0.5
	panel.offset_top = -size.y * 0.5
	panel.offset_right = size.x * 0.5
	panel.offset_bottom = size.y * 0.5

func _make_margin(panel: PanelContainer) -> MarginContainer:
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 28)
	margin.add_theme_constant_override("margin_top", 22)
	margin.add_theme_constant_override("margin_right", 28)
	margin.add_theme_constant_override("margin_bottom", 22)
	panel.add_child(margin)
	return margin

func _open_panel(panel_name: String) -> void:
	active_panel = panel_name
	get_tree().root.set_meta("ui_panel_open", true)
	journal_panel.visible = panel_name == "journal"
	inventory_panel.visible = panel_name == "inventory"
	map_panel.visible = panel_name == "map"
	ledger_panel.visible = panel_name == "ledger"
	evidence_panel.visible = panel_name == "evidence"
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if panel_name == "journal":
		_refresh_journal()
	elif panel_name == "inventory":
		_refresh_inventory()
	elif panel_name == "map":
		_refresh_map()
	elif panel_name == "ledger":
		unread_ledger_entries = 0
		_refresh_ledger()
		_update_act_1_progression()
	elif panel_name == "evidence":
		unread_evidence_items = 0
		_refresh_evidence_board()
		_update_act_1_progression()
	else:
		_refresh_evidence_board()

func _close_panels() -> void:
	active_panel = ""
	get_tree().root.set_meta("ui_panel_open", false)
	if journal_panel:
		journal_panel.visible = false
	if inventory_panel:
		inventory_panel.visible = false
	if map_panel:
		map_panel.visible = false
	if ledger_panel:
		ledger_panel.visible = false
	if evidence_panel:
		evidence_panel.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _refresh_journal() -> void:
	if journal_content == null:
		return
	var lines := ["[b]JOURNAL[/b]", "", "[b]Objectives[/b]"]
	_add_incomplete_casebook_line(lines)
	if incomplete_countdown_active():
		lines.append("")
	for objective in objectives:
		var marker := "x" if objective.complete else " "
		lines.append("[indent][%s] %s[/indent]" % [marker, objective.text])
	if notes.size() > 0:
		lines.append("")
		lines.append("[b]Notes[/b]")
		for note in notes:
			lines.append("[indent]- %s[/indent]" % note.text)
	lines.append("")
	lines.append("[center]Press ESC to return to game[/center]")
	journal_content.text = "\n".join(lines)

func _update_act_1_progression() -> void:
	if act_1_ready:
		return
	if not _act_1_requirements_met():
		return
	act_1_ready = true
	get_tree().root.set_meta("act_1_ready", true)
	if not _has_objective("choose_next_route"):
		objectives.append({"id": "choose_next_route", "text": "Return to the Kitchen hub and choose the next route.", "complete": false})
	if not _has_note("act_1_ready"):
		notes.append({"id": "act_1_ready", "text": "Act 1 evidence is complete. The house has given Mara enough proof to risk the next route."})
	if not _has_ledger_entry("act_1_ready_ledger"):
		ledger_entries.append({
			"id": "act_1_ready_ledger",
			"title": "2:47 AM - Enough Proof",
			"text": "The board, the ledger, and the recorder agreed for the first time. Mara knew better than to trust agreement inside Ashford Manor, but it was enough to move on."
		})
		if active_panel != "ledger":
			unread_ledger_entries += 1
	_refresh_journal()
	_refresh_ledger()

func _act_1_requirements_met() -> bool:
	if evidence_completion_percent() < 100:
		return false
	if unread_ledger_entries > 0 or unread_evidence_items > 0:
		return false
	if int(get_tree().root.get_meta("pending_transcription_count", 0)) > 0:
		return false
	if not visited_map.has("kitchen"):
		return false
	for objective_id in ACT_1_REQUIRED_OBJECTIVES:
		if not _objective_complete(String(objective_id)):
			return false
	for note_id in ACT_1_REQUIRED_NOTES:
		if not _has_note(String(note_id)):
			return false
	for evidence_id in evidence_required.keys():
		if not _has_evidence(String(evidence_id)):
			return false
	return true

func _objective_complete(id: String) -> bool:
	for objective in objectives:
		if objective.id == id:
			return objective.complete
	return false

func _has_objective(id: String) -> bool:
	for objective in objectives:
		if objective.id == id:
			return true
	return false

func _has_note(id: String) -> bool:
	for note in notes:
		if note.id == id:
			return true
	return false

func _has_ledger_entry(id: String) -> bool:
	for entry in ledger_entries:
		if entry.id == id:
			return true
	return false

func _has_evidence(id: String) -> bool:
	for item in evidence_items:
		if item.id == id:
			return true
	return false

func _refresh_inventory() -> void:
	if inventory_content == null or inventory_buttons == null:
		return
	for child in inventory_buttons.get_children():
		child.queue_free()
	inventory_content.text = "[b]INVENTORY[/b]\n\nSelect an item to use it.\n\n[center]Press ESC to return to game[/center]"
	if inventory_items.is_empty():
		var empty := Label.new()
		empty.text = "Mara is carrying nothing yet."
		empty.add_theme_font_size_override("font_size", 20)
		empty.add_theme_color_override("font_color", Color(0.93, 0.88, 0.78, 0.85))
		inventory_buttons.add_child(empty)
		return
	for id in inventory_items.keys():
		var item = inventory_items[id]
		var button := Button.new()
		button.text = "%s - %s" % [item.name, item.description]
		button.custom_minimum_size = Vector2(680, 44)
		button.add_theme_font_size_override("font_size", 18)
		button.add_theme_stylebox_override("normal", _make_box_style(Color(0.015, 0.012, 0.01, 0.24), Color(0.95, 0.78, 0.5, 0.22)))
		button.add_theme_stylebox_override("hover", _make_box_style(Color(0.08, 0.045, 0.03, 0.38), Color(0.95, 0.78, 0.5, 0.48)))
		button.add_theme_stylebox_override("pressed", _make_box_style(Color(0.12, 0.055, 0.035, 0.46), Color(0.95, 0.78, 0.5, 0.62)))
		button.add_theme_color_override("font_color", Color(0.95, 0.86, 0.7))
		button.pressed.connect(_use_inventory_item.bind(id))
		inventory_buttons.add_child(button)

func _refresh_ledger() -> void:
	if ledger_content == null:
		return
	var lines := ["[b]LIVING LEDGER[/b]", ""]
	_add_incomplete_casebook_line(lines)
	if incomplete_countdown_active():
		lines.append("")
	if unread_ledger_entries > 0:
		var page_word := "page" if unread_ledger_entries == 1 else "pages"
		lines.append("[i]%d new %s written since Mara last looked.[/i]" % [unread_ledger_entries, page_word])
		lines.append("")
	for entry in ledger_entries:
		lines.append("[b]%s[/b]" % String(entry.title))
		lines.append(String(entry.text))
		lines.append("")
	lines.append("[center]Press ESC to return to game[/center]")
	ledger_content.text = "\n".join(lines)

func _refresh_evidence_board() -> void:
	if evidence_content == null:
		return
	var found_required := 0
	var required_total := evidence_required.size()
	for item in evidence_items:
		if bool(item.required):
			found_required += 1
	var percent := evidence_completion_percent()
	var lines := [
		"[b]EVIDENCE BOARD[/b]",
		"",
		"Publish readiness: %d%%" % percent,
		"Required proof pinned: %d / %d" % [found_required, required_total],
		""
	]
	_add_incomplete_casebook_line(lines)
	if incomplete_countdown_active():
		lines.append("")
	if unread_evidence_items > 0:
		var proof_word := "piece" if unread_evidence_items == 1 else "pieces"
		lines.append("[i]%d new %s of proof pinned since Mara last looked.[/i]" % [unread_evidence_items, proof_word])
		lines.append("")
	if evidence_items.is_empty():
		lines.append("No proof pinned yet. Mara needs recordings, measurements, documents, and named witnesses.")
	else:
		for item in evidence_items:
			var marker := "*" if bool(item.required) else "-"
			lines.append("[b]%s %s[/b]" % [marker, String(item.title)])
			lines.append("[indent]%s[/indent]" % String(item.detail))
			lines.append("")
	lines.append("[center]Press ESC to return to game[/center]")
	evidence_content.text = "\n".join(lines)

func _add_incomplete_casebook_line(lines: Array) -> void:
	var status := incomplete_status_line()
	if status == "":
		return
	lines.append("[color=#d8b06f99][i]%s[/i][/color]" % status)

func _refresh_map() -> void:
	if map_content == null:
		return
	var discovered_count := discovered_map.size()
	if discovered_count <= 1:
		map_content.text = "[b]MANOR MAP[/b]\n\nGround Floor active. Other survey plans are locked until Mara finds them.\n\n[center]Press ESC to return to game[/center]"
	else:
		map_content.text = "[b]MANOR MAP[/b]\n\nBright rooms have been visited. Dim rooms are known, but still waiting.\n\n[center]Press ESC to return to game[/center]"
	if map_canvas:
		map_canvas.queue_redraw()

func _draw_map() -> void:
	if map_canvas == null:
		return
	_draw_map_floor_tabs()
	var map_rect := MAP_DRAW_RECT
	var map_texture := map_textures.get(active_map_floor) as Texture2D
	if map_texture:
		map_canvas.draw_texture_rect(map_texture, map_rect, false, Color(1.0, 1.0, 1.0, 0.28))
	else:
		map_canvas.draw_rect(map_rect, Color(0.1, 0.075, 0.05, 0.55), true)
	map_canvas.draw_rect(map_rect, Color(0.0, 0.0, 0.0, 0.58), true)
	if active_map_floor == "ground_floor":
		for room in _get_map_rooms():
			_draw_map_room_overlay(room)

func _draw_map_floor_tabs() -> void:
	var tabs := [
		{"id": "ground_floor", "label": "Ground", "locked": false},
		{"id": "first_floor", "label": "First Floor", "locked": true},
		{"id": "attic", "label": "Attic", "locked": true},
		{"id": "cellar", "label": "Cellar", "locked": true}
	]
	var x: float = 0.0
	for tab in tabs:
		var tab_id := String(tab.id)
		var width: float = 132.0
		if tab_id == "first_floor":
			width = 150.0
		var rect := Rect2(x, 0, width, 36)
		var is_active: bool = tab_id == active_map_floor
		var fill := Color(0.05, 0.035, 0.025, 0.52)
		var outline := Color(0.95, 0.78, 0.52, 0.2)
		var text_color := Color(0.95, 0.88, 0.72, 0.38)
		if is_active:
			fill = Color(0.22, 0.16, 0.1, 0.72)
			outline = Color(0.95, 0.78, 0.52, 0.82)
			text_color = Color(0.95, 0.88, 0.72, 0.95)
		map_canvas.draw_rect(rect, fill, true)
		map_canvas.draw_rect(rect, outline, false, 1.0)
		var label := String(tab.label)
		if bool(tab.locked):
			label += " (locked)"
		map_canvas.draw_string(ThemeDB.fallback_font, rect.position + Vector2(10, 23), label, HORIZONTAL_ALIGNMENT_LEFT, rect.size.x - 16, 15, text_color)
		x += width + 8.0

func _get_map_rooms() -> Array:
	return [
		{"id": "kitchen", "rect": _map_room_rect(136, 68, 114, 93)},
		{"id": "library", "rect": _map_room_rect(96, 167, 106, 86)},
		{"id": "study", "rect": _map_room_rect(126, 253, 88, 71)},
		{"id": "west_wing_hall", "rect": _map_room_rect(197, 159, 124, 50)},
		{"id": "dining_room", "rect": _map_room_rect(222, 202, 91, 88)},
		{"id": "cellar_stairs", "rect": _map_room_rect(253, 141, 61, 45)},
		{"id": "master_bedroom", "rect": _map_room_rect(308, 57, 81, 111)},
		{"id": "entrance_hall", "rect": _map_room_rect(321, 187, 81, 131)},
		{"id": "nursery", "rect": _map_room_rect(394, 86, 56, 81)},
		{"id": "chapel_room", "rect": _map_room_rect(442, 86, 61, 81)},
		{"id": "conservatory", "rect": _map_room_rect(514, 224, 64, 84)},
		{"id": "east_wing", "rect": _map_room_rect(384, 167, 194, 141)}
	]

func _map_room_rect(x: float, y: float, width: float, height: float) -> Rect2:
	var scale := Vector2(MAP_DRAW_RECT.size.x / 690.0, MAP_DRAW_RECT.size.y / 388.0)
	return Rect2(MAP_DRAW_RECT.position + Vector2(x * scale.x, y * scale.y), Vector2(width * scale.x, height * scale.y))

func _draw_map_room_overlay(room: Dictionary) -> void:
	var id := String(room.id)
	var rect := room.rect as Rect2
	var known := discovered_map.has(id)
	var visited := visited_map.has(id)
	var current := current_map_area == id
	if not known:
		map_canvas.draw_rect(rect, Color(0.0, 0.0, 0.0, 0.54), true)
		map_canvas.draw_rect(rect, Color(0.08, 0.06, 0.04, 0.6), false, 1.0)
		return
	var map_texture := map_textures.get(active_map_floor) as Texture2D
	if map_texture:
		var reveal_alpha := 0.52
		if visited:
			reveal_alpha = 0.96
		map_canvas.draw_texture_rect_region(map_texture, rect, _texture_region_for_rect(rect), Color(1.0, 1.0, 1.0, reveal_alpha))
	var tint := Color(0.95, 0.78, 0.52, 0.1)
	var outline := Color(0.95, 0.78, 0.52, 0.42)
	if visited:
		tint = Color(0.95, 0.78, 0.52, 0.18)
		outline = Color(0.95, 0.78, 0.52, 0.72)
	if current:
		outline = Color(1.0, 0.9, 0.62, 0.95)
	map_canvas.draw_rect(rect, tint, true)
	map_canvas.draw_rect(rect, outline, false, 2.0)
	if current:
		map_canvas.draw_circle(rect.position + Vector2(rect.size.x - 9, 9), 5.0, Color(1.0, 0.24, 0.18, 0.92))

func _texture_region_for_rect(rect: Rect2) -> Rect2:
	var map_texture := map_textures.get(active_map_floor) as Texture2D
	if map_texture == null:
		return rect
	var texture_size := Vector2(map_texture.get_width(), map_texture.get_height())
	var local_position := rect.position - MAP_DRAW_RECT.position
	var source_position := Vector2(local_position.x / MAP_DRAW_RECT.size.x * texture_size.x, local_position.y / MAP_DRAW_RECT.size.y * texture_size.y)
	var source_size := Vector2(rect.size.x / MAP_DRAW_RECT.size.x * texture_size.x, rect.size.y / MAP_DRAW_RECT.size.y * texture_size.y)
	return Rect2(source_position, source_size)

func _use_inventory_item(id: String) -> void:
	_close_panels()
	if player == null:
		return
	if id == "recorder":
		player.use_recorder_from_inventory()
	elif id == "service_key":
		player.show_message("The service key is a prototype stand-in. The true iron key belongs to the sealed wing later.")
	elif id == "tape_measure":
		player.use_tape_measure_from_inventory()
	else:
		player.show_message("Mara turns the item over, but it offers no answer yet.")

func _make_box_style(fill: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = 3
	style.corner_radius_top_right = 3
	style.corner_radius_bottom_left = 3
	style.corner_radius_bottom_right = 3
	return style

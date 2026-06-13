extends Control

const GAME_SCENE := "res://scenes/main.tscn"
const MANOR_IMAGE := "res://images/R4 — Ashford Manor, exterior (the show's hero image).png"

var detail_panel: PanelContainer
var detail_title: Label
var detail_body: RichTextLabel

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_build_menu()

func _build_menu() -> void:
	var background := TextureRect.new()
	background.name = "AshfordManorBackground"
	background.texture = load(MANOR_IMAGE)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var shade := ColorRect.new()
	shade.name = "StormShade"
	shade.color = Color(0.02, 0.015, 0.012, 0.48)
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(shade)

	var title_block := VBoxContainer.new()
	title_block.name = "TitleBlock"
	title_block.anchor_left = 0.055
	title_block.anchor_top = 0.12
	title_block.anchor_right = 0.62
	title_block.anchor_bottom = 0.38
	title_block.offset_left = 0
	title_block.offset_top = 0
	title_block.offset_right = 0
	title_block.offset_bottom = 0
	add_child(title_block)

	var title := Label.new()
	title.text = "THE WEEPING WALLS"
	title.add_theme_font_size_override("font_size", 58)
	title.add_theme_color_override("font_color", Color(0.95, 0.87, 0.74))
	title.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.85))
	title.add_theme_constant_override("shadow_offset_x", 3)
	title.add_theme_constant_override("shadow_offset_y", 3)
	title_block.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "A first-person horror investigation inside Ashford Manor"
	subtitle.add_theme_font_size_override("font_size", 21)
	subtitle.add_theme_color_override("font_color", Color(0.86, 0.78, 0.67))
	subtitle.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.75))
	subtitle.add_theme_constant_override("shadow_offset_x", 2)
	subtitle.add_theme_constant_override("shadow_offset_y", 2)
	title_block.add_child(subtitle)

	var buttons := VBoxContainer.new()
	buttons.name = "MenuButtons"
	buttons.anchor_left = 0.06
	buttons.anchor_top = 0.56
	buttons.anchor_right = 0.29
	buttons.anchor_bottom = 0.88
	buttons.add_theme_constant_override("separation", 12)
	add_child(buttons)

	_add_menu_button(buttons, "Start Game", _start_game)
	_add_menu_button(buttons, "Options / Controls", _show_options)
	_add_menu_button(buttons, "Quit", _quit_game)

	_build_detail_panel()
	detail_panel.visible = false

func _add_menu_button(parent: VBoxContainer, text: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(270, 48)
	button.add_theme_font_size_override("font_size", 20)
	button.add_theme_stylebox_override("normal", _make_box_style(Color(0.015, 0.012, 0.01, 0.28), Color(0.95, 0.78, 0.5, 0.32)))
	button.add_theme_stylebox_override("hover", _make_box_style(Color(0.08, 0.045, 0.03, 0.42), Color(0.95, 0.78, 0.5, 0.62)))
	button.add_theme_stylebox_override("pressed", _make_box_style(Color(0.12, 0.055, 0.035, 0.52), Color(0.95, 0.78, 0.5, 0.78)))
	button.add_theme_color_override("font_color", Color(0.95, 0.86, 0.7))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.92, 0.76))
	button.pressed.connect(callback)
	parent.add_child(button)

func _build_detail_panel() -> void:
	detail_panel = PanelContainer.new()
	detail_panel.name = "DetailPanel"
	detail_panel.anchor_left = 0.58
	detail_panel.anchor_top = 0.58
	detail_panel.anchor_right = 0.94
	detail_panel.anchor_bottom = 0.9
	detail_panel.add_theme_stylebox_override("panel", _make_box_style(Color(0.02, 0.015, 0.012, 0.26), Color(0.95, 0.78, 0.5, 0.2)))
	add_child(detail_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 22)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_right", 22)
	margin.add_theme_constant_override("margin_bottom", 18)
	detail_panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 10)
	margin.add_child(stack)

	detail_title = Label.new()
	detail_title.add_theme_font_size_override("font_size", 25)
	detail_title.add_theme_color_override("font_color", Color(0.96, 0.86, 0.68))
	stack.add_child(detail_title)

	detail_body = RichTextLabel.new()
	detail_body.bbcode_enabled = true
	detail_body.fit_content = true
	detail_body.scroll_active = false
	detail_body.add_theme_font_size_override("normal_font_size", 18)
	detail_body.add_theme_color_override("default_color", Color(0.91, 0.86, 0.78))
	stack.add_child(detail_body)

func _start_game() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)

func _show_options() -> void:
	detail_panel.visible = true
	detail_title.text = "Controls"
	detail_body.text = "[b]Movement[/b]\nWASD or arrow keys\n\n[b]Investigation[/b]\nE interact\nR use recorder\nJ open journal\nI open inventory\nM open map\nEsc close panels / release mouse"

func _quit_game() -> void:
	get_tree().quit()

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

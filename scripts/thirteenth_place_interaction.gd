extends StaticBody3D

@export var placed_marker_path: NodePath

@onready var placed_marker: Node3D = get_node_or_null(placed_marker_path)

var card_placed := false

func _ready() -> void:
	if placed_marker:
		placed_marker.visible = false

func get_prompt(player: Node) -> String:
	if card_placed:
		return "E - Inspect thirteenth place"
	if player.has_method("has_item") and player.has_item("eleanor_place_card"):
		return "E - Set Eleanor's card"
	return "E - Inspect thirteenth place"

func interact(player: Node) -> void:
	if card_placed:
		player.show_message("Eleanor's place is set. The empty chair still refuses to appear.", 5.0)
		return
	if not player.has_method("has_item") or not player.has_item("eleanor_place_card"):
		player.show_message("The thirteenth place waits for a name. Mara needs something that belongs here.", 6.0)
		return
	card_placed = true
	get_tree().root.set_meta("eleanor_named", true)
	if placed_marker:
		placed_marker.visible = true
	player.complete_journal_objective("set_thirteenth_place")
	player.add_journal_note("thirteenth_place_set", "Eleanor's card belongs at the thirteenth place. The table accepts her name, but not her absence.")
	player.add_ledger_entry("eleanor_named", "Mara gave the thirteenth place a name. Eleanor. The house accepted the offering and immediately wanted another.", "2:47 AM - A Name At The Table")
	player.add_evidence("eleanor_place_card", "Eleanor's Place Card", "The Dining Room responds only when Eleanor is named at the thirteenth setting.", "Named witness")
	player.add_journal_objective("listen_after_eleanor", "Listen for what changes after Eleanor is named.")
	player.show_message("The card sticks to the table as if pressed into soft clay. Somewhere nearby, cutlery shifts by itself.", 8.0)

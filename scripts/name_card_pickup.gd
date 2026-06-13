extends Area3D

var picked_up := false

func get_prompt(_player: Node) -> String:
	return "E - Take Eleanor's place card"

func interact(player: Node) -> void:
	if picked_up:
		return
	picked_up = true
	player.add_inventory_item("eleanor_place_card", "Eleanor's Place Card", "A damp name card for the thirteenth place.")
	player.add_journal_objective("find_thirteenth_place", "Find what belongs in the thirteenth place.")
	player.complete_journal_objective("find_thirteenth_place")
	player.add_journal_objective("set_thirteenth_place", "Set Eleanor's card at the thirteenth place.")
	player.add_journal_note("eleanor_place_card", "The missing place has a name: Eleanor Ashford. The ink is wet.")
	player.show_message("Mara takes the place card. The name Eleanor bleeds through the paper.", 7.0)
	queue_free()

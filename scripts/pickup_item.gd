extends Area3D

@export var item_id := "collectible_item"
@export var item_name := "item"
@export var description := "A carried object from Ashford Manor."
@export var message := "Mara picks up the item."
@export var completion_objective := ""

func get_prompt(_player: Node) -> String:
	return "E - Take " + item_name

func interact(player: Node) -> void:
	player.add_inventory_item(item_id, item_name.capitalize(), description)
	if completion_objective != "":
		player.complete_journal_objective(completion_objective)
	if item_id == "tape_measure":
		player.add_ledger_entry("tape_measure_found", "Mara took Thomas Ashford's tape measure. Numbers felt safer than walls, which was exactly why she did not trust them.", "2:47 AM - The Tape Measure")
	player.show_message(message)
	queue_free()

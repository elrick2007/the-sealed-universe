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
	elif item_id == "burnt_page_fragment":
		player.add_journal_note(
			"burnt_page_fragment",
			"The Library ash gave up a burnt page fragment from the black book. Only a few letters survived: ...AH."
		)
		player.add_evidence(
			"burnt_page_fragment",
			"Burnt Black-Book Fragment",
			"A charred corner of the black book, rescued from Library ash with only a half-name and the letters ...AH.",
			"Document"
		)
		player.add_ledger_entry(
			"burnt_page_fragment",
			"Mara found a black-book corner in the Library ash. The burned edge was cold, but the letters looked recently afraid.",
			"2:47 AM - Ash That Kept Its Word"
		)
		player.add_journal_objective("bring_fragment_to_unnumbered_bed", "Leave the burnt page fragment on the unnumbered bed overnight.")
	player.show_message(message)
	queue_free()

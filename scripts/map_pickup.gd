extends Area3D

func get_prompt(_player: Node) -> String:
	return "E - Take manor plans"

func interact(player: Node) -> void:
	player.add_inventory_item("manor_plans", "Manor Plans", "A torn floor plan of Ashford Manor.")
	player.reveal_map_area("west_wing_hall")
	player.complete_journal_objective("follow_west_wing")
	player.add_journal_objective("study_west_wing", "Study the west wing route on the manor plans.")
	player.add_journal_note("manor_plans_found", "The recovered plans reveal only part of the house. Other rooms are missing or scratched out.")
	player.add_ledger_entry("manor_plans_found", "Mara found Caton's plan and saw the first lie of Ashford Manor: the rooms had been drawn, but not all of them had agreed to stay drawn.", "2:47 AM - Caton's Plan")
	player.add_evidence("manor_plans", "Caton's Ground Floor Plan", "The survey reveals missing, scratched, and contradictory rooms.", "Document")
	player.show_message("Manor plans recovered. Press M to open the map.", 6.0)
	queue_free()

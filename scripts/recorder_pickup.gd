extends Area3D

func get_prompt(_player: Node) -> String:
	return "E - Take recorder"

func interact(player: Node) -> void:
	player.give_recorder()
	player.add_ledger_entry("recorder_found", "Mara recovered the recorder from the entrance hall. Its red light blinked before she touched it, as if Ashford Manor had already pressed record.", "2:47 AM - The Red Light")
	queue_free()

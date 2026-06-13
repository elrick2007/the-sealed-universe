extends StaticBody3D

var opened_once := false

func get_prompt(_player: Node) -> String:
	return "E - Open Living Ledger"

func interact(player: Node) -> void:
	if not opened_once:
		opened_once = true
		player.add_journal_note("living_ledger_found", "The Kitchen ledger writes in Mara's hand after events she does not remember recording.")
		player.add_journal_objective("review_living_ledger", "Review the Living Ledger in the Kitchen.")
		player.complete_journal_objective("review_living_ledger")
		player.add_ledger_entry("kitchen_ledger_found", "At 2:47, Mara found the ledger waiting in the Kitchen. The first page was dry. The second had already learned her name.", "2:47 AM - The Book Writes Back")
		player.show_message("The ledger is not blank. It is waiting. Press L to read what the house has written.", 7.0)
	else:
		var unread := 0
		if player.has_method("ledger_unread_count"):
			unread = player.ledger_unread_count()
		if unread > 0:
			var page_word := "page" if unread == 1 else "pages"
			player.show_message("%d new ledger %s wait under Mara's hand." % [unread, page_word], 5.0)
		else:
			player.show_message("The ledger has no new page yet. It still feels warm under Mara's hand.", 5.0)
	player.open_ledger()

extends Effect

func on_ready():
	# if target.is_in_group(&"player")
	pass

func on_tick():
	if not target.is_in_group(&"player"): return # add functionality for other characters later
	
	for card in (get_tree().get_nodes_in_group(&"ui_card") as Array[TextureRect]):
		if card.mouse_filter == Control.MOUSE_FILTER_PASS: continue # card not on cooldown
		
		(card.cooldown_tw as Tween).custom_step(tick_length)

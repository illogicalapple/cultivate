extends Control

func open_menu():
	$AnimationPlayer.play("in")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		$AnimationPlayer.play_backwards("in")

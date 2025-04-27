extends Control

func _ready():
	$Panel/ScrollContainer/MarginContainer/Cards.connect("card_replaced", close_menu)

func open_menu():
	$AnimationPlayer.play("in")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		close_menu()

func close_menu():
	$AnimationPlayer.play_backwards("in")

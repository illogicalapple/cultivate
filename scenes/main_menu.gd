extends Control

var loading_screen: PackedScene = preload("res://scenes/loading.tscn")

func _ready():
	Inventory.set_slot(0, Inventory.Card.new("menu_settings"))
	Inventory.set_slot(1, Inventory.Card.new("menu_play"))
	Inventory.set_slot(2, Inventory.Card.new("menu_quit"))
	
	$Cards._on_hover_detect_mouse_entered()

func quit() -> void:
	$AnimationPlayer.play("confirm_quit")

func play() -> void:
	$AnimationPlayer.play("play")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_nevermind_pressed() -> void:
	$AnimationPlayer.play("quit_cancel")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "play": get_tree().change_scene_to_packed(loading_screen)

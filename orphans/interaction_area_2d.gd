extends Area2D
class_name InteractionArea2D

signal range_entered
signal range_exited
signal interacted

@export var interact_action: StringName = &"interact"

var in_range: bool = false

func _init():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(_body: Node2D) -> void:
	in_range = true
	range_entered.emit()

func _on_body_exited(body: Node2D) -> void:
	in_range = false
	range_exited.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(interact_action) and in_range:
		interacted.emit()

extends Sprite2D

@export var value = 1

@onready var rotation_velocity: float = randf_range(-4000, 4000)
@onready var rice_target: Control = get_tree().get_first_node_in_group("rice_ui")

func _ready() -> void:
	var movement_tw: Tween = get_tree().create_tween()
	movement_tw.set_trans(Tween.TRANS_CUBIC).tween_property(
		self, "global_position",
		get_tree().get_first_node_in_group("player").global_position,
		0.1
	)
	print(get_tree().get_first_node_in_group("player").global_position)
	
	await movement_tw.finished
	rice_target.gain_rice(value)
	queue_free()

func _process(delta: float) -> void:
	rotation_degrees += rotation_velocity * delta

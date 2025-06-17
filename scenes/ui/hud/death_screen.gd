extends ColorRect

@onready var player: Character = get_tree().get_first_node_in_group("player")

@export var time_scale: float = 1.0:
	set(new_value):
		time_scale = new_value
		if time_scale == 0:
			Engine.time_scale = 1
			get_tree().paused = true
		else:
			Engine.time_scale = new_value
			$AnimationPlayer.speed_scale = 1 / new_value
		

func _ready() -> void:
	player.death.connect(_on_player_death)

func _on_player_death(_origin: Character, death_message: String) -> void:
	show()
	%CauseOfDeath.text = "cause of death: %s" % death_message
	$VBoxContainer.pivot_offset = $VBoxContainer.size / 2
	$AnimationPlayer.play("death")

extends TextureProgressBar

var health_visible: bool = false
var true_value: float = 100.0

func _process(delta: float) -> void:
	var health: float = get_parent().health
	var max_health: float = get_parent().max_health
	
	max_value = max_health
	true_value = lerpf(true_value, health, 4.0 * delta) if health_visible else health
	value = true_value
	
	if health != max_health and not health_visible:
		$AnimationPlayer.play("in")
		health_visible = true
	elif value == max_value and health_visible:
		$AnimationPlayer.play_backwards("in")
		health_visible = false

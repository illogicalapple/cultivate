extends TextureRect

var rice_amount: int = 0

## Triggered through rice particles. See vfx/rice_particle.tscn
func gain_rice(amount: int) -> void:
	rice_amount += amount
	$"../Count".text = str(rice_amount)
	$AnimationPlayer.play("pop")

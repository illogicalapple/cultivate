@tool
extends Node

@export var particles: bool = false

func _process(_delta):
	var size = get_parent().size
	$"../NinePatchRect".custom_minimum_size = size
	$"../NinePatchRect".set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	if particles:
		($"../GPUParticles2D".process_material as ParticleProcessMaterial).emission_box_extents.x = size.x / 2
		($"../GPUParticles2D".process_material as ParticleProcessMaterial).emission_box_extents.y = size.y / 2
	$"../CollisionShape2D".shape.size = size

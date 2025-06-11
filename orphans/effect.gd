extends Node
class_name Effect

signal effect_over(effect_name: String)

@export var effect_name: String = "regeneration"
@export var effect_duration: float = 5.0
@export var tick_length: float = 1.0

var effect_timer: SceneTreeTimer

@onready var effects_cfg: ConfigFile = ConfigFile.new()
@onready var target: Character = get_parent()

func _ready() -> void:
	effects_cfg.load("res://behavior/effects.cfg")
	
	var tick_timer = get_tree().create_timer(tick_length)
	effect_timer = get_tree().create_timer(effect_duration)
	
	effect_timer.timeout.connect(_on_effect_timer_timeout)
	_on_tick_timer_timeout()
	
	if has_method(&"on_ready"): call(&"on_ready")
	
func _on_effect_timer_timeout() -> void:
	if has_method(&"on_effect_over"): call(&"on_effect_over")
	effect_over.emit(effect_name)
	queue_free()

func _on_tick_timer_timeout() -> void:
	if has_method(&"on_tick"): call(&"on_tick")
	
	var tick_timer = get_tree().create_timer(tick_length)
	tick_timer.timeout.connect(_on_tick_timer_timeout)

func get_time_left() -> float:
	return effect_timer.time_left

func end_early() -> void:
	_on_effect_timer_timeout()

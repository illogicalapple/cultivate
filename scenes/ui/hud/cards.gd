extends Control

@export var is_menu: bool = false

var card_mini: PackedScene = preload("res://scenes/ui/hud/card_mini.tscn")
var dragging: bool = false
var hovering: bool = false
var hovering_visually: bool = false

func _ready():
	if is_menu: return
	%Settings.hide()
	%Quit.hide()
	%Play.hide()

func _on_hover_detect_mouse_entered() -> void:
	if not is_menu and get_tree().get_first_node_in_group("inventory").inventory_open: return
	if hovering: return
	hovering = true
	if dragging: return
	$AnimationPlayer.play("hover")
	hovering_visually = true
	$HoverSFX.play()

func _on_hover_detect_mouse_exited() -> void:
	if is_menu: return
	if not is_menu and get_tree().get_first_node_in_group("inventory").inventory_open: return
	if not hovering: return
	hovering = false
	if dragging: return
	$AnimationPlayer.play_backwards("hover")
	hovering_visually = false
	$BlurSFX.play()

func on_drag_started(card_target: TextureRect) -> void:
	var instance = card_mini.instantiate()
	instance.position = get_global_mouse_position()
	instance.card = card_target.card
	instance.triggered.connect(card_target.trigger)
	instance.is_menu = is_menu
	add_sibling(instance)
	start_dragging()

func _input(event: InputEvent) -> void:
	if event.is_action_released("drag_card"): stop_dragging()

func start_dragging():
	if dragging: return
	$AnimationPlayer.play_backwards("hover")
	$BlurSFX.play()
	hovering_visually = false
	dragging = true

func stop_dragging():
	await RenderingServer.frame_post_draw
	dragging = false
	if hovering and not hovering_visually:
		$AnimationPlayer.play("hover")
		$HoverSFX.play()
		hovering_visually = true

func _on_card_left_gui_input(event: InputEvent) -> void:
	if not event.is_action_pressed("drag_card"): return
	on_drag_started(%CardLeft)

func _on_card_right_gui_input(event: InputEvent) -> void:
	if not event.is_action_pressed("drag_card"): return
	on_drag_started(%CardRight)

func _on_card_middle_gui_input(event: InputEvent) -> void:
	if not event.is_action_pressed("drag_card"): return
	on_drag_started(%CardMiddle)

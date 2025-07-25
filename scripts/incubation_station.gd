class_name IncubationStation
extends Area2D

@export var starting_egg_creature: EggCreature

@onready var egg: Egg = $EggPositionMarker/Egg
@onready var hover_panel_container: PanelContainer = $HoverPanelContainer


func _ready() -> void:
	hover_panel_container.visible = false
	if starting_egg_creature:
		egg.set_egg_creature(starting_egg_creature)
	else:
		egg.queue_free()


func pre_game_tick() -> void:
	pass


func next_game_tick() -> void:
	if egg:
		egg.age_ticks += 1


func post_game_tick() -> void:
	update_hover_info_panel()


func update_hover_info_panel() -> void:
	if not egg:
		return
	%CreatureLabel.text = egg.egg_creature.name
	%AgeLabel.text = "Age: %d ticks" % egg.age_ticks
	%TemperatureLabel.text = "Temperature: %0.1d °C" % egg.temperature
	%LuxLabel.text = "Lux: %0.1d lx" % egg.lux
	%RotationTimerLabel.text = "Rotation: %2d ticks" % egg.rotation_ticks_left


func _on_mouse_entered() -> void:
	hover_panel_container.visible = egg != null

func _on_mouse_exited() -> void:
	hover_panel_container.visible = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton 
				and event.button_index == MOUSE_BUTTON_LEFT 
				and event.is_pressed()
				and event.double_click):
		egg.play_crack_animation()

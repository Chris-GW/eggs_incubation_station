class_name IncubationStation
extends Area2D

@export var starting_egg_creature: EggCreature

@onready var egg: Egg = $EggPositionMarker/Egg
@onready var hover_panel_container: Panel = $Panel


func _ready() -> void:
	hover_panel_container.visible = false
	if starting_egg_creature:
		egg.set_egg_creature(starting_egg_creature)
	else:
		egg.queue_free()

func _process(delta: float) -> void:
	if egg:
		$Panel/Temperature/Marker.rotation = $EggPositionMarker/Egg.temperature * delta * 3
	
func pre_game_tick() -> void:
	pass


func next_game_tick() -> void:
	if not egg:
		return
	egg.age_ticks += 1
	if egg and egg.is_happy_enough():
		egg.growth_ticks += 1
	if egg and egg.is_ready_to_hatch():
		egg.hatch_egg()


func post_game_tick() -> void:
	update_hover_info_panel()


func update_hover_info_panel() -> void:
	if not egg:
		return
	
	$Panel/CreatureLabel.text = egg.egg_creature.name
	$Panel/Age/AgeLabel.text = "Age: %d ticks" % egg.age_ticks
	$Panel/Temperature/TemperatureLabel.text = "%0.1d °C" % egg.temperature
	$Panel/LightLevel/LightLevelLabel.text = "LightLevel: %s" % egg.light_level
	$Panel/RotationTimer/RotationTimerLabel.text = "Last rotation: %4d ticks" % egg.ticks_since_last_rotation
	$Panel/Hapinnes/HappinessLabel.text = "Happiness: %2d/100" % egg.happiness
	if egg.happiness > 50:
		$Panel/Hapinnes.texture = preload("res://assets/UI_UX/Egg_Stats/Happy_face.png")
	elif egg.happiness == 50:
		$Panel/Hapinnes.texture = preload("res://assets/UI_UX/Egg_Stats/Neutral_face.png")
	else:
		$Panel/Hapinnes.texture = preload("res://assets/UI_UX/Egg_Stats/Angry_face.png")
	$Panel/Growth/GrowthLabel.text = "Growth ticks: %4d" % egg.growth_ticks


func _on_mouse_entered() -> void:
	hover_panel_container.visible = egg != null

func _on_mouse_exited() -> void:
	hover_panel_container.visible = false

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton 
				and event.button_index == MOUSE_BUTTON_LEFT 
				and event.is_pressed()
				and event.double_click):
		egg.play_crack_animation()

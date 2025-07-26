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
	if egg:
		egg.light_level = EggCreature.LightLevel.DARK


func next_game_tick() -> void:
	if not egg:
		return
	egg.age_ticks += 1
	if egg.is_happy_enough():
		egg.growth_ticks += 1
	if egg.is_ready_to_hatch():
		egg.hatch_egg()


func post_game_tick() -> void:
	update_hover_info_panel()


func update_hover_info_panel() -> void:
	if not egg:
		return
	%CreatureLabel.text = egg.egg_creature.name
	%AgeLabel.text = "Age: %d ticks" % egg.age_ticks
	%TemperatureLabel.text = "Temperature: %0.1d °C" % egg.temperature
	%LightLevelLabel.text = "LightLevel: %s" % egg.light_level
	%RotationTimerLabel.text = "last rotation: %4d ticks" % egg.ticks_since_last_rotation
	%HappinessLabel.text = "Happiness: %2d/100" % egg.happiness
	%GrowthLabel.text = "growth ticks: %4d" % egg.growth_ticks


func _on_mouse_entered() -> void:
	hover_panel_container.visible = egg != null

func _on_mouse_exited() -> void:
	hover_panel_container.visible = false

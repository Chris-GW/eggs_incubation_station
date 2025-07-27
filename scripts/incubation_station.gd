class_name IncubationStation
extends Area2D

signal egg_selection_wanted(incubation_station: IncubationStation)

const AMBIENT_TEMP = 20.0
const EGG = preload("res://scenes/egg.tscn")

@export var starting_egg_creature: EggCreature

@onready var egg: Egg = $EggPositionMarker/Egg
@onready var hover_panel_container: PanelContainer = $HoverPanelContainer

var previous_egg_temp := AMBIENT_TEMP


func _ready() -> void:
	hover_panel_container.visible = false
	if starting_egg_creature:
		egg.set_egg_creature(starting_egg_creature)
	else:
		egg.queue_free()


func pre_game_tick() -> void:
	if egg:
		egg.age_ticks += 1
		egg.light_level = EggCreature.LightLevel.DARK
		previous_egg_temp = egg.temperature
		egg.temperature = AMBIENT_TEMP

func next_game_tick() -> void:
	pass

func post_game_tick() -> void:
	if egg:
		apply_temperature_change()
		if egg.is_happy_enough():
			egg.growth_ticks += 1
		if egg.is_ready_to_hatch():
			egg.hatch_egg()
			await get_tree().create_timer(2.0).timeout
			$PlaceEggButton.visible = true
	update_hover_info_panel()


func apply_temperature_change() -> void:
	var max_change := egg.egg_creature.heat_rate
	var difference := egg.temperature - previous_egg_temp
	if abs(difference) > max_change:
		egg.temperature = previous_egg_temp + sign(difference) * max_change


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


func _on_place_egg_button_pressed() -> void:
	egg_selection_wanted.emit(self)
	$PlaceEggButton.visible = false


func _on_egg_reward_creature_choosen(creature: EggCreature) -> void:
	egg = EGG.instantiate()
	egg.egg_creature = creature
	$EggPositionMarker.add_child(egg)

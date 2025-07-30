class_name IncubationStation
extends Area2D

signal egg_selection_wanted(incubation_station: IncubationStation)

const AMBIENT_TEMP = 20.0
const EGG = preload("res://scenes/egg.tscn")
const HAPPY_FACE = preload("res://assets/UI_UX/Egg_Stats/Happy_face.png")
const NURTAL_FACE =  preload("res://assets/UI_UX/Egg_Stats/Neutral_face.png")
const ANGRY_FACE = preload("res://assets/UI_UX/Egg_Stats/Angry_face.png")

@export var starting_egg_creature: EggCreature

@onready var egg: Egg = $EggPositionMarker/Egg
@onready var hover_panel_container: PanelContainer = $HoverPanel

var previous_egg_temp := AMBIENT_TEMP


func _ready() -> void:
	hover_panel_container.visible = false
	var main: Main = get_tree().get_first_node_in_group("main")
	self.egg_selection_wanted.connect(main._on_egg_selection_wanted)
	if starting_egg_creature:
		egg.set_egg_creature(starting_egg_creature)
		%TemperatureBar.prefered_temp = starting_egg_creature.preferred_temp_range
	else:
		$PlaceEggButton.visible = true
		egg.queue_free()


func _process(delta: float) -> void:
	if egg:
		%Marker.rotation = egg.temperature * delta * 3
	
	
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
	update_temp_info()
	update_light_info()
	update_rotation_info()
	%GrowthLabel.text = "%3d / %3d" % [egg.growth_ticks, egg.egg_creature.growth_duration]
	%AgeLabel.text = "Age: %3d" % egg.age_ticks


func update_temp_info() -> void:
	%TemperatureLabel.text = "%0.1d °C" % egg.temperature
	%TemperatureBar.value = egg.temperature
	if egg.is_good_temp():
		%TempHappiness.texture = HAPPY_FACE
	elif egg.get_temp_difference() <= 4.0:
		%TempHappiness.texture = NURTAL_FACE
	else:
		%TempHappiness.texture = ANGRY_FACE


func update_light_info() -> void:
	var light_level := EggCreature.light_level_name(egg.light_level)
	var prefered_light_level := EggCreature.light_level_name(egg.egg_creature.preferred_light_level)
	%LightLevelLabel.text = light_level + " / " + prefered_light_level
	if egg.is_good_light_level():
		%LightHappiness.texture = HAPPY_FACE
	elif egg.light_level == EggCreature.LightLevel.DIMM:
		%LightHappiness.texture = NURTAL_FACE
	else:
		%LightHappiness.texture = ANGRY_FACE


func update_rotation_info() -> void:
	%RotationTimerLabel.text = "Last rotation: %3d ticks" % egg.ticks_since_last_rotation
	if randf() < 0.7:
		%RotationHappiness.texture = HAPPY_FACE
	else:
		%RotationHappiness.texture = NURTAL_FACE


func _on_mouse_entered() -> void:
	hover_panel_container.visible = egg != null

func _on_mouse_exited() -> void:
	hover_panel_container.visible = false


func _on_place_egg_button_pressed() -> void:
	egg_selection_wanted.emit(self)


func _on_egg_reward_creature_choosen(creature: EggCreature) -> void:
	egg = EGG.instantiate()
	egg.egg_creature = creature
	$EggPositionMarker.add_child(egg)
	$PlaceEggButton.visible = false
	%TemperatureBar.prefered_temp = creature.preferred_temp_range

extends Node2D

const AMBIENT_TEMP = 20.0

@export var intensity: float
@export var enabled := true : set = set_enabled

@onready var egg_effect_area_2d: Area2D = $EggEffectArea2D
@onready var hover_panel_container: PanelContainer = $HoverPanelContainer

var effected_eggs: Array[Egg] = []


func _ready() -> void:
	hover_panel_container.visible = false
	%IntensityLabel.text = "Intensity: %d" % intensity


func pre_game_tick() -> void:
	effected_eggs = []
	for overlapping_area in egg_effect_area_2d.get_overlapping_areas():
		if overlapping_area is Egg:
			effected_eggs.append(overlapping_area)


func next_game_tick() -> void:
	if not enabled:
		return
	for egg in effected_eggs:
		apply_heat_to(egg)


func post_game_tick() -> void:
	pass


func apply_heat_to(egg: Egg) -> void:
	var temp_target := get_temperature_for(egg)
	var max_change := egg.egg_creature.heat_rate
	var difference := temp_target - egg.temperature
	if abs(difference) <= max_change:
		egg.temperature = temp_target
	else:
		egg.temperature += sign(difference) * max_change

func get_temperature_for(egg: Egg) -> float:
	var distance := self.global_position.distance_to(egg.global_position)
	var max_distance := 180.0
	return AMBIENT_TEMP + intensity * (1.0 - distance / max_distance)


func set_enabled(_enabled: bool) -> void:
	enabled = _enabled
	if is_node_ready():
		egg_effect_area_2d.visible = enabled


func _on_mouse_entered() -> void:
	hover_panel_container.visible = true
	egg_effect_area_2d.visible = true

func _on_mouse_exited() -> void:
	hover_panel_container.visible = false
	egg_effect_area_2d.visible = enabled


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton 
				and event.button_index == MOUSE_BUTTON_RIGHT 
				and event.is_pressed()):
		enabled = !enabled

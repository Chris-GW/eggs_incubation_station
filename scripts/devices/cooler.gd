extends Node2D

const AMBIENT_TEMP = 20.0

@export var intensity: float
@export var enabled := true : set = set_enabled

@onready var egg_effect_area_2d: Area2D = $EggEffectArea2D
@onready var hover_panel_container: PanelContainer = $HoverPanelContainer

var effected_eggs: Array[Egg] = []
var is_dragging := false


func _ready() -> void:
	hover_panel_container.visible = false
	%IntensityLabel.text = "Intensity: %d" % intensity


func _process(delta: float) -> void:
	global_position.x = clamp(global_position.x, 40, DisplayServer.window_get_size().x)
	global_position.y = clamp(global_position.y, 40, DisplayServer.window_get_size().y)
	if is_dragging:
		global_position = global_position.lerp(get_global_mouse_position(), delta * 40.0)


func pre_game_tick() -> void:
	effected_eggs = []
	for overlapping_area in egg_effect_area_2d.get_overlapping_areas():
		if overlapping_area is Egg:
			effected_eggs.append(overlapping_area)


func next_game_tick() -> void:
	if not enabled:
		return
	for egg in effected_eggs:
		apply_cool_to(egg)


func post_game_tick() -> void:
	pass


func apply_cool_to(egg: Egg) -> void:
	var temp_target := get_temperature_for(egg)
	var max_change := egg.egg_creature.heat_rate
	var difference := temp_target - egg.temperature
	if abs(difference) <= max_change:
		egg.temperature = temp_target
	else:
		egg.temperature -= sign(difference) * max_change

func get_temperature_for(egg: Egg) -> float:
	return AMBIENT_TEMP + intensity


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


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton 
				and event.button_index == MOUSE_BUTTON_LEFT 
				and event.is_pressed()
				and event.double_click):
		enabled = !enabled
	
	if (event is InputEventMouseButton 
				and event.button_index == MOUSE_BUTTON_LEFT
				and event.is_pressed()):
		is_dragging = true


func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton 
				and event.button_index == MOUSE_BUTTON_LEFT 
				and event.is_released()):
		is_dragging = false

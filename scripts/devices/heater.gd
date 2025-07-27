extends Node2D

@export var intensity: float
@export var enabled := true : set = set_enabled

@onready var egg_effect_area_2d: Area2D = $EggEffectArea2D
@onready var hover_panel_container: PanelContainer = $HoverPanelContainer
@onready var point_light_2d: PointLight2D = $PointLight2D

var effected_eggs: Array[Egg] = []


func _ready() -> void:
	set_enabled(enabled)
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
		var added_temp := get_temperature_for(egg)
		egg.temperature += added_temp


func post_game_tick() -> void:
	pass


func get_temperature_for(egg: Egg) -> float:
	var distance := self.global_position.distance_to(egg.global_position)
	var max_distance := 180.0
	return intensity * (1.0 - distance / max_distance)


func set_enabled(_enabled: bool) -> void:
	enabled = _enabled
	if is_node_ready():
		egg_effect_area_2d.visible = enabled
		point_light_2d.visible = enabled


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

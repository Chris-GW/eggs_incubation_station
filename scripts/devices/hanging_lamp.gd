extends Area2D

@export var intensity: float
@export var enabled := true : set = set_enabled

@onready var switch_button_sprite_2d: Sprite2D = $SwitchButtonSprite2D
@onready var egg_effect_area_2d: Area2D = $EggEffectArea2D
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var hover_panel_container: PanelContainer = $HoverPanelContainer

var effected_eggs: Array[Egg] = []
var is_dragging := false


func _ready() -> void:
	hover_panel_container.visible = false
	%IntensityLabel.text = "Intensity: %d" % intensity


func _process(delta: float) -> void:
	if is_dragging:
		var global_mouse_position := get_global_mouse_position() \
				.snapped(Vector2(5.0, 5.0))
		global_position = global_position.lerp(global_mouse_position, delta * 40.0)


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
	var difference := temp_target - egg.lux
	egg.lux += difference

func get_temperature_for(egg: Egg) -> float:
	var distance := self.global_position.distance_to(egg.global_position)
	var max_distance := 128.0
	return intensity * (1.0 - distance / max_distance)


func set_enabled(_enabled: bool) -> void:
	var should_animate_switch := enabled != _enabled
	enabled = _enabled
	if is_node_ready():
		egg_effect_area_2d.visible = enabled
		point_light_2d.enabled = enabled
		if should_animate_switch:
			play_switch_animation(enabled)


func play_switch_animation(switch_to: bool) -> void:
	if switch_to:
		create_tween().tween_property(switch_button_sprite_2d, "frame", 0, 0.2)
	else:
		create_tween().tween_property(switch_button_sprite_2d, "frame", 2, 0.2)


func _on_mouse_entered() -> void:
	hover_panel_container.visible = true

func _on_mouse_exited() -> void:
	hover_panel_container.visible = false


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton 
				and event.button_index == MOUSE_BUTTON_RIGHT 
				and event.is_pressed()):
		enabled = !enabled
	
	if (event is InputEventMouseButton 
				and event.button_index == MOUSE_BUTTON_LEFT
				and event.is_pressed()):
		is_dragging = true
		egg_effect_area_2d.visible = true


func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton 
				and event.button_index == MOUSE_BUTTON_LEFT 
				and event.is_released()):
		is_dragging = false
		egg_effect_area_2d.visible = enabled

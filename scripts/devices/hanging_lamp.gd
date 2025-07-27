extends Area2D

@export var intensity: float
@export var enabled := true : set = set_enabled

@onready var switch_button_sprite_2d: Sprite2D = $SwitchButtonSprite2D
@onready var egg_effect_area_2d: Area2D = $EggEffectArea2D
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var hover_panel_container: PanelContainer = $HoverPanelContainer

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
		apply_light_to(egg)


func post_game_tick() -> void:
	pass


func apply_light_to(egg: Egg) -> void:
	var max_distance := 120.0
	var half_distance = max_distance / 1.5
	var distance := egg_effect_area_2d.global_position.distance_to(egg.global_position)
	if distance > half_distance:
		if egg.light_level == EggCreature.LightLevel.DARK:
			egg.light_level = EggCreature.LightLevel.DIMM
		else:
			egg.light_level = EggCreature.LightLevel.BRIGHT
	elif distance <= half_distance:
		egg.light_level = EggCreature.LightLevel.BRIGHT


func set_enabled(_enabled: bool) -> void:
	var should_animate_switch := enabled != _enabled
	enabled = _enabled
	if is_node_ready():
		point_light_2d.enabled = enabled
		$SwitchAudioPlayer.play()
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

class_name Draggable
extends Node2D

signal dragg_started
signal dragg_ended

const MAP_SNAP := 4.0
const MAP_BOARDER := Vector2.ONE * 20.0
const MAP_SIZE := Vector2(640.0, 360.0)
const MIN_MAP_POSITION := Vector2.ZERO + MAP_BOARDER
const MAX_MAP_POSITION := MAP_SIZE - MAP_BOARDER

@export var area_2d: Area2D
@export var outline: Line2D
@export var smoothing := 24.0

@onready var drag_start_position := area_2d.global_position

var is_dragging := false : set = set_dragging
var is_reverting_position := false
var is_overlapping := false


func _enter_tree() -> void:
	area_2d.input_event.connect(_on_input_event)

func _exit_tree() -> void:
	area_2d.input_event.disconnect(_on_input_event)


func _physics_process(delta: float) -> void:
	if is_reverting_position and not area_2d.has_overlapping_areas():
		is_reverting_position = false
	elif is_reverting_position: 
		var weight := 1.0 - exp(-8.0 * delta)
		area_2d.global_position = area_2d.global_position.lerp(drag_start_position, weight)
	
	if area_2d.has_overlapping_areas():
		outline.default_color = Color.RED
		outline.visible = true
	else:
		outline.default_color = Color.GREEN
		outline.visible = is_dragging


func _process(delta: float) -> void:
	if not is_reverting_position and is_dragging:
		follow_mouse_position(delta)

func follow_mouse_position(delta: float) -> void:
	var weight := 1.0 - exp(-smoothing * delta)
	var mouse_position := area_2d.get_global_mouse_position() \
				.snappedf(MAP_SNAP) \
				.clamp(MIN_MAP_POSITION, MAX_MAP_POSITION)
	area_2d.global_position = area_2d.global_position.lerp(mouse_position, weight)


func can_drop() -> bool:
	return !area_2d.get_overlapping_areas().any(func overlapping_area(other_area: Area2D):
		return other_area.is_in_group("devices"))


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton 
				and event.button_index == MOUSE_BUTTON_LEFT
				and event.is_pressed()):
		is_dragging = true


func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton 
				and event.button_index == MOUSE_BUTTON_LEFT 
				and event.is_released()):
		is_dragging = false


func set_dragging(_is_dragging: bool) -> void:
	if is_dragging == _is_dragging:
		return
	is_dragging = _is_dragging
	if is_dragging:
		if not area_2d.has_overlapping_areas():
			drag_start_position = area_2d.global_position
		is_reverting_position = false
		dragg_started.emit()
	else:
		is_reverting_position = not can_drop()
		dragg_ended.emit()

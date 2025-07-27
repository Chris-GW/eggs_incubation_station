class_name Main
extends Node2D

const EGG = preload("res://scenes/egg.tscn")

@onready var game_tick_timer: Timer = $GameTickTimer

static var money := 0
var game_ticks := 0


func _ready() -> void:
	for station: IncubationStation in get_tree().get_nodes_in_group("incubation_station"):
		station.egg_selection_wanted.connect(_on_egg_selection_wanted)


func _on_game_tick_timer_timeout() -> void:
	get_tree().call_group("devices", "pre_game_tick")
	get_tree().call_group("devices", "next_game_tick")
	get_tree().call_group("devices", "post_game_tick")
	game_ticks += 1
	%TickLabel.text = "Ticks: %6d" % game_ticks


func _on_open_shop_button_pressed() -> void:
	%DeviceShop.visible = true


var current_station: IncubationStation

func _on_egg_selection_wanted(incubation_station: IncubationStation) -> void:
	current_station = incubation_station
	%EggReward.randomize_choices()
	%EggReward.visible = true


func _on_egg_reward_creature_choosen(creature: EggCreature) -> void:
	current_station._on_egg_reward_creature_choosen(creature)

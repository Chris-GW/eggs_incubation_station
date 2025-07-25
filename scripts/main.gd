class_name Main
extends Node2D

@onready var game_tick_timer: Timer = $GameTickTimer

var game_ticks := 0


func _on_game_tick_timer_timeout() -> void:
	get_tree().call_group("devices", "pre_game_tick")
	get_tree().call_group("devices", "next_game_tick")
	get_tree().call_group("devices", "post_game_tick")
	game_ticks += 1
	%TickLabel.text = "Ticks: %6d" % game_ticks

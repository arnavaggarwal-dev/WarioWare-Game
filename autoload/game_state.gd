extends Node

signal lives_changed(current: int)
signal game_over

var max_lives: int = 5
var current_lives: int = max_lives

var all_microgames: Array[String] = [
	# fill these in as you build them, e.g:
	# "res://microgames/tap_the_circle.tscn",
]
var _bag: Array[String] = []
var current_game_path: String = ""

func _ready() -> void:
	_refill_bag()

func _refill_bag() -> void:
	_bag = all_microgames.duplicate()
	_bag.shuffle()

func lose_life() -> void:
	current_lives = max(current_lives - 1, 0)
	lives_changed.emit(current_lives)
	if current_lives <= 0:
		game_over.emit()

func reset() -> void:
	current_lives = max_lives
	lives_changed.emit(current_lives)
	_refill_bag()

func get_next_microgame() -> String:
	if all_microgames.is_empty():
		return ""
	if _bag.is_empty():
		_refill_bag()
	current_game_path = _bag.pop_back()
	return current_game_path

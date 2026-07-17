extends Node3D

@onready var anim_player: AnimationPlayer = $game_over_character/AnimationPlayer

func _ready() -> void:
	anim_player.play("runtoblast")

extends HBoxContainer

@export var max_lives: int = 5
var current_lives: int = max_lives

func _ready() -> void:
	update_display()

func lose_life() -> void:
	current_lives = max(current_lives - 1, 0)
	update_display()
	if current_lives == 0:
		game_over()

func update_display() -> void:
	for i in get_child_count():
		var wrapper: Control = get_child(i)
		var icon: AnimatedSprite2D = wrapper.get_child(0)
		var alive: bool = i < current_lives
		if alive:
			icon.play("pulse")
			icon.modulate.a = 1.0
		else:
			icon.stop()
			icon.modulate.a = 0.3

func game_over() -> void:
	pass

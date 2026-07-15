extends HBoxContainer

var current_lives: int = 5

func _ready() -> void:
	update_display()
	GameState.lives_changed.connect(_on_lives_changed)

func _on_lives_changed(new_lives: int) -> void:
	current_lives = new_lives
	update_display()

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

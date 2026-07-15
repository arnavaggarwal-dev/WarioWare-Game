extends Node2D

func _ready() -> void:
	var next_scene: String = GameState.get_next_microgame()
	if next_scene != "":
		get_tree().change_scene_to_file(next_scene)
	GameState.game_over.connect(_on_game_over)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"): # temp test binding
		GameState.lose_life()

func _on_game_over() -> void:
	print("Game over!")

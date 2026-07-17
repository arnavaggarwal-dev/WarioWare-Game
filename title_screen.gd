extends Node2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	var next_scene: String = GameState.get_next_microgame()
	if next_scene != "":
		get_tree().change_scene_to_file(next_scene)

func _on_quit_pressed() -> void:
	get_tree().quit()

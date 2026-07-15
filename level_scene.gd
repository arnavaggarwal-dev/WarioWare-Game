extends Node2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"): # Space/Enter by default
		$UI/LivesDisplay.lose_life()

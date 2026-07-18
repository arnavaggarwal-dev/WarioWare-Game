extends Node3D

@onready var actor: Node3D = $actor
@onready var camera: Camera3D = $Camera3D
@onready var anim_player: AnimationPlayer = $actor/AnimationPlayer
@onready var skeleton: Skeleton3D = $actor/GeneralSkeleton

@export var orbit_radius: float = 4.0
@export var orbit_speed: float = 6
@export var vertical_speed: float = 0.3
@export var min_height: float = 0.5
@export var max_height: float = 3.5
@export var look_target_offset: Vector3 = Vector3(0, 1.0, 0)

var _angle: float = 0.0
var _height: float = 1.0
var _height_direction: int = 1
var _hip_bone_idx: int = -1

func _ready() -> void:
	anim_player.play("motion/runtoblast")
	_hip_bone_idx = skeleton.find_bone("CC_Base_Hip")

func _process(delta: float) -> void:
	
	_angle += orbit_speed * delta
	_height += vertical_speed * delta * _height_direction
	if _height >= max_height:
		_height = max_height
		_height_direction = -1
	elif _height <= min_height:
		_height = min_height
		_height_direction = 1
	
	var hip_transform: Transform3D = skeleton.global_transform * skeleton.get_bone_global_pose(_hip_bone_idx)
	var target_pos: Vector3 = hip_transform.origin
	
	camera.global_position = target_pos + Vector3(
		cos(_angle) * orbit_radius,
		_height,
		sin(_angle) * orbit_radius
	)
	camera.look_at(target_pos + look_target_offset, Vector3.UP)

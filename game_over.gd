extends Node3D

@onready var actor: Node3D = $actor
@onready var camera: Camera3D = $Camera3D
@onready var anim_player: AnimationPlayer = $actor/AnimationPlayer
@onready var skeleton: Skeleton3D = $actor/GeneralSkeleton
@onready var mesh: MeshInstance3D = $actor/GeneralSkeleton/Motion_Dummy_Male

@export var orbit_radius: float = 4.0
@export var orbit_speed: float = 6.0
@export var vertical_speed: float = 0.3
@export var min_height: float = 0.5
@export var max_height: float = 3.5
@export var look_target_offset: Vector3 = Vector3(0, 1.0, 0)

var _angle: float = 0.0
var _height: float = 1.0
var _height_direction: int = 1
var _hip_bone_idx: int = -1
var _orbiting: bool = true
var _speed_multiplier: float = 1.0

func _ready() -> void:
	anim_player.play("motion/runtoblast")
	_hip_bone_idx = skeleton.find_bone("CC_Base_Hip")
	var decel_start: float = 1.1 # when the slowdown begins
	var decel_duration: float = 1.58 - decel_start
	
	var decel_timer: SceneTreeTimer = get_tree().create_timer(decel_start)
	decel_timer.timeout.connect(func():
		var tween: Tween = create_tween()
		tween.tween_property(self, "_speed_multiplier", 0.0, decel_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_callback(func(): _orbiting = false)
	)
	
	var dissolve_timer: SceneTreeTimer = get_tree().create_timer(1.6)
	dissolve_timer.timeout.connect(_start_evaporation)

func _process(delta: float) -> void:
	if not _orbiting:
		return
	
	_angle += orbit_speed * _speed_multiplier * delta
	_height += vertical_speed * _speed_multiplier * delta * _height_direction
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

func _start_evaporation() -> void:
	anim_player.pause()
	
	var mat: ShaderMaterial = mesh.material_override
	mat.set_shader_parameter("dissolve_amount", 0.0)
	mat.set_shader_parameter("edge_color_hot", Color(1.0, 1.0, 1.0))
	mat.set_shader_parameter("edge_color_outer", Color(0.2, 0.8, 1.0))
	mat.set_shader_parameter("edge_width", 0.12)
	mat.set_shader_parameter("edge_glow", 10.0)
	mat.set_shader_parameter("pop_amount", 0.15)
	mat.set_shader_parameter("noise_tex", load("res://shaders/dissolve_noise.tres"))
	
	var original_mat: StandardMaterial3D = mesh.mesh.surface_get_material(0)
	if original_mat and original_mat.albedo_texture:
		mat.set_shader_parameter("texture_albedo", original_mat.albedo_texture)
	
	var tween: Tween = create_tween()
	tween.tween_method(func(v): mat.set_shader_parameter("dissolve_amount", v), 0.0, 1.0, 1.5)

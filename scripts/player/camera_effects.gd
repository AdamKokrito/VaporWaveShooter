extends Camera3D
class_name CameraEffects

@export var player : Player 
@export var enable_tilt : bool = true
@export var enable_fall_kick : bool = true

@export_group("Run&Tilt")
@export var run_pitch : float = 0.1
@export var run_roll : float = 0.25
@export var max_pitch : float = 1.0
@export var max_roll : float = 2.5
@export_group("Cam Kick")
@export_subgroup("Fall kick")
@export var fall_time : float = 0.3

var _fall_value : float = 0.0
var _fall_timer : float = 0.0

func _process(delta: float) -> void:
	calculate_view_offset(delta)

func calculate_view_offset(delta)-> void:
	if !player:return
	
	_fall_timer -= delta
	
	
	
	var velocity : Vector3 = player.velocity
	var angles : Vector3 = Vector3.ZERO
	var offset : Vector3 = Vector3.ZERO
	
	if enable_tilt:
		var forward = global_transform.basis.z
		var right = global_transform.basis.x
		
		var forward_dot = velocity.dot(forward)
		var forward_tilt = clampf(forward_dot * deg_to_rad(run_pitch),deg_to_rad(-max_pitch),deg_to_rad(max_pitch))
		angles.x += forward_tilt
	
		var right_dot = velocity.dot(right)
		var right_tilt = clampf(right_dot * deg_to_rad(run_roll),deg_to_rad(-max_roll),deg_to_rad(max_roll))
		angles.z -= right_tilt
	
	if enable_fall_kick:
		var fall_ratio : float = max(0.0,_fall_timer/fall_time)
		var fall_kick_amount : float = fall_ratio * _fall_value
		angles.x -= fall_kick_amount
		offset.y -= fall_kick_amount
	
	position = offset
	rotation = angles
	
	

func add_fall_kick(fall_strength : float)->void:
	_fall_value = deg_to_rad(fall_strength)
	_fall_timer = fall_time

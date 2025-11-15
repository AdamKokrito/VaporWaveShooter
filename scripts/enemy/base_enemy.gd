extends CharacterBody3D
class_name BaseEnemy

signal no_health
signal damaged

@export var stats : Stats
@export var speed : float = 3.0
@export var push_force : float = 10.0
@export var turn_speed : float = 15.0
@export var stop_range : float = 0.5
@export var points : int = 150


@onready var mesh: Node3D = $Mesh
@onready var eyes: Node3D = $Eyes
@onready var hit_box: HitBox = $HitBox
@onready var soft_collision: SoftCollision = $SoftCollision
@onready var bottom_cast: RayCast3D = $Mesh/BottomCast
@onready var man: MeshInstance3D = $Mesh/Man



var player : Player

const UPDATE_INTERVAL : int = 30
var tick_counter : Timer
var dir : Vector3 

var _is_dead : bool = false
var stun : bool = false
var base_mat : ShaderMaterial

func _ready() -> void:
	stats.duplicate()
	stats.no_health.connect(dead)
	tick_counter.timeout.connect(tick_update)
	base_mat = man.get_surface_override_material(0)
	

func _physics_process(delta: float) -> void:
	if !player:return
	
	if bottom_cast.is_colliding():
		climb()
	else:
		if player.global_position.y >= self.global_position.y:
			velocity.y = 0.0
		elif player.global_position.y <= self.global_position.y and not is_on_floor():
			velocity.y += get_gravity().y * delta
		
	if (eyes.global_position.x != player.global_position.x and eyes.global_position.z != player.global_position.z) and global_position != player.global_position:
		eyes.look_at(player.global_position,Vector3.UP)
		mesh.rotation.y = lerp_angle(mesh.rotation.y,eyes.rotation.y,turn_speed * delta)
	
	if global_position.distance_to(player.global_position) <= stop_range:return
	move_and_slide()
	if soft_collision.is_colliding():
		velocity.x += soft_collision.get_push_vector().x * delta * push_force
		velocity.z += soft_collision.get_push_vector().z * delta * push_force



func tick_update() -> void:
	if !player:return
	
	dir = player.global_position - global_position
	dir = dir.normalized()
	velocity.x = dir.x * speed 
	velocity.z = dir.z * speed 

func climb()->void:
	velocity.y = 4.0

func take_damage(value:int)->void:
	stats.health -= value
	if _is_dead:
		Global.points += points
	else:
		Global.points += 10
	damaged.emit()
	
	base_mat.set_shader_parameter("color_compression",-6)
	stun = true
	await get_tree().create_timer(0.2).timeout
	base_mat.set_shader_parameter("color_compression",6)
	stun = false
	

func dead()->void:
	_is_dead = true
	no_health.emit()
	queue_free()

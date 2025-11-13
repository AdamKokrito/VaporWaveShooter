extends CharacterBody3D
class_name BaseEnemy

signal no_health

@export var stats : Stats
@export var speed : float = 3.0
@export var turn_speed : float = 15.0
@export var stop_range : float = 2.0

@onready var mesh: Node3D = $Mesh
@onready var eyes: Node3D = $Eyes
@onready var hit_box: HitBox = $HitBox
@onready var soft_collision: SoftCollision = $SoftCollision



const UPDATE_INTERVAL : int = 20
var tick_counter : int = 0



func _ready() -> void:
	stats.duplicate()
	stats.no_health.connect(dead)

func _physics_process(delta: float) -> void:
	if !Global.player:return
	
	var dir : Vector3 = Global.player.global_position - global_position
	
	if tick_counter == 0:
		if Global.player.global_position.y >= self.global_position.y:
			dir.y = 0.0
		elif Global.player.global_position.y <= self.global_position.y and not is_on_floor():
			dir.y += get_gravity().y * 50 * delta
		dir = dir.normalized()
		velocity = dir * speed 
		if soft_collision.is_colliding():
			velocity += soft_collision.get_push_vector() * delta * speed * 3

		tick_counter = UPDATE_INTERVAL
	else:
		tick_counter -= 1
	
	if eyes.global_position.x != Global.player.global_position.x and eyes.global_position.z != Global.player.global_position.z:
		eyes.look_at(Global.player.global_position,Vector3.UP)
		mesh.rotation.y = lerp_angle(mesh.rotation.y,eyes.rotation.y,turn_speed * delta)
	move_and_slide()
	

func take_damage(value:int)->void:
	stats.health -= value

func dead()->void:
	no_health.emit()
	queue_free()

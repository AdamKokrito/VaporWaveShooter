extends Node
class_name WaveManager

signal enemy_damage

const OFFSET : Vector3 = Vector3(0,1.0,0)

@onready var tick_timer: Timer = $TickTimer
@onready var spawn_timer: Timer = $SpawnTimer

@export var spawns : Node3D
@export var player : Player


var enemy_count : int = 0
var _current_enemy : BaseEnemy 

const MAX_ENEMYS : int = 60
static var enemy_pool : Array = []



func spawn_enemy(global_pos:Vector3,parent:Node3D)->void:
	var enemy_instance : BaseEnemy
	
	
	
	if len(enemy_pool) >= MAX_ENEMYS and is_instance_valid(enemy_pool[0]):
		enemy_instance = enemy_pool.pop_front()
		enemy_pool.push_back(enemy_instance)
		enemy_instance.reparent(parent)
	else:
		enemy_instance = preload("res://scenes/base_enemy.tscn").instantiate()
		_current_enemy = enemy_instance
		_current_enemy.no_health.connect(_dead_enemy)
		_current_enemy.damaged.connect(_damaged_enemy)
		_current_enemy.tick_counter = tick_timer
		_current_enemy.player = player
		
		parent.add_child(enemy_instance)
		enemy_pool.push_back(enemy_instance)
	
	if not is_instance_valid(enemy_pool[0]):
		enemy_pool.pop_front()
	
	
	enemy_instance.global_position = global_pos
	enemy_instance.stats.health = enemy_instance.stats.max_health
	enemy_instance.hit_box.monitorable = true

func _on_spawn_timer_timeout() -> void:
	var random_spawn : Marker3D = spawns.get_child(randi_range(0,spawns.get_child_count(false) - 1))
	spawn_enemy(random_spawn.global_position + OFFSET,random_spawn)
	
	enemy_count += 1
	if enemy_count >= MAX_ENEMYS:
		spawn_timer.stop()

func _damaged_enemy()->void:
	enemy_damage.emit(1)

func _dead_enemy() -> void:
	enemy_count -= 1
	if enemy_count < MAX_ENEMYS:
		spawn_timer.start()

extends Node

@export var enemy_scene : PackedScene
@export var spawns : Node3D
@export var max_enemy_spawned : int = 30
const BASE_ENEMY = preload("uid://ccrk55ebba6wa")

var _last_enemy : BaseEnemy
var enemy_count : int = 0


func _ready() -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	if !enemy_scene:return
	if enemy_count < max_enemy_spawned:
		var enemy : BaseEnemy = BASE_ENEMY.instantiate()
		if _last_enemy:
			enemy.tick_counter = _last_enemy.tick_counter - 1
		else:
			enemy.tick_counter = enemy.UPDATE_INTERVAL
			_last_enemy = enemy
		
		enemy.no_health.connect(dead_enemy)
		
		spawns.add_child(enemy)
		enemy.global_position = spawns.global_position
		enemy.global_position.y += 0.5
		enemy_count += 1
	print(enemy_count)


func dead_enemy() -> void:
	enemy_count -= 1

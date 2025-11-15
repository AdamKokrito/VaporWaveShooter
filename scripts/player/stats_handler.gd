extends Node
class_name StatsHandler

signal health_changed(value:int)

@export var stats : Stats
@export var hurt_box: HurtBox
@export var invincible_time : float = 0.7

var _stuned : bool = false
var dead : bool = false

func _ready() -> void:
	stats = stats.duplicate()
	hurt_box.hurt.connect(take_hit)
	stats.no_health.connect(_player_dead)

func take_hit(other_hit:HitBox) -> void:
	if dead:return
	if _stuned: return
	
	stats.health -= other_hit.damage
	health_changed.emit(stats.health)
	
	_stuned = true
	hurt_box.set_deferred("monitoring",false)
	await get_tree().create_timer(invincible_time).timeout
	_stuned = false
	hurt_box.set_deferred("monitoring",true)

func _player_dead() -> void:
	dead = true

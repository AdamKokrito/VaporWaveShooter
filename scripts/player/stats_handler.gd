extends Node
class_name StatsHandler

@export var stats : Stats
@export var hurt_box: HurtBox

func _ready() -> void:
	stats = stats.duplicate()
	hurt_box.hurt.connect(_take_hit)
	stats.no_health.connect(_player_dead)

func _take_hit(other_hit:HitBox) -> void:
	stats.health -= other_hit.damage
	

func _player_dead() -> void:
	print("dead")

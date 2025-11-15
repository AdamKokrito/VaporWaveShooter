extends CanvasLayer
class_name Interface

@export var player : Player
@export var wave_manager : WaveManager
@export_group("VFX")
@export var vhs_toggle : bool = true

@onready var vhs: ColorRect = $VFX/VHS
@onready var health: Label = $HUD/Health
@onready var info: RichTextLabel = $HUD/Score
@onready var damage_indicator: Control = $DamageIndicator
@onready var animation_player: AnimationPlayer = $DamageIndicator/AnimationPlayer


var stats_handler : StatsHandler

func _ready() -> void:
	stats_handler = player.stats_handler
	
	vhs.visible = vhs_toggle
	damage_indicator.modulate = Color(255,255,255,0)
	
	stats_handler.health_changed.connect(_update_health)
	wave_manager.enemy_damage.connect(_update_score)
	stats_handler.look_at.connect(_rotate_damage)
	
	_update_health(stats_handler.stats.health)
	_update_score(5)

func _update_health(value:int) -> void:
	health.text = "Health : %s" %value

func _update_score(wave:int) -> void:
	info.text = "[wave amp=20 freq =15] wave : %s" %wave + " score : %s [/wave]" %Global.points

func _rotate_damage(look_at:Node3D) -> void:
	damage_indicator.rotation = -look_at.rotation.y
	animation_player.play("fade_out")

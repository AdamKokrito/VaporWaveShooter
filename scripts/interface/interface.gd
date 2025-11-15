extends CanvasLayer
class_name Interface

@export var player : Player
@export var wave_manager : WaveManager
@export_group("VFX")
@export var vhs_toggle : bool = true

@onready var vhs: ColorRect = $VFX/VHS
@onready var health: Label = $HUD/Health
@onready var info: RichTextLabel = $HUD/Score


var stats_handler : StatsHandler

func _ready() -> void:
	stats_handler = player.stats_handler
	vhs.visible = vhs_toggle
	_update_health(stats_handler.stats.health)
	stats_handler.health_changed.connect(_update_health)
	wave_manager.enemy_damage.connect(_update_score)
	_update_score(5)

func _update_health(value:int) -> void:
	health.text = "Health : %s" %value

func _update_score(wave:int) -> void:
	info.text = "[wave amp=20 freq =15] wave : %s" %wave + " score : %s [/wave]" %Global.points

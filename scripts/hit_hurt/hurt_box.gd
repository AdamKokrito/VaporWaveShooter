extends Area3D
class_name HurtBox

signal hurt(hitbox:HitBox)

func _ready() -> void:
	area_entered.connect(_on_area_enterd)

func _on_area_enterd(area3d:Area3D)->void:
	if area3d is not HitBox:return
	hurt.emit(area3d)

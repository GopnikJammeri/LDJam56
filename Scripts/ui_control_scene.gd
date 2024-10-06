extends Control

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var label: Label = $Label

var hp_value: int = 0

func _ready() -> void:
	hp_value = 100 - StatsManager.GetHealth()
	StatsManager.connect("on_health_change",_on_health_changed)

func _on_health_changed() -> void:
	hp_value = 100 - StatsManager.GetHealth()
	label.text = str(hp_value) + "%"
	sprite_2d.frame = 20 - floor( (100 - hp_value) / (100 / 20) )
